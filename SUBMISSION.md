# Email Love plugin submission

This is the portal-ready submission brief for the `email-love` skills-and-MCP plugin.

## Submission type

- **Type:** MCP server with skills
- **Plugin name:** Email Love
- **Publisher:** Email Love
- **Version:** 4.11.1
- **Category:** Creativity
- **Repository:** https://github.com/email-love/codex-agents

The public submission combines one consolidated Email Love MCP with fourteen skills: the four
Figma/Email Love workflows (Builder, Template Repair, Design System Migration, Figma Quality
Gates) plus ten ESP templating skills (Braze Liquid, Customer.io Liquid, HubSpot HubL,
Iterable Handlebars, Klaviyo Django, Marketo Velocity, MoEngage Jinja, Sailthru Zephyr, SFMC
AMPscript, Zeta ZML) that work on any email HTML. The ESP skills are staged into the skill
upload at build time from email-love/esp-skills at the commit pinned in sources.json. Canvas
workflows additionally require the official remote Figma MCP and the Email Love plugin in
Figma.

## Bundled MCP server

- **Server name:** `emaillove`
- **URL:** `https://mcp.emaillove.com/mcp` (streamable HTTP)
- **Domain:** `mcp.emaillove.com`, a subdomain of `emaillove.com`
- **Authentication:** OAuth 2.1 with PKCE and dynamic client registration through Email Love's
  account flow.
- **What it adds:** campaign and brand research (`search_emails`, `fetch_email`,
  `search_brands`, `get_brand_insights`, `list_journeys`, and `get_journey`); authenticated
  design-system access; `emaillove_convert_design` for source-led Figma AI Import; and
  `emaillove_export_figma` plus `emaillove_preview_email` for production export and
  desktop/mobile verification.
- **Boundary:** `emaillove_convert_design` accepts a Figma `fileKey` and `nodeId`, or a
  supplied screenshot URL, and returns measured conversion output for an agent to transcribe.
  It is not a free-form HTML generator. The QA tools verify existing Email Love Figma artifacts
  and do not replace the Email Love Figma plugin as the customer-facing build/export surface.

## Listing details

- **Short description:** Build and repair emails in Figma, research inspiration, and add ESP templating.
- **Long description:** Build production-ready marketing and lifecycle emails in Figma from
  existing Email Love components or a converter-assisted first-email workflow. Diagnose and
  repair broken Email Love templates and modules with canvas, structure, and exporter evidence.
  Audit and migrate legacy email libraries into reusable Email Love design systems through
  staged, reviewable batches that keep the source read-only. Research real campaigns, brand
  patterns, and lifecycle journeys through the Email Love MCP. Add or troubleshoot
  ten major ESP templating languages in any email HTML.
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
4. Find three post-purchase emails to inspire this Figma build.

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

The Email Love MCP adds campaign and journey research, source-led Figma conversion, and
production export/mobile verification after `codex mcp login emaillove`. Any Email Love account,
including a free one, can authorize the connection. A reviewer should request campaign
inspiration, then run a migration/repair export check against an existing Figma artifact. The
first should use research tools; the second should use QA tools. Neither should be described as
free-form HTML generation in chat.

The separate native-Figma connector at `https://mcp.emaillove.com/figma/mcp` is not part of this
ChatGPT plugin submission. Its agent-specific build skill remains behind the live end-to-end Figma
connector acceptance test, so the public listing must not claim that native connector workflow is
released.

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

## Release notes for 4.11.0

Email Love now adds campaign research, brand and lifecycle insights, and source-led Figma AI
Import to the existing authenticated MCP. Users can research real campaigns, inspect individual
emails, compare brands, study lifecycle journeys, and convert a specified Figma design through
the converter pipeline without installing a second connector. Migration and repair keep
design-system access, headless export verification, and desktop/mobile previews for existing
Email Love Figma artifacts. Conversion requires a Figma source or supplied screenshot and is not
presented as free-form HTML generation in chat. The four Email Love workflow skills and ten ESP
templating skills remain in the plugin.

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
3. Create a new plugin version in the OpenAI submission portal, configure
   `https://mcp.emaillove.com/mcp`, and
   upload the final skill bundle, logo, listing details, reviewer tests, and release notes.
   Keep the MCP server details section current.
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
- Add the four starter prompts above.
- Add the five positive and three negative reviewer tests from
  `tests/submission-cases.json`.
- Complete MCP domain verification for `mcp.emaillove.com`, then enter that server URL and its
  OAuth details. Confirm its tool scan includes the research, conversion, and QA tools listed
  above.
- Supply reviewer-accessible Figma fixtures without MFA, email confirmation, or private
  network requirements.
- Confirm the public privacy policy covers the converter disclosure above.
- Select only countries where Email Love's product, legal terms, and support are available.
- Complete the policy attestations after checking the final uploaded skill snapshot.
