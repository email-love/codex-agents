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
#       This artifact ADDITIONALLY bundles the ten ESP templating skills,
#       staged at build time from an email-love/esp-skills checkout verified
#       at the commit pinned in sources.json (espSkills lane). The ESP skills
#       are deliberately not committed into this repository - esp-skills is
#       canonical - so the OFFICIAL ChatGPT plugin carries thirteen skills
#       while the Git-backed artifact mirrors this repository's three.
#       Point ESP_SKILLS_DIR at a local esp-skills checkout; the build
#       refuses to run if that checkout is not at the pinned commit.
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

# ---- ESP skills source (portal artifact only) ----
ESP_PIN="$(python3 -c "import json; print(json.load(open('sources.json'))['espSkills']['commit'])")"
ESP_LIST="$(python3 -c "import json; print(' '.join(json.load(open('sources.json'))['espSkills']['skills']))")"
ESP_SKILLS_DIR="${ESP_SKILLS_DIR:-}"
if [ -z "$ESP_SKILLS_DIR" ]; then
  ESP_SKILLS_DIR="$(mktemp -d)/esp-skills"
  git clone --quiet https://github.com/email-love/esp-skills "$ESP_SKILLS_DIR"
fi
ESP_HEAD="$(git -C "$ESP_SKILLS_DIR" rev-parse HEAD 2>/dev/null || echo none)"
if [ "$ESP_HEAD" != "$ESP_PIN" ]; then
  if ! git -C "$ESP_SKILLS_DIR" checkout --quiet "$ESP_PIN" 2>/dev/null; then
    echo "refusing to build: esp-skills checkout is at $ESP_HEAD, pinned commit is $ESP_PIN" >&2
    echo "fetch the pinned commit in $ESP_SKILLS_DIR or update sources.json deliberately" >&2
    exit 1
  fi
fi
if [ -n "$(git -C "$ESP_SKILLS_DIR" status --porcelain)" ]; then
  echo "refusing to build: esp-skills checkout at $ESP_SKILLS_DIR is dirty" >&2
  exit 1
fi

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
    for sub in references agents scripts; do
      [ -d "$dir/$sub" ] || continue
      ( cd "$dir" && find "$sub" -type f \( -name '*.md' -o -name '*.yaml' -o -name '*.py' \) -print0 ) \
        | while IFS= read -r -d '' f; do
            mkdir -p "$root/skills/$short/$(dirname "$f")"
            install -m 0644 "$dir/$f" "$root/skills/$short/$f"
          done
      local unshipped
      unshipped="$(cd "$dir" && find "$sub" -type f ! -name '*.md' ! -name '*.yaml' ! -name '*.py' 2>/dev/null || true)"
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

# OpenAI portal skills-only upload (no .mcp.json, and no claim of one),
# with the ten ESP skills staged from the pinned canonical checkout.
SKILLS_STAGE="$(mktemp -d)"
stage_common "$SKILLS_STAGE"
# A manifest that declares mcpServers while the archive ships no .mcp.json is
# a dangling reference (2026-08-30 review, F1). The skills-only manifest drops
# the key so the artifact makes no bundled-connection claim.
python3 - "$SKILLS_STAGE/email-love/.codex-plugin/plugin.json" <<'PYEOF'
import json, sys
path = sys.argv[1]
manifest = json.load(open(path))
manifest.pop("mcpServers", None)
with open(path, "w") as handle:
    json.dump(manifest, handle, indent=2)
    handle.write("\n")
PYEOF
chmod 0644 "$SKILLS_STAGE/email-love/.codex-plugin/plugin.json"
for esp in $ESP_LIST; do
  src="$ESP_SKILLS_DIR/skills/$esp"
  [ -f "$src/SKILL.md" ] || { echo "esp-skills is missing $esp" >&2; exit 1; }
  dest="$SKILLS_STAGE/email-love/skills/$esp"
  mkdir -p "$dest"
  install -m 0644 "$src/SKILL.md" "$dest/SKILL.md"
  for sub in references agents scripts; do
    [ -d "$src/$sub" ] || continue
    ( cd "$src" && find "$sub" -type f \( -name '*.md' -o -name '*.yaml' -o -name '*.py' \) -print0 ) \
      | while IFS= read -r -d '' f; do
          mkdir -p "$dest/$(dirname "$f")"
          install -m 0644 "$src/$f" "$dest/$f"
        done
  done
done
zip_deterministic "$SKILLS_STAGE" "$PWD/dist/email-love-codex-plugin-skills-only-$VERSION.zip"
rm -rf "$SKILLS_STAGE"
echo "built dist/email-love-codex-plugin-skills-only-$VERSION.zip (14 skills: 4 repo + 10 ESP @ ${ESP_PIN:0:12})"

if command -v sha256sum >/dev/null 2>&1; then
  ( cd dist && sha256sum ./*.zip > SHA256SUMS )
else
  ( cd dist && shasum -a 256 ./*.zip > SHA256SUMS )
fi
echo "checksums in dist/SHA256SUMS"
