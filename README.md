# Email Love for OpenAI Codex

Build, repair, and migrate real, export-ready emails and email design systems in Figma with
progressively loaded Codex skills.

This repository is the source for the public Email Love plugin and a Git-backed Codex plugin
marketplace. It packages four focused Email Love skills:

- **Email Love Figma Builder:** build one email or campaign using an existing Email Love
  design system, or create a first email through the design-converter workflow.
- **Email Love Template Repair:** diagnose and repair an existing Email Love email or reusable
  module when the canvas, plugin Preview, production exporter, mobile layout, or inbox result
  disagrees.
- **Email Love Design System Migration:** audit a legacy library from Figma, files, cloud
  storage, or a supported ESP and convert it into an Email Love design system in staged,
  reviewable batches.
- **Email Love Figma Quality Gates:** independently verify migration batches and reusable
  modules before approval.

The underlying Figma frames export to production HTML through the Email Love plugin. These
workflows therefore protect Email Love's structural conventions, not just canvas appearance.

## Install

### 1. Install the public plugin

[Install Email Love from the Plugins Directory](https://chatgpt.com/plugins/plugins_6a739f43c3b48191b1281a9b2d48b409),
then start a new Codex task. The published version is a reviewed snapshot; 4.11 adds campaign
research and Figma conversion through the consolidated Email Love MCP after review and publication.

The public listing is the recommended customer install. It is a reviewed, published snapshot,
not a live checkout of this repository.

### Developer install from GitHub

For development or testing an exact repository release, add this marketplace and install the
plugin:

```bash
codex plugin marketplace add email-love/codex-agents --ref v4.11.0
codex plugin add email-love@email-love
```

You can also open `/plugins` in Codex CLI, select the **Email Love** marketplace, and install
the Git-backed plugin there. Replace `v4.11.0` with `main` only when testing unreleased work.

The public and Git-backed installs are separate distribution paths. A GitHub push or marketplace
refresh does not update the reviewed public plugin.

### 2. Connect Figma

The skills require the official remote Figma MCP as an external prerequisite. The Email Love
plugin does not bundle or declare the Figma integration. Connect it before using any workflow:

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

The plugin bundles one consolidated Email Love MCP connection:

- `emaillove` at `https://mcp.emaillove.com/mcp` searches real campaigns, individual emails,
  brands, and lifecycle journeys; accesses saved collections; converts a Figma design or
  supplied screenshot through `emaillove_convert_design`; and gives migration and repair
  workflows design-system access, headless export verification, and desktop/mobile previews.

On a public directory install, authorize it once:

```bash
codex mcp login emaillove
```

The sign-in screen uses Email Love's normal account flow. Completing it authorizes the MCP
connection, not the Figma plugin. Start a new task after connecting. On a developer Git install,
add the server manually if its bundled connection was not registered:

```bash
codex mcp add emaillove --url https://mcp.emaillove.com/mcp
codex mcp login emaillove
```

If the `emaillove` QA connection is unavailable or not authorized, migration and repair fall
back to a human-run Email Love plugin Export for the production batch check.

The MCP is source-led: conversion starts from a Figma node or supplied screenshot, and the QA
tools verify existing Email Love Figma artifacts. It is not a free-form HTML generator for chat.

### 3. Install Email Love in Figma

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

### Repair a broken template

```text
Use $email-love-template-repair to diagnose and repair this Email Love template.
The canvas looks correct, but the second section exports as one image on mobile.
```

The repair skill first proves whether the target is an Email Love email, reusable module, or
library instance. It preserves the original campaign by default, changes one measured cause at a
time, and reports canvas, structure, and exporter verification separately. A repair is called
fixed only when all three pass. If a private plugin value or a named inbox test cannot be changed
from Codex, the handoff names the exact remaining user action.

### Migrate a design system

```text
Use $email-love-design-system-migration to audit this legacy email design system.
Keep the source file read-only.
```

The migration skill always audits first, builds in a separate target file, and converts no
more than five modules before a review gate.

Each audit records source text and image counts for every module. Before design review, every
rebuild must pass source-parity checks for content, alignment, band fills, typography weight,
semantic bindings, contrast, and asset identity, with a fresh screenshot for each module.

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
3. It reads the Path A, Path B, repair, audit, migration, or render references only when that phase
   requires them.

The complete pre-plugin instructions remain frozen under [`legacy/`](legacy/) for provenance,
not as the recommended installation path.

## Upgrade

Public plugin updates follow a release process:

1. Validate and tag the GitHub release.
2. Create a new skills-plus-MCP plugin version in the OpenAI submission portal, enter
   `https://mcp.emaillove.com/mcp`, and upload the final skill bundle.
3. Submit it for review, then publish the approved version.
4. Verify the public listing and start a new task before testing it.

Pushing to GitHub alone does not update people who installed the public plugin. Once an approved
version is published, directory users receive that published snapshot. See the
[OpenAI plugin submission guide](https://developers.openai.com/plugins/deploy/submission) for the
current portal workflow.

For a developer install from the Git marketplace, refresh it separately, then reinstall or
upgrade from `/plugins`:

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
    ├── email-love-template-repair/
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
packages and tests only the Codex version. The implementation handoff for porting the Repair skill
is in [CLAUDE-HANDOFF-TEMPLATE-REPAIR-SKILL.md](CLAUDE-HANDOFF-TEMPLATE-REPAIR-SKILL.md).

## Documentation and support

- [Install the public Email Love plugin](https://chatgpt.com/plugins/plugins_6a739f43c3b48191b1281a9b2d48b409)
- [Agents in Figma](https://help.emaillove.com/plugin/ai/agents-in-figma)
- [Migrate an existing design system](https://help.emaillove.com/plugin/ai/migrate-design-system)
- [Email Love support](mailto:hello@emaillove.com)
