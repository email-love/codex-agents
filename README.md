# Email Love for OpenAI Codex

Build real, export-ready emails in Figma and migrate legacy email design systems into Email
Love with progressively loaded Codex skills.

This repository is a Git-backed Codex plugin marketplace. It packages two focused skills:

- **Email Love Figma Builder:** build one email or campaign using an existing Email Love
  design system, or create a first email through the design-converter workflow.
- **Email Love Design System Migration:** audit a legacy library from Figma, files, cloud
  storage, or a supported ESP and convert it into an Email Love design system in staged,
  reviewable batches.

The underlying Figma frames export to production HTML through the Email Love plugin. These
workflows therefore protect Email Love's structural conventions, not just canvas appearance.

## Install

### 1. Add the Email Love marketplace

```bash
codex plugin marketplace add email-love/codex-agents --ref main
```

For production use, replace `main` with a release tag so upgrades are deliberate.

### 2. Install the plugin

```bash
codex plugin add email-love@email-love
```

You can also open `/plugins` in Codex CLI, select the **Email Love** marketplace, and install
the plugin there.

Start a new Codex task or CLI session after installation so the bundled skills are loaded.

### 3. Connect Figma

The plugin declares the official remote Figma MCP as a dependency. If Codex does not prompt
you to connect it automatically, run:

```bash
codex mcp add figma --url https://mcp.figma.com/mcp
codex mcp login figma
```

Use the remote server. The workflow requires `use_figma`, `get_metadata`, and
`get_screenshot`; a connection without `use_figma` is read-only.

The Figma MCP login uses OAuth. Separately, the Email Love conversion workflow can require a
Figma personal access token for file, library, and asset operations outside the MCP OAuth
session:

```bash
export FIGMA_TOKEN=figd_...
```

Create it in Figma Account Settings with Current user, File content, File metadata, and
Library content scopes, then launch Codex from the same environment.

For fully agent-run migration export and mobile QA, also connect the Email Love MCP:

```bash
codex mcp add emaillove --url https://mcp.emaillove.com/mcp
codex mcp login emaillove
```

When `emaillove_export_figma` is available, Codex can compile a bare module through Email
Love's production export pipeline with no export quota and send the returned preview token to
`emaillove_preview_email`. Without it, the migration skill falls back to a human-run plugin
Export for the batch check.

### 4. Install Email Love in Figma

Install the latest Email Love Figma plugin.

- Building from an existing library requires a
  [synced design system](https://help.emaillove.com/plugin/components/design-systems).
- Building a first email without one uses the design-converter path.

Approve the Figma write calls when Codex asks. Do not disable the entire sandbox merely to
avoid repeated Figma approvals. For unattended work, use a trusted isolated environment and
grant only the permissions the workflow needs.

## Use

Talk to Codex normally. The skills can activate implicitly, or invoke one explicitly.

### Build an email

```text
Use $email-love-figma-builder to build a promo email in
https://figma.com/design/...

Spring sale, 20% off with code SPRING20, ends Sunday, one CTA to the pricing page.
```

You can also say:

```text
Build a three-email welcome sequence in this Figma file.
```

### Migrate a design system

```text
Use $email-love-design-system-migration to audit this legacy email design system.
Keep the source file read-only.
```

The migration skill always audits first, builds in a separate target file, and converts no
more than five modules before a review gate.

At the start of an audit it asks where the current emails live. Supported sources are:

- Figma;
- a local folder of HTML, EML, PNG, or JPEG files;
- Google Drive or SharePoint folders;
- Klaviyo, Marketo, Customer.io, Brevo, Kit, ActiveCampaign, Iterable, Omnisend, or HubSpot.

Figma produces the richest audit because components, styles, variables, and reuse are
structured data. File, cloud, and ESP sources are treated as visual references and rebuilt to
email standards. Each connected source stays read-only. Non-Figma sources require their named
MCP connection, except Local Folder, which requires local file access, and Marketo, which uses
read-only REST calls from an environment that permits outbound HTTP.

The first adapter release intentionally reads a bounded content pool per ESP. For example,
Klaviyo and Marketo start with standalone templates, while Customer.io starts with Templates
and Newsletters. The migration report names excluded campaign, automation, transactional, or
dynamic-content surfaces so a partial source is never presented as the customer's whole library.

## Why this is a plugin instead of a global `AGENTS.md`

The original builder and migration files were approximately 158 KB and 241 KB. Codex's
default combined project-instruction limit is 32 KiB, so installing those files as
`AGENTS.md` could truncate them before the critical render and verification rules.

Skills use progressive disclosure:

1. Codex initially sees only each skill's name and trigger description.
2. It loads the compact `SKILL.md` when a matching task begins.
3. It reads the Path A, Path B, audit, migration, or render references only when that phase
   requires them.

The complete pre-plugin instructions remain frozen under [`legacy/`](legacy/) for provenance,
not as the recommended installation path.

## Upgrade

Refresh the Git marketplace, then reinstall or upgrade the plugin from `/plugins`:

```bash
codex plugin marketplace upgrade email-love
```

Start a new task after an upgrade.

## Security and data handling

Path B and migration conversion send customer-provided design renders to the Email Love
design-converter service. Review [SECURITY.md](SECURITY.md) before using the converter with
sensitive or regulated material.

## Development

Repository structure:

```text
.agents/plugins/marketplace.json
plugins/email-love/
├── .codex-plugin/plugin.json
└── skills/
    ├── email-love-figma-builder/
    └── email-love-design-system-migration/
```

Run the repository checks before opening a pull request:

```bash
python3 scripts/validate_repo.py
```

The checks validate plugin metadata, skill frontmatter, context budgets, reference links,
provenance snapshots, and representative routing fixtures.

## Claude

The source Email Love workflows for Claude live at
[email-love/claude-skills](https://github.com/email-love/claude-skills). This repository
packages and tests only the Codex version.

## Documentation and support

- [Agents in Figma](https://help.emaillove.com/plugin/ai/agents-in-figma)
- [Migrate an existing design system](https://help.emaillove.com/plugin/ai/migrate-design-system)
- [Email Love support](mailto:hello@emaillove.com)
