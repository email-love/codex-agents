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
FULL="dist/email-love-codex-plugin-full-$VERSION.zip"
SKILLS_ONLY="dist/email-love-codex-plugin-skills-only-$VERSION.zip"

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
  done < <(find "$PLUGIN/skills" -type f \( -name '*.md' -o -name '*.yaml' \) -print0)
  # Reverse parity: no archive skill file without a source counterpart.
  while IFS= read -r entry; do
    case "$entry" in
      */) continue ;;
      email-love/skills/*) [ -f "$PLUGIN/${entry#email-love/}" ] || {
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
echo "ok artifact split: full carries .mcp.json, skills-only does not"

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
