# Email Love plugin submission

This is the portal-ready submission brief for the `email-love` skills-and-MCP plugin.

## Submission type

- **Type:** MCP server with skills
- **Plugin name:** Email Love
- **Publisher:** Email Love
- **Version:** 4.10.0
- **Category:** Creativity
- **Repository:** https://github.com/email-love/codex-agents

The package bundles the Email Love MCP (server name `emaillove`) and fourteen skills: the four Figma/Email Love workflows (Builder, Template Repair, Design System Migration, Figma Quality Gates) plus ten ESP templating skills (Braze Liquid, Customer.io Liquid, HubSpot HubL, Iterable Handlebars, Klaviyo Django, Marketo Velocity, MoEngage Jinja, Sailthru Zephyr, SFMC AMPscript, Zeta ZML) that work on any email HTML. The ESP skills are staged into the upload at build time from email-love/esp-skills at the commit pinned in sources.json. Its
workflows additionally require the official remote Figma MCP as an external prerequisite for
canvas builds, and the Email Love plugin installed in Figma.

## Bundled MCP server

- **Server name:** `emaillove`
- **URL:** `https://mcp.emaillove.com/mcp` (streamable HTTP)
- **Domain:** `mcp.emaillove.com`, a subdomain of `emaillove.com` (same publisher; use for
  domain verification)
- **Authentication:** OAuth 2.1 with PKCE and dynamic client registration
  (`/.well-known/oauth-authorization-server` on the same origin). The consent page also
  accepts an Email Love license key for legacy accounts. The sign-in screen is Email Love's
  standard account flow, shared with the Figma plugin.
- **Tool annotations:** declared by the server per tool (`readOnlyHint`, `destructiveHint`,
  `idempotentHint`, `openWorldHint` on every tool definition).
- **What it adds:** the agent-only QA connection for migration work: design-system access
  (brands, components, templates) and the headless exporter. `emaillove_export_figma`
  compiles a Figma template or module to production HTML with no plugin click
  (`operationType: "preview"` charges no export quota), and its token feeds
  `emaillove_preview_email` for desktop and mobile renders. It is not a customer surface
  for creating, previewing, or exporting emails; those happen in the Email Love Figma
  plugin.

## Listing details

- **Short description:** Build, repair, and migrate export-ready emails in Figma.
- **Long description:** Build production-ready marketing and lifecycle emails in Figma from
  existing Email Love components or a converter-assisted first-email workflow. Diagnose and
  repair broken Email Love templates and modules with canvas, structure, and exporter evidence.
  Audit and migrate legacy email libraries into reusable Email Love design systems through
  staged, reviewable batches that keep the source read-only.
- **Website:** https://emaillove.com
- **Support:** https://help.emaillove.com/plugin/getting-started/overview
- **Privacy policy:** https://emaillove.com/privacy-policy
- **Terms of service:** https://emaillove.com/terms
- **Logo:** `plugins/email-love/assets/email-love-logo.png`
- **Brand color:** `#EE2461`

## Starter prompts

1. Build an export-ready email in my Figma file.
2. Repair this broken Email Love template in Figma.
3. Audit and migrate this legacy email design system.

## Capabilities and prerequisites

The plugin contains four skills:

- `email-love-figma-builder` builds one campaign email or sequence through an existing
  Email Love design system or the converter-assisted first-email path.
- `email-love-template-repair` diagnoses and repairs an existing Email Love email or reusable
  module. It preserves the original by default, protects component and foundation integrity,
  and calls a repair fixed only after canvas, structure, desktop export, and mobile export pass.
- `email-love-design-system-migration` audits and migrates a legacy email library in staged
  batches while keeping the source read-only.
- `email-love-figma-quality-gates` is the independent acceptance layer: it audits a migration
  batch or reusable module against proof-batch, geometry, asset, property, and production
  render gates before approval, using a machine-readable audit snapshot and two bundled
  Python validators.

Reviewer setup requires:

- the official remote Figma MCP with `use_figma`, `get_metadata`, and `get_screenshot`;
- a reviewer-accessible Figma fixture with a synced Email Love design system for Path A;
- a separate reviewer-accessible Figma fixture without a design system for Path B;
- the latest Email Love Figma plugin;
- normal approval prompts enabled for canvas writes.

The bundled Email Love MCP adds quota-free preview export and mobile verification once the
reviewer authorizes it (`codex mcp login emaillove`; any Email Love account works, including
a free one). The skills include a human-run plugin Export fallback when the MCP is not
authorized or a module is outside the exporter's core-tag coverage.

## Data handling disclosure

Path B and migration conversion send a rendered PNG of customer-provided design material to
`https://convert.emaillove.com`. Requests may include pinned text, font,
color, dimension, and frame-structure metadata. The documented default result cache is 24
hours and `nocache=1` bypasses that cache. The skills instruct users to confirm permission,
remove credentials and unnecessary personal data, and avoid sensitive or regulated content
before conversion. See `SECURITY.md` for the repository disclosure.

Before submission, confirm the public privacy policy describes these data categories,
processing purposes, recipients, retention behavior, and user controls.

## Reviewer tests

The required cases (five positive, three negative) are in
`tests/submission-cases.json`. Provide reviewer-accessible fixture links in the portal for
the cases that require Figma files. Keep those links out of the public repository if they
grant write access.

## Release notes for 4.8.0

Email Love adds a third skill for repairing existing Email Love templates and reusable modules.
The repair workflow reproduces the failure first, preserves campaign originals, requires an
explicit impact choice before changing shared source components, and applies one measured repair
at a time. It includes a symptom-to-cause matrix for invalid roots, flattened content, Outlook
clipping, double padding, mobile stacking, buttons, images, dark mode, links, and component
properties. A repair is reported as fixed only when the canvas, structure, desktop exporter, and
mobile exporter all pass; unavailable exporter or inbox checks are named as deferred rather than
silently counted as success. Builder and migration behavior are unchanged.

## Initial release notes (4.5.0, for the record)

Initial public submission of Email Love for ChatGPT and Codex. The plugin packaged two
skills for building export-ready emails in Figma and migrating legacy email design systems.
It enforces source-safe migration, staged human review, exporter-aware structure, mobile and
dark-mode checks, and explicit fallback behavior when required write tools are unavailable.

## Publishing an update

The public plugin is a reviewed snapshot. A push to GitHub, a new tag, or a Git marketplace
upgrade does not update people who installed it from the Plugins Directory.

For every public update:

1. Port and validate the final Codex skill changes in this repository.
2. Tag and push the GitHub release.
3. Create a new plugin version in the OpenAI submission portal and upload the final bundle
   (skills plus the bundled MCP declaration), logo, listing details, reviewer tests, and
   release notes. Keep the MCP server details section current.
4. Submit the version for review.
5. Publish it after approval.
6. Verify the public listing at
   https://chatgpt.com/plugins/plugins_6a739f43c3b48191b1281a9b2d48b409 and test it from a new
   ChatGPT chat or Codex task.

Directory users receive the newly published snapshot after step 5. Starting a new chat or task is
the safest way to ensure the new version is loaded. Confirm the current requirements against the
[OpenAI plugin submission guide](https://developers.openai.com/plugins/deploy/submission) before
each submission.

## Portal checklist

- Confirm the submitter has **Apps Management: Write** in the publishing organization.
- Select the verified Email Love business identity.
- Upload the final skill bundle and logo.
- Add the three starter prompts above.
- Add the five positive and three negative reviewer tests from
  `tests/submission-cases.json`.
- Complete MCP domain verification for `mcp.emaillove.com` and enter the server URL and
  OAuth details from the Bundled MCP server section above.
- Supply reviewer-accessible Figma fixtures without MFA, email confirmation, or private
  network requirements.
- Confirm the public privacy policy covers the converter disclosure above.
- Select only countries where Email Love's product, legal terms, and support are available.
- Complete the policy attestations after checking the final uploaded skill snapshot.
