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

These instructions are **version 1.16.0** (2026-07-29). They track the
`emaillove-eds-converter` Claude skill at 1.16.0 and the `emaillove-migration-audit` skill at
1.8.0, with one rule from those versions not yet in this file: the absent-versus-fused
distinction in the asset survey (Step 2 of the audit skill) and the combined-raster recovery it
pairs with (section 4.2.2 of that render spec). Everything else in both skills is here.

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

**Version 1.11.0 changed what the audit produces, and Phases 2 and 3 now depend on it.** An
audit written with a 1.10.x or earlier copy classified whole designs, one row per template, and
said nothing about the scale the source was drawn at. Phase 3 converts MODULES, so those reports
cannot be batched from. Phase 1 now produces a deduplicated **Module inventory** (Step 4) and a
**Scale factor** (Step 3), and both are required sections. If you are picking up a migration
whose audit predates this, re-run Phase 1 rather than improvising a module list out of a
per-design table. Two specific risks in work already done: a batch built from a per-design table
tends to contain components that are whole emails rather than reusable blocks, and a batch built
from a source that was never at email scale is uniformly two or three times too big.

**Version 1.12.0 added R0.7 and R4.2.1**, and with them two required Module inventory columns.
R0.7 is double padding: when the block above and the block below both pay for the gap between
them, the two values add, so the gap renders at about twice what the design shows. R4.2.1 is
images: render the source node and use the render, never export the raw fill, because a crop
transform and any clipping by overlapping siblings live outside the asset. Both were observed on
a live conversion, and both pass every other check in this appendix, which is why they need
naming. In batches converted with a 1.11.x or earlier copy, two things are worth re-measuring:
any leaf frame whose height exceeds its content by exactly one padding you wrote, and any image
that carries dead space where the composition used to be tight. Step 4 also now requires a
**source ref** and a **build constraints** column on every Module inventory row, which is how a
finding like "render the node, not the fill" reaches the module it constrains instead of dying
in Flags.

**Version 1.13.0 added R3.4.1, the Two Column Swap, and it moves modules out of verdict C.**
Source designs routinely place a photograph so it overlaps or bleeds past the block it belongs
to, which in Figma is z-order plus absolute position and in email is nothing at all. Earlier
copies had no standard answer, so every one of these was argued from scratch and usually landed
as a C with a paragraph of explanation. The remedy is now settled: rebuild the block as a two
column row, one `mj-section` with two `mj-column`s, image in one and text in the other in source
order. **A block whose only obstacle is an overlap or an edge bleed is verdict
`A (concession: image bleed rebuilt as a two column row)`, never a C**, because the whole block
converts as live text and C reads as a partial conversion. Step 4 has the classification, Phase 3
step 2 has the build, and appendix R3.4.1 has the construction and the two tells for recognizing
the pattern on the nodes (the screenshot hides the overflow by construction). Two things are
worth revisiting in work already done: any C whose notes describe a bleed or an overlap and
nothing else, which is now an A and cheaper than it was priced, and any converted module where a
band came across as a flattened image where the design had a photo beside copy.

**Version 1.14.0 made the scale factor ONE number and gave the report a table that proves it.**
Earlier copies recommended a factor in Step 3 and then, in Phase 2, mapped each text style
individually toward a round email number, which silently reintroduced a per-style factor: a
measured module came out at 1.83 on its headline and 2.19 on its body, so the source's own
headline-to-body ratio of 1.57 was built as 1.88 and the headline was 20 percent too large. It does
not read as a type problem, it reads as a padding problem, which is why it survived review. Step 3
now requires a four-column ramp table with the factor restated on every row plus a ratio acceptance
test, Phase 2 builds the ramp from that table verbatim and re-runs the check, and appendix R0.6 has
the rule at the geometry level. Two things are worth re-checking in libraries already converted:
divide the largest type size by the smallest and compare that to the same ratio in the source, and
do the same across the ends of the spacer scale. If either is more than a couple of percent off,
the ramp was rounded style by style and the whole library inherits it.

**Version 1.15.0 added the progress contract, and it is the first change here that is purely about
what you say.** Earlier copies told you to state an estimate before you begin and then said nothing
about the next forty minutes, so a run that was working looked identical to a run that had hung, and
a user who had been told twenty minutes had to work out for himself that he was at forty. The
estimate is now half of it. "Report progress while it runs", under "How long this takes", fixes the
checkpoints (three while the audit walks, five while a batch converts), the format (a count, a
percentage, the module by name), the requirement to recompute the remaining time from observed pace
instead of repeating the opening guess, and the ceiling on frequency: module boundaries, never per
node. Nothing built with an earlier copy is wrong because of this, so there is nothing to re-check
in converted work.

**Version 1.16.0 PRESCRIBES the library structure, which was previously left to judgment.** Two
agents converting the same source from the same audit produced two differently shaped libraries,
because the old Phase 2 asked for "a Cover, one page per category, Buttons, Type, Campaigns" and
left the rest open. So the page list came out of whatever categories the walk happened to find, in
whatever order, with no scaffolding around them, and two customers' libraries could not be navigated
by the same person. Phase 2 step 1 now fixes the page list as a FIXED frame plus a dynamic middle,
in one canonical order (Cover, Getting Started, `--- Foundations`, Foundations, Type, Buttons,
`--- Components`, the audit's category pages, `--- Templates`, Campaigns), and gives each
scaffolding page a content contract: a Cover that answers "what is this and what width is it", a
Getting Started that explains instancing and properties, `---` divider pages standing in for the
page folders Figma does not have, a Foundations token sheet, and a Type page built as a SPECIMEN
sheet so a broken ramp is visible to the eye as well as to the ratio check. Step 2 is new and
requires real Figma VARIABLES in two tiers, primitives named by value and semantic aliases named by
role, with component fills BOUND to the semantics, so changing a brand color is one edit rather than
forty. Step 4 of Phase 1 now orders the inventory's categories top-of-email-to-bottom, because that
order becomes the page order. There is also a Phase 2 completion checklist, read back off the file
rather than recalled. Worth doing in libraries already converted: compare the page list against the
canonical order, and check whether any component fill carries a hand-typed hex instead of a bound
semantic token.

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

## How long this takes, and what to tell the user first

A migration is measured in sessions, not seconds, and most of the frustration around one comes
from a user who expected a minute. **Before you start any run longer than a couple of minutes,
which means foundations, any module batch, and the audit of a large library, say in one line
what you are about to do and roughly how long it should take.** Then start. A short line at
each module boundary is the right rhythm after that: not silence for forty minutes, not a
running commentary on every node.

**Where the time actually goes.** Almost all of it is round trips to Figma, not model
thinking. Every node you create or read back is a call, so a module with forty nodes costs
many times what a module with six costs, and **the node count predicts the time far better
than how complicated the design looks**. The design-converter worker is not the slow part: it
returns MJML JSON in a few seconds to about half a minute per design. If the user comes away
thinking the AI is what is slow, they have the wrong picture. The AI is waiting on the canvas.

**What has actually been measured.** On batches of five modules, working from converted MJML:

| Pass over a batch of 5 modules | Observed |
| --- | --- |
| Rendering the batch from converted MJML | about 38 minutes |
| Restructuring the batch | about 31 minutes |
| Promoting the batch to components | about 28 minutes |
| A sizing correction pass | about 18 minutes |
| Adding component properties | about 14 minutes |

Hold two things in mind before repeating those numbers. First, they come from several agents
working in parallel **with an adversarial verification pass on every module**. A single agent
following this file has a different profile: less parallelism, but also fewer passes, since it
is not re-verifying someone else's work. Second, they are observations of past runs, not a
rate card. Quote them as ranges, and never as a commitment.

**Source shape moves the number more than anything else.** An email-native source (frames
already at 600 or 640, auto layout in place) converts far faster than an unstructured one
(groups, absolutely positioned layers, a scaled-up mockup), because in the unstructured case
you first have to work out where each module even begins and ends before you can build
anything. On a real unstructured file that came out at roughly **three times slower per
module**. The audit already knows which kind of file this is, so use it: if it flagged loose
groups, absolute positioning, or off-spec widths, widen the estimate before you give it.

**The ranges to give:**

- **The audit:** minutes, scaling with library size. It is read-only and creates nothing, so it
  is the quick phase.
- **Foundations:** a single pass, comparable in length to one module batch.
- **A first batch of about five modules:** expect tens of minutes, and longer than that on an
  unstructured source.
- **A full library of a hundred modules or more:** multiple sessions. That is exactly why this
  process is batched with a design review between batches rather than run as one long
  unattended pass.

### Report progress while it runs

Codex shows the user every tool call it makes, so they can already see WHAT is happening: the
`use_figma` writes, the curl to the worker, the screenshot exports. That is more raw activity than
a user of a quieter surface sees, and it makes one part of this contract lighter and the rest of it
heavier. The visible calls never say **how far through** the run is or **how much longer** it has
to go, and a scrolling wall of node writes reads as motion without progress. So the count, the
percentage, and the revised estimate carry the whole load here. Restating the operation carries
almost none: do not spend a line telling the user you are calling Figma, because they watched you
call it.

Post exactly one line at each of these points, and nowhere else.

**While the audit walks (Phase 1).** The audit creates nothing, so it earns three lines, not more:

1. **After the census** (end of Step 2): the counts you found. Pages, candidate frames, designs
   after desktop and mobile twins are merged, text and paint styles. **The design count is the
   denominator for every line after it**, so state it even when it looks obvious.
2. **Per design, as you walk them** (Step 4, pass 1): count, percentage, the design's name, and
   what it added to the inventory. Say a blocker at the design where you hit it rather than saving
   it for the report: a component library file you cannot see, a split you are inferring and need
   the designer to confirm, a type ramp that contradicts the width derivation.
3. **At the end** (Step 6): the shape of the report. Modules by verdict, the scale factor, and the
   one or two flags that decide the next step.

**While a conversion batch runs (Phases 2 and 3).** This is the long, quiet one, so it earns five:

1. **After the source census:** your read of the audit's Module inventory plus your first look at
   the source file. Modules in the inventory, modules in this batch, the designs they come from.
2. **Before the batch starts:** what IS in it by module name, what is NOT and why (deferred,
   blocked on an unconfirmed concession, out of scope), and the opening estimate.
3. **After each module completes:** count, percentage, module name, revised remaining time.
4. **The moment a step is retried or a decision goes to the user:** a `recache=1` re-run, an
   `X-Trivial-Response` retry, an unconfirmed concession, a scale factor nobody has confirmed. Say
   it then, not in the batch report. A failed call the user just watched scroll past does not tell
   them whether you are recovering or stuck.
5. **At the end:** what was built, what was skipped, and why.

How each line is written:

- **A count and a percentage, never prose.** "Module 3 of 7 done, 43 percent" is the format.
  "Making good progress" is not a checkpoint. The denominator is the batch size you listed at the
  before-the-batch line.
- **Name the thing you are on.** "Module 4 of 7: Global footer" lets the user find it in Figma, and
  in Phase 1 "Design 3 of 11: Welcome email" does the same in their own file. "Module 4 of 7" does
  not, and a layer name scrolling past inside a tool call is not something a user can follow.
- **Revise the estimate from observed pace, every time.** After module 1 you know the real
  per-module cost in this file, so recompute the remainder from it instead of repeating the opening
  guess. Revising upward is fine and expected: an unstructured source runs slower than the opening
  guess, and the honest larger number beats the tidy stale one. This is the one thing the visible
  tool calls can never supply, so it is the part to get right.
- **Do not narrate the operation the user is already watching.** "Calling the worker" and "writing
  the node" are lines Codex has printed already, in more detail than you would. Spend the line on
  the arithmetic instead. The exception is when the visible calls mislead rather than inform: a long
  wait with nothing on the canvas, or a burst of calls that looks like thrash and is really one
  repair, earns one plain-language clause. "Transcribing the footer, 43 nodes" is worth reading;
  "running use_figma" is not.
- **Module boundaries only, and in Phase 1 design boundaries only.** Never per node, per style, per
  call, or per screenshot. A fifty-node module gets one line when it finishes, not fifty, and an
  audit that narrates every text node it reads is worse than one that stays quiet. The transcript is
  already dense with calls, so prose in between costs more here than it would on a quieter surface.
- **Own an overrun the moment it is apparent.** If the run is tracking well past the estimate you
  gave, say so at that module boundary, with the new number. A user who was told twenty minutes and
  is at forty should hear it from you rather than work it out.

Two worked examples, the format to copy. A conversion module:

> Module 3 of 7 done, 43 percent: Global footer, 43 nodes transcribed. Modules are averaging 6
> minutes in this file against the 4 I estimated, so the remaining 4 are roughly 25 minutes,
> putting the batch near 45 minutes total against the 30 I opened with. Next: Module 4 of 7,
> Two column product row.

An audit design, which is shorter because there is no build to price:

> Design 3 of 11 walked, 27 percent: Welcome email, 4 blocks cut, 2 of them new, 9 modules in the
> inventory so far.

---

# Phase 1: Audit (read-only)

Audit an existing Figma design system for migration to Email Love, and produce a migration
report the customer and the Email Love team can act on. This is Phase 1 of a migration: it
tells everyone what they have, what converts, what needs design judgment, and how big the job
is. Phase 2 is the conversion, and this report is its input: **"Phases 2 and 3: Convert" below
runs it** in this same file, or Email Love's team runs it for the customer as part of Enterprise
onboarding. Step 7 is the hand-off, and it is part of the job, not an afterthought.

**This phase is strictly read-only.** Never create, modify, rename, or delete anything in the
customer's file. Every Figma call you make must be an inspection. If the user asks you to
start converting, that is Phase 2: it happens in a separate target file, driven by "Phases 2
and 3: Convert" below (Step 7 has the hand-off), and the source file stays read-only in that
phase too.

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
3. **Design census:** every candidate frame, with name, width, height, and component/frame
   type. Group desktop and mobile twins (the same design at two widths, commonly 600 and 390);
   in Email Love these merge into ONE frame with Mobile Styles overrides, so count designs,
   not frames.

Record the authored type sizes and the design widths verbatim, in the numbers the file actually
carries. Step 3 divides both, and it cannot do that from rounded or remembered figures.

## Step 3: Detect the scale factor

Not every source library is drawn at email scale. A file that was never meant to export as
email is often drawn at some multiple of it: a mockup enlarged for presentation, a web-first
canvas, a slide artboard. The factor decides every number in every converted module (widths,
type sizes, paddings, image dimensions), so getting it wrong makes the whole library uniformly
wrong, and nobody notices until a converted module sits next to a real email.

Compute BOTH derivations, always, and put both in the report:

1. **From the canvas width:** the source design width divided by the email width they intend
   (600 or 640). A 1089px design against 600 gives 1.815. If nobody has named a target width,
   derive against 600, Email Love's default, and say in the report that you assumed it.
2. **From the type ramp:** the authored type sizes divided by the standard email sizes they map
   onto. Divide the whole ramp, not one style, and look for a cluster: a 35px body over a 16px
   email body gives 2.19, a 26px caption over 12 gives 2.17, a 53px headline over 24 gives
   2.21. Three styles landing near 2.2 is a signal; one style is a coincidence. Sanity check
   the candidate by dividing the ramp back by it: if 2.2 turns the authored sizes into 16, 12,
   and 24, the factor is real.

If the two derivations agree within a few percent, say so, give the one number, and move on:
there is nothing to decide. When they disagree, and on an unstructured source they usually do,
the report carries the disagreement rather than hiding it:

- **State both derivations with their arithmetic and name the gap in percent.** An observed
  migration came out at 1.815 from the width and 2.2 from the type, a 21 percent gap, and 21
  percent is the difference between a converted module a designer accepts and one nobody can
  use.
- **Recommend one, with the reasoning.** Prefer the type ramp when the authored sizes divide
  cleanly into standard email sizes and the width ratio does not. In that observed migration
  the type sizes divided to exactly the standard sizes while the width ratio landed on an
  arbitrary 1.815, so the ramp was the trustworthy signal. The reason generalizes: a designer
  picks type sizes deliberately off a ramp, while a canvas width absorbs bleed, margins, and
  whatever artboard someone happened to start on, so the width carries noise the ramp does not.
- **Mark it a designer decision, in those words.** It is a recommendation until their designer
  confirms it, and because it changes every module it is the highest-leverage line in the
  report.

Two more things while you are in here: check that every design shares one factor (a single
design drawn at a different scale is a flag, not a second factor), and state the email width as
the TARGET width rather than the source canvas width. Conversion divides by the factor; it
never carries source pixels across.

Record the result in the report's **Scale factor** section (Step 6). Phase 2 reads that number
instead of deriving its own, which is the whole point of settling it here.

### The factor is ONE number, and the ramp table has to prove it

Recommending a factor is necessary and not sufficient. Phases 2 and 3 have to APPLY it,
uniformly, to every number they write: type sizes, line heights, widths, paddings, image
dimensions, spacer heights. The report is what makes that auditable, so it shows the arithmetic
per style rather than only the conclusion.

**Write the type ramp mapping as a four-column table, one row per style:**

| Style | Authored size | Factor | Email size |
| --- | --- | --- | --- |
| Headline | 65 | 2.2 | 30 |
| Subhead | 55 | 2.2 | 25 |
| Body | 35 | 2.2 | 16 |

The Factor column carries the SAME number on every row, and that is the reason for printing it at
all: a per-style factor cannot hide in a table that restates the factor on each line, because a
second number in that column is visible at a glance. Never write the table as authored size
straight to email size with the division left out, and never round a row toward a size that looks
like a nicer email number. Divide, round to the nearest whole pixel, write down what you get. Same
table, same discipline, for the spacing scale.

**Acceptance test, run on the table before the report ships: the source's ratios must survive.**
Divide the largest email size in the table by the smallest, divide the largest authored size by
the smallest, and compare the two. More than a couple of percent apart means a row has been
rounded off the factor: find that row and fix it, do not ship the table. Run the same check across
the spacing scale. Worked, from the migration this rule comes from: authored 65/35 = 1.86 against
email 30/16 = 1.88 passes, a 1 percent drift that is nothing but whole-pixel rounding. The module
that actually shipped came out with a 55 source headline at 30 and a 35 source body at 16, so 1.57
in the source against 1.88 built, a 20 percent failure. That is the defect this test exists to
catch, and it is worth catching here because downstream it presents as a padding problem rather
than a type problem, so nobody thinks to look at the ramp.

If a row's email size looks wrong, that is evidence the FACTOR is wrong, not licence to adjust the
row. Revisit the factor, re-divide the whole ramp, re-run the test.

## Step 4: Split the designs into modules, then classify every module

Email Love design systems are built from modules, not from whole designs. A module is one
reusable block that gets dropped into many emails: a hero, a copy block, a 2-up product row, a
footer. Phase 3 converts modules, one component per module, and batches them, so this step's job
is to hand it a deduplicated **Module inventory**, which is the name both phases use for this
artifact. A per-design verdict cannot do that job. On an observed migration, six finished emails
turned out to be the same nine modules in a different order each time: the six-row per-design
table said almost nothing, and the nine-row Module inventory said everything.

Three passes:

1. **Split each design into blocks.** Walk the tree (node types, auto-layout, text nodes, image
   fills, vectors, nested instances) and cut at the natural block boundaries: a full-width
   background change, a divider, a jump in vertical padding, a repeated row, a run of copy
   followed by an image. On an email-native source the components and auto-layout frames tell
   you where the cuts are. On an unstructured source (loose groups, absolute positioning, no
   components, no styles) you are inferring them, so say so in the report and ask the designer
   to confirm the split: the Module inventory is what gets built, so a wrong boundary is a wrong
   component. **Then write the boundary down on the row.** Whoever converts the module has to
   screenshot exactly the region you cut, and a boundary you found but did not record is a
   boundary they have to infer again, differently. So record a source ref per module: the design to
   convert from, plus the node name or node id you cut at, and on a source with no node to name (a
   loose group, an absolutely positioned run) the position within that design, for instance "top 0
   to 480" or "between the divider and the footer rule". One appearance is enough; it is the one
   that gets built.
2. **Deduplicate across designs.** The same block appearing in six designs is ONE module with
   six appearances, never six rows. Near-duplicates are one module plus a note when the
   difference is content, and two modules when the difference is structural (a different column
   count, an added region).
3. **Name each module the way it should appear in their library**, because the name carries
   straight through conversion into the component name ("Hero, text led", "Footer, legal +
   social"). Give each one a category from the sections their plugin already has (Pre-Header,
   Header, Heroes, Single Column, Two Column, Three Column, Four Column, Buttons, Reviews,
   Images, Lists, Order Tables, Footer) rather than one you invent.

   **Then order the categories deliberately, because they become PAGES.** Phase 2 builds one page
   per category in this inventory, in the order the inventory presents them, and it builds no
   others. So a category order that came out of whatever the walk happened to find first becomes
   an incidental page list in the customer's finished library, which is the shape problem the
   prescription in Phase 2 exists to remove. Do not leave it to the walk.

   **Order the categories the way modules appear in a typical email, top to bottom:** Pre-Header,
   Header, Heroes, Single Column, Two Column, Three Column, Four Column, Images, Reviews, Lists,
   Order Tables, Buttons, Footer. That is how someone building an email scans for the next block
   they need, so it is how the file should be ordered. Skip any category the inventory does not
   use, and add none it does not. Where a category genuinely has no settled place in that
   sequence, put it where the customer's own emails put it and say in the report that you did.

   **Group the inventory rows by category, in that order, and order the rows inside a category by
   reuse, highest first.** The category order is the load-bearing part, since it is what Phase 2
   reads; the within-category order is what makes the highest-reuse modules easy to find. The
   batch plan is read off Recommended next step, which names modules explicitly, so it does not
   depend on row order.

Then assign every module exactly one verdict:

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
  an editable image. Reserve it for blocks where copy and picture are one composited whole with no
  boundary to cut on: type set over a photographic collage where the lettering is part of the
  artwork. **An overlap or an edge bleed on its own is NOT a C**, it is an A with a concession:
  see the Two Column Swap below.
- **(D) Not emailable.** Interactive patterns (hover states, carousels, video embeds beyond a
  thumbnail link), viewport-relative layouts, or app UI that has no email equivalent. List
  what would replace them.

**A photo that overlaps or bleeds past its block is verdict A, not C.** This is the single most
common reason a module gets over-classified, and it is now a settled decision rather than a
per-module argument. Source designs routinely place a photograph so it overlaps or bleeds past
the block it belongs to: a product shot entering from the right behind body copy, an animal
cropped off by the left edge of a cream band with text beside it. In Figma that is z-order plus
absolute position, email has neither, and no MJML attribute gets close. **The standard remedy is
to rebuild the block as a two column row: one `mj-section`, two `mj-column`s, the image in one
and the text in the other, in the source's left to right order.** The image stops at its column
edge instead of bleeding, nothing overlaps, and the text stays live. Appendix R3.4.1 is the full
rule, including the two tells for recognizing it (the photo's bounds extend past the band's, or
the photo is clipped by a sibling drawn over it rather than by a mask), which you have to look
for on the nodes because the screenshot hides the overflow by construction.

So classify such a module **`A (concession: image bleed rebuilt as a two column row)`**, note in
the row that the overlap is what is lost, and price it as an A. Do not write it as a C: C reads
as a partial conversion and this is not one, the whole block converts as live text. Do not
propose flattening the block to an editable image either, which trades selectable text,
accessibility, and dark mode for one effect. What still earns a C is a block that genuinely needs
splitting, type set over a photographic collage where the lettering is part of the artwork, or
any treatment where copy and picture are one composited whole. The test: if you can name the
rectangle the image belongs in and the rectangle the text belongs in, it is the swap and it is an
A. If you cannot, it is a C.

**The concession field on A: required on every A row, and deliberately not a fifth verdict
letter.** A module can convert perfectly as live text except for one effect email cannot
reproduce at all: an overlapping or bleeding photograph, a full-bleed treatment that has to stop
at the content box, a blur, a blend mode, a shape email has no way to draw. That is not B
(nothing needs to become an image), not C
(there is no rich region to split off), and not D (it emails fine). Two modules on an observed
unstructured source were exactly this, and with nowhere to put it the finding got smuggled into
a C with a paragraph of explanation, which is how a decision a designer needed to make ends up
buried.

So record it on the verdict instead: write the verdict as **`A (concession: <the named
concession>)`** and spell the concession out in the row's notes, both what is lost and the
nearest email-safe substitute you propose. Every A row states either `none` or a named
concession, so a blank is a missing answer rather than an implied no. Every named concession
also gets its own line in Flags, for the designer to accept or reject before the module is
built.

**The one concession with a standard wording, because its substitute is already decided:** an
overlap or an edge bleed is written **`A (concession: image bleed rebuilt as a two column row)`**
and the substitute is appendix R3.4.1, not something you invent per module. Use that wording
verbatim so a reviewer can count these at a glance and Phase 3 knows exactly which rebuild to
apply. It still gets its Flags line, because a designer still has to accept losing the overlap.

**Why a field and not a letter:** the ladder answers how a module gets built, and these
get built exactly like any other A, same technique and same effort. What differs is a decision a
human has to accept. A fifth letter would fork the ladder, and every per-verdict count and
effort row with it, on something orthogonal to construction. B and C rows may carry a concession
too when one applies; on those the field is optional, because their verdict already carries an
explanation.

**A flag that constrains HOW a module gets built belongs on that module's row.** Flags is a prose
section a human reads once. The Module inventory is what Phase 3 works from, row by row, and a
converting agent that never opens Flags is the normal case rather than a careless one. So any
finding that changes the technique for a specific module has to be written where that module gets
built from: name it in the row's `build constraints` column and spell it out in the row's notes,
and only then also in Flags when a human has to decide about it. Observed failure: an audit
correctly flagged "images are clipped by z-order, not masks, so export rendered nodes rather than
raw fills" in Flags alone. The conversion exported raw fills, every cropped image came across as
the whole uncropped photograph, and the customer reported it as a spacing bug. The audit was right
and the hand-off still failed, which is a defect in where the finding was written, not in the
finding.

Findings that are build constraints rather than observations, and therefore belong on the row:
images that carry a crop transform or are clipped by overlapping siblings (the row says "render the
node, not the fill", which is R4.2.1), an image that overlaps or bleeds past its block (the row says
"two column row per R3.4.1" and which column the image goes in), an image that is inset rather than
full bleed and the percentage it is inset by, copy that has to stay outside an image for
accessibility, a font this module in particular leans on, a pinned width this module cannot keep,
spacing that has to come from one side only. Write each one short and imperative: one clause a
builder can act on without
reading anything else. A constraint that applies to the whole library belongs in Brand foundations
or Flags instead of being repeated on twenty rows.

Signals that push a module from A toward B or C: vector logos and illustrations (email wants
images), buttons built as nested app-style instances with state layers, stacked image fills,
gradients and blend modes on text, and effects email clients do not render. Signals of A:
clean vertical auto-layout, flat solid fills, one image per region, system-mappable text.

Do not over-classify toward images. Two MJML capabilities keep more modules live-text than
designers expect: **mj-hero** renders live text over a full background image, so "headline on
a photo" is verdict A when the text sits on one background image rather than woven through
layered art; and sections support background images behind live columns. Reserve B for
compositions where text and imagery genuinely interleave (text wrapping around cutouts,
badges over product shots, hand-placed collage). And the Two Column Swap above keeps a third
group live: an overlap or a bleed is a fixed rebuild, not a reason to reach for an image.

Finally, **roll the verdicts up per design**: for each design, the ordered list of module names
it is made of and the worst verdict present in it. The Per-design roll-up is a view of the Module
inventory, not a second classification, so it introduces no verdict that is not already on a
module row. It exists so a customer can still ask "what happens to this email" and get an answer,
and Phase 3 does not work from it.

## Step 5: Extract the brand foundations

From the survey, draft what the Email Love design system will carry:

- **Type ramp mapping:** each of their text styles mapped to an email-safe equivalent, using
  their own fallback choices when a fallbacks page exists. Flag fonts that need web-font
  hosting or substitution. When the Step 3 scale factor is not 1, use the four-column table Step
  3 specifies (style, authored size, factor, email size), with the factor restated on every row,
  so a reader can audit the arithmetic instead of trusting it. Run Step 3's ratio acceptance test
  on the finished table.
- **Palette:** their named paint styles, and a proposed set of the six Email Love theme
  colors (backgroundColor, contentColor, textColor, linkColor, buttonTextColor,
  buttonContentColor) drawn from it, marked as a proposal for their designer to confirm.
- **Spacing scale** from any padding/spacer components, stated at email scale (divided by the
  Step 3 factor) rather than at source scale.
- **Buttons:** their button styles as candidates for the Email Love button component page.
- **Target email width:** the width the converted system gets built at (600 or 640), which is
  the source design width divided by the Step 3 factor when the source is not at email scale.
  Label it as the target, and list anything in the file that contradicts it.

## Step 6: Write the migration report

Produce one markdown report, in this exact structure. **Scale factor and Module inventory are
required sections**: they are what Phases 2 and 3 consume, and a report missing either one
cannot be converted from.

# Migration audit: [Design system name]
## Summary
[Three sentences: what they have, how much converts cleanly, the one or two biggest items
needing design judgment. If the source is not at email scale, say so here; it is the finding
that changes the most work.]
## Inventory
[Pages, style counts, component counts, design count (with desktop/mobile pairs merged),
distinct module count, fonts in play.]
## Scale factor
[REQUIRED. Both derivations with their arithmetic, the gap between them in percent, the
recommended factor, the reasoning for choosing it, and "designer decision" in as many words.
State the target email width the factor is measured against. One factor for the library; note
any design that contradicts it. When the two derivations agree, say so and give the single
number.]
## Module inventory
[REQUIRED, deduplicated, and this is the section Phase 3 works from. One row per DISTINCT
module: module name | category | appears in (design names) | source ref | verdict A/B/C/D |
concession | build constraints | effort S/M/L | notes. The name is the name the converted
component will carry. **Source ref is REQUIRED on every row** and names the one appearance to
convert from, precisely enough to screenshot without re-deriving the split (Step 4): a design name
plus a node name or id, or, where there is no node to name, a position within that design ("top 0
to 480", "between the divider and the footer rule"). Every A row states either `none` or a named
concession in the concession column, with what is lost and the proposed substitute in the notes.
An overlap or an edge bleed uses the standard wording
`A (concession: image bleed rebuilt as a two column row)` verbatim, and is never a C.
**Build constraints is REQUIRED on every row and states either `none` or the short imperative
constraints from Step 4** (for example "render nodes, not raw fills: images clipped by z-order",
"two column row per R3.4.1, image left", or "image is inset 91 percent, not full bleed"), so that
nothing which changes how a module is built exists only in Flags. **Group the rows by category, in
the top-of-email-to-bottom order Step 4 specifies, and order the rows within a category by reuse,
highest first. The category order is load bearing:** Phase 2 creates one page per category in
exactly the order they appear here, so an incidental order in this table becomes an incidental page
list in the customer's library. The batch plan is read off Recommended next step, which names its
modules, rather than off row order.]
## Per-design roll-up
[One row per design: design name | width(s) | the module names it is made of, in order | worst
verdict present. A roll-up of the Module inventory, not a second classification: no verdict
appears here that is not already on a module row above.]
## Brand foundations
[Type ramp mapping table (style, authored size, factor, email size, one row per style with the
same factor on every row), proposed theme colors, spacing scale at email scale, button styles,
target email width. State that the ratio acceptance test passed, with the two ratios you
compared.]
## Flags
[Everything a human should look at: fonts unavailable for email, naming typos, empty pages,
inconsistent widths, accessibility risks from image-heavy modules, module boundaries you
inferred rather than read. Plus two that are decisions rather than observations: every named
concession from the Module inventory, for the designer to accept or reject, and the scale-factor
recommendation when the two derivations disagreed. Anything here that constrains how a specific
module gets built must ALSO appear in that module's build constraints column (Step 4): Flags is
where a human decides, the row is where a builder reads, and a build constraint that lives only
here will be missed.]
## Effort estimate
[Per-verdict counts over MODULES, not designs, and an S/M/L per module (the Module inventory
already carries the per-module value; total it here). A modules are mechanical; C modules need a
design pass; D modules need product decisions; a concession costs decision time, not build time.
State the total in designer-days as a range, and say plainly that estimates firm up after the
first converted batch.]
## Recommended next step
[The batch plan, naming modules by their Module inventory row names: foundations first, then
batch 1 of about five of the highest-reuse modules, then the later batches, with a design review
between batches. Then point at Step 7's two routes.]

Numbers in the report come from your actual reads, never estimates presented as counts. Where
you sampled instead of walking everything, say so.

## Step 7: Hand off to conversion

Deliver the report as a file the user can share internally. Then close the loop, because an
audit that ends without naming what happens next leaves the customer thinking the migration is
somebody's private process. There are two routes, and the report is the input to both:

1. **Self-serve, in this file.** "Phases 2 and 3: Convert" below runs Phase 2 from this report:
   foundations once, then modules in batches with a designer review between batches. It builds
   in a NEW target file and keeps this source file read-only. What it reads out of this report,
   by section name: the **Module inventory** (one module per row, one batch per group of rows,
   with the source refs, verdicts, concessions, build constraints, categories, and effort, and its
   category ORDER, which becomes the order of the component pages in the converted file), the
   **Scale factor** (every number it builds is at that scale), the **Brand foundations** (type
   ramp on email-safe fallbacks, proposed theme colors, spacing, buttons, target email width),
   and the **Flags**.
2. **Done for you.** Email Love's team runs the same process, design review included, as part
   of Enterprise onboarding: hello@emaillove.com.

Two things need a human "yes" before either route starts, and both are in Flags: the scale
factor, and each named concession. They change what gets built, so getting them agreed now is
cheaper than re-running a batch. If the audit surfaced a missing component library file, that
blocks conversion outright; say so rather than letting a batch start without it.

Offer to answer questions about any specific module's verdict, and to re-run the audit after
they clean up anything the flags surfaced.

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
- **The audit report is required input.** It carries the per-module classification (A/B/C/D plus
  any named concession), the scale factor, the brand foundations, and the flags. Do not re-derive
  what it already settled; do re-verify anything that looks wrong when you meet the actual nodes.

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
4. Which batch to run: "foundations", or a batch of modules named by their rows in the audit's
   **Module inventory** ("batch 1: the five modules the audit's Recommended next step lists
   first", or an explicit list of row names). An explicit list from the user wins over the
   audit's proposed batch.

Once you have those four, and **before the first write to the canvas**, tell the user what the
run covers and roughly how long to expect, per "How long this takes, and what to tell the user
first" above. Do this every batch, not just the first one, and adjust the estimate as the file
teaches you what it costs. That opening line is one of the five checkpoints in "Report progress
while it runs" in that same section, and it is the one that matters most to the rest: the batch's
module count becomes the denominator for every line after it.

### What you read out of the audit, by section name

The audit's sections map onto the phases below. Use the audit's own words for these artifacts so
the two halves of the migration stay one conversation:

- **Module inventory** (required in the report): the deduplicated module list. One row is one
  module, and a batch is a group of rows. It carries each module's name (which becomes the
  component name), category, the designs it appears in, the **source ref** (the one appearance you
  screenshot, so you never re-derive the split), verdict, concession, **build constraints**, and
  effort. Read the build constraints column before you convert a row: it is where a technique
  constraint for that module lives, "render nodes, not raw fills" (R4.2.1) above all, and a
  constraint you skip there resurfaces as a defect the customer reports. This is what Phase 3
  iterates over. **Its category ORDER is load bearing too:** Phase 2 creates one component page per
  category in exactly the order the inventory presents them, so read that order off the table
  rather than sorting the categories yourself. There is no per-design conversion pass: the report's
  Per-design roll-up is context for the customer, not a work list.
- **Scale factor** (required in the report): the number every geometry decision is divided by.
  Read it; never re-derive it (see Phase 2).
- **Brand foundations:** the type ramp on email-safe fallbacks, the proposed theme colors, the
  spacing scale, the button styles, and the target email width. Phase 2 builds from these, and it
  takes the ramp table's Email size column verbatim rather than mapping styles itself.
- **Flags:** the gates. Two of them block work rather than describe it: the scale factor when
  the audit's two derivations disagreed, and each named concession. Both need a human "yes"
  before the affected modules get built.

If the report has no Module inventory or no Scale factor, it predates this contract (see the
1.11.0 note under "Version and staying current"). Do not improvise a module list out of a
per-design table: re-run Phase 1, which is minutes of work and saves rebuilding a batch against
the wrong boundaries.

## Phase 2: Foundations (run once per customer)

**Everything you build, here and in Phase 3, is at email scale.** Take the factor from the
audit's Scale factor section and divide the source numbers by it: type sizes, widths, paddings,
image dimensions. Do not re-derive the factor from the file, even when the arithmetic looks
obvious to you: the audit computed both derivations, and where they disagreed a human chose
between them, so a fresh derivation here quietly overrules that decision. When the audit says the
factor is still a designer decision and nobody has confirmed it, get the yes before you build,
because the factor changes every module. State the factor you built at in the foundations report,
so batch 1 and every batch after it inherits one number. Appendix R0.6 has the same rule at the
geometry level.

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
   deliberately (Phase 1, Step 4).

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
   not. Two runs of this file on two customers must produce the same page doing the same job.

   - **Cover.** The first thing anyone opening the file sees, and it answers "what is this and
     what width is it" without anyone having to ask. Required: the customer's brand name set
     large; "Email Love Design System" beneath it; and a single metadata line carrying three
     facts, the design system's own version (`v1.0` on a first build, never this file's version
     number), the email width the system is built at, and the month and year
     (for example `v1.0 · 600px · July 2026`). **The width is required because it is the single
     most useful fact about an email design system:** it decides whether a module dropped in from
     anywhere else fits. Put the content on a full-bleed frame whose fill is bound to
     `color/bg/brand`, so the cover is on brand color and moves when the brand color moves. No
     module lives on this page.
   - **Getting Started.** How to use the library, in prose a designer or marketer new to the file
     can follow. Required, one short block each: that modules are wrapper components and are used
     by INSTANCING them, never by copying or detaching; that text and images are edited through
     the component properties on an instance rather than by editing inside it; that color, type,
     and spacing come from the tokens on Foundations and Type rather than from hand-typed values;
     and where to look when something does not export as expected (confirm the block is still an
     instance and not detached, confirm the copy was changed through its property rather than in
     place, then hello@emaillove.com). Name the email width and the scale factor here too, so the
     page stands alone.
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
     type bug (the single-factor rule: step 3 here, appendix R0.6). Run both checks every time:
     the arithmetic catches what the eye misses on a long ramp, and the eye catches what a passing
     ratio hides in the middle of one.
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
     14 up to 16 is a second scale factor wearing a friendly number.
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
3. **Type mapping. Build the ramp from the audit's table VERBATIM.** Recreate the customer's
   type ramp as Figma text styles in the target file using their email-safe fallback choices
   from the audit (never the unlicensed brand font unless the user confirms web-font hosting).
   Name styles as the customer named theirs. Take the Email size column of the audit's Brand
   foundations table exactly as written: every value in it is already the authored size divided
   by the one confirmed factor. Do not re-derive it, do not re-round it, and above all do not
   map a style toward a size that looks like a number email usually uses. A 65 the table says
   is 30 is 30; a 55 the table says is 25 is 25, even though 30 and 24 are the sizes you have
   seen in a hundred other emails. Mapping style by style toward pleasant numbers is exactly
   how a per-style factor gets back in after the audit removed it, and it is the defect this
   instruction exists to prevent. Appendix R0.6 carries the measured case: a module that came
   out with 1.83 on its headline and 2.19 on its body, from a ramp built one round number at a
   time, and it read as a padding bug.

   **Then run the ratio check, before anything gets built on top of these styles.** Divide the
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
   instance cannot be bound from the module that uses it (appendix R8).
5. **Spacing.** Recreate their spacer scale as components if they had one, at the email-scale
   values from the audit, taken verbatim like the type ramp: the same one factor, whole-pixel
   rounding only, never rounded onto a friendlier multiple of 8 because it reads better. Run the
   ratio check across the ends of the scale the same way.
6. **Assets.** Export the logo and any recurring imagery from the source file
   (`download_assets`) and upload into the target file (`upload_assets`). Logos become
   images, never vectors. Export the RENDERED node every time, never the raw image fill behind
   it: a source fill with `scaleMode: 'CROP'` loses its crop the moment you take the underlying
   asset, and you get the whole photograph instead of the picture the designer composed
   (appendix R4.2.1, which also has the aspect-ratio rule).
7. **Root EMAIL TEMPLATE frame** on Campaigns at the audit's target email width (600 or 640,
   never the source canvas width when the source was not at email scale): vertical
   auto-layout, width FIXED at that email width, height Hug, the shared marker, and the theme
   colors from the audit's proposal:
   `setSharedPluginData('emaillove', 'nodeType', 'mainFrame')` plus backgroundColor,
   contentColor, textColor, linkColor, buttonTextColor, buttonContentColor,
   lightThemeBackgroundColor, and fallBackFontName (appendix R2.1 has all nine and what each
   one is for). Empty theme keys are not neutral: the exporter substitutes dark defaults.
   **This is the only `mainFrame` foundations produces, and it is an email, not a module.**
   It exists so batch 1 has somewhere to drop modules and see them in context. The modules
   themselves are a different shape entirely (Phase 3, and appendix R2): each one is an
   `mj-wrapper` COMPONENT with **no** `mainFrame` marker and no theme keys. Do not copy this
   frame as a starting point for a module.
8. **Report** what was built, the scale factor and target email width you built at, the ratio
   check result with the two ratios you compared, the completion checklist result below, what the
   audit proposed that you changed, and what needs the designer's eye before batch 1 (theme
   colors especially: they are a proposal until a human confirms). If you changed a type size or
   a spacer away from the audit's table, that is not a foundations detail, it is a change to the
   factor: say so explicitly and say who agreed to it.

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
- [ ] **Getting Started:** instancing rather than copying, editing through component properties,
      styling from the tokens, and the "does not export as expected" path are all four present,
      plus the email width and the scale factor.
- [ ] **Foundations:** every swatch labeled with hex AND variable name, primitives and semantics
      visibly separated, the spacing scale rendered and labeled with token names and values, the
      radius token present. No hex anywhere on the page that no variable carries.
- [ ] **Type:** one specimen row per style, each with the style name, a sample line actually set
      in that style, and a caption naming family, weight, and size, ordered largest to smallest.
      Then look at it: does the ramp step evenly? A step that reads wrong beside its neighbors is
      a factor problem, not a style problem (step 3).
- [ ] **Buttons:** one component per audit button style, each labeled, each a styled frame with a
      single text node, the label's TEXT property on the component itself, no loose instances left
      on the page.
- [ ] **Campaigns:** exactly one root frame, `nodeType = 'mainFrame'`, at the target email width,
      with all nine theme keys set and not one of them empty.

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

Scale, checked last because it invalidates everything above it:

- [ ] The ratio check passed, with both ratios recorded (step 3).
- [ ] Every number on every page is at email scale: the root frame is 600 or 640, the type sizes
      are the audit's Email size column verbatim, the spacing values are the audit's.

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

**One module per row of the audit's Module inventory.** The batch is a group of those rows, and
each row already tells you the module's name (use it verbatim as the component name), its
category, the designs it appears in, its source ref, its verdict, its concession if any, its build
constraints, and its effort. Where a module appears in several designs, the source ref names the
one appearance to convert from, so convert it ONCE from there and note that design; the other
appearances are the same component placed again, not more work. When a row has no source ref, pick
the cleanest appearance yourself and record which one in the batch report, so a reviewer can tell
your boundary from the audit's. Build every number at the audit's scale factor, dividing source
pixels by it as you go (Phase 2 has the rule; appendix R0.6 has it at the geometry level).

Before building any module whose inventory row carries a concession, check the audit's Flags for
a human "yes" on it. If there is none, ask, and record the answer in the batch report. Building
first and asking later means rebuilding.

**A row's build constraints are instructions, not context.** Read them before the first node of
that module and state in the batch report how each one was satisfied. They exist because a correct
audit finding was once left in Flags alone and the conversion built straight past it. An older
audit may have no build-constraints column, so on those read Flags in full before the batch starts,
and treat anything phrased as "export rendered nodes, not raw fills", "re-crop", or "clipped by
z-order" as binding (appendix R4.2.1). Treat anything phrased as "image bleeds", "photo overlaps
the copy", "extends past the band", or "full-bleed image" the same way: that is the Two Column
Swap, appendix R3.4.1, and the module is an A that gets rebuilt as a two column row.

**An overlap or a bleed you find yourself is the same instruction.** An audit written before the
Two Column Swap existed may have filed one of these as a C, or as an A with a hand-written
substitute, or missed it because the screenshot hid it. When the nodes show the pattern, R3.4.1 is
what you build regardless of what the row says, and you record the verdict change and its reason
in the batch report per step 2. Do not improvise a different substitute and do not flatten the
block to an image because the row said C.

For each module in the batch, in order:

### 1. Convert the source design to MJML JSON via the design-converter worker

Do not rebuild by eye and do not run the plugin's Convert button for migration batches. The
pipeline is: screenshot the source module (read-only), POST it to the design-converter
worker, transcribe the returned MJML JSON into the target file, then verify.

1. **Screenshot the module** from the customer's file (read-only; `get_screenshot` or an
   export). On an email-native source that is a frame; on an unstructured source it is the
   region of a design that the Module inventory row describes, cropped at the boundaries the
   audit set. Keep the PNG; it is also your visual reference for verification.
   **Size the export so the PNG comes back at the target email width**, which means exporting a
   source at scale factor 2.2 at roughly 0.45x. The worker infers its numbers from the pixels
   you send it, so a PNG already at email scale returns email-scale widths, paddings, and type
   sizes, and the appendix rule that worker values are authoritative stays true as written. If
   you did send a source-scale PNG, its numbers are authoritative only at that scale: divide
   every one of them by the factor before it becomes geometry, and say in the batch report that
   you converted that way. You have a shell, so the reliable way to get the width right is to
   resize locally after the export rather than trusting an export scale:
   `sips --resampleWidth 600 module-01.png` on macOS, or
   `convert module-01.png -resize 600x module-01.png` where ImageMagick is available.
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
  save dialog, so use the module's Module inventory row name verbatim: the audit chose it to be
  the name in the customer's library, so renaming it here silently forks the two documents.
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
| A photo that overlaps or bleeds past the block it belongs to, with text beside it | one `mj-section` holding two `mj-column`s, image in one and text in the other | Email has no z-order and no absolute position, so the overlap cannot be reproduced. The Two Column Swap (R3.4.1) is the settled substitute, and it keeps the text live. Not an `mj-group`: this pattern wants the mobile stacking a group suppresses. |
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
  foundations; use flat gray fills at the correct dimensions everywhere else and list them. Any
  image you pull from the source now is a render of its node, never the raw fill (R4.2.1), and its
  height comes from the render's aspect ratio.
- **The worker cannot see an overlap, so it never returns the Two Column Swap.** It infers
  structure from a flat screenshot and email has no z-order to infer into, so a photo that
  bleeds past its block comes back either as a full-width `mj-image` above the copy or as the
  whole band flattened into one image. Neither is the answer. Rebuild it per R3.4.1, and note in
  the module's report line that you did.
- **Unpinned colors, radii, and fonts drift** between runs, and unpinned fonts flatten to
  Arial. Correct them against the foundations rather than accepting what came back.
- Map every text node to the type styles from foundations.
- Buttons: `mj-button-Frame` wrapping an instance of the foundations button component.
- **Honor the inventory row's verdict.** Verdict A: live text throughout. **Verdict
  `A (concession: ...)`: build it as live text like any other A and apply the named substitute,
  nothing more.** Do not quietly reproduce the effect the concession gave up, in an image or
  otherwise: that is the concession being un-made without the designer in the room, and it turns
  a module the audit priced as mechanical into a flattened picture. **For the one concession with
  a fixed substitute, `A (concession: image bleed rebuilt as a two column row)`, the substitute is
  appendix R3.4.1 and nothing else:** one section, two columns, image in one and text in the
  other in source order, both columns pinned to widths that sum to the section content box, the
  text column pinned first with R3.3.1 slack and the image column taking the remainder, the image
  a rendered crop of the source region at the render's natural aspect. Build it exactly that way
  rather than deriving your own answer, so two agents converting two batches produce the same
  thing. Verdict B regions: place the
  design content as a frame with NO recognized tag name inside a column; the exporter flattens it
  to a hosted image at export while it stays editable. Verdict C modules: live-text structure for
  the copy, one editable-image frame for the rich region. Changing a verdict when the nodes
  contradict the audit is allowed and sometimes right; record it and its reason in the batch
  report.
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

Then confirm its category for the upload. **The Module inventory row already proposes one**, so
start there and change it only when the rebuilt structure contradicts it, saying so in the batch
report. **Use the customer's real category names**, which are
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
- Concession honored, where the row carried one: on a module built with the Two Column Swap, both
  columns are FIXED and their widths plus the section's horizontal padding sum to the section
  content box, the text column's pin has slack, the `mj-image` rectangle is at the image column's
  content width with the crop's natural aspect for its height, there is no `mj-group` around the
  pair, and nothing in the block was flattened to an image (appendix R3.4.1). Confirm too that the
  overlap was not reproduced by some other means.
- Scale: the module root is at the audit's target email width, and its type sizes, paddings, and
  image dimensions are at email scale rather than source scale (appendix R0.6). A module built at
  source scale looks correct in isolation and wrong the moment it sits next to another module, so
  check it before the batch grows.
- Naming: every layer carries the display name for its tag, and no friendly string leaked into
  the plugin data `name` key.
- Component: the module root is a direct child of its category page, not inside a component
  set or a Figma section, with no stray instances of it left loose on the page. Every property
  binding re-read and confirmed.
- Visual: screenshot the rebuild next to the source screenshot from step 1; flag divergences
  rather than silently accepting them.
- Mobile: list the mobile keys you set per node.

### 6. Batch report and gate

One report per batch: per module, keyed by its Module inventory row name, what was rebuilt, the
design you converted it from, verdict honored or changed (with reason), any concession and whether
it was accepted and by whom (and for a bleed concession, the two column widths you landed on, so a
reviewer can check the sum), what the worker returned and what you repaired, mobile decisions,
divergences flagged, component properties added and the evidence for each, the category you kept
or changed. Open with the scale factor and target email width the batch was built at, so a
reviewer can check one number instead of measuring modules. End with the open questions for the
design review. Do not start the next batch until the user says the review happened.

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

In a conversion the worker JSON paddings are authoritative: transcribe them exactly, **at the
scale of the screenshot they came from (R0.6)**. The
ranges above are for gaps you have to invent. Four things that keep padding honest: pick a
base unit (8px) and use multiples of it; padding sits inside the box and eats content width
(two 50 percent columns with 20px each side lose 80px total); Outlook ignores values under
5px and handles even numbers more predictably; mobile padding is a separate override
(`mobileStylesPadding*`), not a reason to compromise the desktop value.

### R0.6 Every number here is at EMAIL scale, never source scale

Widths, type sizes, paddings, radii, and image dimensions in this appendix are email pixels: a
600 or 640 body, a 16px body copy, a 20px column padding. A source file that was never meant to
export as email is often drawn at a multiple of that, and the audit settles the factor once (its
**Scale factor** section, a number a designer confirmed) so every module in the library is built
against the same one.

The worker's numbers are at the scale of the screenshot it was sent, so the cheapest way to stay
honest is to send it a PNG already at the target email width; then "transcribe the worker
paddings exactly" (R0.5) and "build at email scale" are the same instruction. If the screenshot
went in at source scale, divide every returned number by the factor first.

So divide source measurements by that factor before they become geometry here, and never carry a
source pixel across untouched. A module built at source scale passes every other check in this
appendix: it hugs, it is tagged, it exports. It is simply two or three times too big, which shows
up as a body size no email uses and a root wider than the body, and it only becomes obvious next
to a module built correctly. If you find yourself deriving the factor from the file rather than
reading it from the audit, stop: a fresh derivation silently overrules the decision a human
already made between two disagreeing derivations.

**One factor, chosen once, applied to EVERY number.** Not type sizes only: line heights, widths,
paddings, image dimensions, spacer heights, radii, border widths. Uniformity is the entire point of
settling on a single number, and it is lost the moment any one value is arrived at some other way.
Rounding is allowed, but only to the nearest whole pixel, and only after the division. What is not
allowed is picking a converted value because it looks like a size email usually uses. That is a
second factor, invented for one style, wearing the costume of a sensible number.

**Then check the result against the source's own RATIOS.** Divide the largest converted type size
by the smallest and compare that to the same ratio in the source. Do it for the ends of the spacing
scale too. If the two ratios differ by more than a couple of percent, per-style rounding has crept
in, and the drift is somewhere between the number you divided and the number you wrote down.

**The failure this catches, measured in a real converted module.** The source was drawn above email
scale: headline 55, body 35. What got built at 600 wide: headline 30, body 16. That is two
different factors inside one module, 55/30 = 1.83 on the headline and 35/16 = 2.19 on the body, and
the consequence is that the source's own type relationship did not survive. The source
headline-to-body ratio is 55/35 = 1.57; the built one is 30/16 = 1.88. The headline is 20 percent
too large relative to the body.

The audit had done its job. It reported 1.815 from the canvas width and 2.2 from the type ramp,
named the 21 percent gap, and recommended 2.2. Foundations then built the ramp style by style
toward round email numbers, a 65 to 30, a 55 to 25, a 35 to 16, and per-style factors came back in
through that rounding, so the recommended factor was never actually applied to anything.

What makes it expensive is the symptom, because it does not present as a type problem. The module
reads as though its padding is wrong: a headline 20 percent oversized crowds the space around it,
so the reviewer goes hunting through padding values that are every one of them correct, and finds
nothing. The ratio check finds it in one division.

**A converted size that looks wrong is evidence against the FACTOR, not licence to adjust one
style.** If a 25px headline looks small, the reading is that 2.2 may be the wrong factor for this
library. Revisit the factor, put the whole ramp through the new one, and re-run the ratio check.
Never nudge the one style and leave the rest where they were. One style nudged is this bug; the
whole ramp moved together is a decision, and it is a decision that belongs back with the audit and
the designer who confirmed the factor.

### R0.7 DOUBLE PADDING: a gap belongs to ONE block, never to both

The space between two stacked blocks is one decision, made once, on one node. When the block
above already carries a `paddingBottom`, the block below must NOT add a `paddingTop` for the same
gap, and the reverse. Setting both is not "a little more room": the two values add, so a 40 below
the section above plus a 30 above the block below renders as 70, and the module reads as broken to
the designer who drew it.

**Failure signature**, in the order you notice it:

- The gap looks roughly twice what the design shows, while each of the two paddings that produced
  it is individually plausible. That plausibility is why this survives review.
- A leaf frame's height exceeds its content by exactly the padding you wrote, and the module's
  total height is over by the same number. An `mj-image-Frame` measuring 362 around a 332
  rectangle is a 30 that should not exist.
- Removing either value alone fixes the look. That is the proof there were two.

**Where to put it: on the preceding block's `paddingBottom`.** Prefer trailing space over leading
space so that each block owns the gap that follows it. Then a block switched off (`visible =
false`, or a BOOLEAN component property, R8) takes its spacing away with it, instead of leaving a
hole where lead-in space on the next block used to be paid for by a neighbor that is now gone.

This holds at every level, not just section to section: wrapper to section, section to column,
column to leaf pair. Before writing any padding, read what the sibling above it already carries.
The worker JSON paddings are authoritative and already complete (R0.5), so a padding you add on
top of them is almost always this bug.

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
email template, in Phase 2 step 7, so batch 1 has somewhere to drop modules and see them in
context.

**A module is not a small email.** An email template root *contains* wrapper components; a
module *is* one of those wrapper components. So a module has no wrapper inside it and no
`mainFrame` above it. If your module root is a `mainFrame` containing an `mj-wrapper`, you
have built a one-wrapper email and mislabeled it, and R2.3 explains why the plugin will
reject it.

R3 through R6 apply identically to both shapes. Only the root differs.

### R2.1 EMAIL TEMPLATE root (Phase 2 step 7 only)

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
- **A group is not the vehicle for the Two Column Swap** (R3.4.1, the standard rebuild for an
  overlapping or bleeding image). That pattern wants the mobile stacking a group suppresses, so
  it uses a plain `mj-section` holding two `mj-column`s. Reach for a group only when the design
  genuinely must stay side by side at 390px.

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

#### R3.4.1 THE TWO COLUMN SWAP: the standard rebuild for an overlapping or bleeding image

**The failure it replaces.** Source designs routinely place a photograph so it overlaps or
bleeds past the block it belongs to: a product shot entering from the right behind body copy, an
animal cropped off by the left edge of a cream band with text beside it. In Figma that is
z-order plus absolute position. Email has neither, so it cannot be reproduced, and no attribute
in this appendix gets close. **The standard remedy is to rebuild the block as a two column row:
one `mj-section`, two `mj-column`s, the image in one and the text in the other, in the same left
to right order the design implies.** The image stops at its column edge instead of bleeding, and
nothing overlaps. This is a settled decision rather than a per-module judgment call, so do not
re-argue it per module and do not go hunting for a cleverer reproduction of the overlap.

**How to recognize it, because nothing in the source labels it.** Two tells, either one of which
is enough:

- **The photo's bounds extend past the bounds of the block it reads as part of.** It is wider or
  taller than the band, or its absolute x/y put part of it outside the frame that appears to
  contain it. Compare the image node's absolute box against the band's box; do not judge it from
  the screenshot, where the overflow is invisible by construction.
- **The photo is clipped by a sibling drawn over it rather than by a mask.** A rectangle of
  background color sits above it in z-order and hides one edge. The layer panel shows no mask
  and no crop, and the composite you see exists in no single node.

On an unstructured source neither tell is written down anywhere, and the screenshot looks like an
ordinary photo in a band, which is why recognizing this is its own step rather than something you
notice in passing.

**The construction.** One `mj-section`, two `mj-column` children, image column and text column in
source order.

- Both columns FIXED (R0.3 case 2, R3.4). Their widths plus the section's horizontal padding must
  sum to the section content box: a 600 wide section with 20/20 padding takes columns summing to
  560. Unequal splits only survive because both numbers are pinned; the exporter derives the
  percentages from them.
- **Derive the widths in this order.** Pin the text column first, with the slack from R3.3.1,
  then give the image column the remainder, then size the image last. Worked: text hugs at 260
  and pins to 292, so the image column is 268.
- **The image is a rendered crop of the source region (R4.2.1), never the raw fill**, and it is
  cropped to its column rather than padded to fit, per R4.2.1's never-pad rule on aspect ratio.
  The `mj-image` rectangle is the image column's content width, and its height is the render's
  natural aspect at that width: continuing the example, a 780 x 660 render at 268 wide is 227
  tall, and 227 is the number.
- Heights HUG throughout (R0.1). Both alignment axes equal on the section and on each column
  (R3.4's axis alignment rule, the trap).
- Spacing on one side of each boundary only (R0.7). The gutter between the two columns is one
  column's horizontal padding, never both.
- **Not an `mj-group`.** A group exists to keep columns side by side on mobile (R3.3), which is
  the opposite of what this pattern wants.

**Mobile.** Two columns stack, so the image lands above the text, which is a normal email pattern
and arguably better than a bleed that would have had to be abandoned on a 390 wide screen anyway.
Stacking follows source order, so put the column you want first on mobile first. When the design
reads text then image on desktop but should read image then text on mobile, set `reverseStack` =
`'true'` on the section (R3.2) rather than reordering the columns.

**Why this is the default, so nobody relitigates it.** It keeps the text LIVE: the alternative,
flattening the whole block to one editable image, gives up selectable text, accessibility, and
dark mode for the sake of an effect. It degrades well, per the mobile note above. And the loss is
small and nameable, the overlap and nothing else, which is exactly what the concession field
records.

**What this does to the verdict.** A block whose only obstacle is an overlap or an edge bleed is
**verdict A**, carrying `A (concession: image bleed rebuilt as a two column row)`, and it is not
a C. Build it as live text like any other A, apply this substitute, and add nothing further. C
reads as a partial conversion, and this is not one.

**What stays verdict C.** Blocks that genuinely need splitting into live text plus an editable
image region: type set over a photographic collage where the lettering is part of the artwork, or
any treatment where copy and picture are one composited whole with no boundary to cut on. The
test: if you can name the rectangle the image belongs in and the rectangle the text belongs in,
it is this pattern and it is an A. If you cannot, it is a C.

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
- Fill: an IMAGE fill, `scaleMode: 'FILL'`, from an image that is already in the target file.
  `figma.createImageAsync(src)` is NOT available to you as an external agent, so a worker `src`
  URL is not something you can turn into a fill directly, and R4.2.1 has the route for anything
  coming from the customer's source file. The worker returns `"placeholder"` for every `src`
  anyway, so substitute the asset you round-tripped into the target file's foundations pages when
  one exists (logos especially); otherwise use one SOLID light gray fill (`#E8E8E8`). The
  exporter re-exports the node's own pixels, so a gray rect exports as a gray image, which is
  correct placeholder behavior.
- `cornerRadius` from `border-radius`.
- Shared plugin data ON THE RECTANGLE (not the wrapper): `href` from MJML `href` (omit when
  absent; never write `#`), `altText` from MJML `alt`.
- Sizing note: if the rectangle width is LESS than the column content width the exporter
  drops `fluid-on-mobile`; if equal it keeps it. So match the worker `width` exactly: a 560
  image in a 560 column stays fluid, a 134 logo does not.

### R4.2.1 Bringing an image across from the source file: RENDER the node, never the raw fill

An image in a source file is almost never the whole photograph the designer started from. Two
things routinely sit between the raw bytes and what you see on the canvas, and neither one travels
with the raw asset:

- **A crop transform.** An image fill with `scaleMode: 'CROP'` carries an `imageTransform` matrix:
  which part of the photograph is showing, and at what zoom. Export the raw fill and you get the
  full frame back with that transform discarded, including everything the designer cropped away.
  The symptom is dead space where the composition used to be tight: a subject that filled 56 to 59
  percent of a band now occupies 27 percent and floats small inside it, or sits half out of view.
  Nothing about the rectangle's geometry is wrong, which is exactly why this gets misdiagnosed and
  reported as a spacing bug.
- **Clipping by overlapping siblings.** Unstructured sources clip by z-order and not by masks: a
  shape, a band of background, or another image sits on top and hides part of the picture. What you
  see is a composite of several nodes, and those pixels exist in none of them on its own. Only a
  render captures it. This is also the second tell for the Two Column Swap (R3.4.1): if the sibling
  drawn over the photo is what stops it bleeding past its block, the block needs rebuilding as a
  two column row and this rule supplies the image inside it.

So, for every image you bring across: **render the node as it appears and use the render.** Never
the raw fill, never the asset behind `fills[0].imageHash`. If the audit's row for a module says its
images are clipped by z-order rather than by masks, or that they carry a crop, that is this rule in
its `build constraints` column and it is not optional.

The route, since `figma.createImageAsync` is unavailable to an agent:

1. `download_assets` on the NODE in the source file (`get_screenshot` on the node, or
   `node.exportAsync`, do the same job), at 2x, to a local PNG. Reading `fills[0].imageHash` and
   fetching that asset instead is the mistake, not the shortcut.
2. `upload_assets` to place that PNG onto the `mj-image` rectangle in the target file. The crop is
   baked into the pixels now, so the fill is a plain `scaleMode: 'FILL'` with an identity transform
   and there is no crop left to reproduce.
3. Verify against a screenshot of the SOURCE NODE, never against the source's raw asset.

**Aspect ratio: preserve the render's, never stretch to fit a chosen width.** Measure the ratio on
the rendered PNG and derive the height from the width you picked: `height = round(targetWidth *
renderH / renderW)`. A 995 x 550 render placed at 600 wide is 332 tall, and 332 is not a number to
round to something tidier. If a height was decided earlier and it disagrees with the render, the
render wins and you re-derive the height. Forcing a render into the wrong box is either a
`scaleMode: 'FILL'` quietly cropping it a second time or a visibly squashed photo.

**Width is a decision, so make it deliberately and state it.** A source image narrower than its
canvas (995 in a 1089 wide design, so about 91 percent) is inset by design, not full bleed. Either
reproduce the inset as horizontal padding on the `mj-image-Frame`, at email scale and snapped to
the spacing scale the foundations already use, or take it full bleed at the body width. Both are
defensible. Pick against the design system's own established patterns, and record which you chose
and why in the batch report so the next module makes the same call. What this must never be is an
accident of arithmetic.

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
A gap the block above already pays for is not yours to pay for again: R0.7.

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
component itself and let it surface through the instance, which is why Phase 2 step 4 puts it
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
    paddings equal the worker attrs. All of those numbers are at email scale, from the audit's
    confirmed scale factor, not source scale (R0.6): the root is 600 or 640, and body copy is a
    size email actually uses.
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
17. **No gap is paid for twice.** For every pair of stacked siblings, exactly one of them carries
    the padding that separates them, and it is the one above (R0.7). Any frame whose height
    exceeds its content by exactly a padding you wrote is this bug.
18. **Every image is a render of its source node, not a raw fill** (R4.2.1), so any crop or
    z-order clipping is baked into the pixels. Each rectangle's height is the render's aspect
    ratio at the width you chose, and the width itself was a recorded decision (full bleed or the
    source's inset), not an accident.
19. **Every overlap or edge bleed in the source became a two column row** (R3.4.1), never an
    improvised container and never a flattened image. Per swap: both columns FIXED and summing
    with the section padding to the section content box, the text column pinned with R3.3.1
    slack, the image column the remainder, the `mj-image` height the render's natural aspect at
    the image column's content width, no `mj-group`, and the gutter paid by one column only. The
    module's report line names the swap and states that the overlap is the whole of what was
    lost.
