# Email Love plugin submission

This is the portal-ready submission brief for the `email-love` skills-only plugin.

## Submission type

- **Type:** Skills only
- **Plugin name:** Email Love
- **Publisher:** Email Love
- **Version:** 4.5.0
- **Category:** Creativity
- **Repository:** https://github.com/email-love/codex-agents

The package does not bundle an MCP server. Its workflows require the official remote Figma
MCP as an external prerequisite and the Email Love plugin installed in Figma.

## Listing details

- **Short description:** Build export-ready emails and migrate email design systems.
- **Long description:** Build production-ready marketing and lifecycle emails in Figma from
  existing Email Love components or a converter-assisted first-email workflow. Audit and
  migrate legacy email libraries into reusable Email Love design systems through staged,
  reviewable batches that keep the source read-only.
- **Website:** https://emaillove.com
- **Support:** https://help.emaillove.com/plugin/getting-started/overview
- **Privacy policy:** https://emaillove.com/privacy-policy
- **Terms of service:** https://emaillove.com/terms
- **Logo:** `plugins/email-love/assets/email-love-logo.png`
- **Brand color:** `#EE2461`

## Starter prompts

1. Build an export-ready email in my Figma file.
2. Audit this legacy email design system.
3. Convert the next migration batch in Figma.

## Capabilities and prerequisites

The plugin contains two skills:

- `email-love-figma-builder` builds one campaign email or sequence through an existing
  Email Love design system or the converter-assisted first-email path.
- `email-love-design-system-migration` audits and migrates a legacy email library in staged
  batches while keeping the source read-only.

Reviewer setup requires:

- the official remote Figma MCP with `use_figma`, `get_metadata`, and `get_screenshot`;
- a reviewer-accessible Figma fixture with a synced Email Love design system for Path A;
- a separate reviewer-accessible Figma fixture without a design system for Path B;
- the latest Email Love Figma plugin;
- normal approval prompts enabled for canvas writes.

The optional Email Love MCP adds quota-free preview export and mobile verification. The
skills include a human-run plugin Export fallback when that MCP is unavailable.

## Data handling disclosure

Path B and migration conversion send a rendered PNG of customer-provided design material to
`https://design-converter.andy-30d.workers.dev`. Requests may include pinned text, font,
color, dimension, and frame-structure metadata. The documented default result cache is 24
hours and `nocache=1` bypasses that cache. The skills instruct users to confirm permission,
remove credentials and unnecessary personal data, and avoid sensitive or regulated content
before conversion. See `SECURITY.md` for the repository disclosure.

Before submission, confirm the public privacy policy describes these data categories,
processing purposes, recipients, retention behavior, and user controls.

## Reviewer tests

The required five positive and three negative cases are in
`tests/submission-cases.json`. Provide reviewer-accessible fixture links in the portal for
the cases that require Figma files. Keep those links out of the public repository if they
grant write access.

## Initial release notes

Initial public submission of Email Love for ChatGPT and Codex. The plugin packages two
skills for building export-ready emails in Figma and migrating legacy email design systems.
It enforces source-safe migration, staged human review, exporter-aware structure, mobile and
dark-mode checks, and explicit fallback behavior when required write tools are unavailable.

## Publishing an update

The public plugin is a reviewed snapshot. A push to GitHub, a new tag, or a Git marketplace
upgrade does not update people who installed it from the Plugins Directory.

For every public update:

1. Port and validate the final Codex skill changes in this repository.
2. Tag and push the GitHub release.
3. Create a new plugin version in the OpenAI submission portal and upload the final skills-only
   bundle, logo, listing details, reviewer tests, and release notes.
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
- Supply reviewer-accessible Figma fixtures without MFA, email confirmation, or private
  network requirements.
- Confirm the public privacy policy covers the converter disclosure above.
- Select only countries where Email Love's product, legal terms, and support are available.
- Complete the policy attestations after checking the final uploaded skill snapshot.
