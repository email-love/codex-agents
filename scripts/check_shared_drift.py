#!/usr/bin/env python3
"""Deterministic drift check between this Codex port and canonical claude-skills.

The two repositories deliberately differ in tool names, login steps, skill
names, and progress language. What must NOT drift are the shared behavioral
rules. This check asserts that each canonical rule sentence below appears in
BOTH repositories' corresponding skill files, so a change to the shared
contract in one repo fails CI in the other until it is ported.

Usage:
    python3 scripts/check_shared_drift.py --claude-skills /path/to/claude-skills

In CI, clone claude-skills at the commit recorded in sources.json first:
    git clone https://github.com/email-love/claude-skills /tmp/claude-skills
    git -C /tmp/claude-skills checkout "$(python3 -c 'import json; print(json.load(open("sources.json"))["upstream"]["commit"])')"
    python3 scripts/check_shared_drift.py --claude-skills /tmp/claude-skills
"""
from __future__ import annotations

import argparse
import json
import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent

# (codex-relative path, claude-relative path, [shared rule sentences])
SHARED_RULES = [
    (
        "plugins/email-love/skills/email-love-template-repair/SKILL.md",
        "plugins/email-love/skills/template-repair/SKILL.md",
        [
            "Establish source fidelity before writing.",
            "Never derive intended geometry from the broken canvas",
            "Parallel discovery does not permit\nearly mutation",
            "property_patch | instance_replacement | section_reconstruction",
            "New contradictory evidence invalidates the contract and stops further mutation",
            "Report five states, each on its own evidence",
            "An untested viewport is `deferred`, not `pass`",
        ],
    ),
    (
        "plugins/email-love/skills/email-love-template-repair/references/diagnostic-workflow.md",
        "plugins/email-love/skills/template-repair/references/diagnostic-workflow.md",
        [
            "## Source-fidelity gate",
            "A screenshot submitted to report a defect is symptom evidence",
            "map visible\ncopy to the proof instance and then to the source component",
            "Do not promote a plausible recommendation, a peer pattern, or a measurement of\nthe current broken state to a fact.",
            "Do not write while `Unknown or pending` contains anything",
        ],
    ),
    (
        "plugins/email-love/skills/email-love-template-repair/references/repair-verification.md",
        "plugins/email-love/skills/template-repair/references/repair-verification.md",
        [
            "Evaluate desktop and mobile canvas fidelity independently.",
            "A repair that improves one viewport and regresses the other fails.",
            "Assign desktop and mobile exporter results separately.",
            "success at one viewport cannot compensate for\nfailure at the other",
        ],
    ),
    (
        "plugins/email-love/skills/email-love-template-repair/references/symptom-cause-matrix.md",
        "plugins/email-love/skills/template-repair/references/symptom-cause-matrix.md",
        [
            "notch, crescent, or stepped seam",
            "resolved outer bounds",
            "forward-test-gated",
        ],
    ),
    (
        "plugins/email-love/skills/email-love-design-system-migration/references/module-conversion.md",
        "plugins/email-love/skills/eds-converter/SKILL.md",
        [
            "component-by-breakpoint acceptance matrix",
            "`deferred` means the check was consciously postponed",
            "`missing` means the batch never covered it",
            "completion-inflation",
            "Provisional rules, forward-test-gated.",
            "paired-section escape hatch",
        ],
    ),
]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--claude-skills", required=True,
                    help="path to a checkout of email-love/claude-skills")
    args = ap.parse_args()
    claude_root = pathlib.Path(args.claude_skills)
    if not (claude_root / "plugins").is_dir():
        print(f"not a claude-skills checkout: {claude_root}", file=sys.stderr)
        return 2

    sources = json.loads((ROOT / "sources.json").read_text())
    print(f"canonical commit per sources.json: {sources['upstream']['commit'][:12]}")

    failures = 0
    for codex_rel, claude_rel, sentences in SHARED_RULES:
        codex_text = (ROOT / codex_rel).read_text(encoding="utf-8")
        claude_text = (claude_root / claude_rel).read_text(encoding="utf-8")
        for sentence in sentences:
            missing = []
            if sentence not in codex_text:
                missing.append(f"codex:{codex_rel}")
            if sentence not in claude_text:
                missing.append(f"claude:{claude_rel}")
            if missing:
                failures += 1
                print(f"  DRIFT  {sentence[:70]!r} missing from {', '.join(missing)}")
        if all(s in codex_text and s in claude_text for s in sentences):
            print(f"  ok    {codex_rel.split('/')[-1]}: {len(sentences)} shared rules present in both")

    if failures:
        print(f"\n{failures} shared rule(s) drifted", file=sys.stderr)
        return 1
    print("\nno drift: every shared rule present in both repositories")
    return 0


if __name__ == "__main__":
    sys.exit(main())
