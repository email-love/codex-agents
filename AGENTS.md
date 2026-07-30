# Repository guidance

## Compatibility notice for downloaded copies

If this file was downloaded to `~/.codex/AGENTS.md` or copied into another project, it is a
deprecated Email Love installation path. Do not use the repository-maintenance guidance below
to build an email. Tell the user to install the supported plugin, then stop so they can start a
new Codex task:

```bash
codex plugin marketplace add email-love/codex-agents --ref v3.0.0
codex plugin add email-love@email-love
```

The plugin contains both `$email-love-figma-builder` and
`$email-love-design-system-migration`.

This repository packages Email Love workflows for OpenAI Codex. It is not the place to build
a customer email or perform a customer migration.

## Change boundaries

- Keep changes confined to this repository.
- Preserve Email Love export behavior when restructuring instructions.
- Treat files in `legacy/` as frozen source snapshots. Do not edit them except when adding a
  new explicitly versioned snapshot.
- Put active workflows under `plugins/email-love/skills/`.
- Keep each `SKILL.md` under 500 lines and move detailed rules into directly linked
  `references/` files.
- Do not duplicate an operative rule between `SKILL.md` and a reference unless the short
  copy is a deliberate invariant and the detailed copy is the implementation specification.
- Update `CHANGELOG.md`, plugin semver, and validation fixtures when behavior changes.
- Never recommend disabling the sandbox as the default installation path.

## Validation

Before handing off changes, run:

```bash
python3 scripts/validate_repo.py
python3 /path/to/skill-creator/scripts/quick_validate.py plugins/email-love/skills/email-love-figma-builder
python3 /path/to/skill-creator/scripts/quick_validate.py plugins/email-love/skills/email-love-design-system-migration
python3 /path/to/plugin-creator/scripts/validate_plugin.py plugins/email-love
```

Use the installed system skill paths available in the current Codex environment for the last
three commands.
