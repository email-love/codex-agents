# Deprecated migration installation path

This file exists so the pre-3.0 migration download URL fails safely.

If Codex loaded this file from a migration project, stop before making any Figma calls. Tell
the user that Email Love migration now ships inside the supported Codex plugin:

```bash
codex plugin marketplace add email-love/codex-agents --ref v4.3.0
codex plugin add email-love@email-love
```

After installation, start a new Codex task and ask:

```text
Use $email-love-design-system-migration to audit this legacy email design system.
Keep the source file read-only.
```

The complete pre-plugin migration instructions remain available for provenance at
`legacy/migration-AGENTS-1.19.0.md`. Do not copy that snapshot back into active instructions.
