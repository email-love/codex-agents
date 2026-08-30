#!/usr/bin/env bash
# Post-build assertions on the plugin distributions in dist/.
#
# Properties a broken release would violate: both artifacts present and
# integral; no symlinks, executables, traversal, or entries outside
# email-love/; the manifest, logo, LICENSE, and every skill file present;
# .mcp.json in the FULL artifact and ABSENT from the skills-only artifact;
# source parity in both directions for the allowlisted files; checksums
# matching; and a byte-identical rebuild (determinism).
set -euo pipefail

cd "$(dirname "$0")/.."
PLUGIN="plugins/email-love"
VERSION="$(python3 -c "import json; print(json.load(open('$PLUGIN/.codex-plugin/plugin.json'))['version'])")"
FULL="$PWD/dist/email-love-codex-plugin-full-$VERSION.zip"
SKILLS_ONLY="$PWD/dist/email-love-codex-plugin-skills-only-$VERSION.zip"
ESP_LIST="$(python3 -c "import json; print(' '.join(json.load(open('sources.json'))['espSkills']['skills']))")"

is_esp_path() { # $1 = archive entry
  local e
  for e in $ESP_LIST; do
    case "$1" in email-love/skills/$e/*) return 0 ;; esac
  done
  return 1
}

for a in "$FULL" "$SKILLS_ONLY"; do
  [ -f "$a" ] || { echo "missing artifact: $a" >&2; exit 1; }
  unzip -tq "$a" >/dev/null || { echo "corrupt archive: $a" >&2; exit 1; }
  listing="$(unzip -Z1 "$a")"
  if grep -v "^email-love/" <<<"$listing" | grep -q .; then
    echo "$a contains entries outside email-love/" >&2; exit 1
  fi
  if grep -q '\.\.' <<<"$listing"; then
    echo "$a contains a path with '..'" >&2; exit 1
  fi
  if unzip -Z "$a" | grep -Eq '^[lL]'; then
    echo "$a contains a symlink" >&2; exit 1
  fi
  if unzip -Z "$a" | grep -Eq '^-.{0,8}x'; then
    echo "$a contains an executable file" >&2; exit 1
  fi
  for required in "email-love/.codex-plugin/plugin.json" \
                  "email-love/assets/email-love-logo.png" \
                  "email-love/LICENSE"; do
    grep -qxF "$required" <<<"$listing" || {
      echo "$a is missing $required" >&2; exit 1; }
  done
  # Source parity: every allowlisted skill file must be present.
  while IFS= read -r -d '' f; do
    rel="${f#"$PLUGIN/"}"
    grep -qxF "email-love/$rel" <<<"$listing" || {
      echo "$a is missing source file $rel" >&2; exit 1; }
  done < <(find "$PLUGIN/skills" -type f \( -name '*.md' -o -name '*.yaml' -o -name '*.py' \) -print0)
  # Reverse parity: no archive skill file without a source counterpart.
  # ESP paths are exempt here: their counterpart is the pinned esp-skills
  # checkout, byte-compared below.
  while IFS= read -r entry; do
    case "$entry" in
      */) continue ;;
      email-love/skills/*)
        if is_esp_path "$entry"; then continue; fi
        [ -f "$PLUGIN/${entry#email-love/}" ] || {
        echo "$a contains $entry with no source counterpart" >&2; exit 1; } ;;
    esac
  done <<<"$listing"
done

full_listing="$(unzip -Z1 "$FULL")"
skills_listing="$(unzip -Z1 "$SKILLS_ONLY")"
grep -qxF "email-love/.mcp.json" <<<"$full_listing" || {
  echo "$FULL must contain .mcp.json (the Git-backed plugin carries MCP config)" >&2; exit 1; }
if grep -qxF "email-love/.mcp.json" <<<"$skills_listing"; then
  echo "$SKILLS_ONLY must NOT contain .mcp.json (a portal skills-only upload carries no MCP config)" >&2
  exit 1
fi
# Manifest truthfulness: every path a packaged manifest declares must resolve
# inside its own archive; the skills-only manifest must not declare an MCP
# config it does not ship (2026-08-30 review, F1).
tmpm="$(mktemp -d)"
( cd "$tmpm" && unzip -qo "$FULL" "email-love/.codex-plugin/plugin.json" && \
  mkdir -p skills-only && cd skills-only && unzip -qo "$SKILLS_ONLY" "email-love/.codex-plugin/plugin.json" )
python3 - "$tmpm/email-love/.codex-plugin/plugin.json" "$FULL" <<'PYEOF'
import json, sys, zipfile
manifest = json.load(open(sys.argv[1]))
names = set(zipfile.ZipFile(sys.argv[2]).namelist())
mcp = manifest.get("mcpServers")
if mcp != "./.mcp.json" or "email-love/.mcp.json" not in names:
    raise SystemExit(f"full manifest mcpServers {mcp!r} does not resolve inside the archive")
PYEOF
python3 - "$tmpm/skills-only/email-love/.codex-plugin/plugin.json" "$tmpm/email-love/.codex-plugin/plugin.json" <<'PYEOF'
import json, sys
skills_only = json.load(open(sys.argv[1]))
full = json.load(open(sys.argv[2]))
if "mcpServers" in skills_only:
    raise SystemExit("skills-only manifest still declares mcpServers with no bundled .mcp.json")
so_desc = skills_only.get("interface", {}).get("longDescription", "")
if "Bundles the Email Love MCP" in so_desc:
    raise SystemExit("skills-only manifest still claims a bundled MCP connection")
if "separately configured Email Love MCP" not in so_desc:
    raise SystemExit("skills-only manifest lacks the separate-connection wording")
if "Bundles the Email Love MCP" not in full.get("interface", {}).get("longDescription", ""):
    raise SystemExit("full manifest lost its (true) bundled-MCP description")
PYEOF
rm -rf "$tmpm"
echo "ok artifact split: full carries .mcp.json + resolving manifest, skills-only claims no MCP"

# ESP split: the portal artifact carries the ten pinned ESP skills (thirteen
# total); the Git-backed artifact mirrors the repository (three skills, no
# ESP directories). ESP files must be byte-identical to the pinned checkout.
ESP_PIN="$(python3 -c "import json; print(json.load(open('sources.json'))['espSkills']['commit'])")"
ESP_LIST="$(python3 -c "import json; print(' '.join(json.load(open('sources.json'))['espSkills']['skills']))")"
for esp in $ESP_LIST; do
  grep -qxF "email-love/skills/$esp/SKILL.md" <<<"$skills_listing" || {
    echo "$SKILLS_ONLY is missing ESP skill $esp" >&2; exit 1; }
  if grep -q "^email-love/skills/$esp/" <<<"$full_listing"; then
    echo "$FULL must not contain ESP skill $esp (repo-faithful artifact)" >&2; exit 1
  fi
done
skill_count="$(grep -cE '^email-love/skills/[^/]+/SKILL.md$' <<<"$skills_listing")"
[ "$skill_count" -eq 14 ] || {
  echo "$SKILLS_ONLY has $skill_count skills, expected 14" >&2; exit 1; }
full_count="$(grep -cE '^email-love/skills/[^/]+/SKILL.md$' <<<"$full_listing")"
[ "$full_count" -eq 4 ] || {
  echo "$FULL has $full_count skills, expected 4" >&2; exit 1; }
if [ -n "${ESP_SKILLS_DIR:-}" ] && [ -d "$ESP_SKILLS_DIR" ]; then
  tmpe="$(mktemp -d)"
  for esp in $ESP_LIST; do
    ( cd "$tmpe" && unzip -qo "$SKILLS_ONLY" "email-love/skills/$esp/*" )
    while IFS= read -r -d '' f; do
      rel="${f#"$tmpe/email-love/skills/"}"
      cmp -s "$f" "$ESP_SKILLS_DIR/skills/$rel" || {
        echo "$SKILLS_ONLY: skills/$rel differs from pinned esp-skills source" >&2; exit 1; }
    done < <(find "$tmpe/email-love/skills/$esp" -type f -print0)
    rm -rf "$tmpe/email-love"
  done
  rm -rf "$tmpe"
  echo "ok ESP byte-equality against pinned checkout ($ESP_PIN)"
else
  echo "note: ESP_SKILLS_DIR not set; byte-equality against the pinned checkout skipped"
fi
echo "ok ESP split: portal artifact 14 skills, Git artifact 4"

if command -v sha256sum >/dev/null 2>&1; then SHACMD="sha256sum"; else SHACMD="shasum -a 256"; fi
( cd dist && $SHACMD -c SHA256SUMS >/dev/null ) || {
  echo "checksums in dist/SHA256SUMS do not match" >&2; exit 1; }
echo "ok SHA256SUMS"

before="$(cd dist && $SHACMD ./*.zip)"
bash scripts/build_plugin.sh >/dev/null
after="$(cd dist && $SHACMD ./*.zip)"
if [ "$before" != "$after" ]; then
  echo "build is not deterministic: checksums changed on rebuild" >&2
  exit 1
fi
echo "ok deterministic rebuild"

echo
echo "2 artifact(s) verified for v$VERSION"
