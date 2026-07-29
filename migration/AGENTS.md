# Email Love: migrating an existing design system (Codex)

## What this file is, and how to use it

This is a **configuration file for OpenAI Codex**, not a prompt. It covers **migration**:
auditing an existing (non Email Love) Figma design system, then converting it into a working
Email Love design system. It is the Codex port of the emaillove-migration-audit and
emaillove-eds-converter Claude skills (github.com/email-love/claude-skills).

It is a **separate file from the email builder instructions** on purpose. Migration is a
project you do once; building emails is something you do constantly. Keep them apart:

1. Make a folder for the migration work, for example `~/email-love-migration`.
2. Save this file as `AGENTS.md` at the root of that folder.
3. Run `codex` from inside that folder. Codex loads this file automatically; you never
   mention it again.
4. Keep the builder instructions at `~/.codex/AGENTS.md` for everyday email work.

**Agent reading this:** if this file reached you as an attachment or pasted message rather
than as installed instructions, say so and point the user to the four steps above before
doing anything else.

## Version and staying current

These instructions are **version 1.10.1** (2026-07-29). They track the
`emaillove-eds-converter` Claude skill at 1.10.1 and the `emaillove-migration-audit` skill at
1.1.0.

This file does not update itself. If you have web access, check once per conversation
(quietly, without narrating it)
https://raw.githubusercontent.com/email-love/codex-agents/main/migration/AGENTS.md against
the version above, and mention it at hand-off if yours is older:

```bash
curl -o AGENTS.md https://raw.githubusercontent.com/email-love/codex-agents/main/migration/AGENTS.md
```

**Version 1.9.0 replaced the conversion method entirely.** Earlier copies told you to rebuild
each module by eye from the source design. That is now forbidden: structure comes from the
design-converter worker and you transcribe what it returns. Earlier copies also had no module
versus email-template distinction, so batches converted with them can contain modules the
plugin uploads as broken emails. Phase 3, step 0 explains how to spot one.

**Version 1.10.0 added R3.3.1**, the slack rule for pinned columns that carry text. A module
converted with a 1.9.0 or earlier copy can have a badge, label, or two-up row that looks
correct on the Figma canvas and wraps in the plugin Preview, so it is worth re-checking those
rows in already-converted batches.

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
- The conversion also uses your shell: `curl` to reach the design-converter worker, and local
  files to hold each module's screenshot and returned JSON.
- Work incrementally: one `setCurrentPageAsync` per `use_figma` call, small batches of
  operations, and validate with `get_metadata` or a screenshot after each structural step.
  A migration is long; a failed 200-operation call wastes far more than a failed 10-operation
  one.
- Never use em dashes in any layer name, plugin data value, text characters, or report.

---

# Phase 1: Audit (read-only)

Audit an existing Figma design system for migration to Email Love, and produce a migration
report the customer and the Email Love team can act on. This is Phase 1 of a migration: it
tells everyone what they have, what converts, what needs design judgment, and how big the job
is. The actual conversion is done by Email Love's team as part of Enterprise onboarding.

**This phase is strictly read-only.** Never create, modify, rename, or delete anything in the
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

Deliver the report as a file the user can share internally. Offer to answer questions about
any specific module's verdict, and to re-run the audit after they clean up anything the flags
surfaced.

---

# Phases 2 and 3: Convert

Convert an audited legacy design system into a working Email Love design system. This follows
the audit and works in two phases: foundations once, then modules in batches. A designer
reviews between batches; never convert the whole library in one unreviewed pass.

Prefer to have this done for you? Email Love's team runs this exact process, with design
review included, as part of Enterprise onboarding: hello@emaillove.com.

Two hard rules:

- **The customer's source file is read-only, always.** All building happens in a separate
  target file. Reads from the source are inspections, screenshots, and asset downloads only.
- **The audit report is required input.** It carries the classification (A/B/C/D), the brand
  foundations, and the flags. Do not re-derive what it already settled; do re-verify anything
  that looks wrong when you meet the actual nodes.

And one method rule that governs everything below: **you do not rebuild a module by eye.**
Structure comes from the design-converter worker and you transcribe what it returns, per the
render spec in the appendix. A frame you build from your own mental model of email structure
looks correct on canvas and silently drops content on export, because the plugin keeps its
real conventions in private plugin data you cannot read.

## Inputs

1. The migration audit report (file or pasted).
2. The source Figma file link (read-only).
3. The target file: an existing one the team designates, or create one named
   "[Customer] Email Love Design System" via the Figma MCP.
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
   instances. These become the sub-components nested inside mj-button-Frames, and they are
   the INSTANCE_SWAP targets for module-level "Button Style" properties later. Put the
   label's TEXT property on the button component itself: a label living inside a nested
   instance cannot be bound from the module that uses it (appendix R8).
4. **Spacing.** Recreate their spacer scale as components if they had one.
5. **Assets.** Export the logo and any recurring imagery from the source file
   (`download_assets`) and upload into the target file (`upload_assets`). Logos become
   images, never vectors.
6. **Root EMAIL TEMPLATE frame** on Campaigns at the customer's email width: vertical
   auto-layout, width FIXED at that email width, height Hug, the shared marker, and the theme
   colors from the audit's proposal:
   `setSharedPluginData('emaillove', 'nodeType', 'mainFrame')` plus backgroundColor,
   contentColor, textColor, linkColor, buttonTextColor, buttonContentColor,
   lightThemeBackgroundColor, and fallBackFontName (appendix R2.1 has all nine and what each
   one is for).
   **This is the only `mainFrame` foundations produces, and it is an email, not a module.**
   It exists so batch 1 has somewhere to drop modules and see them in context. The modules
   themselves are a different shape entirely (Phase 3, and appendix R2): each one is an
   `mj-wrapper` COMPONENT with **no** `mainFrame` marker and no theme keys. Do not copy this
   frame as a starting point for a module.
7. **Report** what was built, what the audit proposed that you changed, and what needs the
   designer's eye before batch 1 (theme colors especially: they are a proposal until a human
   confirms).

## Phase 3: Module conversion (run per batch)

### 0. What you are building: a module, not a small email

**Phase 3 builds MODULES.** A module is one reusable block that gets dropped into many
emails, so its shape is a **`mj-wrapper` COMPONENT**: the wrapper IS the component, it carries
shared `name = 'mj-wrapper'`, its layer name is the module name, and it carries **no
`nodeType = 'mainFrame'` marker anywhere in its tree**. The marker is not a harmless extra:
the upload does not stop you, it archives the block as a whole email and emits no component
JSON. An email template is the other shape (a `mainFrame` root with wrapper components stacked
inside), and foundations built one of those in Phase 2 for context.

Appendix R2 has both shapes side by side and the plugin evidence. Read it before the first
module of a batch. If you are picking up a batch converted with an older copy of these
instructions, read `nodeType` back off each module root: a leftover `mainFrame`, or a wrapper
nested inside a wrapper, means that module uploads as a broken email and has to be reshaped.

For each module in the batch, in order:

### 1. Convert the source design to MJML JSON via the design-converter worker

Do not rebuild by eye and do not run the plugin's Convert button for migration batches. The
pipeline is: screenshot the source module (read-only), POST it to the design-converter
worker, transcribe the returned MJML JSON into the target file, then verify.

1. **Screenshot the source frame** from the customer's file (read-only; `get_screenshot` or
   an export at 1x/2x). Keep the PNG; it is also your visual reference for verification.
2. **POST to the worker** at `https://design-converter.andy-30d.workers.dev`:
   - Headers: `Content-Type: application/json`, `Authorization: Bearer` with an EMPTY token,
     and `X-Auth-Provider: gumroad`. The worker treats empty Bearer plus gumroad as an
     anonymous Free user, which is allowed; no license key is needed for this path.
   - Body: `{ "screenshot": "<raw base64 PNG, no data: prefix>", "screenshotMime":
     "image/png" }`. Set the mime correctly: it is passed straight through, so a JPEG
     declared as PNG is a silent quality loss. `layerTree` and `promptInputs` are optional
     extras; screenshot alone works and is the normal agent path.
   - Query params, all optional:
     - `nocache=1` skips the cache read (results are cached by screenshot hash), for QA.
     - `recache=1` skips the cache read AND forces a write, overwriting a poisoned cached
       result. Use this when a previous conversion of the same screenshot was bad.
     - `decomposeRasterized=1` asks the worker to OCR flat image-only regions into live
       `mj-text`/`mj-button` elements instead of one `mj-image`. Use for source frames that
       are a single baked screenshot with no live text.
   - The response body is the MJML JSON. Response header `X-Cache` says HIT or MISS;
     `X-Trivial-Response: true` means the result degenerated to a single image and you should
     re-run with `recache=1` (and usually `decomposeRasterized=1`). A full module takes 20 to
     40 seconds.

   From the Codex shell:

   ```bash
   B64=$(base64 -i module-01.png | tr -d '\n')
   printf '{"screenshot":"%s","screenshotMime":"image/png"}' "$B64" > body.json

   curl -sS --max-time 120 -D headers-01.txt \
     -H 'Content-Type: application/json' \
     -H 'Authorization: Bearer' \
     -H 'X-Auth-Provider: gumroad' \
     --data-binary @body.json \
     'https://design-converter.andy-30d.workers.dev' > module-01.json
   ```

   The `Authorization` value is the literal word `Bearer` with nothing after it. On Linux
   `base64 -i` becomes `base64 -w0`. Read the headers file before you trust the body.
3. **Save the MJML JSON to disk per module** so the transcription and later re-verification
   work from a stable input.

Fallback only: users without Figma MCP write access can select frames in the Figma plugin's
AI Import screen and click Convert there; it calls this same worker. The agent path above is
preferred for migration batches because every node it writes is inspectable and repairable.

### 2. Transcribe the MJML JSON into the target file

**Follow the appendix at the end of this file exactly.** It maps every MJML tag and attribute
to the Figma node, auto-layout, fill, and shared plugin data the plugin's exporter reads back.
**Start at R2 and build the MODULE shape**, not the email-template shape.

The worker returns a whole MJML document, so its JSON has an `mjml` / `mj-body` envelope and
one or more wrappers inside. You do not transcribe that envelope. Take the module's wrapper
and make it the component:

```js
const moduleRoot = figma.createComponent()                          // the mj-wrapper itself
moduleRoot.name = 'Hero, text led'                                  // the module name
moduleRoot.setSharedPluginData('emaillove', 'name', 'mj-wrapper')
// and nothing else: no nodeType, no theme colors
```

- **No `mainFrame`, no theme keys, no wrapper-inside-a-wrapper.** If the worker JSON returns
  several wrappers for one source module, that is usually one module per wrapper: convert
  them as separate modules, or, when they genuinely are one block, merge their sections under
  a single wrapper component. Never nest one wrapper inside another to keep them together.
- **The layer name is load bearing here**, unlike everywhere else in the file. It becomes the
  saved component name and its storage path, and there is no rename field in the plugin's
  save dialog, so name it the way it should appear in the customer's library.
- **Every node gets two names.** The MJML tag goes in the `name` shared plugin data key; the
  Figma layer name gets the plugin's own friendly display name for that tag ("Row (Contains
  columns that sit side by side)", "Text Block", "Button Text"), so the layers panel reads
  like a plugin-built file rather than a wall of `mj-` strings. The exporter never reads the
  layer name for dispatch, so this is free. The module root is the one exception: it is tagged
  `mj-wrapper` like any wrapper, but its layer name is the module name rather than the wrapper
  display string. Appendix R6 has the full table and the three ways this goes wrong. Never
  rely on the layer-name fallback.
- **Content leaves are tagged PAIRS, wrapper plus inner node.** `mj-text-Frame` contains a
  text node tagged `mj-text`; `mj-image-Frame` contains the image rectangle tagged
  `mj-image`; `mj-button-Frame` contains a node tagged `mj-button` whose own direct child is
  a TEXT node. Tagging only the wrapper is the single most damaging mistake in a conversion:
  untagged inner content is not skipped, it is flattened into a hosted PNG by the exporter's
  unknown-node path, so buttons silently lose their text and links and image sections can
  export empty. After building each module, verify every leaf pair before moving on.
- **Heights hug, widths are a decision, spacing is padding.** Appendix R0 is the whole rule
  and it is not cosmetic: every frame from the root down hugs vertically, a fixed height clips
  content in Outlook, vertical rhythm comes from auto layout padding (manual positioning
  exports as nothing), a FIXED width is only for load-bearing cases like unequal columns and
  `mj-group` percentage math, and a button sized FILL is what makes it full width on mobile.
  `mj-spacer` is the single node allowed a fixed height. Read R0 before you transcribe, not
  after.

**Start from the visual pattern, not the layer name.** Most conversion mistakes come from
rebuilding what a design *looks like* instead of reaching for the primitive that produces it.
This mapping covers almost everything you will meet:

| What the design shows | What to build | Why |
| --- | --- | --- |
| A pill, badge, tag, or chip | `mj-button` | It renders a padded, rounded, background-filled box with centred text and an Outlook VML fallback. A column with a border radius does not survive Outlook. A pill needs no link to be a button. |
| A call-to-action button | `mj-button` | Same primitive; add the `href`. |
| Two things side by side that must not stack on mobile | `mj-group` of `mj-column`s | Columns stack on small screens unless grouped. |
| Headline and copy over a full-bleed image | `mj-hero` | Keeps the text live rather than baking it into a picture. |
| A horizontal rule | `mj-divider` | Never a thin rectangle. |
| Vertical breathing room | `mj-spacer` | Never an empty frame. |
| A row of links | `mj-navbar` with `mj-navbar-link` | |
| Tabular data | `mj-table` with `mj-table-row` | |
| ESP tokens, Handlebars, dynamic cards | `mj-raw` | Passed through verbatim. |
| A composition that genuinely cannot be rebuilt | an untagged frame in a column | Deliberately flattened to a hosted image, still editable in Figma. |

- **Build the pair, do not style the wrapper.** The wrapper carries layout; the inner node
  carries content. An image is an `mj-image-Frame` containing a rectangle whose fill is the
  image, never a frame with an image fill on itself. A divider is an `mj-divider-Frame`
  containing a line, never a frame with a solid fill. Childless wrappers export as empty
  cells. Legacy designs almost always express images and rules as fills on a frame, so this
  is the most common thing you must actively restructure rather than copy.
- **A badge, pill, or icon sitting beside text is an `mj-group`, not a loose frame inside
  `mj-text-Frame`.** A loose frame there flattens to an image and detaches from the text.
  Rebuild it as a group inside the section: `mj-group` containing one `mj-column` that holds
  the badge as an `mj-button` (the table row above: a pill is a button, never a radiused
  column) and another `mj-column` for the adjoining text. Give those columns exact fixed
  pixel widths and let the exporter derive the percentages (appendix R3.3), pin those widths
  with slack rather than at the width Figma hugged to (appendix R3.3.1: a pinned column cannot
  grow, and the email renders a different font binary than the canvas), and remember the
  group must be a child of the section, not of a column, so a design that nests such a row
  inside a column needs the row lifted to section level. Only fall back to treating the region
  as an editable image when the composition is genuinely inseparable.
- **The worker never emits `mj-group`,** so every side-by-side row that must not stack is
  yours to rebuild. Its whole vocabulary is `mj-wrapper`, `mj-section`, `mj-column`,
  `mj-text`, `mj-image`, `mj-button`, `mj-divider`, `mj-spacer`, and `mj-social` with
  `mj-social-element` children. When it returns a tag the appendix does not map, in practice
  a social icon row, do not invent a node and do not silently drop it: rebuild the row from
  mapped primitives (for social icons, an `mj-group` of one-column `mj-image` pairs, each
  with its own `href`). List every row you rebuilt this way in the module's report line.
- **Every `src` comes back as `"placeholder"`.** Place the real assets you round-tripped in
  foundations; use flat gray fills at the correct dimensions everywhere else and list them.
- **Unpinned colors, radii, and fonts drift** between runs, and unpinned fonts flatten to
  Arial. Correct them against the foundations rather than accepting what came back.
- Map every text node to the type styles from foundations.
- Buttons: `mj-button-Frame` wrapping an instance of the foundations button component.
- Verdict B regions (from the audit): place the design content as a frame with NO recognized
  tag name inside a column; the exporter flattens it to a hosted image at export while it
  stays editable. Verdict C modules: live-text structure for the copy, one editable-image
  frame for the rich region.
- Text over a single background photo is mj-hero territory, live text, not an image.

### 3. Merge the mobile twin

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

### 4. Confirm the component shape, add properties, and pick its category

The module was built as a COMPONENT in step 2, because the `mj-wrapper` IS the component. Do
not create a second component around it, and do not promote a `mainFrame` frame into one.
Confirm before going further, by reading the values back off the root:

- `node.type === 'COMPONENT'`
- `getSharedPluginData('emaillove', 'name') === 'mj-wrapper'`
- `getSharedPluginData('emaillove', 'nodeType') === ''` (empty, on the root and everywhere
  below it)
- the root is a direct child of its category page, and its layer name is the module name

The plugin creates every wrapper as a COMPONENT itself (`UiParser.ts:1519-1522`), so this is
its own shape, not a convention we invented, and component properties are impossible without
it. Appendix R7 has the calls and the four rules that keep a component root working (keep it
a direct page child, never combine roots into a variant set, bind properties at the level that
owns the node, do not write `isStandalone`); R2.3 has the evidence for why the `mainFrame`
marker must be absent.

**Add component properties for the parts a marketer will change**, per appendix R8: TEXT
bound to `characters` on the inner text node, BOOLEAN bound to `visible` on the block wrapper,
INSTANCE_SWAP bound to `mainComponent` on a nested instance. There is no image property type.

Derive them from evidence in the source library rather than adding them everywhere: a BOOLEAN
needs a sibling design where that region is genuinely absent; a TEXT needs evidence the copy
changes between sends; boilerplate stays unbound. Two to five per module is the working range,
and zero is a legitimate answer for a fixed block like a logo header. **A property whose
binding is wrong is worse than no property**, so re-read `componentPropertyReferences` back
off each node to confirm the binding landed. Record the properties you added, and why, in the
module's report line.

Then decide its category for the upload. **Use the customer's real category names**, which are
whatever sections already exist in their plugin, not names you invent. If the Email Love MCP
is connected, `list_components` returns their categories; otherwise read them off the plugin's
Assets sidebar, which ships 13 predefined sections: Pre-Header, Header, Heroes, Single Column,
Two Column, Three Column, Four Column, Buttons, Reviews, Images, Lists, Order Tables, Footer.
Classify by what the component structurally is: **Heroes** for a top-of-email feature block,
**Single Column** for one full-width stack, **Two Column** or **Three Column** for side-by-side
columns, **Order Tables** for line-item layouts, **Images** for image-only blocks. When
nothing fits, choose the closest existing section and note it, rather than inventing one.

**Do not write `saveCategory` or `saveName` plugin data.** The plugin reads neither key. A
module goes into a design system through the Assets sidebar Upload button, and the **Figma
component name** becomes the component name, so the layer name you set in step 2 is the only
thing that carries. Record the category you chose per module in the batch report, so a human
can correct any misfits in one pass rather than hunting for them later.

### 5. Verify per module

Run the appendix post-build checklist (R9), plus:

- **Shape, first and hardest:** the root is a COMPONENT tagged `mj-wrapper`, its layer name is
  the module name, and `nodeType` is empty on the root **and on every node below it**. Read it
  back; do not assume. A module carrying `mainFrame` uploads as a whole email, and a module
  with a wrapper nested inside another wrapper is an email in disguise. No theme color keys
  unless a designer asked for a dark-mode treatment on that block.
- Structural checklist: the `name` plugin data key resolves to a real tag on every node
  (nothing relying on the layer-name fallback); every leaf is a complete tagged pair; both
  alignment axes match on every auto-layout frame; no detached instances; no unrecognized
  frames except intentional editable-image regions; `mj-column-inner`, if used, is literally
  `children[0]` of its column.
- Sizing: walk the tree and confirm every frame is vertical HUG, the only fixed height is an
  `mj-spacer`, every FIXED width is one of the load-bearing cases, every pinned width that
  carries text has slack (appendix R3.3.1), and each button's width sizing was chosen for its
  mobile behavior (appendix R0).
- Naming: every layer carries the display name for its tag, and no friendly string leaked into
  the plugin data `name` key.
- Component: the module root is a direct child of its category page, not inside a component
  set or a Figma section, with no stray instances of it left loose on the page. Every property
  binding re-read and confirmed.
- Visual: screenshot the rebuild next to the source screenshot from step 1; flag divergences
  rather than silently accepting them.
- Mobile: list the mobile keys you set per node.

### 6. Batch report and gate

One report per batch: per module, what was rebuilt, verdict honored or changed (with reason),
what the worker returned and what you repaired, mobile decisions, divergences flagged,
component properties added and the evidence for each, the category you chose. End with the
open questions for the design review. Do not start the next batch until the user says the
review happened.

## Hand-off after the final batch

The design system is on the canvas but not yet in the plugin. Walk the user through the
upload: pick the design system in the plugin, open the Assets section you recorded for the
batch, select the wrapper components on the canvas, click **Upload**, confirm. A
multi-selection of wrappers uploads as one batch, so an approved batch goes in with one click
rather than one component at a time. **The Upload button only renders for a user on a paid
plan** (`AssetsComponent.tsx` gates that whole header on the subscribed state), so if the
person doing the upload is on Free they will not see the button at all and the hand-off needs
a seat on a paid plan first. Custom Templates and its Add New Template dialog are the
email-template route, not this one: it refuses a module with "Please select valid email
template". Then: sync check in the plugin, build one real sample email from the new components
as proof, export it, and send a test to a real inbox. Building is free; exports count against
plan limits.

---

# Appendix: the render spec

Codex cannot install a `references/` directory, so the transcription rules ship inline here.
This is the operative subset of `render-spec.md` and `structure.md` from the Claude skills,
which are derived from the plugin source (`email-love/Figma-plugin`), not from inference. The
full documents live at
https://raw.githubusercontent.com/email-love/claude-skills/main/skills/emaillove-eds-converter/references/render-spec.md
and `.../structure.md` if you ever need a case this appendix does not cover. Do not
reconstruct these rules from memory: that is rebuilding by eye under another name.

You may only use what an external agent can write: layer names, geometry, auto-layout,
fills/strokes/radii, TEXT node properties, `setSharedPluginData('emaillove', key, value)`,
and, for modules, component creation plus component properties (R7, R8).

**Read R2 before you create anything.** This spec describes two different things, an EMAIL
TEMPLATE and a DESIGN-SYSTEM MODULE. They share every rule except the root, and the root is
where the difference is fatal. A migration batch builds modules.

## R0. Sizing: hug heights, deliberate widths (read before you create a node)

Sizing decides whether the email survives Outlook, whether it survives a copy change, and how
the button behaves on a phone. Email Love's own product docs state it plainly: the Height of
each component and its child frames must be Hug contents, not Fixed, because fixed-height
containers cause content clipping, especially in Outlook.

### R0.1 Height is HUG on the root and on EVERY descendant frame

- `layoutSizingVertical = 'HUG'` on the root, and on every wrapper, section, group, column,
  column-inner, and leaf pair wrapper inside it. Never `'FIXED'`.
- Outlook on Windows renders through the Word engine and CLIPS whatever does not fit, so a
  fixed-height frame that looked correct on canvas ships as a cut off headline in the least
  forgiving client in the mix. It also breaks the first time copy runs one line longer.
- If you call `resize(w, h)` at all, the height argument is a throwaway. Set `layoutMode`,
  then set `layoutSizingVertical = 'HUG'` in the same breath, before you append children.
- Order of operations: `layoutSizing*` is only accepted once the node itself has a
  `layoutMode`, and `'FILL'` only once the node is a child of an auto-layout parent. So:
  create, set `layoutMode`, append, then set sizing.
- Three node types are not frames. A TEXT node hugs vertically. The `mj-image` RECTANGLE and
  the `mj-divider` LINE carry intrinsic geometry from `resize()` and have no hug at all.
  Their pair wrapper FRAMES still hug, and that is what keeps them from being clipped.
- `mj-spacer` is the single exception, and R0.2 says why.

### R0.2 Vertical rhythm is auto layout padding, never a height

- Space between blocks is `paddingTop` / `paddingBottom` on the owning frame. Not a taller
  frame, not `itemSpacing`, not manual positioning.
- **Manual positioning does not export at all.** The exporter reads Auto Layout padding and
  nothing else, so a node nudged into place exports with zero spacing and the design
  collapses silently. If a gap is not padding, it does not exist in the sent email.
- Prefer padding to spacers. When the worker JSON returns an `mj-spacer` whose only job is a
  gap between two blocks, fold that height into the padding of the neighboring element and
  drop the spacer. Keep a spacer only where the design needs a standalone gap of its own (a
  colored band, a gap inside a bordered column).
- `mj-spacer` is the ONLY node here that carries a fixed height, and it is load bearing: the
  exporter emits `height: <node.height>px` straight off the node, and a spacer has no
  children to clip. Set `layoutSizingVertical = 'FIXED'` on a spacer and nowhere else.

### R0.3 Width: FILL, HUG, and the narrow case for FIXED

| Sizing | Where it belongs |
| --- | --- |
| FILL | `mj-wrapper` under an email root; `mj-section` under a wrapper; a single `mj-column` in its section; `mj-column-inner`; every leaf pair wrapper as a column child; the `mj-text` TEXT node inside its frame; the `mj-divider` LINE for a full-width rule |
| HUG | `mj-group` (its width comes from the fixed columns inside it); the `mj-button` frame (auto-width button); `mj-button-text`; and the transient state of any frame you created but have not yet appended and set to FILL |
| FIXED | the four cases below, and nothing else |

FIXED width is correct for:

1. **The root node**, at the numeric `mj-body` width (usually 600). It applies to an
   email-template root and to a module's own wrapper component alike (R2): a module is
   measured against the same body width as the emails it will live in.
2. **Every column in a section that holds two or more columns**, unequal columns above all.
   The exported percentage is
   `column.width / (section.width - section horizontal padding) * 100`, so the pixel number
   IS the percentage. A 200 + 360 split only stays a 200 + 360 split because both are pinned.
3. **Every column inside an `mj-group`.** MJML requires percentage widths there, and the
   exporter derives them from your pixels.
4. **The `mj-image` RECTANGLE**, whose pixel width also decides whether the image stays fluid
   on mobile (R4.2).

Anywhere else, a FIXED width is a latent bug: it stops tracking the section content box the
moment a padding value changes.

**And where a load-bearing FIXED width sits above text (cases 2 and 3, plus a FIXED button in
R0.4), pin it with slack, never at Figma's hug width.** The pixel you measured was measured in
the font Figma rendered; the email declares a different stack and a pinned column cannot grow.
R3.3.1 has the rule, the numbers, and the failure signature.

### R0.4 Button width is a mobile behavior decision

- **FILL**: the plugin enables full width on mobile (`width: 100%`) and the exporter sets
  `applyFullWidth`. The button spans the column on desktop and on mobile.
- **HUG or FIXED**: the button keeps its width on mobile.

Choose from the source design, never from what makes the canvas look tidy. An edge to edge
CTA is FILL. An inline, auto-width button is HUG, which is what worker JSON buttons are by
default. FIXED only when the design system pins a button width. Record the choice in the
module's report line when it is anything other than HUG.

Never set the button frame's height. It comes from the text height plus `inner-padding`, and
that padding is also how you get a tap target of at least 44px.

### R0.5 Where padding belongs, by level

| Level | Typical values | Notes |
| --- | --- | --- |
| `mj-wrapper` | 0 to 20 | Outer breathing room around a group of rows. This is where a visible gap between content and the outer background color comes from |
| `mj-section` | 0 to 20, often 0 | Many designs keep section padding at 0 and control spacing at column and element level. Horizontal section padding also defines the content box column percentages are computed against (R3.2), so reproduce worker values exactly |
| `mj-column` | 20 to 30 horizontal, 10 to 20 vertical | The most commonly adjusted level |
| Leaf pair wrapper | sparingly | Fine tuning one element, for example 10px above a button but not above the text over it |
| `mj-button` `inner-padding` | from the MJML, symmetric only | The button's tap target, not layout spacing. Asymmetric values round-trip wrong (R4.3) |

In a conversion the worker JSON paddings are authoritative: transcribe them exactly. The
ranges above are for gaps you have to invent. Four things that keep padding honest: pick a
base unit (8px) and use multiples of it; padding sits inside the box and eats content width
(two 50 percent columns with 20px each side lose 80px total); Outlook ignores values under
5px and handles even numbers more predictably; mobile padding is a separate override
(`mobileStylesPadding*`), not a reason to compromise the desktop value.

## R1. Non-negotiable ground rules

1. **Tag every node via shared plugin data.** The plugin identifies a node with
   `getMetaName(node)`: it reads the plugin data key `name` first (private, with fallback to
   the shared `emaillove` namespace), else the Figma layer name. Always write
   `node.setSharedPluginData('emaillove', 'name', '<exact tag>')`. The layer name is then
   free for a human label (R6). Never rely on the layer-name fallback. A layer named
   `mj-section - Report CTA` with no shared key FAILS, because the whole string is read as
   the tag; the only layer-name forms that work are the bare tag (`mj-section`) or the parsed
   form `Report CTA, (mjml:mj-section)`.
2. **Exact tag strings.** Matching is exact string equality against: `mj-wrapper`,
   `mj-section`, `mj-group`, `mj-column`, `mj-column-inner`, `mj-text-Frame`, `mj-text`,
   `mj-image-Frame`, `mj-image`, `mj-button-Frame`, `mj-button`, `mj-button-text`,
   `mj-divider-Frame`, `mj-divider`, `mj-spacer`. Case sensitive, `-Frame` suffix capitalized
   exactly as shown.
3. **Every frame in the chain must resolve to a known tag.** The exporter's fallback for
   anything unrecognized is `renderNodeAsImage`: it silently flattens the node AND its entire
   subtree into a hosted PNG. An untagged frame between a column and its leaves destroys
   every well-tagged leaf below it. An untagged button becomes a picture of a button with no
   href. Never insert helper or group frames that are not one of the tags above.
4. **Visibility.** The extractor returns early on `!node.visible`. Every node you create must
   end `visible = true`.
5. **Both axes, same value.** For horizontal alignment the exporter reads
   `primaryAxisAlignItems` and maps MIN to left, MAX to right, anything else (including
   CENTER) to center. On a VERTICAL frame that mapping is wrong for what you see on canvas,
   so the plugin's own components always set `primaryAxisAlignItems` and
   `counterAxisAlignItems` to the SAME value. Do the same on every auto-layout frame you
   create. The shared value is what exports.
6. **Fills discipline.** The exporter treats `fills[0]` as a background signal: leaf wrapper
   frames (`mj-text-Frame`, `mj-button-Frame`, `mj-divider-Frame`, `mj-spacer`) with any
   visible fill export `container-background-color`; `mj-image-Frame` must always have
   `fills = []`; columns, sections, and wrappers with a fill export `background-color`. So
   set `fills = []` on every frame with no background in the MJML, and one SOLID fill of the
   exact hex when the MJML sets a background. Never leave a hidden 0-opacity fill lying
   around.
7. **itemSpacing = 0 everywhere.** Nonzero itemSpacing makes the exporter emit extra `c-gap`
   raw divs and half-padding CSS. All vertical rhythm is padding.
8. **Ignore `css-class` in the worker JSON.** The exporter regenerates classes. Never copy
   them anywhere.
9. **Fonts.** Load every font before setting characters. Map `font-family: "Arial,
   sans-serif"` to Figma family `Arial` (first entry of the stack, trimmed). Weight and style
   map to the Figma style name:

   | font-weight | style (normal) | style (italic) |
   | --- | --- | --- |
   | 100 | Thin | Thin Italic |
   | 200 | Extra Light | Extra Light Italic |
   | 300 | Light | Light Italic |
   | 400 | Regular | Italic |
   | 500 | Medium | Medium Italic |
   | 600 | Semi Bold | Semi Bold Italic |
   | 700 | Bold | Bold Italic |
   | 800 | Extra Bold | Extra Bold Italic |
   | 900 | Black | Black Italic |

   If a family lacks the style, fall back to Regular of the same family, then Inter Regular,
   and note it in the module's report line. In a migration the foundations text styles are
   the real source: map every text node to them rather than to whatever the worker guessed.
10. **Line-height.** Worker values are unitless ratios ("1.5"). Set Figma
    `lineHeight = { unit: 'PERCENT', value: ratio * 100 }`. Exception: a ratio of exactly 1.2
    or 1 may be left as `{ unit: 'AUTO' }`; the exporter emits AUTO as `1.2`.
11. **Content HTML.** Worker `content` strings may contain inline HTML. Convert:
    `<br>`/`<br/>` to `\n`; `<a href="...">text</a>` to a `setRangeHyperlink` on that
    character range; `<b>`/`<strong>` to the Bold style on that range (`setRangeFontName`);
    strip any other tags. Characters must contain no leftover markup.
12. **No em dashes** in any layer name, plugin data value, or text characters.

## R2. Which are you building? Email template or design-system module

**Answer this before you create a single node.** There are exactly two root shapes in an
Email Love file. Building the wrong one produces a module that uploads as a broken email,
or an email the plugin refuses to open.

| | **EMAIL TEMPLATE** | **DESIGN-SYSTEM MODULE** |
| --- | --- | --- |
| What it is | One sendable email | One reusable block dropped into many emails |
| Root node | FRAME (or COMPONENT) that carries NO `mj-*` tag | COMPONENT that **is** the `mj-wrapper` |
| `nodeType` = `mainFrame` | **REQUIRED** on the root | **FORBIDDEN.** Nothing stops the upload: the marker makes the block archive as a whole email |
| Shared `name` on the root | none (the root is untagged) | `mj-wrapper` |
| Theme color keys | all eight, on the root, alongside the `nodeType` marker (R2.1) | none by default (see R2.2) |
| Root layer name | the email name | **the module name** (it becomes the saved component name and its storage path) |
| What lives directly inside | `mj-wrapper` components, stacked | `mj-section` frames |
| Component properties | rarely; a campaign email is a one-off | **yes, they live here** (R8) |

The one-line test: **is this a whole email someone will send, or one block someone will place
into many emails?** Heroes, footers, copy blocks, 2-up product rows, banners: those are
modules. **Phase 3 of a migration builds modules, not emails.** Foundations builds exactly one
email template, in Phase 2 step 6, so batch 1 has somewhere to drop modules and see them in
context.

**A module is not a small email.** An email template root *contains* wrapper components; a
module *is* one of those wrapper components. So a module has no wrapper inside it and no
`mainFrame` above it. If your module root is a `mainFrame` containing an `mj-wrapper`, you
have built a one-wrapper email and mislabelled it, and R2.3 explains why the plugin will
reject it.

R3 through R6 apply identically to both shapes. Only the root differs.

### R2.1 EMAIL TEMPLATE root (Phase 2 step 6 only)

Create a top-level FRAME on the target page. It may be a COMPONENT instead (R7) when the whole
email is meant to be reused; nothing below changes.

- **Geometry:** `resize(W, 100)` where `W` is the numeric `mj-body` width (usually `600`),
  then `layoutMode = 'VERTICAL'` and immediately `layoutSizingVertical = 'HUG'`, horizontal
  FIXED at `W`. `primaryAxisAlignItems = counterAxisAlignItems = 'MIN'`. `itemSpacing = 0`,
  all paddings 0. The `100` is a throwaway that gets the node onto the canvas.
- **Layer name:** the email name. Do NOT put a tag in the root layer name, and do NOT write a
  `name` key on it: the root is identified by `nodeType`, not by a tag.
- **Shared plugin data (namespace `emaillove`), all REQUIRED:**

  | key | value |
  | --- | --- |
  | `nodeType` | `mainFrame` (how the plugin recognizes the template; without it nothing else matters) |
  | `backgroundColor` | dark-mode page background. Use the mj-body or first-wrapper background hex |
  | `contentColor` | dark-mode content/section background. Use the dominant section background hex |
  | `textColor` | dark-mode text color. Use the dominant mj-text `color` |
  | `linkColor` | link color. Use the design link color, else same as textColor |
  | `buttonTextColor` | the button label `color` |
  | `buttonContentColor` | the button `background-color` |
  | `lightThemeBackgroundColor` | the mj-body background hex; exports as mj-body `background-color` |
  | `fallBackFontName` | `Arial` |

  Empty theme keys are NOT neutral: the exporter substitutes dark defaults (`#000000`
  background, white text), which wrecks a light email. In a migration the audit's proposed
  palette is the source, used identically on every email root; consistency across the system
  beats per-email color matching.
- Optional: `emailSubject`, `emailPreHeader` (plain strings).
- Also give the root frame a visible SOLID fill of the body background so the canvas looks
  right.
- Children: `mj-wrapper` components in document order (R3.1), each set to
  `layoutSizingHorizontal = 'FILL'` after append.

The `mjml`, `mj-head`, `mj-body` tags themselves produce NO Figma nodes; the exporter
reconstructs them (body width comes from the root frame's width).

### R2.2 DESIGN-SYSTEM MODULE root: the mj-wrapper IS the component

There is no separate root. Create a COMPONENT and tag it `mj-wrapper`. That component is not
a container that holds a wrapper; it **is** the wrapper, so R3.1 describes this exact node,
minus its "direct child of the root" line: in a module there is nothing above it.

```js
const moduleRoot = figma.createComponent()
moduleRoot.name = 'Hero, text led'                                   // the module name
moduleRoot.setSharedPluginData('emaillove', 'name', 'mj-wrapper')    // the ONLY required key
// and NOT: setSharedPluginData('emaillove', 'nodeType', 'mainFrame')
```

- **Node:** COMPONENT, a direct child of its category page. Not a FRAME:
  `addComponentProperty` does not exist on a FrameNode, so a frame module can never carry
  properties. R7 has the four rules that keep a COMPONENT root working.
- **Shared `name` = `mj-wrapper`.** This single key is what makes the plugin treat the
  selection as a saveable top-level block rather than a fragment. A module tagged
  `mj-section` or left untagged is not a module.
- **`nodeType`: never write it.** Not `mainFrame`, not anything else. R2.3 is the evidence.
- **Layer name = the module name**, clean and human, because it becomes both the saved
  component name and its storage path, and there is no rename field in the save dialog.
  `Hero, text led` and `Footer, legal + social` are good; `EmailLove_clone`, `Frame 42`, and
  anything containing `mj-` are not. This is the one place where the layer name is load
  bearing rather than cosmetic.
- **Geometry:** identical to an email root, at the same email width.
- **Paddings, fill, radius, `fullWidth`, `stackColumns` / `reverseStack`:** all per R3.1.
  They are wrapper attributes and this node is the wrapper.
- **Children:** `mj-section` frames in order, each set to
  `layoutSizingHorizontal = 'FILL'` after append. **No `mj-wrapper` inside a module**, and no
  `mainFrame` anywhere in the subtree.
- **Component properties live here** (R8), because this is the component that directly owns
  the section, column, and leaf nodes.
- **Theme color keys: leave them off** unless a designer asked for a dark-mode treatment on
  this specific block. On a wrapper they are per-node dark-mode *overrides*, not the email
  theme. The plugin writes `backgroundColor` / `contentColor` / `textColor` / `linkColor`
  onto every wrapper component it creates (`UiParser.ts:1570`), so those four are legitimate
  here, but they only ever mean "override the enclosing email for this block".
  `buttonContentColor` and `buttonTextColor` are worse: the exporter emits them
  unconditionally whenever they are non-empty, without comparing them to the enclosing email,
  so a module carrying them ships its own dark-mode CSS into every email it is placed in. A
  module inherits nothing and conflicts with everything, so the safe default for a converted
  module is **no theme keys at all**; the email root supplies them.

### R2.3 The evidence, so this reads as ground truth rather than preference

Read at `origin/main` of `email-love/Figma-plugin`, all paths under `src/`.

1. **Every `mj-wrapper` the plugin builds is already a COMPONENT.** `UiParser.ts:1519-1522`:
   `if (tag === MjmlNodeType.Wrapper || isStandalone) frameNode = figma.createComponent(); else frameNode = figma.createFrame();`
   So a wrapper-as-component is not an agent convention layered on top of the plugin; it is
   what the plugin itself produces every time it renders MJML into Figma. Purple wrapper
   components inside a plugin-built email are normal. Do not "fix" them into frames, and do
   not wrap one in something else to make it look like a root.
2. **The two shapes go in through two different screens, and each one rejects the other.**
   Custom Templates, Add New Template is the email-template route: `AddTemplate.tsx:62` is the
   only caller of `select-component` and always sends `customType: 'customProperties'`, which
   lands in `code.ts:3226-3236` and rejects any selection *without* the marker, with "Please
   select valid email template". A module has no marker, so that dialog can never take one. The
   module route is the **Assets sidebar Upload button** (`AssetsComponent.tsx:610-632`), which
   needs a selected design system and dispatches `syncTemplateUpload` (`code.ts:3861`), taking
   an array of node ids when more than one node is selected, so a whole approved batch uploads
   at once. (`select-component` also has a mirror-image module branch at `code.ts:3280-3307`
   that rejects a selection carrying the marker; no UI reaches it today.)
3. **The design-system upload path keys off the `mj-wrapper` tag, not the marker.**
   `code.ts:3892-3893` sets
   `isTopLevel = getName(getMetaName(selectedNode)).tagName === 'mj-wrapper'`. Only when
   `isTopLevel` is true does the plugin wrap a clone in its own temporary `mainFrame`
   envelope and generate the MCP companion JSON (`code.ts:3934`, whose own comment notes that
   bare sections and columns "would emit a fragment the backend can't compile"). A module root
   that is not tagged `mj-wrapper` is archived as if it were a whole email and gets **no MCP
   JSON at all**.
4. **Marking a node both ways is worse than either mistake.** In both serializers the
   `mainFrame` branch is tested before any wrapper handling (`nodeJsonExtractor.ts:282`
   versus the wrapper branch at `1587`; `exportTemplate.ts:180` versus `285`). First match
   wins. So a node carrying `name = mj-wrapper` **and** `nodeType = mainFrame` passes the
   `isTopLevel` check, gets cloned into the temp envelope, and then still matches the
   `mainFrame` branch inside that envelope, producing a nested `mjml` document inside
   `mj-body` that nothing downstream can compile.

**Strip `nodeType` from every module component. Non-negotiable.**

## R3. Containers

### R3.1 mj-wrapper

**In an email template** this is a node inside the root. **In a design-system module this
node IS the root** (R2.2): same tag, same attributes, same auto-layout, but created as a
COMPONENT with no `mainFrame` above it and none on it.

- Node: FRAME as a direct child of an email root; COMPONENT as a module root.
- Shared `name` = `mj-wrapper`.
- Auto-layout: `layoutMode = 'VERTICAL'`, vertical HUG (never FIXED), horizontal FILL under
  an email root or FIXED at the email width as a module root,
  `primaryAxisAlignItems = counterAxisAlignItems = 'MIN'`.
- Attribute mapping:

  | MJML attr | Figma property |
  | --- | --- |
  | `padding-top/right/bottom/left` | `paddingTop/Right/Bottom/Left` (parseFloat px) |
  | `background-color` | one SOLID fill; absent means `fills = []` |
  | `border-radius` | `cornerRadius` (or the four per-corner radii for a 4-value string) |
  | `full-width` | shared plugin data `fullWidth` = `'true'` (only if present) |

- Optional shared keys: `stackColumns` (`'true'` default), `reverseStack`. They propagate
  down to child sections that lack their own value.
- Children: `mj-section` frames in order; each gets `layoutSizingHorizontal = 'FILL'` after
  append.

### R3.2 mj-section

- Node: FRAME, child of a wrapper.
- Shared `name` = `mj-section`.
- Auto-layout: `layoutMode = 'HORIZONTAL'`, both sizing HUG, then FILL width as a child of
  the wrapper (height stays HUG),
  `primaryAxisAlignItems = counterAxisAlignItems = 'CENTER'` (primary exports as the section
  `text-align`: MIN left, MAX right, else center).
- Attribute mapping: same table as wrapper. Borders map to strokes (R5.6).
- Geometry matters: exported column widths are computed as
  `columnWidth / (section.width - section.paddingLeft - section.paddingRight) * 100%`. With
  the standard worker output (section 600 wide, padding-left/right 20, column width 560) that
  is exactly 100 percent. Reproduce the worker paddings exactly and match each column's pixel
  width to the worker `width` attr.
- Children: `mj-column` frames (or a single `mj-group`) left to right.
- Optional shared keys: `stackColumns` = `'false'` to prevent mobile stacking without a
  group; `reverseStack` = `'true'` to reverse stacking order on mobile.

### R3.3 mj-group

- Node: FRAME, MUST be a direct child of `mj-section`, never of a column.
- Shared `name` = `mj-group`.
- Auto-layout: `layoutMode = 'HORIZONTAL'`, both sizing HUG (the group's width comes from the
  fixed columns inside it), `primaryAxisAlignItems = counterAxisAlignItems = 'CENTER'`
  (primary exports as horizontal alignment; counter exports as `vertical-align`).
- `background-color` to fill, `padding-*` to paddings, `border-radius` to radius, borders to
  strokes.
- Children: two or more `mj-column` frames with FIXED pixel widths.
- Width math: the exporter emits the group width as
  `group.width / (section.width - section horizontal padding) * 100%`, and each inner column
  as `column.width / (group.width - group horizontal padding) * 100%`. A 560 group containing
  280 + 280 exports 50%/50%. MJML requires percentage columns inside a group; you get that for
  free by setting exact pixel widths and letting the exporter divide.
- Columns inside a group keep their elements side by side on mobile.

#### R3.3.1 Pinned widths that carry text need slack

**Never pin a text-bearing column at the width Figma hugged to.** Pinning the width is
correct, and R0.3 is right that the pixel IS the percentage. What the pixel is NOT is a safe
measurement. It was taken in the font Figma rendered on canvas, the email declares a different
one, and a pinned column cannot grow. Text that fit by a hair on canvas wraps at send time, in
a font the canvas never showed you.

Two independent sources of drift stack up:

1. **Same family name, different binary.** Figma renders its own bundled Inter. The exporter
   writes `font-family: Inter, Arial` and also emits an `mj-font` link to
   `fonts.googleapis.com/css2?family=Inter`, so the email renders Google's Inter build, not
   Figma's. Measured on a real string: "Lorem Ipsum Dolor" at Inter Regular 16px fits inside a
   143px content box on the Figma canvas and measures 143.39px in Chromium against Google's
   Inter. An overflow of 0.39px, 0.27 percent, is enough to wrap the row onto two lines.
2. **The webfont may not load at all.** Any client that blocks or fails the `mj-font` link
   falls back to the next entry in the stack, which is `fallBackFontName` and defaults to
   `Arial`. Measured drift on real strings against Figma's Inter runs as high as +11.5 percent,
   and it goes both ways: do not assume the fallback is always narrower or always wider than
   what you see.

So take the text node's natural hug width in Figma, then pin the column at:

```
column width = max( ceil(hugWidth * 1.12), hugWidth + 8 ) + the column's horizontal padding
```

The 12 percent covers the worst measured fallback drift **for Arial and Helvetica**, which is
what `fallBackFontName` resolves to unless someone changed it. The `+ 8px` floor stops short
strings ("Sale", "New", "Just In") from ending up with one or two pixels of slack, which is no
slack at all.

**Use 25 percent instead when the fallback is a wide face.** `fallBackFontName` is a writable
key, so a brand can set it to Verdana, Tahoma or Georgia. Those set much wider than Arial at the
same size: measured against Figma's rendering across realistic label strings, Verdana reached
+24.9 percent, Georgia +11.5 percent and Tahoma +9.8 percent, so a 12 percent allowance is not
enough to hold them. Read the root's `fallBackFontName` before you pin anything, and if it names
one of those three, widen by 1.25 rather than 1.12. A brand webfont paired with a wide fallback
is a materially different risk from Inter paired with Arial, and should not share one number.

Applying it: widen the FIXED columns only. Leave the group HUG and let Figma recompute its
width, and leave every FILL child alone, they cascade through the layout engine on their own.
Then re-derive the exported percentages by hand and confirm the inner ones still sum to 100.
Worked example from the fix that produced this rule: a 66px badge column plus a 151px label
column in a 217px group became 74 + 169 in a 243px group, exporting 30.4527% + 69.5473%, which
is exactly 100.

**Failure signature, so you recognize it next time:** it looks right on the Figma canvas and
wraps in the plugin Preview, same machine, same session, same minute. Nothing is mis-tagged, no
width is "wrong" in Figma terms, and a diff of the tree shows nothing at all. When a reviewer
reports a line breaking that does not break on canvas, suspect a pinned width first, and
measure the string against the **exported** font stack rather than trusting the canvas.

**Where else this bites.** Anywhere a FIXED width sits above text:

- Columns in a group (this section) and columns in a multi-column section (R0.3 case 2). Group
  columns are the worse of the two, because they never stack on mobile, so the pinched width is
  what every reader gets.
- An `mj-button` pinned to FIXED (R0.4) with a label inside it.

It does NOT apply to FILL columns or FILL buttons, which resolve against the content box at
render time and adapt. Do not pad those; the extra width would be real design drift for no gain.

### R3.4 mj-column

- Node: FRAME, child of `mj-section` or `mj-group`.
- Shared `name` = `mj-column`.
- Auto-layout: `layoutMode = 'VERTICAL'`, vertical HUG, never FIXED. A column is the frame
  most often left at a fixed height by mistake, and it is where Outlook clipping bites
  hardest, because every leaf in the email hangs off a column.
- Horizontal sizing, per R0.3:
  - **Single column in its section: FILL.** It resolves to the section content box and
    exports `width: 100%`. An explicit FIXED at the worker width is acceptable and exports
    identically; never use HUG, which collapses the column to its content.
  - **Two or more columns in one section, or any column inside an `mj-group`: FIXED at the
    worker `width`.** Load bearing: the exported percentage is derived from the pixel number.
    When you are deriving the number from a Figma measurement rather than copying a worker
    attr, and the column contains text, add slack per R3.3.1 before you pin it.
- **Axis alignment rule (the trap):** set BOTH axes to the dominant horizontal alignment of
  the column's content. `align="left"` or mixed: `MIN` / `MIN`. `align="center"`: `CENTER` /
  `CENTER`. `align="right"`: `MAX` / `MAX`. Why: `counterAxisAlignItems` drives the
  column-level `text-align: <value> !important` CSS, and `primaryAxisAlignItems` exports as
  the column `vertical-align`. For hug-height columns the vertical value is visually
  irrelevant, so horizontal fidelity wins; do not try to honor a worker `vertical-align: top`
  on a centered column.
- Attribute mapping:

  | MJML attr | Figma property |
  | --- | --- |
  | `width` | frame width in px: FILL for a lone column, FIXED at this number for multi-column and group columns |
  | `padding-*` | paddings |
  | `background-color` | SOLID fill; absent means `fills = []` (any fill at all exports as background-color, even at opacity 0) |
  | `border-radius` | cornerRadius |
  | `border` / `border-*` | strokes (R5.6) |

- Children: leaf PAIR wrapper frames and `mj-spacer`, top to bottom. After appending, set
  each child's `layoutSizingHorizontal = 'FILL'`.

### R3.5 mj-column-inner (rarely needed)

Use ONLY when a column needs a second, inner background or border box distinct from its own
(a card inside a colored column). Most card-in-column designs are expressible without it: put
the card fill, radius, and paddings directly on the `mj-column` and the outer color on the
section. Prefer that.

If you must use it: FRAME, the FIRST (and only) child of an `mj-column`, with the leaves moved
inside it. This is load bearing: the exporter checks `column.children[0]` and ONLY there. In
any other position its fill, radius, borders, and paddings are silently discarded and its
children flatten into the parent. If a card sits below other content in a column, split the
section so the card gets its own dedicated column with the `mj-column-inner` as sole first
child. Shared `name` = `mj-column-inner`; `layoutMode = 'VERTICAL'`, vertical HUG, horizontal
FILL, `primaryAxisAlignItems = counterAxisAlignItems = 'CENTER'`.

## R4. Leaf pairs

Every content leaf is TWO tagged nodes: an outer wrapper FRAME that carries layout (paddings,
alignment, container background) and an inner node that carries content. Style the inner
node, not the wrapper. Both must be tagged. A wrapper with a fill and no child exports as an
empty cell. Every pair wrapper hugs vertically.

### R4.1 mj-text: `mj-text-Frame` wrapping a TEXT node `mj-text`

Wrapper FRAME:
- Shared `name` = `mj-text-Frame`. Layer name `Text Block`.
- `layoutMode = 'HORIZONTAL'` (yes, horizontal), vertical HUG, never FIXED: a pinned text
  frame is the classic Outlook clip, because copy length changes most often between sends.
  `primaryAxisAlignItems = counterAxisAlignItems = 'CENTER'`.
- `padding-*` from the mj-text attrs go HERE (the exporter reads `node.parent.paddingTop`).
- `fills = []` unless the MJML has `container-background-color`, which becomes this frame's
  SOLID fill.
- As a column child: `layoutSizingHorizontal = 'FILL'`.

Inner TEXT node (direct child):
- Shared `name` = `mj-text`.
- `layoutSizingHorizontal = 'FILL'`, `layoutSizingVertical = 'HUG'`.
- Property mapping:

  | MJML attr | TEXT property |
  | --- | --- |
  | `align` | `textAlignHorizontal` = LEFT / CENTER / RIGHT (the ONLY source of the exported `align`) |
  | `color` | one SOLID fill |
  | `font-family` | `fontName.family` (first of the stack) |
  | `font-weight` + `font-style` | `fontName.style` per the table in R1.9 |
  | `font-size` | `fontSize` (px number) |
  | `line-height` | `lineHeight` PERCENT (ratio * 100), AUTO allowed for 1.2/1 |
  | `letter-spacing` | `letterSpacing` `{ unit: 'PIXELS' }` |
  | `text-transform` | `textCase`: uppercase UPPER, lowercase LOWER, capitalize TITLE, none ORIGINAL |
  | `text-decoration` | `textDecoration`: underline UNDERLINE, line-through STRIKETHROUGH, none NONE |
  | `content` | `characters` after HTML conversion (R1.11); links via `setRangeHyperlink` |

- Also set `textAlignVertical = 'CENTER'`.

### R4.2 mj-image: `mj-image-Frame` wrapping a RECTANGLE `mj-image`

Wrapper FRAME:
- Shared `name` = `mj-image-Frame`. Layer name `Image Block`.
- `layoutMode = 'HORIZONTAL'`, both sizing HUG (FILL width as column child, height stays
  HUG).
- `primaryAxisAlignItems` from `align`: left MIN, right MAX, center or absent CENTER. Set
  `counterAxisAlignItems` to the SAME value.
- `padding-*` from the mj-image attrs go HERE.
- `fills = []` ALWAYS.
- Never copy the rectangle's height onto this frame.

Inner RECTANGLE (direct child):
- Shared `name` = `mj-image`.
- `resize(width, height)` from the MJML `width`/`height` attrs. Keep
  `layoutSizingHorizontal = 'FIXED'`. A RECTANGLE has no hug, and its pixel size is one of
  the four load-bearing FIXED widths.
- Fill: the worker returns `"placeholder"` for every `src`, so substitute the asset you
  round-tripped into the target file's foundations pages when one exists (logos especially);
  otherwise use one SOLID light gray fill (`#E8E8E8`). Where a real URL is available, create
  the image via `figma.createImageAsync(src)` and set an IMAGE fill, `scaleMode: 'FILL'`. The
  exporter re-exports the node's own pixels, so a gray rect exports as a gray image, which is
  correct placeholder behavior.
- `cornerRadius` from `border-radius`.
- Shared plugin data ON THE RECTANGLE (not the wrapper): `href` from MJML `href` (omit when
  absent; never write `#`), `altText` from MJML `alt`.
- Sizing note: if the rectangle width is LESS than the column content width the exporter
  drops `fluid-on-mobile`; if equal it keeps it. So match the worker `width` exactly: a 560
  image in a 560 column stays fluid, a 134 logo does not.

### R4.3 mj-button: `mj-button-Frame` wrapping FRAME `mj-button` whose DIRECT child is a TEXT node

Three levels. The TEXT node MUST be a direct child of the `mj-button` frame:
`extractButtonJson` locates it via `node.children.find(c => c.type === 'TEXT')`.

Level 1, wrapper FRAME:
- Shared `name` = `mj-button-Frame`. Layer name `Button Block`.
- `layoutMode = 'HORIZONTAL'`, both sizing HUG (FILL width as column child).
- `primaryAxisAlignItems` from the mj-button `align` (left MIN, right MAX, else CENTER);
  `counterAxisAlignItems` the SAME value. The exporter reads the button's alignment from this
  frame, the button's direct parent. Mirror the same alignment on the containing column's
  axes when all of the column's content shares it; the two must not fight.
- `padding-*` from the mj-button attrs go HERE.
- `fills = []` unless `container-background-color` is set.

Level 2, FRAME `mj-button` (in a migration this is where the foundations button instance
sits, tagged `mj-button` itself):
- Shared `name` = `mj-button`. Layer name `Button`.
- `layoutMode = 'HORIZONTAL'`, `layoutSizingVertical = 'HUG'` always, and
  `layoutSizingHorizontal` per R0.4 (HUG default, FILL for an edge to edge CTA, FIXED only
  when the design system pins a width). When you do pin one FIXED, give the label slack per
  R3.3.1: a pinned button cannot grow around a label that sets wider in the exported font than
  it did on the Figma canvas.
- `primaryAxisAlignItems` from `text-align` (default CENTER);
  `counterAxisAlignItems = 'CENTER'`.
- `background-color` to one SOLID fill (a missing fill exports
  `background-color: transparent`).
- `border-radius` to `cornerRadius`.
- `border` shorthand (e.g. `2px solid #1A1A4B`) to strokes: `strokes = [SOLID color]`,
  `strokeWeight = weight`. `border: 0px` means no strokes.
- `inner-padding` `"T R B L"` to paddings. Symmetric values are safe; the plugin's own
  re-import of asymmetric inner-padding swaps left/right, so avoid asymmetric inner padding.
  This padding is the button's tap target and the only thing that sets its height, so check
  the result is at least 44px tall rather than reaching for a fixed height.
- Shared plugin data ON THIS FRAME: `href` from MJML `href` (omit when absent).

Level 3, TEXT node (direct child of the `mj-button` frame):
- Shared `name` = `mj-button-text`. Layer name `Button Text`.
- `characters` = the button `content` (plain text, R1.11).
- Font family, style, size, line-height, text-transform, text-decoration mapped exactly as in
  R4.1.
- `color` attr to the TEXT fill (this exports as the button label color).
- `textAlignHorizontal = 'CENTER'`, `textAlignVertical = 'CENTER'`,
  `layoutSizingHorizontal = 'HUG'`, `layoutSizingVertical = 'HUG'`.

Do not add any other children. Button icon frames (`beforeIcon-Frame` / `afterIcon-Frame`)
are out of scope here, and they carry a naming trap: the library-save path finds them by a
raw layer-name substring check, so if you ever build them the literal substring must stay in
the layer name or the component loses its icons when it is saved.

### R4.4 mj-divider: `mj-divider-Frame` wrapping a LINE `mj-divider`

Wrapper FRAME:
- Shared `name` = `mj-divider-Frame`. Layer name `Divider`.
- `layoutMode = 'HORIZONTAL'`, vertical HUG, FILL width as column child. Space above and
  below a rule is this frame's padding, never its height.
- `primaryAxisAlignItems` from `align` (default CENTER); `counterAxisAlignItems` the SAME
  value.
- `padding-*` from the mj-divider attrs go HERE. `fills = []` unless
  `container-background-color`.

Inner LINE node (use `figma.createLine()`, not a rectangle: the exporter reads `strokes`,
`strokeWeight`, and `dashPattern`):
- Shared `name` = `mj-divider`. Layer name `Divider Line`.
- `strokes = [SOLID <border-color>]` (default `#000000`); `strokeWeight` = numeric
  `border-width` (default 1); `dashPattern` `[]` solid, `[4, 4]` dashed, `[1, 2]` dotted.
- `resize(W, 0)` where W is the numeric `width` if given in px, else the column content
  width; then `layoutSizingHorizontal = 'FILL'` for a full-width divider.

### R4.5 mj-spacer: single FRAME (no pair), and the one fixed height in the spec

**Try not to need one** (R0.2). When you do build one: FRAME, direct child of the column,
shared `name` = `mj-spacer`, layer name `Spacer`, `layoutMode = 'HORIZONTAL'`, `fills = []`
(any visible fill exports as `container-background-color`), `resize(width, H)` with H from
the `height` attr, then `layoutSizingVertical = 'FIXED'` and
`layoutSizingHorizontal = 'FILL'`. `padding-*` attrs map to the frame's paddings. No
children.

## R5. Cross-cutting attribute rules

**R5.1 Padding.** Worker `padding-*` are explicit px strings; `parseFloat` them onto the
OWNING frame. Container tags carry their own paddings; leaf tags carry theirs on the PAIR
WRAPPER frame (the exporter reads `node.parent.padding*` for text, button, image, divider).

**R5.2 Colors.** All colors are hex strings. One SOLID fill per background; TEXT fills for
text color. `transparent` or absent means `fills = []`.

**R5.3 Alignment master table.**

| Node | Property read by exporter | Exported as |
| --- | --- | --- |
| `mj-section` | `primaryAxisAlignItems` ('row' map) | section `text-align` |
| `mj-group` | `primaryAxisAlignItems`, `counterAxisAlignItems` | group left/right class, `vertical-align` |
| `mj-column` | `primaryAxisAlignItems` ('col' map: MIN top, MAX bottom, else middle) | column `vertical-align` |
| `mj-column` | `counterAxisAlignItems` ('col' map: MIN left, MAX right, else center) | column-level `text-align !important` CSS |
| TEXT `mj-text` | `textAlignHorizontal` | text `align` |
| `mj-image-Frame` | `primaryAxisAlignItems` ('row') | image `align` |
| `mj-button-Frame` | `primaryAxisAlignItems` ('row') | button `align` |
| `mj-button` | `primaryAxisAlignItems` ('row') | button `text-align` |
| `mj-divider-Frame` | `primaryAxisAlignItems` ('row') | divider `align` |

'row' map: MIN left, MAX right, anything else center. Always set the counter axis to the same
value as the primary on every one of these frames.

**R5.4 Column width handling.** Single column: a section 600 wide with `padding-left/right:
20px` and a FILL column (resolving to 560) exports `width: 100%`. Multi column: widths export
as percentages of the section content box. The worker may bake gutters as column paddings
(`padding-right: 10px` on the left column); keep those as paddings, do NOT convert them to
itemSpacing. Inside `mj-group`: same math against the group's content box.

**R5.5 href and alt.** Never in layer names or geometry; always shared plugin data. `href` on
the `mj-image` rectangle and on the `mj-button` frame; `altText` on the `mj-image` rectangle.
Omit the key entirely when the worker value is empty or `#`.

**R5.6 Borders.** Per-side `border-top/right/bottom/left` ("Wpx style #hex"): set
`strokes = [SOLID hex]` plus `strokeTopWeight` etc. per side (0 for absent sides). Uniform
`border` shorthand: `strokes` + `strokeWeight`. Dashed and dotted map to `dashPattern`
`[4,4]` / `[1,2]`.

## R6. Layer names: friendly on the canvas, the tag in plugin data

Every node carries two names: `node.name`, the Figma layer name, for the human who opens the
file, and the plugin data key `name` (shared namespace `emaillove`), which is the MJML tag.
**The exporter never reads the layer name for dispatch**, so a friendly layer name cannot
break the export as long as the plugin data tag is there. The plugin does exactly this to its
own nodes.

```js
const section = figma.createFrame()
section.name = 'Row (Contains columns that sit side by side)'   // for humans
section.setSharedPluginData('emaillove', 'name', 'mj-section')  // for the plugin
```

Three ways this goes wrong:

1. **Skipping the plugin data write and relying on the fallback.** The plugin has a helper
   (`enableVariableNaming`) that copies `node.name` into plugin data `name` for any node
   whose plugin data `name` is empty. Once that runs, the friendly label IS the tag,
   permanently, and the node matches no branch in the exporter.
2. **Putting the friendly name in plugin data.** The value must be either the bare tag or the
   parsed form `Friendly, (mjml:mj-section)`. A friendly-only value is read whole as the tag,
   matches nothing, and the node is dropped with no error. Extra props ride in the same
   string when needed: `, (type:link)`, `, (group:Button)`.
3. **Button icon frames** are found by a raw layer-name substring check on the library-save
   path, so they must keep the literal `beforeIcon-Frame` / `afterIcon-Frame` substring. They
   are out of scope here, so the safe move is not to build them.

The root is the one node whose naming depends on the shape (R2): an EMAIL TEMPLATE root gets
no tag at all and its layer name is the email name; a DESIGN-SYSTEM MODULE root is tagged
`mj-wrapper` and this is the one node where the friendly-name rule inverts, because its layer
name is the module name rather than the wrapper display string.

### R6.1 Display names by tag

| tag (plugin data `name`) | Figma layer name (`node.name`) |
| --- | --- |
| `mj-body` | Email Canvas |
| `mj-wrapper` | Wrapper (Groups rows and sets the background for this section ) |
| `mj-section` | Row (Contains columns that sit side by side) |
| `mj-column` | Column (Your images, text, buttons, and other content go in here) |
| `mj-column-inner` | Inner Column |
| `mj-group` | Group (Groups columns together for responsive stacking) |
| `mj-text-Frame` | Text Block |
| `mj-text` | Text |
| `mj-image-Frame` | Image Block |
| `mj-image` | Image |
| `mj-button-Frame` | Button Block |
| `mj-button` | Button |
| `mj-button-text` | Button Text |
| `mj-hero-Frame` | Hero Block |
| `mj-hero` | Hero |
| `mj-hero-Image` | Hero Image |
| `mj-divider-Frame` | Divider |
| `mj-divider` | Divider Line |
| `mj-raw` | Code Block |
| `mj-raw-text` | Code Text |
| `mj-spacer` | Spacer |
| `mj-social` | Social Bar |
| `mj-social-element` | Social Icon |
| `mj-navbar` | Nav Bar |
| `mj-navbar-link` | Nav Link |
| `mj-nav-text` | Nav Text |
| `mj-table` | Table |
| `mj-table-row` | Table Row |
| `mj-table-column` | Table Cell |
| `mj-table-text` | Table Text |
| `mj-table-image` | Table Image |
| `beforeIcon-Frame` | Before Icon |
| `afterIcon-Frame` | After Icon |

Reproduce these strings verbatim, including the stray space before the closing paren in the
wrapper string; that is what the plugin writes. Any tag not listed uses the tag itself as the
layer name. You may append a short human qualifier when a module holds several of the same
block ("Text Block / eyebrow"), but avoid the comma form, since `Label, (mjml:mj-text)` is
the parsed tag syntax. The module root is the one node that takes no display name at all.

**The tags below the transcription set.** `mj-hero`, `mj-social`, `mj-navbar`, `mj-table`,
`mj-raw`, and their children are real plugin node types, which is why they appear here and in
the visual-pattern mapping in Phase 3 step 2. This spec's detailed attribute mapping covers
the core set only (R3, R4). `mj-raw` is a frame containing exactly one TEXT child whose
characters are emitted verbatim, and the exporter reads `children[0]` unguarded, so an empty
`mj-raw` frame breaks the export; raw content is also skipped in the plugin preview but
present in the export. For anything else the appendix does not map in detail, compose the row
from mapped primitives, and reserve `mj-hero` for a design that genuinely needs live text over
a full-bleed background image.

## R7. Components: when a node is a COMPONENT instead of a FRAME

**Make it a COMPONENT when it is meant to be reused**: a converted design-system module
(always), a foundations button or badge that other modules instance. Keep it a FRAME when it
is a one-off email that nobody will instance.

This is safe. Confirmed against the plugin source: the export gate whitelists `FRAME`,
`INSTANCE`, `COMPONENT` at the root and at every container level; the Add New Template branch
tests plugin data only (`nodeType === 'mainFrame'`), never `node.type`; and every
`mj-wrapper` the plugin renders is created as a COMPONENT (`UiParser.ts:1519-1522`).
Instances work too, because an instance surfaces the main component's plugin data, so a
customer who places an instance of a componentized module still exports correctly.

```js
// build it as a component from the start...
const root = figma.createComponent()          // instead of figma.createFrame()
// ...or promote the frame you already finished:
const root = figma.createComponentFromNode(frame)

// A DESIGN-SYSTEM MODULE (R2.2): the component IS the mj-wrapper.
root.name = 'Hero, text led'
root.setSharedPluginData('emaillove', 'name', 'mj-wrapper')
// no nodeType key. Writing 'mainFrame' here breaks the module upload (R2.3).

// A REUSABLE WHOLE EMAIL (R2.1): the component is the untagged root.
root.name = 'Welcome email'
root.setSharedPluginData('emaillove', 'nodeType', 'mainFrame')
// plus the eight theme keys. No 'name' key on this node.
```

Four rules keep a COMPONENT root working:

1. **Keep it a direct child of the page.** The plugin's template discovery enumerates DIRECT
   page children and filters on plugin data. A root pulled into a COMPONENT_SET is no longer
   a page child and vanishes from the plugin's picker. Never combine module roots into a
   variant set. A Figma SECTION swallows a root the same way, and that hazard applies to
   FRAME roots too.
2. **Do not leave instances of a module root loose on the library page.** Instances inherit
   the main component's plugin data. To show a module in use, place it inside an email root.
3. **Properties go on the component that owns the node** (R8), which is the MODULE, never the
   email root. Because every `mj-wrapper` is itself a COMPONENT, an email root cannot bind a
   property to anything inside its wrapper components: Figma rejects
   `componentPropertyReferences` on an instance sublayer. That is the structural reason
   properties belong on the wrapper-level module component, and one more reason a module must
   not be built as a `mainFrame` wrapping a wrapper: the properties would have nowhere valid
   to live.
4. **Do not write `isStandalone`.** The shipped plugin build ignores that key entirely, so a
   "standalone" section or hero sitting directly under a root gets no wrapper-level controls
   in the properties sidebar and is not eligible for the Upload button. Keep `mj-wrapper` as
   the top-level block boundary.

## R8. Component properties

Properties turn a rebuilt module into something a marketer can use without opening it. They
are an agent-side layer on top of the plugin's plugin data model: the plugin neither writes
nor reads them, and they change nothing about the export except through `visible`.

Three hard constraints before any code:

- `addComponentProperty` exists **only** on ComponentNode and ComponentSetNode. A FrameNode
  does not have the method. Convert first (R7).
- The property id that comes back is **suffixed** (`Body#12:3`). Always bind and set with the
  returned id, never with the bare name.
- Figma refuses `componentPropertyReferences` on an **instance sublayer**. The property must
  be added to the component that directly contains the node you are binding.

There are exactly four property types: BOOLEAN, TEXT, INSTANCE_SWAP, VARIANT. **There is no
image property type**, so an `mj-image` fill cannot be exposed as a property; image swapping
stays a plugin-side fill edit.

```js
// TEXT, bound to characters, for copy that changes per send.
// Bind the inner TEXT node, never the wrapper: mj-text, mj-button-text, mj-table-text.
const headline = moduleRoot.addComponentProperty('Headline', 'TEXT', textNode.characters)
textNode.componentPropertyReferences = { characters: headline }

// BOOLEAN, bound to visible, for optional regions.
// Bind the block-level wrapper frame, never the inner leaf.
const showBtn = moduleRoot.addComponentProperty('Show Button', 'BOOLEAN', true)
ctaFrame.componentPropertyReferences = { visible: showBtn }

// INSTANCE_SWAP, bound to mainComponent, for style variants:
// in a migration, the foundations button instance inside the mj-button-Frame.
const style = moduleRoot.addComponentProperty('Button Style', 'INSTANCE_SWAP', primaryButton.key, {
  preferredValues: [
    { type: 'LOCAL_COMPONENT', key: primaryButton.key },
    { type: 'LOCAL_COMPONENT', key: inverseButton.key },
    { type: 'LOCAL_COMPONENT', key: textLink.key },
  ],
})
buttonInstance.componentPropertyReferences = { mainComponent: style }
```

BOOLEAN composes exactly with the exporter, which returns early on any node where `visible`
is false, so flipping it off genuinely removes the block from the exported MJML and HTML
rather than shipping a hidden element. VARIANT is only meaningful on a ComponentSetNode; skip
it for email modules, and remember rule 1 in R7.

**Which properties to add.** A property whose binding is wrong is worse than no property: it
looks editable in the panel, does nothing or edits the wrong node, and the person who trusted
it ships the mistake. Derive them from evidence in the source library, not imagination. A
BOOLEAN needs a sibling design where that region is genuinely absent. A TEXT needs evidence
the copy actually changes between sends (different values across variants, a template
variable in the source, a date or offer). Boilerplate stays unbound: mailing address, legal
lines, standing disclosures. Two to five per module is the working range, and zero is a
legitimate answer for a fixed block like a logo header. Name them in plain language ("Show
Button", "Headline", "Body", "Button Style") and reuse the same names across modules so the
panel reads consistently system-wide. Re-read `componentPropertyReferences` back off the node
after you set it.

**The known failure:** a button label that lives on a sublayer inside a nested button instance
cannot be bound from the module. The fix is to add the TEXT property to the foundations button
component itself and let it surface through the instance, which is why Phase 2 step 3 puts it
there.

## R9. Post-build checklist (run per module before handing off)

1. **The root matches the shape you meant to build** (R2), and for a migration module that
   means: shared `name = mj-wrapper`, **no `nodeType` key anywhere in the tree**, no theme
   keys unless a designer asked for a dark-mode treatment on this block, layer name is the
   module name, and its direct children are `mj-section` frames. Read `nodeType` back off the
   root and confirm it is empty; a leftover `mainFrame` uploads as a whole email. (For the one
   email template foundations builds: shared `nodeType = mainFrame`, all theme color keys plus
   `lightThemeBackgroundColor` and `fallBackFontName`, no `name` key, and its direct children
   are `mj-wrapper` components.)
2. Every FRAME/RECT/LINE/TEXT you created has shared `name` set to exactly one known tag;
   zero untagged frames anywhere in the tree, except deliberate editable-image regions for
   verdict B and C; nothing relying on the layer-name fallback.
3. Every node's layer name is the display name for its tag (R6.1), and no friendly string was
   written into the plugin data `name` key. The one exception is the module root.
4. Every leaf is a complete pair; every `mj-button` has a direct TEXT child; no empty wrapper
   frames.
5. `primaryAxisAlignItems === counterAxisAlignItems` on every auto-layout frame.
6. All nodes `visible = true` (except a region deliberately left off via a BOOLEAN default);
   `itemSpacing = 0` everywhere; no stray fills.
7. **Every frame in the tree has `layoutSizingVertical === 'HUG'`.** Walk the whole tree, root
   included. The only FIXED height allowed is on an `mj-spacer`; the only hard heights are on
   the `mj-image` rectangle and the `mj-divider` line, neither of which is a frame.
8. **Every FIXED width is one of the four load-bearing cases** (root, columns in a
   multi-column section, columns in a group, the image rectangle). Lone columns are FILL,
   groups and buttons are HUG.
9. **Every pinned-width column that contains text has slack, and every pinned string was
   sanity-checked against the exported font, not the canvas font** (R3.3.1). Columns in a group
   above all, since those never stack on mobile. `max(ceil(hug * 1.12), hug + 8)` plus
   horizontal padding, and the inner group percentages still sum to 100. A label that fits
   exactly on the Figma canvas is a wrap in the plugin Preview, because the canvas font and the
   font the email loads are different binaries. FILL columns are exempt.
10. **Every button's width sizing was a decision** (R0.4), and buttons are at least 44px tall,
    from `inner-padding` rather than a set height.
11. All vertical spacing is padding: no gaps produced by a taller frame, by `itemSpacing`, or
    by a manually positioned node.
12. Root width equals the mj-body width; column px widths equal the worker attrs; section
    paddings equal the worker attrs.
13. The module root is a COMPONENT tagged `mj-wrapper`, a direct child of its category page,
    not inside a COMPONENT_SET or a Figma SECTION, with no stray instances left on the page,
    and no second `mj-wrapper` nested inside it. `mj-column-inner`, if used, is literally
    `children[0]` of its column.
14. Every component property you added was re-read back off the node to confirm the binding
    landed, and each one has a reason you can state in the batch report.
15. No em dashes in any layer name, plugin data value, or text characters.
16. Compare a fresh screenshot of the module against the source screenshot you converted from,
    for spacing, alignment, and color parity. Small color and font-metric differences are
    acceptable; missing content, zero-height sections, clipped text, and alignment flips are
    not.
