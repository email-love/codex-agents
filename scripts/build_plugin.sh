#!/usr/bin/env bash
# Build the two Email Love Codex plugin distributions into dist/:
#
#   email-love-codex-plugin-full-<version>.zip
#       The full Git-backed plugin: manifest, assets, skills, AND .mcp.json.
#       This is what a developer Git install carries, MCP configuration
#       included.
#
#   email-love-codex-plugin-skills-only-<version>.zip
#       The OpenAI portal upload: manifest, assets, and skills, WITHOUT
#       .mcp.json. A portal skills-only upload does not carry MCP
#       configuration, and this artifact makes no claim that it does.
#
# Builds are DETERMINISTIC: explicit allowlist staging, sorted entry order,
# fixed timestamp, no extra zip attributes — the same source tree produces
# byte-identical archives anywhere. Symlinks refuse the build. A checksum
# manifest covers both artifacts.
set -euo pipefail

cd "$(dirname "$0")/.."
PLUGIN="plugins/email-love"
VERSION="$(python3 -c "import json; print(json.load(open('$PLUGIN/.codex-plugin/plugin.json'))['version'])")"
STAMP="202601010000"

rm -rf dist && mkdir -p dist

if find "$PLUGIN" -type l -print | grep -q .; then
  echo "refusing to build: symlink(s) found under $PLUGIN" >&2
  find "$PLUGIN" -type l -print >&2
  exit 1
fi

stage_common() { # $1 = staging root
  local root="$1/email-love"
  mkdir -p "$root/.codex-plugin" "$root/assets"
  install -m 0644 "$PLUGIN/.codex-plugin/plugin.json" "$root/.codex-plugin/plugin.json"
  install -m 0644 "$PLUGIN/assets/email-love-logo.png" "$root/assets/email-love-logo.png"
  install -m 0644 LICENSE "$root/LICENSE"
  # Skills: SKILL.md, references/*.md, agents/*.yaml — the runtime allowlist.
  for dir in "$PLUGIN"/skills/*/; do
    local short; short="$(basename "$dir")"
    mkdir -p "$root/skills/$short"
    install -m 0644 "$dir/SKILL.md" "$root/skills/$short/SKILL.md"
    for sub in references agents; do
      [ -d "$dir/$sub" ] || continue
      ( cd "$dir" && find "$sub" -type f \( -name '*.md' -o -name '*.yaml' \) -print0 ) \
        | while IFS= read -r -d '' f; do
            mkdir -p "$root/skills/$short/$(dirname "$f")"
            install -m 0644 "$dir/$f" "$root/skills/$short/$f"
          done
      local unshipped
      unshipped="$(cd "$dir" && find "$sub" -type f ! -name '*.md' ! -name '*.yaml' 2>/dev/null || true)"
      if [ -n "$unshipped" ]; then
        echo "refusing to build: files the allowlist would drop in $short/$sub:" >&2
        echo "$unshipped" >&2
        exit 1
      fi
    done
  done
}

zip_deterministic() { # $1 = staging dir, $2 = output zip
  find "$1" -exec touch -t "$STAMP" {} +
  ( cd "$1" && find email-love \( -type f -o -type d \) | LC_ALL=C sort \
      | zip -qX "$2" -@ )
}

# Full Git-backed plugin (includes .mcp.json).
FULL_STAGE="$(mktemp -d)"
stage_common "$FULL_STAGE"
install -m 0644 "$PLUGIN/.mcp.json" "$FULL_STAGE/email-love/.mcp.json"
zip_deterministic "$FULL_STAGE" "$PWD/dist/email-love-codex-plugin-full-$VERSION.zip"
rm -rf "$FULL_STAGE"
echo "built dist/email-love-codex-plugin-full-$VERSION.zip"

# OpenAI portal skills-only upload (no .mcp.json, and no claim of one).
SKILLS_STAGE="$(mktemp -d)"
stage_common "$SKILLS_STAGE"
zip_deterministic "$SKILLS_STAGE" "$PWD/dist/email-love-codex-plugin-skills-only-$VERSION.zip"
rm -rf "$SKILLS_STAGE"
echo "built dist/email-love-codex-plugin-skills-only-$VERSION.zip"

if command -v sha256sum >/dev/null 2>&1; then
  ( cd dist && sha256sum ./*.zip > SHA256SUMS )
else
  ( cd dist && shasum -a 256 ./*.zip > SHA256SUMS )
fi
echo "checksums in dist/SHA256SUMS"
