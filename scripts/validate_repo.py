#!/usr/bin/env python3
"""Validate the Email Love Codex plugin repository without third-party packages."""

from __future__ import annotations

import hashlib
import json
import re
import sys
from pathlib import Path
from urllib.parse import unquote


ROOT = Path(__file__).resolve().parents[1]
PLUGIN = ROOT / "plugins" / "email-love"
SKILLS = PLUGIN / "skills"
MANIFEST = PLUGIN / ".codex-plugin" / "plugin.json"
MARKETPLACE = ROOT / ".agents" / "plugins" / "marketplace.json"
SOURCES = ROOT / "sources.json"
EVALS = ROOT / "tests" / "evals.json"
MIGRATION_COMPATIBILITY = ROOT / "migration" / "AGENTS.md"
MAX_SKILL_LINES = 500
MAX_SKILL_BYTES = 32 * 1024
REQUIRED_TAGS = {
    "mj-wrapper",
    "mj-section",
    "mj-group",
    "mj-column",
    "mj-column-inner",
    "mj-text-Frame",
    "mj-text",
    "mj-image-Frame",
    "mj-image",
    "mj-button-Frame",
    "mj-button",
    "mj-button-text",
    "mj-divider-Frame",
    "mj-divider",
    "mj-spacer",
}
STALE_MONOLITH_REFERENCES = {
    "appendix at the end of this file",
    "render spec in the appendix",
    "shared section below",
    "Self-serve, in this file",
    '"The one rule" below',
    "migration/AGENTS.md",
}
MIGRATION_SOURCE_ADAPTERS = {
    "activecampaign.md",
    "brevo.md",
    "customer-io.md",
    "google-drive.md",
    "hubspot.md",
    "iterable.md",
    "kit.md",
    "klaviyo.md",
    "local-folder.md",
    "marketo.md",
    "omnisend.md",
    "sharepoint.md",
}

errors: list[str] = []


def fail(message: str) -> None:
    errors.append(message)


def load_json(path: Path) -> dict:
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        fail(f"{path.relative_to(ROOT)}: invalid or unreadable JSON: {exc}")
        return {}


def validate_manifest() -> None:
    manifest = load_json(MANIFEST)
    if manifest.get("name") != "email-love":
        fail("plugin manifest name must be 'email-love'")
    if manifest.get("version") != "4.1.1":
        fail("plugin manifest version must be 4.1.1 for this migration contract")
    if not re.fullmatch(r"\d+\.\d+\.\d+(?:[-+][0-9A-Za-z.-]+)?", manifest.get("version", "")):
        fail("plugin manifest version must be strict semver")
    if manifest.get("skills") != "./skills/":
        fail("plugin manifest must point skills to ./skills/")
    author = manifest.get("author", {})
    if author.get("name") != "Email Love":
        fail("plugin manifest author.name must be 'Email Love'")
    interface = manifest.get("interface", {})
    for key in ("displayName", "shortDescription", "longDescription", "developerName", "category"):
        if not interface.get(key):
            fail(f"plugin manifest interface.{key} is required")

    marketplace = load_json(MARKETPLACE)
    if marketplace.get("name") != "email-love":
        fail("marketplace name must be 'email-love'")
    entries = marketplace.get("plugins", [])
    if len(entries) != 1:
        fail("marketplace must expose exactly one plugin")
        return
    entry = entries[0]
    if entry.get("name") != "email-love":
        fail("marketplace plugin name must match the manifest")
    if entry.get("source", {}).get("path") != "./plugins/email-love":
        fail("marketplace source path must be ./plugins/email-love")
    policy = entry.get("policy", {})
    if policy.get("installation") != "AVAILABLE":
        fail("marketplace installation policy must be AVAILABLE")
    if policy.get("authentication") != "ON_INSTALL":
        fail("marketplace authentication policy must be ON_INSTALL")


def parse_frontmatter(path: Path) -> dict[str, str]:
    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0] != "---":
        fail(f"{path.relative_to(ROOT)}: missing opening YAML delimiter")
        return {}
    try:
        end = lines.index("---", 1)
    except ValueError:
        fail(f"{path.relative_to(ROOT)}: missing closing YAML delimiter")
        return {}
    fields: dict[str, str] = {}
    for line in lines[1:end]:
        if not line.strip():
            continue
        if ":" not in line:
            fail(f"{path.relative_to(ROOT)}: invalid frontmatter line: {line}")
            continue
        key, value = line.split(":", 1)
        fields[key.strip()] = value.strip()
    return fields


def validate_links(path: Path, text: str) -> None:
    for match in re.finditer(r"\[[^\]]+\]\(([^)]+)\)", text):
        target = match.group(1).strip()
        if target.startswith(("https://", "http://", "mailto:", "#")):
            continue
        target = unquote(target.split("#", 1)[0])
        resolved = (path.parent / target).resolve()
        if not resolved.exists():
            fail(f"{path.relative_to(ROOT)}: broken relative link to {target}")


def validate_skills() -> None:
    skill_dirs = sorted(path for path in SKILLS.iterdir() if path.is_dir())
    expected = {"email-love-figma-builder", "email-love-design-system-migration"}
    if {path.name for path in skill_dirs} != expected:
        fail("plugin must contain exactly the builder and migration skills")

    for skill_dir in skill_dirs:
        skill_file = skill_dir / "SKILL.md"
        if not skill_file.exists():
            fail(f"{skill_dir.relative_to(ROOT)}: missing SKILL.md")
            continue
        raw = skill_file.read_bytes()
        text = raw.decode("utf-8")
        lines = text.splitlines()
        if len(lines) > MAX_SKILL_LINES:
            fail(f"{skill_file.relative_to(ROOT)}: {len(lines)} lines exceeds {MAX_SKILL_LINES}")
        if len(raw) > MAX_SKILL_BYTES:
            fail(f"{skill_file.relative_to(ROOT)}: {len(raw)} bytes exceeds 32 KiB")
        fields = parse_frontmatter(skill_file)
        if set(fields) != {"name", "description"}:
            fail(f"{skill_file.relative_to(ROOT)}: frontmatter must contain only name and description")
        if fields.get("name") != skill_dir.name:
            fail(f"{skill_file.relative_to(ROOT)}: name must match its directory")
        if "[TODO" in text:
            fail(f"{skill_file.relative_to(ROOT)}: contains a TODO placeholder")
        if "--dangerously-bypass-approvals-and-sandbox" in text:
            fail(f"{skill_file.relative_to(ROOT)}: must not recommend bypassing sandboxing")
        validate_links(skill_file, text)

        metadata = skill_dir / "agents" / "openai.yaml"
        if not metadata.exists():
            fail(f"{skill_dir.relative_to(ROOT)}: missing agents/openai.yaml")
        elif "https://mcp.figma.com/mcp" not in metadata.read_text(encoding="utf-8"):
            fail(f"{metadata.relative_to(ROOT)}: missing official Figma MCP dependency")

        references = sorted((skill_dir / "references").glob("*.md"))
        if not references:
            fail(f"{skill_dir.relative_to(ROOT)}: no references found")
        combined_render = ""
        for reference in references:
            ref_text = reference.read_text(encoding="utf-8")
            if len(ref_text.splitlines()) > 100 and "## Contents" not in "\n".join(
                ref_text.splitlines()[:30]
            ):
                fail(f"{reference.relative_to(ROOT)}: long reference lacks an opening Contents section")
            if "claude-skills/main" in ref_text:
                fail(f"{reference.relative_to(ROOT)}: uses mutable upstream main instead of a pinned commit")
            for stale_reference in STALE_MONOLITH_REFERENCES:
                if stale_reference in ref_text:
                    fail(
                        f"{reference.relative_to(ROOT)}: contains stale monolith reference "
                        f"{stale_reference!r}"
                    )
            validate_links(reference, ref_text)
            if reference.name.startswith("render-"):
                combined_render += "\n" + ref_text
        missing_tags = sorted(tag for tag in REQUIRED_TAGS if tag not in combined_render)
        if missing_tags:
            fail(f"{skill_dir.relative_to(ROOT)}: render references missing tags: {missing_tags}")
        for rule in range(10):
            if f"R{rule}." not in combined_render:
                fail(f"{skill_dir.relative_to(ROOT)}: render references missing R{rule}")

    migration = SKILLS / "email-love-design-system-migration"
    source_dir = migration / "references" / "sources"
    actual_adapters = {path.name for path in source_dir.glob("*.md")}
    if actual_adapters != MIGRATION_SOURCE_ADAPTERS:
        fail(
            "migration source adapters must be exactly: "
            f"{sorted(MIGRATION_SOURCE_ADAPTERS)}; got {sorted(actual_adapters)}"
        )
    for adapter in sorted(source_dir.glob("*.md")):
        adapter_text = adapter.read_text(encoding="utf-8")
        if not adapter_text.startswith("## Source adapter:"):
            fail(f"{adapter.relative_to(ROOT)}: missing Source adapter heading")
        validate_links(adapter, adapter_text)

    required_migration_contract = {
        migration / "SKILL.md": ["## Phase 0: Pick the source", "references/sources/hubspot.md"],
        migration / "references" / "audit.md": [
            "Type ramp, censused rather than sampled",
            "Palette, censused rather than sampled, and clustered by role",
            "recommend a floor at 12px",
            "Spacing system, censused rather than sampled",
            "## Spacing system",
            "## Palette",
        ],
        migration / "references" / "foundations.md": [
            "### Precondition: packaged render references",
            "### Shared plugin-data contract",
            "Magic link values the exporter rewrites",
            "figma.listAvailableFontsAsync()",
            "A gap in the ramp is a decision for foundations",
            "WCAG contrast table",
            "vertical HUG with `clipsContent` off",
        ],
        migration / "references" / "module-conversion.md": [
            "render each whole design once at 1:1",
            "Group columns resolve wide enough on mobile",
            "Multi-column gutter present. A section with more than one column",
            "batch report says so verbatim",
            "a card image touches the next card's edge",
            "emaillove_preview_email",
            "Take STRUCTURE from the worker and NUMBERS from measurement",
            "error code: 1010",
            "unsubscribe.com",
            "Semantic-token bind count",
            "### 6. Export sniff test",
            "### Send-readiness pass",
            "Button label",
        ],
        migration / "references" / "render-nodes.md": [
            "R3.3.2 Group columns shrink on mobile",
            "R3.4.0 Multi-column gutters: a section with more than one column needs one",
            "zero horizontal column padding is a",
            "186.67px, with 8px horizontal padding on each side",
            "Do not infer card width by dividing content width by column count",
            "R5.2.1 Measuring a type size off a screenshot",
            "Open the PNG and look at it before uploading",
            "The neighbour's content",
        ],
        migration / "references" / "render-components-validation.md": [
            "For `mj-navbar`, do not invent a mapping",
            "setRangeHyperlink",
            "resolved width at 375px per R3.3.2",
        ],
    }
    for path, required_strings in required_migration_contract.items():
        text = path.read_text(encoding="utf-8")
        for required_string in required_strings:
            if required_string not in text:
                fail(f"{path.relative_to(ROOT)}: missing v4.1.1 contract text {required_string!r}")

    render_nodes_text = (migration / "references" / "render-nodes.md").read_text(encoding="utf-8")
    gutter_rule = render_nodes_text.find("#### R3.4.0 Multi-column gutters")
    two_column_swap = render_nodes_text.find("#### R3.4.1 THE TWO COLUMN SWAP")
    if gutter_rule < 0 or two_column_swap < 0 or gutter_rule >= two_column_swap:
        fail("render rule R3.4.0 must remain before R3.4.1 Two Column Swap")

    module_text = (migration / "references" / "module-conversion.md").read_text(encoding="utf-8")
    content_width = module_text.find("- **Content width:")
    gutter_check = module_text.find("- **Multi-column gutter present.")
    naming = module_text.find("- Naming:")
    if min(content_width, gutter_check, naming) < 0 or not content_width < gutter_check < naming:
        fail("module gutter check must remain between Content width and Naming")


def validate_provenance() -> None:
    sources = load_json(SOURCES)
    upstream = sources.get("upstream", {})
    commit = upstream.get("commit", "")
    if not re.fullmatch(r"[0-9a-f]{40}", commit):
        fail("sources.json upstream commit must be a full Git SHA")
    expected_upstream = {
        "commit": "e6b532b2c4b3681fc4a1ac2d2090ec7e87afd2ae",
        "builder_tag": "emaillove-figma-builder-v2.9.2",
        "render_tag": "emaillove-eds-converter-v1.34.0",
        "migration_tag": "emaillove-migration-audit-v1.18.0",
    }
    for key, expected in expected_upstream.items():
        if upstream.get(key) != expected:
            fail(f"sources.json upstream.{key} must be {expected!r} for v4.1.1")
    for snapshot in sources.get("legacy_snapshots", []):
        relative = snapshot.get("path", "")
        expected = snapshot.get("sha256", "")
        path = ROOT / relative
        if not path.exists():
            fail(f"missing legacy snapshot: {relative}")
            continue
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        if actual != expected:
            fail(f"{relative}: legacy snapshot changed; expected {expected}, got {actual}")


def validate_evals() -> None:
    payload = load_json(EVALS)
    cases = payload.get("cases", [])
    if len(cases) < 11:
        fail("tests/evals.json must contain at least eleven representative cases")
    seen: set[str] = set()
    required = {"id", "prompt", "expected_skill", "expected_route", "must_do", "must_not_do"}
    for index, case in enumerate(cases):
        missing = required - set(case)
        if missing:
            fail(f"eval case {index} missing fields: {sorted(missing)}")
            continue
        case_id = case["id"]
        if case_id in seen:
            fail(f"duplicate eval id: {case_id}")
        seen.add(case_id)
        if case["expected_skill"] not in {
            "email-love-figma-builder",
            "email-love-design-system-migration",
        }:
            fail(f"{case_id}: unknown expected skill")
        if not case["must_do"] or not case["must_not_do"]:
            fail(f"{case_id}: must_do and must_not_do must both be non-empty")


def validate_repository_guidance() -> None:
    agents = ROOT / "AGENTS.md"
    if len(agents.read_bytes()) >= 32 * 1024:
        fail("root AGENTS.md must stay below the default 32 KiB instruction budget")
    compatibility_files = (agents, MIGRATION_COMPATIBILITY)
    required_compatibility_text = {
        "codex plugin marketplace add email-love/codex-agents --ref v4.1.1",
        "codex plugin add email-love@email-love",
    }
    for compatibility_file in compatibility_files:
        if not compatibility_file.exists():
            fail(f"missing compatibility notice: {compatibility_file.relative_to(ROOT)}")
            continue
        compatibility_text = compatibility_file.read_text(encoding="utf-8")
        for required_text in required_compatibility_text:
            if required_text not in compatibility_text:
                fail(
                    f"{compatibility_file.relative_to(ROOT)}: missing compatibility command "
                    f"{required_text!r}"
                )
    active_text = "\n".join(
        path.read_text(encoding="utf-8")
        for path in (PLUGIN / "skills").rglob("*")
        if path.is_file()
    )
    if "[TODO" in active_text:
        fail("active plugin files contain TODO placeholders")


def main() -> int:
    validate_manifest()
    validate_skills()
    validate_provenance()
    validate_evals()
    validate_repository_guidance()
    if errors:
        print(f"Validation failed with {len(errors)} issue(s):", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print("Email Love Codex plugin validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
