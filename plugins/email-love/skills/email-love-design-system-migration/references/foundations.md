## Phase 2: Foundations (run once per customer)

## Contents

- Apply the accepted audit decisions
- Build the prescribed library page structure
- Create primitive and semantic variables
- Build the type and button foundations
- Set the library body and content widths
- Create proof email structure
- Run the foundations completion checklist

### Precondition: packaged render references

Before building, confirm all three packaged references are readable:

- [render-geometry.md](render-geometry.md)
- [render-nodes.md](render-nodes.md)
- [render-components-validation.md](render-components-validation.md)

They carry the complete mapping and exporter ground truth. If any is missing, tell the user
before the first write, name which verification is unavailable, and refresh the plugin or agree
on a reduced scope. Do not discover the gap in the middle of a batch.

### Shared plugin-data contract

The exporter reads namespace `emaillove`. This load-bearing subset stays inline even though the
references contain the full rules.

| Key | Node | Value and purpose |
| --- | --- | --- |
| `name` | every tagged node | Exact MJML tag, including `-Frame` where required; never rely on the layer-name fallback |
| `nodeType` | whole-email root only | `'mainFrame'`; forbidden everywhere in a reusable module |
| `backgroundColor` | mainFrame | Dark-mode page background hex; empty falls back to black |
| `contentColor` | mainFrame | Dark-mode content background hex |
| `textColor` | mainFrame | Dark-mode text hex |
| `linkColor` | mainFrame | Link hex |
| `buttonTextColor` | mainFrame | Button-label hex |
| `buttonContentColor` | mainFrame | Button-background hex |
| `lightThemeBackgroundColor` | mainFrame | Light `mj-body` background hex |
| `fallBackFontName` | mainFrame | One family such as `Arial`, never a CSS stack |
| `emailSubject` | mainFrame | Plain subject string |
| `emailPreHeader` | mainFrame | Plain preheader string |
| `fullWidth` | `mj-wrapper` | `'true'` only when the wrapper is full width |
| `stackColumns` | wrapper or section | `'true'` or `'false'` for mobile stacking behavior |
| `reverseStack` | wrapper or section | `'true'` to reverse mobile stack order |
| `href` | `mj-image` rectangle or `mj-button` frame | Real link; omit when absent and never write `#` |
| `altText` | `mj-image` rectangle | Meaningful alternative text, or intentionally empty for decorative imagery |

**Magic link values the exporter rewrites at export time.** These values are portable
instructions, not placeholder URLs. Put them on the link for text, buttons, or images. Never
invent a placeholder unsubscribe URL, and never hard-code an ESP merge tag unless the customer
explicitly requests that ESP-specific value.

| Put this on the link | What the exporter does |
| --- | --- |
| `unsubscribe.com` | Replaces it with the selected ESP's unsubscribe merge tag. Source: [Email Love unsubscribe links](https://help.emaillove.com/plugin/links/unsubscribe). |

Several mobile behaviors are not shared keys. A FILL `mj-button` produces full-width mobile;
an image whose rectangle equals its content width stays fluid; mobile padding is a node property;
and columns stack by default unless `stackColumns='false'` or `mj-group` supplies the lockup.
Check Figma sizing and width relationships before hunting for a key that does not exist.

**Start by reading the audit's Source fidelity tier, and say which tier you are building under
before you create a node.** It decides where every number below comes from, so it is not something
to discover in the middle of a type ramp.

**Everything you build, here and in Phase 3, is at email scale.** How you get there is the tier's
answer, not a single procedure:

- **AUTHORITATIVE or PARTIAL: build from the source, through the factor.** Take the factor from the
  audit's Scale factor section and divide the source numbers by it: type sizes, line heights, the
  spacing scale, paddings, spacer heights. **Widths are not the factor's to divide**: the body width
  and everything measured across it (content width, column splits, image widths) come from the target
  email width, which is the width-versus-type check below and render rule R0.6's two factor tension.
  Do not re-derive the factor from the file, even when the arithmetic looks
  obvious to you: the audit computed both derivations, and where they disagreed a human chose
  between them, so a fresh derivation here quietly overrules that decision. When the audit says the
  factor is still a designer decision and nobody has confirmed it, get the yes before you build,
  because the factor changes every module. State the factor you built at in the foundations report,
  so batch 1 and every batch after it inherits one number. Appendix R0.6 has the same rule at the
  geometry level. On a PARTIAL source the factor came from the deliberate part of the file and the
  audit said which part: preserve what it proved consistent, standardise the rest onto the defaults
  below, and give every standardisation its own line in the report.
- **REFERENCE ONLY: build to email standards, and scale nothing.** There is no factor, you do not
  derive one, and there is no source measurement to divide. **The defaults, stated rather than
  derived:** a **600** body width; **one content width for the whole library**, 560 on a 600 body, so
  no module invents its own; a conventional type ramp with **body at 16** (12 fine print, 14
  secondary, 16 body, 20 subhead, 24 to 30 headline, line height 1.4 to 1.5 on body copy and tighter
  on headings); and a **spacing scale in multiples of 8** (8, 16, 24, 32, 40, 48), with one section
  padding chosen off that scale and used library-wide. From the source take the palette, the
  typefaces, the logo, the copy, and the module structure and its order: nothing else. **Record in the
  foundations report that the geometry is ours**, in those words, because otherwise somebody
  downstream compares a module to the source, reads the difference as a defect, and "fixes" the
  library back toward the guesses this tier exists to discard.

Everything below that reads a source number, the ramp and the spacing scale above all, is an
AUTHORITATIVE and PARTIAL instruction. On a REFERENCE ONLY source it is the defaults above that get
built, and the source's numbers stay in the audit as evidence.

**Read the audit's Spacing system and Palette sections before creating foundations.** The spacing
section is the one system every later module must use, not a collection of per-module source
measurements. The palette is the complete color census and the approved mapping from source hexes
to primitives and semantic roles. A missing section is a stale audit and blocks foundations until
the audit is refreshed.

**Foundations also SETS the content width, once, for the whole library, and records it.** This is
the same shape as the scale factor rule above, so treat it the same way: one number, decided here,
applied by every later batch, never re-derived per module. Content width is the width text actually
occupies inside a module (the body width minus the side margins), and it decides where a reader's
eye finds the left edge of every line in every email built from this library. On an AUTHORITATIVE or
PARTIAL source, take the audit's
derived content margin and content width from its **Brand foundations** section as the starting
value, decide the number, and state it in the foundations report and on Getting Started. **On a
REFERENCE ONLY source the number is 560 on a 600 body**, straight off the defaults, with no
derivation from a source margin: a margin nobody chose carries no information, and converting a
percentage of an arbitrary canvas width is how a library ends up with 20px margins that came out of
arithmetic rather than out of a decision. With a 600
body and a 560 content width, every text-bearing section carries 20/20 padding. Full-bleed image
bands at the body width are the only exception. You may overrule a derived value, but say
so and say why, exactly as you would for a type size.

Why this needs saying: the design-converter worker in Phase 3 returns a section padding per
screenshot, it sees one module at a time, and it has no knowledge of the module's siblings, so its
side margin is a per-module guess BY CONSTRUCTION. Accepting it per module does not risk drift, it
guarantees it. Measured on one assembled email: side margins of 48, 40, and 20 across six modules,
which is three content widths in one email and a text left edge that moves as the reader scrolls,
with every individual padding value looking perfectly reasonable on its own. Appendix R0.3.1 has the
measured table and the failure signature. Foundations fixing one number is half the remedy; Phase 3
applying that number instead of the worker's is the other half.

**And run the width-versus-type factor check, once, here, on an AUTHORITATIVE or PARTIAL source.**
Divide the source width by the target
email width and compare that ratio to the scale factor you are building at. If they differ by more
than a couple of percent, the library carries two factors whatever the audit recommended, so say so
in the foundations report and name which one governs which quantities: type factor for type sizes,
line heights, and the spacing scale, target width for the body width and everything measured across
it (content width, column splits, image widths). Measured case: a 1092 wide source built to 600 is
1.82 across the width while the confirmed type factor was 2.2, and nobody wrote that down, so the
content-width decision had no traceable derivation. This is a tension to declare, not a bug to fix
(render rule R0.6, Step 4).

**On a REFERENCE ONLY source this check does not run**, and the reason is worth stating rather than
leaving as an omission: the tension it declares is between two ways of preserving a source
proportion, and this tier preserves none. Record in the report that you skipped it because the
geometry is built to standards. Do not compute the ratios anyway as background: the measured failure
this branch exists to prevent began with two derivations on a file where neither belonged, and ended
as a 16px body inside 20px margins that nobody had chosen.

Build the scaffold every later batch depends on:

1. **Pages: a FIXED frame plus a dynamic middle.** The page structure is PRESCRIBED, not derived
   from what the audit happened to find. Two customers' libraries have to be navigable by the
   same person without relearning the file, so the scaffolding pages are always present, always
   spelled exactly as written here, and always in this order. Only the component category pages
   vary.

   ```
   Cover
   Getting Started
   --- Foundations
   Foundations
   Type
   Buttons
   --- Components
   <one page per category from the audit's Module inventory, in the inventory's own order>
   --- Templates
   Campaigns
   ```

   **The scaffolding pages are not optional and not reorderable.** Do not drop the Cover because
   the file is small, do not merge Foundations into Type, do not sort the category pages
   alphabetically or by how many modules they hold, and do not move Campaigns up because it is
   the page you were working on. An agent deciding the shape per run is the defect this
   prescription removes: the page list stops being a matter of judgment.

   **The three `---` pages are dividers, not content.** Figma has no page folders, so a page
   named `--- Foundations` acts as a visual separator in the page list. Leave them empty. Name
   them with three hyphens, one space, then the word, exactly as written. **A divider sits BEFORE
   the group it introduces**, which is the order that reads correctly in the page list:
   `--- Foundations` then the foundations pages, `--- Components` then the category pages,
   `--- Templates` then Campaigns.

   **The middle is the only dynamic part.** One page per category the audit's Module inventory
   uses (Heroes, Single Column, Lists, and so on), in the order the inventory presents them, and
   no page for a category the inventory does not use. Do not invent a category here: the audit
   already chose them from the sections the customer's plugin has, and it ordered them
   deliberately (Phase 1, Step 5).

   **One category collides with a scaffolding page, and there is exactly one right answer:
   Buttons.** `Buttons` is both a foundations page in the canonical order above and one of the
   categories the audit can use, so an inventory that carries button modules would otherwise
   produce two pages with the same name. It does not: the middle SKIPS the Buttons category, and
   any Buttons-category module goes on the existing Buttons page, below the button styles. The
   page list stays exactly the canonical list. No other category collides.

   Create the pages in one pass in this order so the list comes out right without reordering.
   **A file you just created still has Figma's default page: RENAME it to `Cover` rather than
   creating a Cover beside it**, or the finished list carries a stray `Page 1` and fails the
   checklist below. If the target file already had pages before you arrived, move them into
   position rather than appending, and delete nothing you did not create.

   **Each scaffolding page has a CONTRACT.** Layout and polish are yours; the listed content is
   not. Two runs of this workflow on two customers must produce the same page doing the same job.

   - **Cover.** The first thing anyone opening the file sees, and it answers "what is this and
     what width is it" without anyone having to ask. Required: the customer's brand name set
     large; "Email Love Design System" beneath it; and a single metadata line carrying three
     facts, the design system's own version (`v1.0` on a first build, never this workflow's version
     number), the email width the system is built at, and the month and year
     (for example `v1.0 · 600px · July 2026`). **The width is required because it is the single
     most useful fact about an email design system:** it decides whether a module dropped in from
     anywhere else fits. Put the content on a full-bleed frame whose fill is bound to
     `color/bg/brand`, so the cover is on brand color and moves when the brand color moves. No
     module lives on this page.
   - **Getting Started.** How to use the library, in prose a designer or marketer new to the file
     can follow. **Its frame is vertical HUG with `clipsContent` off, never fixed height.** Take a
     whole-page screenshot after writing it and confirm every line is visible. Required, one short
     block each: that modules are wrapper components and are used by INSTANCING them, never by
     copying or detaching; that text is edited through component properties on an instance;
     images are edited by selecting the image rectangle inside the instance and replacing its
     image fill, because Figma has no image property type; that color, type,
     and spacing come from the tokens on Foundations and Type rather than from hand-typed values;
     and where to look when something does not export as expected (confirm the block is still an
     instance and not detached, confirm the copy was changed through its property rather than in
     place, then hello@emaillove.com). Name the email width, the content width, and the scale
     factor here too, so the page stands alone. **On a REFERENCE ONLY source there is no factor to
     name, so say instead, in one sentence, that the geometry is built to email standards and the
     brand is what came from the source file.** That sentence is what stops somebody opening this file
     in six months, comparing a module to the old one, and correcting the library back toward it.
     **The content width is required here** because it is
     the number every later module is measured against and the one a module dropped in from elsewhere
     will get wrong: state it as the number plus the side margin it implies (for example `560px
     content width, 20px side margins on a 600px body`), and say that full-bleed image bands at the
     full body width are the only exception.
   - **Foundations.** The token sheet. Required: a swatch per color, each labeled with BOTH its
     hex and its variable name, with primitives and semantic aliases in two clearly separated
     groups so a reader can see which name to reach for; the spacing scale rendered as visible
     bars or frames, each labeled with its token name and its pixel value; and the radius token
     with its value. A hex on this page that no variable carries is a defect: the point of the
     page is that everything on it is bindable.
   - **Type.** A SPECIMEN sheet, not a list of style names. Per style in the ramp, three things:
     the style name, a line of sample text actually set in that style, and a caption stating
     family, weight, and size (for example `Inter, Bold, 30px`). Order the rows largest to
     smallest so the ramp reads as a ramp. **This page is how a human catches a broken ramp by
     eye.** A specimen sheet makes a style that has drifted off the single scale factor visible
     as a step the wrong size next to its neighbors, which is the same defect the ratio check in
     step 3 catches arithmetically, and which presents downstream as a padding bug rather than a
     type bug (the single-factor rule: step 3 here, render rule R0.6). Run both checks every time:
     the arithmetic catches what the eye misses on a long ramp, and the eye catches what a passing
     ratio hides in the middle of one. On a REFERENCE ONLY source there is no ratio check to pair it
     with, so the page carries the whole load: look at the specimen sheet and confirm the standard
     ramp reads as a ramp.
     **A gap in the ramp is a decision for foundations, not for batch 3.** If the sheet jumps from
     26 to 17, or from 30 to 20, inspect the source for eyebrows, captions, small subheads, or fine
     print that belongs between those steps. If any exists, add the missing step now and record it
     as a standardization. A step added this way sits outside the ratio check because it was not
     derived from the audit's factor; state which original rows the ratio check covers.
   - **Buttons.** One component per button style the audit listed, built as step 4 specifies, each
     visibly labeled with its name, each with its fill bound to the semantic token that style
     actually uses. Where the inventory has a Buttons category, its modules land here too, below
     the styles and visibly separated from them. Nothing else on the page: no loose instances, no
     scratch work.
   - **Campaigns.** The one root EMAIL TEMPLATE frame, built as step 7 specifies. It is the only
     `mainFrame` in the file and it is an email, not a module. Empty until batch 1 drops modules
     into it.
2. **Variables: two tiers, and component fills BIND to them.** Build real Figma variables, not a
   page of hex values a reader has to retype. One collection named `Email Love Tokens`, one mode,
   two tiers inside it:

   - **Primitives, named by value:** `black/1000`, `navy/900`, `blue/500`, `cream/100`. The
     family plus a numeric weight, taken from the audit's palette. A primitive's name says what
     the color IS and never where it is used, so nothing about it goes stale when a usage
     changes. COLOR variable values take `{ r, g, b, a }` with alpha, on a 0 to 1 scale, while
     the paint you bind them to takes `{ r, g, b }` without it: the two are easy to cross and the
     error is silent.
   - **Semantic aliases, named by role, each pointing at a primitive:** `color/bg/page`,
     `color/bg/content`, `color/bg/brand`, `color/bg/subtle`, `color/text/primary`,
     `color/text/inverse`, `color/text/accent`. A semantic carries no color of its own; its
     value is an alias:
     `semantic.setValueForMode(modeId, { type: 'VARIABLE_ALIAS', id: primitive.id })`.
   - **A numeric spacing scale** as FLOAT variables under `spacing/`: `spacing/xs`, `spacing/sm`,
     `spacing/md`, `spacing/lg`, `spacing/xl`, `spacing/2xl`. The NAMES are prescribed; the
     default values are 4, 8, 16, 24, 32, 48. Where the audit carried the customer's own spacing
     scale, its values win and keep these names. **Do not round the audit's values onto the
     default ladder** to make them look tidier: that is step 5's rule, and rounding a customer's
     14 up to 16 is a second scale factor wearing a friendly number. **That rule is about a source
     whose spacing was chosen, so it binds on an AUTHORITATIVE or PARTIAL source only.** On a
     REFERENCE ONLY source the values are the multiples of 8 from the top of this phase (8, 16, 24,
     32, 40, 48) and no source spacing is carried across at all.
   - **A radius token for the pill,** `radius/pill`, FLOAT, at the radius the customer's button
     styles actually use.
   - **Set `scopes` explicitly on every variable.** The default `ALL_SCOPES` puts every token in
     every picker, which makes the collection useless at the moment it becomes large. Background
     colors get `['FRAME_FILL', 'SHAPE_FILL']`, text colors `['TEXT_FILL']`, spacing `['GAP']`
     plus whichever padding scopes you actually use, radius `['CORNER_RADIUS']`.
   - **Component fills bind to the SEMANTIC variables, never to a primitive and never to raw
     hex.** `setBoundVariableForPaint` returns a NEW paint, so capture it:
     `node.fills = [figma.variables.setBoundVariableForPaint({ type: 'SOLID', color: { r: 0, g: 0, b: 0 } }, 'color', semanticVar)]`.
     Spacing binds with `node.setBoundVariable('paddingTop', spacingVar)` and its siblings;
     radius binds per corner (`topLeftRadius` and the other three), never through `cornerRadius`.
     `fontSize` and `lineHeight` are NOT bindable, so type sizes stay literal on the text node and
     the ramp is governed by the text styles from step 3 instead.
   - **What this buys: changing a brand color becomes one edit.** Repoint `color/bg/brand`'s
     alias at a different primitive and every module using it moves together. Leave forty
     components carrying hex and it is forty edits, plus a reviewer counting them to be sure.
   - **Variables are a Figma-side convenience and must not change what exports.** The plugin's
     exporter reads RESOLVED fills: it takes `node.fills[0].color` and hexes it, and it never
     reads `boundVariables` at all. A bound paint still carries the resolved RGB in `color`, so
     binding is invisible to the export, and that is exactly the property that makes this safe to
     do. Two consequences follow. Set each primitive to the hex the audit gave, so resolved
     equals intended. And the email template root's theme keys are shared plugin data STRINGS,
     not fills (step 7), so they cannot be bound at all: they carry literal hex, and repointing a
     semantic token means updating the matching theme key by hand.
3. **Type mapping.** Recreate the type ramp as Figma text styles in the target file using the
   customer's email-safe fallback choices from the audit (never the unlicensed brand font unless the
   user confirms web-font hosting). Name styles as the customer named theirs. **The typefaces come
   from the source on every tier. Where the SIZES come from is the tier's answer.**

   **Check that the target font is installed before building the ramp.** Call
   `figma.listAvailableFontsAsync()` and look for the family by name. Agent-run Figma environments
   commonly expose Google Fonts but not Helvetica, Helvetica Neue, or Arial. When Arial or
   Helvetica is the target and is unavailable, build in **Arimo**, the metrically compatible Arial
   clone, so advance widths and pinned-column slack remain representative. Record the consequence
   in the foundations report: the exporter writes the Figma family into `font-family`, so output
   will say Arimo until the family is swapped or Arial is accepted at send time. Also record any
   collapse from brand weights such as Light, Extra Bold, or Black to the Regular and Bold weights
   available in the chosen email-safe stack.

   **REFERENCE ONLY: build the conventional ramp, and do not divide anything.** 12 fine print, 14
   secondary, 16 body, 20 subhead, 24 to 30 headline, line height 1.4 to 1.5 on body copy and tighter
   on headings. These are the defaults from the top of this phase, stated rather than derived, and the
   source's authored sizes play no part in them: a ramp that was eyeballed style by style is not a
   ramp, so there is nothing in it to scale down. Keep the customer's style names where they map onto
   that ramp, and where their ramp had more steps than this one, collapse rather than invent: two
   headline sizes 2px apart in a source nobody built to a scale are one headline. **The ratio check
   below does not apply on this tier**, because it exists to prove a single factor was applied
   uniformly and there is no factor here. What replaces it is a read-back: confirm the built ramp is
   the ramp above, body at 16, each step present once.

   **AUTHORITATIVE or PARTIAL: build the ramp from the audit's table VERBATIM.** Take the Email size
   column of the audit's Brand
   foundations table exactly as written: every value in it is already the authored size divided
   by the one confirmed factor. Do not re-derive it, do not re-round it, and above all do not
   map a style toward a size that looks like a number email usually uses. A 65 the table says
   is 30 is 30; a 55 the table says is 25 is 25, even though 30 and 24 are the sizes you have
   seen in a hundred other emails. Mapping style by style toward pleasant numbers is exactly
   how a per-style factor gets back in after the audit removed it, and it is the defect this
   instruction exists to prevent. Appendix R0.6 carries the measured case: a module that came
   out with 1.83 on its headline and 2.19 on its body, from a ramp built one round number at a
   time, and it read as a padding bug. On a PARTIAL source, a size the audit could not prove was
   deliberate gets standardised onto the conventional ramp above instead, and that substitution is one
   line in the report.

   **Then run the ratio check, before anything gets built on top of these styles**, on those two
   tiers. Divide the
   largest size in the ramp you just built by the smallest, divide the largest authored source
   size by the smallest, and compare the two. More than a couple of percent apart means a style
   has drifted off the factor: find it, fix it, check again. If a size still looks wrong once
   the ramp passes, that is evidence against the FACTOR, so take it back to the audit and the
   designer and move the whole ramp together. Never adjust the one style and leave the rest of
   the ramp where it was.
4. **Buttons page.** Rebuild each of their button styles as a component: correct email
   construction (a styled frame with a single text node), not their app-style nested
   instances. These become the sub-components nested inside mj-button-Frames, and they are
   the INSTANCE_SWAP targets for module-level "Button Style" properties later. Put the
   label's TEXT property on the button component itself: a label living inside a nested
   instance cannot be bound from the module that uses it (render rule R8).
5. **Spacing.** Build the audit's accepted Spacing system by role. For AUTHORITATIVE or PARTIAL,
   preserve its decided values at email scale and its named exceptions; never recover a discarded
   per-module outlier during conversion. Recreate spacer components only when the source had them,
   and run the ratio check across the accepted scale. **On REFERENCE ONLY use 8, 16, 24, 32, 40,
   48**, and choose one section padding for the whole library. There is no source ratio to check.
6. **Assets.** Export the logo and any recurring imagery from the source file
   (`download_assets`) and upload into the target file (`upload_assets`). Logos become
   images, never vectors. **A logo keeps its intrinsic dimensions and aspect ratio; never resize
   it to fill a column or include it in a bulk image-growing pass.** Export the RENDERED node
   every time, never the raw image fill behind
   it: a source fill with `scaleMode: 'CROP'` loses its crop the moment you take the underlying
   asset, and you get the whole photograph instead of the picture the designer composed
   (render rule R4.2.1, which also has the aspect-ratio rule). This rule fires here for recurring
   assets and again in Phase 3 for each module's own image assets. Never crop an asset out of a
   full-canvas render, which bakes overlapping siblings into the image.
7. **Root EMAIL TEMPLATE frame** on Campaigns at the audit's target email width (600 or 640,
   never the source canvas width when the source was not at email scale; 600 on a REFERENCE ONLY
   source unless the customer's ESP or brand asks for 640): vertical
   auto-layout, width FIXED at that email width, height Hug, the shared marker, and the theme
   colors from the audit's proposal:
   `setSharedPluginData('emaillove', 'nodeType', 'mainFrame')` plus backgroundColor,
   contentColor, textColor, linkColor, buttonTextColor, buttonContentColor,
   lightThemeBackgroundColor, and fallBackFontName (render rule R2.1 has all nine and what each
   one is for). Empty theme keys are not neutral: the exporter substitutes dark defaults.
   **This is the only `mainFrame` foundations produces, and it is an email, not a module.**
   It exists so batch 1 has somewhere to drop modules and see them in context. The modules
   themselves are a different shape entirely (Phase 3, and render rule R2): each one is an
   `mj-wrapper` COMPONENT with **no** `mainFrame` marker and no theme keys. Do not copy this
   frame as a starting point for a module.

   **A wrapper is FIXED at the target email width, as a component and as every instance of it.**
   When Phase 3 drops wrapper instances into this root frame, size each instance
   `layoutSizingHorizontal = 'FIXED'` at the same width the component was built at, not FILL.
   R0.3's FILL rule (prefer FILL, pin only when you must) is for frames INSIDE a wrapper, not
   for the wrapper itself. A wrapper sized FILL inherits from whatever container it is in,
   which reads correctly the moment its container is this root and breaks the moment the same
   instance is placed elsewhere or the root width changes. The plugin's export also reads column
   widths from the pinned wrapper width, so a FILL wrapper leaves the export math ambiguous.
   Module step 5 has the matching verification.
8. **Report** what was built, **the source fidelity tier you built under and one clause of why**,
   the target email width, and the content width you built at,
   the completion checklist result below, what the
   audit proposed that you changed, and what needs the designer's eye before batch 1 (theme
   colors especially: they are a proposal until a human confirms).

   **Include a WCAG contrast table for every text-on-fill pairing.** At minimum calculate
   `textColor` on `backgroundColor`, `linkColor` on `backgroundColor`, `buttonTextColor` on
   `buttonContentColor`, plus explicit text-on-brand combinations. Report the ratio and pass/fail:
   4.5:1 for normal text and 3:1 for large text at 18pt or 14pt bold. Flag normal-text failures
   and button pairs sitting exactly at 3:1, and name a darker semantic token that passes or ask the
   designer for one.

   Then the tier's own numbers:

   - **AUTHORITATIVE or PARTIAL:** the scale factor, the width-versus-type factor check with both
     ratios and which factor governs which quantities, and the ratio check result with the two ratios
     you compared. If you changed a type size or a spacer away from the audit's table, that is not a
     foundations detail, it is a change to the factor: say so explicitly and say who agreed to it. On
     PARTIAL, list every value you standardised, one line each.
   - **REFERENCE ONLY:** that there is no scale factor and why not, the email standards you built to
     (600 body, 560 content width, the ramp with body at 16, the spacing scale in multiples of 8), and
     what came from the source, which is the palette, the typefaces, the logo, the copy, and the
     module structure. **Then the sentence that has to survive this document: the geometry is ours, by
     decision, and a module whose margins do not match the source file is correct.** Without it the
     next person to open both files reads the difference as a bug.

### Phase 2 completion checklist

**Run every line of this before reporting foundations done**, and put the result in the report.
Each line is a read-back off the file, not a recollection of having built it: an agent that
remembers creating the Cover and an agent that read its metadata line back are not in the same
position. Report the checklist as passed only when it passed in full; a partial pass is an open
item, named.

Pages, in canonical order:

- [ ] The page list reads exactly Cover, Getting Started, `--- Foundations`, Foundations, Type,
      Buttons, `--- Components`, the category pages, `--- Templates`, Campaigns. Read the names
      off `figma.root.children` and compare them in sequence, including the three hyphens and the
      single space in each divider name. Nothing else is in the list: no second `Buttons`, and no
      `Page 1` left over from creating the file.
- [ ] The category pages are exactly the categories the audit's Module inventory uses, in the
      inventory's order, with none added, none missing, and none renamed, except Buttons, which
      has its page in the Foundations group instead.
- [ ] The three divider pages are empty.
- [ ] **Cover:** brand name set large, "Email Love Design System" beneath it, and one metadata
      line stating version, email width, and month and year. The width printed there matches the
      width the root frame was actually built at. Its frame fill is bound to `color/bg/brand`.
- [ ] **Getting Started:** the frame is vertical HUG with `clipsContent` off and a full-page
      screenshot shows every line. Instancing rather than copying, text editing through component
      properties, image editing by replacing the nested image rectangle's fill, styling from the
      tokens, and the "does not export as expected" path are all present,
      plus the email width, the content width with its side margin, and the scale factor, or, on a
      REFERENCE ONLY source, the sentence that the geometry is built to email standards and the brand
      came from the source.
- [ ] **Foundations:** every swatch labeled with hex AND variable name, primitives and semantics
      visibly separated, the spacing scale rendered and labeled with token names and values, the
      radius token present. No hex anywhere on the page that no variable carries.
- [ ] **Type:** one specimen row per style, each with the style name, a sample line actually set
      in that style, and a caption naming family, weight, and size, ordered largest to smallest.
      Then look at it: does the ramp step evenly? A step that reads wrong beside its neighbors is
      a factor problem, not a style problem, on a source built through a factor, and a mis-built
      standard ramp on one that was not (step 3). The target family was checked with
      `figma.listAvailableFontsAsync()` before the ramp was built, and any Arimo substitution,
      weight collapse, or intentionally added ramp-gap step is recorded in the foundations report.
- [ ] **Buttons:** one component per audit button style, each labeled, each a styled frame with a
      single text node, the label's TEXT property on the component itself, no loose instances left
      on the page.
- [ ] **Campaigns:** exactly one root frame, `nodeType = 'mainFrame'`, at the target email width,
      with all eight theme keys set (the nine of step 7 less the `nodeType` marker itself) and not
      one of them empty.

Variables and bindings:

- [ ] The collection exists with both tiers: primitives named by value, semantics named by role.
- [ ] Every semantic's value reads back as a `VARIABLE_ALIAS` pointing at a primitive, not as a
      color of its own. Read the value and check its `type`, do not infer it from the swatch.
- [ ] The spacing scale exists as FLOAT variables under `spacing/`, and `radius/pill` exists.
- [ ] `scopes` is set explicitly on every variable, and nothing is left on `ALL_SCOPES`.
- [ ] Every fill on every foundations component resolves through a semantic variable: walk the
      button components and the Cover frame and confirm each fill carries a bound variable rather
      than a hand-typed color.
- [ ] Binding changed nothing about export: read `fills[0].color` back off a bound node and
      confirm it hexes to the value the audit gave for that token.
- [ ] The root frame's theme keys carry literal hex matching the semantics they mirror, because
      plugin data cannot be bound.
- [ ] The WCAG contrast table covers every theme and explicit text-on-fill pairing; each failure
      names a passing alternative token or an unresolved designer decision.

Scale, checked last because it invalidates everything above it. **The first line decides which of the
next two you run:**

- [ ] The source fidelity tier is stated in the report, with the signals behind it, and it is the tier
      the audit gave or the one a named person overruled it with.
- [ ] **AUTHORITATIVE or PARTIAL only:** the ratio check passed, with both ratios recorded (step 3),
      and every number on every page is at email scale, meaning the root frame is 600 or 640, the type
      sizes are the audit's Email size column verbatim, and the spacing values are the audit's. On
      PARTIAL, every standardised value is listed in the report.
- [ ] **REFERENCE ONLY only:** no scale factor appears anywhere in the report, the pages, or the built
      values. The root frame is 600, the ramp reads 12/14/16/20/24 to 30 with body at 16, the spacing
      scale is multiples of 8, the content width is 560, and the report says in words that the geometry
      is ours. A factor that has crept back in as a caption or an aside is a failure of this line,
      because the next reader applies whatever number is on the page.
- [ ] **The library's ONE content width is decided and recorded**: in the report and on Getting
      Started, as a number plus the side margin it implies. Every text-bearing module in every later
      batch is measured against this, so an unrecorded content width means batch 1 inherits the
      worker's per-module guess and the drift in render rule R0.3.1 starts on the first module.
- [ ] The width-versus-type factor check is in the report: source width divided by target email
      width, compared to the scale factor, with which factor governs which quantities stated in words
      when the two differ (render rule R0.6). **On a REFERENCE ONLY source this line is satisfied by
      recording that the check was skipped and why**, not by running it.
