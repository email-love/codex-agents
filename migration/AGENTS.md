# Email Love: migrating an existing design system (Codex)

## What this file is, and how to use it

This is a **configuration file for OpenAI Codex**, not a prompt. It covers **migration**:
auditing an existing (non Email Love) Figma design system, then converting it into a working
Email Love design system. It is the Codex port of the emaillove-migration-audit and
emaillove-eds-converter Claude skills (github.com/email-love/claude-skills).

It is a **separate file from the email builder instructions** on purpose. Migration is a
project you do once; building emails is something you do constantly. Keep them apart:

1. Make a folder for the migration work, for example `~/seed-migration`.
2. Save this file as `AGENTS.md` at the root of that folder.
3. Run `codex` from inside that folder. Codex loads this file automatically; you never
   mention it again.
4. Keep the builder instructions at `~/.codex/AGENTS.md` for everyday email work.

**Version 1.8.0** (2026-07-28). This file does not update itself. If you have web access,
check https://raw.githubusercontent.com/email-love/codex-agents/main/migration/AGENTS.md
against the version above once per conversation, and mention it at hand-off if yours is
older.

## Setup

- Connect the **remote** Figma MCP server (`https://mcp.figma.com/mcp`) and sign in:
  `codex mcp add figma --url https://mcp.figma.com/mcp` then `codex mcp login figma`.
- **Approve the `use_figma` tool calls when asked.** Every canvas write goes through that one
  tool and a conversion fires hundreds of them. If they are declined, or the session cannot
  prompt, you will report that Figma write tools "aren't connected" and build nothing even
  though the connection is fine. For unattended runs, pass
  `--dangerously-bypass-approvals-and-sandbox`.
- The audit needs only read access. The conversion also needs the Email Love Figma plugin
  installed in the target file.
- Work incrementally: one `setCurrentPageAsync` per `use_figma` call, small batches of
  operations, and validate with `get_metadata` or a screenshot after each structural step.
  A migration is long; a failed 200-operation call wastes far more than a failed 10-operation
  one.

---

# Phase 1: Audit (read-only)

Audit an existing Figma design system for migration to Email Love, and produce a migration
report the customer and the Email Love team can act on. This is Phase 1 of a migration: it
tells everyone what they have, what converts, what needs design judgment, and how big the job
is. The actual conversion is done by Email Love's team as part of Enterprise onboarding.

**This skill is strictly read-only.** Never create, modify, rename, or delete anything in the
customer's file. Every Figma call you make must be an inspection. If the user asks you to
start converting, explain that conversion is the next phase and offer to connect them with
Email Love (hello@emaillove.com).

## Step 1: Scope the input

You need the Figma file link. If several files hold the design system, audit each. Ask only
three questions if not obvious: which frames or pages are the email templates (as opposed to
web or app design); whether there is an existing production email you can use as a reference
for how their emails actually render today; and whether the component masters live in this
file or in a separate Figma library, and if separate, ask for that file too. A missing
library file is the most common blocker an audit surfaces, and knowing up front saves the
report from guessing about components it cannot see.

## Step 2: Survey the file

Build the inventory with read-only calls:

1. **Pages** and what each holds (component libraries, template galleries, guidelines,
   icon sets, font fallback references).
2. **Brand foundations:** local text styles (the type ramp with families, weights, sizes),
   local paint styles (the palette and its naming taxonomy), variable collections, and any
   spacing or padding component sets. Note a fonts-fallback page if one exists; it means the
   team has already chosen email-safe substitutes.
3. **Template census:** every candidate frame, with name, width, height, and component/frame
   type. Group desktop and mobile twins (the same design at two widths, commonly 600 and 390);
   in Email Love these merge into ONE frame with Mobile Styles overrides, so count designs,
   not frames.

## Step 3: Classify every template

Inspect each design's structure (walk the tree: node types, auto-layout, text nodes, image
fills, vectors, nested instances) and assign one verdict:

- **(A) Live-text convertible.** Auto-layout stacks of text, images, and buttons that map
  onto mj-section/mj-column/element-frame structure. Text stays selectable and editable in
  the sent email. Best deliverability and accessibility; most modules should land here.
- **(B) Editable-image candidate.** Design-rich compositions (layered imagery, text on
  photos, custom shapes, brand illustrations) that would fight email rendering as live text.
  Email Love handles these deliberately: the design frame is placed inside a column without
  an MJML type name, and the exporter flattens it to a single hosted image at export while it
  stays fully editable in Figma. No rebuild needed; the design survives as-is. Cost: the text
  inside is not live in the inbox (image weight, accessibility, clients with images off), so
  recommend pairing with alt text and keeping critical copy outside the image.
- **(C) Hybrid.** Split the module: headline and body as live text, the rich visual region as
  an editable image. Common for heroes.
- **(D) Not emailable.** Interactive patterns (hover states, carousels, video embeds beyond a
  thumbnail link), viewport-relative layouts, or app UI that has no email equivalent. List
  what would replace them.

Signals that push a module from A toward B or C: vector logos and illustrations (email wants
images), buttons built as nested app-style instances with state layers, stacked image fills,
gradients and blend modes on text, and effects email clients do not render. Signals of A:
clean vertical auto-layout, flat solid fills, one image per region, system-mappable text.

Do not over-classify toward images. Two MJML capabilities keep more modules live-text than
designers expect: **mj-hero** renders live text over a full background image, so "headline on
a photo" is verdict A when the text sits on one background image rather than woven through
layered art; and sections support background images behind live columns. Reserve B for
compositions where text and imagery genuinely interleave (text wrapping around cutouts,
badges over product shots, hand-placed collage).

## Step 4: Extract the brand foundations

From the survey, draft what the Email Love design system will carry:

- **Type ramp mapping:** each of their text styles mapped to an email-safe equivalent, using
  their own fallback choices when a fallbacks page exists. Flag fonts that need web-font
  hosting or substitution.
- **Palette:** their named paint styles, and a proposed set of the six Email Love theme
  colors (backgroundColor, contentColor, textColor, linkColor, buttonTextColor,
  buttonContentColor) drawn from it, marked as a proposal for their designer to confirm.
- **Spacing scale** from any padding/spacer components.
- **Buttons:** their button styles as candidates for the Email Love button component page.
- **Email width** (their desktop template width) and anything that contradicts it.

## Step 5: Write the migration report

Produce one markdown report, in this exact structure:

# Migration audit: [Design system name]
## Summary
[Three sentences: what they have, how much converts cleanly, the one or two biggest items
needing design judgment.]
## Inventory
[Pages, style counts, component counts, template count as designs (with desktop/mobile pairs
merged), fonts in play.]
## Template classification
[A table: design name | verdict A/B/C/D | width(s) | notes. One row per design.]
## Brand foundations
[Type ramp mapping table, proposed theme colors, spacing scale, button styles.]
## Flags
[Everything a human should look at: fonts unavailable for email, naming typos, empty pages,
inconsistent widths, accessibility risks from image-heavy modules.]
## Effort estimate
[Per-verdict counts and an S/M/L per design: A modules are mechanical; C modules need a
design pass; D modules need product decisions. State the total in designer-days as a range,
and say plainly that estimates firm up after the first converted batch.]
## Recommended next step
[The conversion phases: foundations, then modules in batches with design review between
batches. Email Love's team does this as part of Enterprise onboarding: hello@emaillove.com.]

Numbers in the report come from your actual reads, never estimates presented as counts. Where
you sampled instead of walking everything, say so.

## Step 6: Hand off

Deliver the report as a file or artifact the user can share internally. Offer to answer
questions about any specific module's verdict, and to re-run the audit after they clean up
anything the flags surfaced.

---

# Phases 2 and 3: Convert

Convert an audited legacy design system into a working Email Love design system. This skill
follows a migration audit (the emaillove-migration-audit skill produces it) and works in two
phases: foundations once, then modules in batches. A designer reviews between batches; never
convert the whole library in one unreviewed pass.

Prefer to have this done for you? Email Love's team runs this exact process, with design
review included, as part of Enterprise onboarding: hello@emaillove.com.

Two hard rules:

- **The customer's source file is read-only, always.** All building happens in a separate
  target file. Reads from the source are inspections, screenshots, and asset downloads only.
- **The audit report is required input.** It carries the classification (A/B/C/D), the brand
  foundations, and the flags. Do not re-derive what it already settled; do re-verify anything
  that looks wrong when you meet the actual nodes.

## Inputs

1. The migration audit report (file or pasted).
2. The source Figma file link (read-only).
3. The target file: an existing one the team designates, or create one named
   "[Customer] — Email Love Design System" via the Figma MCP.
4. Which batch to run: "foundations", or a named batch of modules ("batch 1: the 5 modules
   listed in the audit's recommended next step", or an explicit list).

## Phase 2: Foundations (run once per customer)

Build the scaffold every later batch depends on:

1. **Pages**, following Email Love library conventions: a Cover, one page per section
   category the audit found (Heroes, Copy Blocks, Lists, and so on), Buttons, Type,
   Campaigns.
2. **Type mapping.** Recreate the customer's type ramp as Figma text styles in the target
   file using their email-safe fallback choices from the audit (never the unlicensed brand
   font unless the user confirms web-font hosting). Name styles as the customer named theirs.
3. **Buttons page.** Rebuild each of their button styles as a component: correct email
   construction (a styled frame with a single text node), not their app-style nested
   instances. These become the sub-components nested inside mj-button-Frames.
4. **Spacing.** Recreate their spacer scale as components if they had one.
5. **Assets.** Export the logo and any recurring imagery from the source file
   (download_assets) and upload into the target file (upload_assets). Logos become images,
   never vectors.
6. **Root template frame** on Campaigns at the customer's email width: vertical auto-layout,
   the shared marker, and the six theme colors from the audit's proposal:
   `setSharedPluginData('emaillove', 'nodeType', 'mainFrame')` plus backgroundColor,
   contentColor, textColor, linkColor, buttonTextColor, buttonContentColor.
7. **Report** what was built, what the audit proposed that you changed, and what needs the
   designer's eye before batch 1 (theme colors especially: they are a proposal until a human
   confirms).

## Phase 3: Module conversion (run per batch)

For each module in the batch, in order:

### 1. Rebuild the desktop frame as Email Love structure

Work from the source design's structure and a screenshot. In the target file, build the
module as a component with correct export structure:

- Structural frames named exactly (`mj-section`, `mj-column`) or carrying the tag in the
  `name` shared plugin data key with a human layer name.
- **Content leaves are tagged PAIRS, wrapper plus inner node.** `mj-text-Frame` contains a
  text node tagged `mj-text`; `mj-image-Frame` contains the image rectangle tagged
  `mj-image`; `mj-button-Frame` contains a node tagged `mj-button` whose own direct child is
  a TEXT node. Tagging only the wrapper is the single most damaging mistake in a conversion:
  untagged inner content is not skipped, it is flattened into a hosted PNG by the exporter's
  unknown-node path, so buttons silently lose their text and links and image sections can
  export empty. After building each module, verify every leaf pair before moving on.
- A badge, pill, or icon sitting beside text is its own element pair, not a loose frame
  inside `mj-text-Frame`.
- Map every text node to the type styles from foundations.
- Images: one image fill per `mj-image-Frame`, assets round-tripped from the source file.
- Buttons: `mj-button-Frame` wrapping an instance of the foundations button component.
- Verdict B regions (from the audit): place the design content as a frame with NO
  recognized tag name inside a column; the exporter flattens it to a hosted image at export
  while it stays editable. Verdict C modules: live-text structure for the copy, one
  editable-image frame for the rich region.
- Text over a single background photo is mj-hero territory, live text, not an image.

### 2. Merge the mobile twin

Diff the source's mobile frame against its desktop sibling and express every intentional
difference as Mobile Styles data on the rebuilt nodes, via shared plugin data:

- Padding: `mobileStylesPaddingTop/Right/Bottom/Left` (inner variants exist as
  `mobileStylesInnerPadding*`).
- Visibility: `mobileStylesHideInMobileDevice` / `mobileStylesHideInDesktopDevice` ("true").
  Desktop-only and mobile-only twins of a region become two nodes, one hidden each way.
- Alignment: `mobileStylesTextAlign` / `mobileStylesAlign`.
- Column stacking on the wrapper when the mobile layout stacks: `stackColumns`.

Ignore differences that are just the 390px frame being narrower; capture only deliberate
changes (padding scale, hidden elements, alignment shifts, reordered stacks). When a
difference cannot be expressed in these keys (different copy, different image crop), note it
in the module's report line for the designer.

### 3. Componentize and pre-tag

Make the finished module a COMPONENT on its category page, then tag it for saving into the
plugin:

```js
node.setSharedPluginData('emaillove', 'saveCategory', 'Hero')
node.setSharedPluginData('emaillove', 'saveName', 'Hero — text led, portrait')
```

### 4. Verify per module

- Structural checklist: naming or metadata resolves on every structural frame; content in
  element frames; no detached instances; no unrecognized frames except intentional
  editable-image regions.
- Visual: screenshot the rebuild next to a screenshot of the source design; flag divergences
  rather than silently accepting them.
- Mobile: list the mobile keys you set per node.

### 5. Batch report and gate

One report per batch: per module, what was rebuilt, verdict honored or changed (with reason),
mobile decisions, divergences flagged, save tags applied. End with the open questions for the
design review. Do not start the next batch until the user says the review happened.

## Hand-off after the final batch

The design system is on the canvas but not yet in the plugin. Walk the user through saving
each pre-tagged component (or the bulk import, once the plugin ships it), then: sync check in
the plugin, build one real sample email from the new components as proof, export it, and send
a seed test. Building is free; exports count against plan limits.
