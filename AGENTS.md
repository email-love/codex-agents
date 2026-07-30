# Email Love: building emails in Figma

## What this file is, and how to use it

This is a **configuration file for OpenAI Codex**, not a prompt and not a task. It teaches
Codex to build real, export-ready emails inside your Figma file: either from the Email Love
design system you already have, or from scratch when you do not have one yet. It is the Codex
port of the Email Love Figma Builder skill for Claude
(github.com/email-love/claude-skills).

**To use it:**

1. Save this file as `~/.codex/AGENTS.md` so it applies everywhere, or at the root of the
   project you use for email work. If you already have an AGENTS.md, paste this in as a
   section rather than replacing the file.
2. Complete the one-time setup below (the remote Figma MCP and a Figma token). Without it
   Codex can read this file but cannot touch your canvas.
3. Then just talk normally in Codex. You never mention this file again:
   *"Build a promo email in https://figma.com/design/... Spring sale, 20% off with code
   SPRING20, ends Sunday, one CTA to the pricing page."*

**Do not paste this file into a chat as a message or attachment.** Nothing will happen
except the agent asking what you want, because instructions only take effect when they are
installed as persistent context. It also has to be Codex (CLI, app, or IDE extension) with
the remote Figma MCP connected: ChatGPT chat does not have the Figma write tools this
workflow needs, and never will, so use Claude with the Email Love skill there instead.

**Agent reading this:** if this file reached you as an attachment or pasted message rather
than as installed instructions, say so and point the user to the three steps above before
doing anything else.

## If the ask is a migration, this is the wrong file

**This file is the builder port. It builds one email, or a sequence of them, and it is not the
migration instructions.** Migration is the other job, auditing a legacy Figma library and
converting it into an Email Love design system, and it ships as a separate file scoped to a
project directory. This is the copy people install globally at `~/.codex/AGENTS.md`, so **a
migration ask arrives here by default**: not because the user did anything wrong, but because the
globally installed instructions are the ones that answer, and everything below this line was
written for building emails one at a time.

Check for it before the brief and before any Figma call. The signals, in the user's own words
rather than in this file's vocabulary:

- convert, migrate, port, or rebuild **their existing** templates, library, or design system;
- **build a design system**, or make their brand reusable across all their emails;
- **foundations**, tokens, or a type ramp as the deliverable rather than as styling for one email;
- **modules**, or module names offered as a list of things to build;
- **a batch** of anything, or "start with the first five";
- **an audit report** handed over as input, or asked for as output.

Any of those and the answer is not a build. Say this much, in your own words:

> This is the Email Love builder port, and it builds one email at a time. Migrating an existing
> library is a different job with its own instructions: an audit that produces a module inventory,
> foundations built once, then modules in batches with a design review between them. Save the
> migration file into the folder you want the migration done in, and restart Codex from there:
>
> ```bash
> curl -o AGENTS.md https://raw.githubusercontent.com/email-love/codex-agents/main/migration/AGENTS.md
> ```
>
> It is project-scoped on purpose. A migration is a project you do once and email building is
> constant, which is why the global copy is the builder one you are talking to now, and why the
> migration file has to be fetched into the project rather than being here already.

Then stop and wait, and **do not improvise the migration while they fetch it.** Without that file
you have no audit, no module inventory, no batch definition and no review gate, so what you would
run is your own idea of a batch. Measured, that ends as foundations plus the first module of an
invented five, followed by a silent stop, which is worse than either file on its own. Offering to
"make a start on the first module" is the same failure with a friendlier sentence in front of it.

**What is NOT a migration, so this does not fire on ordinary work.** An email built by instancing a
design system the customer already has is Path A, and it stays yours no matter how large their
library is. Saving a few reusable components out of a build is B6, which says plainly that those
components are not a design system. Judge by the deliverable: one or more emails is yours, a
library is not.

## Version and staying current

These instructions are **version 2.9.0** (2026-07-29). They track the
`emaillove-figma-builder` Claude skill at 2.9.0, plus the render spec that skill loads by
reference, from the `emaillove-eds-converter` skill at 1.19.0, minus one of that spec's rules
that is not here yet, and plus the library structure that same skill prescribes. The one:

- its combined-raster asset rule (4.2.2), for recovering fused icon strips by slicing a render.

The appendix here is a copy of that render spec, so it can gain a rule without
the builder skill's own version moving: when that happens, only the patch number changes. When the
builder skill itself moves too, as it did for 2.6.0, the minor number moves with it.

Unlike a Claude plugin, this file does not update itself: you downloaded a copy. If you have
web access, check once per conversation (quietly, without narrating it) whether a newer
version exists by fetching
https://raw.githubusercontent.com/email-love/codex-agents/main/AGENTS.md and comparing the
version line above. If yours is older, tell the user once, before the first write to the
canvas, and give them the refresh command:

```bash
curl -o ~/.codex/AGENTS.md https://raw.githubusercontent.com/email-love/codex-agents/main/AGENTS.md
```

**There is no update mechanism, so that check is the whole of it.** Codex reads this file off the
disk when a session starts, and that is the end of the machinery: nothing negotiates a version,
nothing notices that a newer copy exists, and this file cannot change itself. A copy from six months
ago loads exactly as confidently as today's and reports its own stale version number with a straight
face. So the fetch and compare above is not belt and braces, it is the only thing between the user
and silently running last quarter's rules, and the `curl` is the only remedy. Three things follow:

- **Check early enough for it to matter.** A gap found at hand-off means the work was already done
  under the old rules. A gap found before the first write to the canvas costs one re-fetch.
- **Say it once, plainly, and leave the decision to the user.** "Your copy is 2.7.0, current is
  2.9.0, here is the command" is the whole message. It is not a reason to refuse to build.
- **A refresh lands in the NEXT session.** Overwriting the file does not reload the copy already in
  this one, so when you both agree the gap matters, say to restart Codex after the `curl` and build
  there, rather than carrying on and hoping. If it only comes up mid-build, finish the email first:
  the email is the unit of work either way.

The migration port is a separate file on a separate path, so it is a separate copy to keep current.
Updating one does nothing for the other.

**Version 2.0.0 was a rewrite, so anything built with a 1.x copy is worth re-checking.**
The 1.x instructions taught you to assemble `mj-section` / `mj-column` scaffolding by hand.
That is now the one thing this file forbids, because hand-built structure looks correct on
the canvas and silently drops content on export. Emails built from a 1.x copy can contain
buttons, badges, and whole sections that exported as flat images instead of live text.

**Version 2.3.1 added R3.3.1**, the slack rule for pinned columns that carry text. An email
built with an earlier copy can have a badge, label, or two-up row that looks correct on the
Figma canvas and wraps in the plugin Preview, so those rows are worth re-checking.

**Version 2.3.3 added R0.6**, the rule that every number in the appendix is at email scale. It
matters on Path B, where the design you convert can come from a source that was never drawn at
email size: an email built from one of those is uniformly two or three times too big, and it
passes every other check in the appendix while being unusable. B2 has the check to run before
you send anything to the worker.

**Version 2.3.4 added R0.7 and R4.2.1.** R0.7 is double padding: when the block above and the
block below both pay for the gap between them the two values add, so the gap renders at about
twice what the design shows while each padding on its own looks plausible. R4.2.1 is images from
a source design: render the node and use the render, never the raw fill, because a crop transform
and any clipping by overlapping siblings live outside the asset. Both bite on Path B, and both
pass every other check in the appendix, so an email built with an earlier copy is worth
re-measuring on two points: any leaf frame whose height exceeds its content by exactly one
padding, and any image that carries dead space where the composition used to be tight.

**Version 2.4.0 added R3.4.1, the Two Column Swap.** Source designs routinely place a photograph
so it overlaps or bleeds past the block it belongs to, which in Figma is z-order plus absolute
position and in email is nothing at all. The standard rebuild is now settled: one `mj-section`,
two `mj-column`s, image in one and text in the other, in source order. It replaces two worse
answers an earlier copy left open, improvising a container for the overlap and flattening the
whole block to an image, and the second of those costs live text, accessibility, and dark mode. On
Path B it matters twice, because the worker cannot see an overlap and never returns the swap
(B5), and because the tell lives on the source nodes rather than in the screenshot. In an email
built with an earlier copy, look for a band that came across as an image where the design had a
photo beside copy.

**Version 2.5.0 made the Path B scale factor ONE number and added the ratio check.** Earlier copies
told you to derive a factor and then said nothing about applying it, so the factor got used on some
numbers and each remaining value was rounded on its own toward a size email usually uses. Measured
on a real conversion: a source headline of 55 and body of 35, a ratio of 1.57, came out as 30 and
16, a ratio of 1.88, which is 1.83 on the headline against 2.19 on the body and a headline 20
percent too large for its body. The expensive part is that it presents as a padding problem, so a
reviewer audits paddings that are all correct and finds nothing. B2 now carries the one-factor rule
and the ratio check, and R0.6 has it at the geometry level. Worth running on emails already built
from a non-email-scale source: divide the largest type size by the smallest and compare it to the
same ratio in the source.

**Version 2.6.0 added the progress contract, and it is the first change here that is purely about
what you say rather than what you build.** Earlier copies told you to state an estimate before the
first write to the canvas and then said nothing about the minutes after it, so a build that was
working looked the same as one that had hung. "Report progress while it runs", under "How long a
build takes", fixes the checkpoints, the format (a count, a percentage, the section by name, two
counters for a sequence), the requirement to revise the estimate when the pace disagrees with it,
and the ceiling on frequency: section boundaries, never per node. Nothing built with an earlier copy
is wrong because of this, so there is nothing to re-check in emails already built.

**Version 2.7.0 taught this file the shape of an Email Love library, on both paths.** The migration
instructions now PRESCRIBE that shape rather than leaving it to the converting agent (a fixed page
frame of Cover, Getting Started, divider pages, Foundations, Type, Buttons, the component category
pages and Campaigns, with color and spacing as two-tier Figma variables and component fills bound to
the semantic tokens), which means a library you are handed increasingly has a structure worth
recognizing and respecting. On Path A, A1 now reads that structure, takes the email width off the
Cover and the conventions off Getting Started, binds anything you create outside an instance to the
semantic tokens the file already carries, and forbids renaming, reordering, or adding pages and
tokens mid-build; "Foundations you do not change" carries the same rule. On Path B, B6 draws the
line between saving a few reusable components, which is what a build can legitimately produce, and a
design system, which comes out of the migration route rather than being improvised while you build
one email. Nothing built with an earlier copy is wrong, though an email built into a customer's
library with a 2.6.x copy is worth a glance for a page or a style that got added along the way.

**Version 2.8.0 corrected R0.6 about the worker and added R0.8 plus a `query()` gotcha in R6.** The
correction first: earlier copies said the worker's numbers arrive at the scale of the screenshot you
sent, and they do not. It is scale-agnostic, classifying at a canonical email scale, so a 768px PNG
sent for a 600px target came back at `mj-body` 600 with round email values regardless of the input
pixels. Sending the screenshot at the email width and pinning `emailWidth` are still right, but as
the input the worker was tuned for rather than as arithmetic, so an email built on Path B with an
earlier copy is worth the R0.6 ratio check if its worker output was divided by a factor. R0.8 is new
and is the expensive one, and it is a Path A concern: `resize()` on a node nested inside a component
instance does nothing, silently, with no error and the value unchanged on read-back, so the remedy is
to FILL the descendant chain and resize the INSTANCE, and the habit is to read every geometry write
back. R6 now also warns that `query()` cannot match a layer name containing a space, which is every
friendly display name the appendix prescribes.

**Version 2.8.1 removed four places where the appendix contradicted itself.** No new rules, so
nothing built with 2.8.0 is wrong; these are the sentences that made a correct rule hard to follow.
R0.5 still said the worker's paddings arrive at the scale of the screenshot they came from, two
sections after R0.6 established that they do not. R0.8's remedy left the tree with a FILL chain and
a FIXED instance root, which R0.1 and checklist item 7 forbid, so it now ends by putting the sizing
back and reading it back. Checklist item 8 said buttons are HUG, which R0.4 contradicts on purpose
since a button's width is a mobile-behavior decision. And R3.4.1 told you to put the column you
wanted first on mobile first, in the same breath as telling you to use `reverseStack` rather than
reordering the columns.

**Version 2.9.0 added the geometry-fidelity question to Path B, and corrected R0.6 with it.** Earlier
copies assumed any design you were handed was authoritative about its own geometry, so B2 derived a
scale factor from every source and preserved its proportions. That is right for a past email of theirs
or a comp you wrote at the email width, and wrong for an old mockup at no particular width with no
styles and margins eyeballed one at a time: dividing those numbers reproduces guesses with more
precision than they were made with. B2 now judges first, from four signals (standard email width, real
text styles, auto layout, margins identical rather than similar), and on a design that fails them
there is **no factor at all**: build to email standards (600 body, 560 content width, body at 16 on a
conventional ramp, spacing in multiples of 8) and take only the brand, the copy, and the block order
from the source. R0.6 carries the same branch. Worth re-checking in emails already built from a
low-fidelity source: a 16px body inside 20px margins, both correctly divided out of a file where
neither had been chosen, is the measured shape of this going wrong.

## Setup the user must do once

- Connect the **remote** Figma MCP server (`https://mcp.figma.com/mcp`). The local/desktop
  server does not expose the write tools this workflow needs.

  ```bash
  codex mcp add figma --url https://mcp.figma.com/mcp
  codex mcp login figma
  ```

- Export a Figma personal access token before launching Codex:
  `export FIGMA_TOKEN=figd_...`, generated at Figma, Account Settings, Personal Access
  Tokens, with at least these scopes: Current user, File content, File metadata, Library
  content.
- Install the Email Love Figma plugin (latest version) in Figma. For Path A you also need a
  synced design system in the file. See
  help.emaillove.com/plugin/components/design-systems.
- **Approve the `use_figma` tool calls when Codex asks.** Every canvas write goes through
  that one tool, and a build fires dozens of them. This is the most common failure: if the
  calls are declined, or the session cannot prompt you, Codex reports that the Figma write
  tools "aren't connected" and builds nothing, even though the server is connected fine.
  Approve when prompted, or start Codex in an approval mode that does not stop on every MCP
  call. For fully unattended runs (`codex exec`), pass
  `--dangerously-bypass-approvals-and-sandbox`, since a non-interactive session auto-cancels
  every approval request.
- Optional but useful: the Email Love MCP servers, which let you read the customer's own
  components and Email Love's library of 500,000+ real brand emails. See
  help.emaillove.com/plugin/ai/email-inspiration-mcp.

## Before you start: check your tools

This workflow depends on `use_figma`, the general-purpose Figma write tool that executes
Plugin API code. Confirm it is in your Figma tool catalog before promising a build.
`get_metadata` and `get_screenshot` are also required.

If `use_figma` is missing, stop and tell the user plainly: their Figma MCP connection is
read-only, so you cannot build on the canvas. Two honest offers, in this order: write the
email plan (structure, copy, subject lines) instead, or, if they have no design system yet,
run the Path B conversion up to the point where they paste the render into Figma themselves
and hit Convert in the plugin (B3 explains that route). Do not fake a build by generating a
picture of an email.

Work incrementally. One `setCurrentPageAsync` per `use_figma` call, small batches of
operations, and a `get_metadata` or screenshot check after each structural step. A failed
200-operation call wastes far more than a failed 10-operation one.

## How long a build takes, and telling the user first

Building an email in Figma is **minutes, not seconds**, and a user expecting an instant result
reads a normal build as a hang. **Before the first write to the canvas, say in one line what
you are building and roughly how long to expect.** A short line at each section boundary after
that is the right rhythm: not silence, not a running commentary.

Almost all of that time is round trips to Figma, not model thinking. Every node you create or
read back is a tool call, so **the node count predicts the time far better than how
complicated the design looks**. A one-section reminder is quick; a multi-section email with a
hero, several content blocks, and a footer is meaningfully longer; a sequence multiplies by the
number of emails. Path A is the faster path, because instancing a finished component is a
handful of calls where transcribing the same block node by node is dozens.

The design-converter worker on Path B is not the slow part: it returns MJML JSON in a few
seconds to about half a minute per design. If the user comes away thinking the AI is what is
slow, they have the wrong picture. The AI is waiting on the canvas.

Give ranges, never promises, and keep the scale straight. One email is minutes. Converting a
whole design system is a different job: a batch of five design-system modules has been measured
at tens of minutes per pass, which is why library migration is a separate batched process with
design review between batches, covered by `migration/AGENTS.md` at
github.com/email-love/codex-agents.

### Report progress while it runs

Codex shows the user every tool call it makes, so they can already see WHAT is happening: the
`use_figma` writes, the curl to the design converter, the screenshot reads. That makes one part of
this contract lighter and the rest of it heavier. The visible calls never say **how far through**
the build is or **how much longer** it has to go, and a wall of node writes reads as motion without
progress. So the count, the percentage, and the section name carry the load. Telling the user you
are calling Figma does not: they watched you call it, in more detail than you would have given.

A build is minutes rather than tens of minutes, so the granularity is the **section**, not the
whole email and not the node. Post one line at each of these points and nowhere else:

1. **Before the first write to the canvas:** the path and why (you owe that line anyway), the
   section plan by name, and the estimate. **The section count you give here is the denominator for
   every line after it**, so name them: "Path A, 9 sections: preheader, logo header, hero, three
   product cards, testimonial, CTA, footer. Roughly 8 minutes."
2. **After each section lands:** count, percentage, section name.
3. **On Path B, when the design-converter call goes out** (B3): one line before it. Codex shows the
   curl leaving, but a 20 to 40 second wait with nothing appearing on the canvas is the one point in
   a build where a user reasonably concludes the run has hung, and the visible call says nothing
   about how long it should take. Say the same thing the moment you re-run with `recache=1` or retry
   an `X-Trivial-Response`, rather than mentioning it at hand-off: a failed call the user just
   watched does not tell them whether you are recovering or stuck.
4. **At the end:** what was built, what you assumed or had to ask about, and anything skipped.

How each line is written:

- **A count and a percentage, never prose.** "Section 4 of 9 done, 44 percent" is the format.
  "Almost there" is not a checkpoint.
- **Name the section.** "Section 4 of 9: testimonial" lets the user find it in Figma. "Section 4 of
  9" does not, and a layer name scrolling past inside a tool call is not something a user can
  follow.
- **Two counters for a sequence, not one.** "Email 2 of 4, section 3 of 7: hero" locates someone in
  a campaign. A single percentage of the whole sequence does not.
- **Revise the estimate when the pace disagrees with it.** Most builds are short enough that the
  opening number holds. But if sections are landing at double what you opened with, say so at the
  next section boundary with the new number instead of at the end, and revise upward without
  apology: Path B transcription in particular runs slower than it looks. This is the one thing the
  visible tool calls can never supply, so it is the part to get right.
- **Do not narrate the operation the user is already watching.** Spend the line on the arithmetic
  instead. The exception is when the visible calls mislead rather than inform: a silent wait, or a
  burst of calls that looks like thrash and is really one repair, earns one plain-language clause.
  "Transcribing the footer, 43 nodes" is worth reading; "running use_figma" is not.
- **Section boundaries only.** Never per node, per instance, per property, or per screenshot. A hero
  with thirty nodes gets one line when it is finished, not thirty. The transcript is already dense
  with calls, so prose in between costs more here than it would on a quieter surface.

Two lines, the format to copy. Path A, after a section:

> Section 4 of 9 done, 44 percent: testimonial, instanced and filled. Sections are averaging about
> 50 seconds, so the remaining 5 are roughly 4 minutes. Next: section 5 of 9, CTA.

Path B, before the worker:

> Sending the hero comp to the design converter now. It takes a few seconds to about half a minute,
> then transcribing what comes back is the longer part.

### Say when you STOP, too

Those four points cover a build that is still building. Nothing in them covers a build that has
stopped, and that asymmetry is worse than having neither half: **an agent that reports progress but
not its own stop is worse than one that does neither, because the user infers continuation from the
last progress line.** The visible tool calls make this worse rather than better. When you stop, the
calls stop too, and a user who has been watching a wall of `use_figma` writes scroll past reads the
quiet exactly the way he reads a long transcription: as work in progress. Silence is indistinguishable
from still working.

**Never stop silently.** If you stop, for any reason, say so in the SAME message as the last of the
work, not in a later reply and not only once the user asks. Four things, every time: what you
completed in the format of point 2 above so it reconciles with the lines before it, what remains by
section name, why you stopped, and the exact thing needed to resume, phrased so the user can send it
straight back. The reasons that qualify are a blocker, a decision only the user can make, a limit you
have hit, or reaching the end of a unit of work. Finishing the email is that last one, and point 4 is
how it gets announced.

**Do not stop between the sections of one email.** The email is the unit of work, so the section plan
you gave at point 1 is a plan to finish, not a menu to stop partway down. In a sequence the unit is
still the email: between emails is a defined boundary, mid-email is not, so finish the one you are in
before you stop, and report it with both counters. The exceptions are the two this file already names,
and both are a question put to the user at the section it belongs to rather than a build abandoned
quietly: A5, where no component fits and they are the one who knows, and "The one rule" below, where
neither path can produce the section at all. Announce either in the shape below rather than trailing
off. Library migration is the other shape of this, and it is not yours to improvise: batches and the
review between them live in
`migration/AGENTS.md`, and "If the ask is a migration, this is the wrong file" near the top is what
to do when one is asked of you here.

**If you wrote resumable state, name its path in that message.** Write one whenever the build is a
sequence or you expect it to cross a session boundary, beside the `/tmp/mjml.json` payload Path B
already has you save, and treat it as expected behaviour rather than extra credit. On a one-off email
the sections already on the canvas are most of the state, so name the frame instead. Either way the
user has to be told where it is. He watched the file get written scroll past inside a shell call,
which is not the same as knowing it exists or what it is for: state the user cannot see does not make
the build resumable, it only makes you feel that it is.

One worked example, the format to copy. It is one message, sent unprompted, not an answer to "are you
still working on it":

> Stopped, not still building. Email 2 of 4, 5 of 7 sections done, 71 percent: preheader, logo header,
> hero, two product cards, all in the `Email 2 - Winback` frame. Remaining in this email: countdown
> banner and footer. Why I stopped: no component in the design system covers a countdown banner and
> the converter flattens it to a single image, so neither path can produce it and I am not
> hand-building the structure. To resume, point me at a component to use, or say "place it as a static
> image with a fallback line", and I will finish from the saved state at `/tmp/build-state.json`.

---

# The one rule: you do not hand-author structure

**Never assemble `mj-section` / `mj-column` / leaf scaffolding from your own mental model of
how an email should be built.** Every structural bug in this pipeline has the same origin: an
agent that was right about the containers and wrong about the content, because the plugin
keeps its real conventions in **private plugin data that you cannot read**. A frame you build
by eye looks correct from the outside and silently drops content on export.

Structure comes from exactly two places, and nowhere else:

- **Path A: instance published components from the customer's Email Love design system.** The
  components already contain the correct `mj-*` structure internally. You place, fill, and
  write copy. You do not open them up.
- **Path B: generate the structure with the design-converter worker (the engine behind AI
  Import), then transcribe the returned MJML JSON per the render spec** (the appendix at the
  end of this file). This is the path for a customer with no design system yet.

If neither path can produce a section, stop and ask. "No component fits so I will build it
myself" is the single failure mode this file exists to prevent.

The only frame you ever create from nothing is the **root** (see "Root frame"), and it is an
empty container: everything inside it arrives by instancing or by transcription.

## Decide the path by checking, not assuming

1. If the Email Love MCP is connected, call `list_brands`, then `list_components` for the
   relevant brand, then `list_templates` (tool names may be prefixed `emaillove_`). A brand
   new account commonly returns a single `Default` brand with **zero** components and **zero**
   templates. An empty list is a real answer: it means Path B.
2. Otherwise look in the Figma file: library pages holding COMPONENT / COMPONENT_SET nodes,
   and existing email frames carrying the plugin's root marker.
3. Components exist, in the plugin or in the file: **Path A**. Nothing exists: **Path B**.
   A partial library (a few components, nothing for the section you need): Path A for what
   fits, Path B for the gap, and say so.

Tell the user which path you are on and why, in one line, before you build.

## Step 1: The brief (adaptive interview)

Collect the essentials before touching the canvas. If the user's message already answers a
question, do not re-ask it. Ask what is missing from these four, in one batch:

1. **What email or emails?** One-off promo, announcement, newsletter, or a sequence (welcome,
   onboarding, winback). If a sequence, how many emails and what does each one do?
2. **The goal and the one CTA.** What should the reader do? One primary call to action per
   email produces measurably better emails than several competing buttons, so push for one.
3. **Key content.** The offer, dates, product names, proof points, links to source material.
   Actual facts, not vibes.
4. **The Figma file link**, if not already shared.

**Make answering feel like a short survey, not an essay assignment.** Codex runs in a
terminal with no interactive question widget, so give every choice-shaped question lettered
options and keep the free-text items (file link, key content) as plain asks, so the user can
answer everything in one short line.

Go deeper only when it earns its keep: vague answers ("make it good") need one example email
they like or the landing page the email supports; a sequence needs timing per email and how
the story escalates; a multi-brand file needs to know which brand; a lifecycle email needs to
know what the recipient just did (signed up, purchased, went quiet), which drives tone far
more than brand adjectives do.

Two rounds of questions maximum, then build with sensible assumptions and say what you
assumed.

## Step 2: Inspiration (shapes the brief, never the build)

Email Love's Inspiration MCP exposes a curated library of 500,000+ real marketing emails.
Look for tools named like `search_emails`, `fetch_email`, `get_brand_insights`,
`list_journeys`, and in environments where connector tools load on demand, actively search
for them before concluding they are absent. Use them when the user names a brand to draw
from, when the brief is thin on direction, or when you are building a sequence and want to
see how real brands pace the same flow (`list_journeys` / `get_journey` return actual
lifecycle sequences by type).

Mine those emails for **structure rhythm** (how many sections a real welcome runs, where
proof sits relative to the CTA), subject line patterns, offer framing, and tone. Tell the
user which emails informed your choices.

Three hard rules:

- Inspiration informs the **brief**. The build still comes from Path A or Path B.
- Never copy another brand's copy verbatim. Adapt the pattern, write original words.
- **Never send a library email's preview image to the design-converter worker.** It is
  mechanically easy and it is wrong: the converter is a transcriber, not an abstracter, so
  what comes back is that brand's email with the pictures removed, headline, benefit lines,
  footer disclosure and postal address included. Path B input must be the customer's own
  material or a comp you designed for them.

If the inspiration tools are not connected and the user explicitly asked for brand
inspiration, say so up front, link the setup guide
(help.emaillove.com/plugin/ai/email-inspiration-mcp), and offer to wait or proceed on general
best practice. If they did not ask, continue and mention it once at hand-off.

---

# PATH A: the customer has an Email Love design system

Instance-only discipline. The components are the ground truth; your job is selection, copy,
and imagery.

## A1: Inventory the library properly

A shallow inventory produces every email as a re-skin of one existing campaign. A real one
produces emails whose sections fit their content.

1. **Enumerate the components.** From `list_components` if the Email Love MCP is connected
   (it returns them grouped by the customer's own categories, which are the names you should
   reuse everywhere), otherwise by listing every page in the file and searching each for
   COMPONENT and COMPONENT_SET nodes, one call per page. Email Love design systems usually
   keep the library on dedicated pages (Heroes, Cards, Lists, Copy Blocks, Data, Footer)
   separate from the campaigns page.
2. **Read the file's structure, and leave it as you found it.** A library built through Email
   Love's migration route carries a prescribed page frame, and recognizing it saves you a lot of
   searching:

   ```
   Cover
   Getting Started
   --- Foundations
   Foundations
   Type
   Buttons
   --- Components
   one page per component category, in the customer's own category names
   --- Templates
   Campaigns
   ```

   The `---` pages are dividers standing in for the page folders Figma does not have, so they are
   empty on purpose. A file shaped like that is telling you where everything lives: the color and
   spacing tokens on Foundations, the type ramp on Type, the button components on Buttons, the
   modules on the category pages, and finished emails on Campaigns beside the existing ones, which
   is where this build belongs. **Read Cover and Getting Started when they exist.** Cover states
   the email width the system is built at, and that is the width your root frame has to match.
   Getting Started states the file's own conventions, which outrank any habit of yours.

   **Respect the structure you find rather than imposing one.** Do not rename a page, do not
   reorder the page list, do not add a Cover or a divider that is not there, and do not open a new
   page for this build when the file already has the page this work belongs on. Plenty of libraries
   look nothing like the frame above, because they were built by hand or built before it existed.
   That is not a defect for you to fix mid-build: reshaping someone's library while they asked for
   one email is a change they did not ask for. Say in one line what shape you found, put your work
   where that shape puts it, and if the file genuinely has nowhere for a finished email, ask before
   creating a page.
3. **Use the tokens the file already has.** Where the library carries Figma variables, a semantic
   set (names like `color/bg/page`, `color/text/primary`, `spacing/md`) usually sits on top of a
   primitive set named by value. For anything you create outside an instance, the root frame fill
   above all, bind to the SEMANTIC variable rather than typing a hex: that is how the file was
   built, and it is what keeps a later brand-color change to one edit. Never repoint or rename a
   token, and never bind to a primitive directly. Instances are already bound, so leave them
   alone. Two things a variable cannot reach: the root frame's eight theme keys, which are shared
   plugin data strings and carry literal hex (R2.1), and `fontSize` or `lineHeight`, which are not
   bindable, so type comes from the file's text styles instead. Where there are no variables, take
   the values from the palette as usual.
4. **Study 2 or 3 of their past emails.** Screenshot and read the frames the user named as
   their best, or the most recent. Learn voice, copy length, section rhythm, imagery habits,
   and footer conventions, including whether the footer uses an `mj-raw` token block. These
   are also your donor candidates for the root frame.
5. **Report the palette** to the user in one compact list.

## A2: Ask who picks the components

Every build, unless the Step 1 questions already answered it or the brief already dictates
the exact sections (then confirm that list in one line). If they defer, pick by content fit
and say what you chose and why.

Codex runs in a terminal, so the strongest picker available to you is the canvas itself:

- **Pick in Figma (preferred here).** Lay out a temporary top-level frame named
  "Component menu, delete me" beside the build area, containing labeled instances of the 3 or
  4 candidates for the current section. Ask the user to click their choice in Figma and say
  "picked". Read `figma.currentPage.selection`, confirm what you saw by name, and move to the
  next section. Delete the menu frame when the picking is done. The user judges components at
  full size and never squints at a thumbnail.
- **Numbered list fallback.** If the user would rather not switch to Figma, list candidates
  per section with a one-line note on fit and your recommendation tagged, and let them answer
  with numbers. You can also save `get_screenshot` output to local files and tell the user
  the paths so they can open them.

Compose with a clear split: past emails teach voice and polish, the palette plus the content
decides structure. Statistics want a stats card, steps want a list component, social proof
wants a testimonial card, a single announcement wants a hero plus copy block. If your section
stack is identical to an existing campaign's, you matched the donor rather than the content.

## A3: Root frame from a donor, then vet what you inherited

**Duplicate an existing Email Love email frame.** That gives you a root carrying every plugin
setting (marker, theme colors, subject and preheader slots). The donor's value is its root
settings, not its body:

- Keep inherited sections only if they are component instances (or a raw footer block).
- **A hand-built section inside the donor** (a plain frame that is not an instance) is
  invisible to the exporter and must be replaced with a library instance or removed. This is
  the most common way an inherited email silently loses content.
- Delete inherited sections you do not need and instantiate fresh ones from the palette.

If no donor exists in the file, build the root per "Root frame" in the shared section below
and append the instances straight into it, in order. Never wrap an instance in a frame of
your own: an untagged frame between the root and an instance flattens everything below it
into one image.

## A4: Assemble by instancing

The complete list of edits you may make to an instance:

- **Text content.** Load the node's current fonts, await, then mutate. Read the fonts off the
  node rather than assuming. Skipping the font load is the most common build failure.
- **Image fills** on the component's image blocks, at their existing dimensions, 2x
  resolution, watching crop and focal point. The plugin picks up image fills at export and
  handles hosting. If a geometry write inside the instance is ever unavoidable (an image band
  whose height has to match a photo's aspect), R0.8 is the rule you need: `resize()` on a node
  nested inside an instance silently does nothing, no error and the value unchanged on
  read-back, so FILL the descendant chain and resize the INSTANCE, and read every geometry
  write back.
- **Component properties**: toggle booleans to hide optional regions, swap instance-swap
  slots, set text properties. Because the plugin exports what is visible, a boolean that
  hides a region genuinely removes it from the sent email.
- **Plugin data**: `href`, `altText`, mobile style keys, per the shared section below.

Everything else is forbidden: **never detach**, never add, delete, or reparent layers inside
an instance, never retag anything inside it, never change its internal auto-layout, never
apply a fill to a structural frame inside it. Detaching severs the structure the exporter
reads, and restructuring internals reintroduces exactly the hand-authoring this file forbids.

**Naming inside an instance is not your problem, so leave it alone.** A component the plugin
built carries the plugin's own naming on every node, the MJML tag in plugin data and the
friendly display name on the layer, and an instance surfaces the main component's plugin
data. Do not rename layers inside an instance to "clarify" them, and do not write plugin data
onto instance internals. The naming rules in the appendix (R6) are for nodes you create, and
on Path A the only node you create is the root. If a component's internals look wrong, that
is a design-system fix in the source component, not something to patch per instance.

Also: **one visible CTA button per email** unless the user asks otherwise (hide competing
buttons via component properties); **leave final CTA URLs to the plugin** unless the user
gave you real URLs; **placeholder missing imagery** as flat gray fills at the existing
dimensions and say so in the report; **lay multiple emails side by side**, each in its own
frame, so the team can review a sequence at a glance.

## A5: When no component fits, stop

In order:

1. Reconsider. Most "no component fits" moments are a copy problem, not a component problem.
   Fit the content to the closest component and check with the user.
2. Ask the user directly, showing what you have and what the section needs. They often know a
   component you did not find, on a page you did not check.
3. Only if they confirm nothing exists: build that one section through **Path B** (generate
   and transcribe, not freehand), then offer to save it into their design system so it exists
   next time (see B6). A gap-fill section is a design-system asset by definition, which means
   it is a **module**, not a tiny email: build it as an `mj-wrapper` COMPONENT with **no**
   `nodeType = 'mainFrame'` marker, friendly layer names inside, the module name on the
   component itself, and properties for the parts that will change (appendix R2.2). It should
   be indistinguishable from the components around it.

Never assemble the section by hand, and never flatten it to an image to make the problem go
away. An image in place of a section is a decision for the customer to make, not for you.

---

# PATH B: the customer has no design system yet

The new-customer path. Structure comes from the design-converter worker; styling comes from
the brand foundations and is applied on top. Say plainly at the start that you are generating
a first email and that it doubles as the first piece of their design system.

## B1: A short brand interview

Four questions, one batch, on top of the Step 1 brief:

1. **Brand basics:** logo file, primary and secondary colors as hex, and the brand fonts. Ask
   for an email-safe fallback for any font that is not web-safe (Arial, Georgia, Helvetica,
   Times, Verdana, Tahoma, Trebuchet, Courier). Never invent a substitution silently.
2. **Email width:** 600 or 640. Everything downstream is measured against this.
3. **Footer requirements:** postal address, unsubscribe mechanism, and whether their ESP
   injects the footer with a merge token (see "The footer token block" below).
4. **Do they have anything to start from?** This is the important one, and it decides B2.

## B2: Where the design comes from, best first

- **Their own past email.** The strongest input: real brand colors, real type, real logo, no
  clone risk. Accept an HTML file from their ESP, an `.eml`, or a screenshot. If they give
  HTML, render it headlessly to PNG at the email width. If they give a screenshot, use it as
  is.
- **Their own non-Email-Love Figma design.** Screenshot the frame via the Figma MCP
  (`get_screenshot`) and convert that. Their file stays read-only.
- **A comp you design for them.** When they have nothing. Write the layout as a single HTML
  file at the email width using their real colors, fonts, and copy, render it headless at 2x,
  and convert that render. Let the Step 2 inspiration decide the section order and pacing;
  let the brand interview decide every color and typeface.

**First judge whether the design you were handed is AUTHORITATIVE about geometry, because only then
are its proportions worth preserving.** This is the short version of a question the migration audit
asks in full, and Path B meets it every time somebody hands over a Figma frame. Their own past email,
or a comp you wrote at the email width, is authoritative by construction: it was made to send. An old
mockup drawn to present usually is not. Four cheap signals answer it: is the design at a standard
email width, does it use real text styles rather than sizes typed per layer, is it built with auto
layout rather than absolute positioning, and are its equivalent margins identical rather than merely
similar.

- **Mostly yes: the geometry is a specification.** Derive the scale factor as below, carry the
  source's margins, ramp, and spacing across, and tell the user what you preserved. Convert its
  side margin ONCE, through the target email width, and use that one content width in every
  section (R0.3.1), because the worker returns a side margin per screenshot and three of those in
  one email is a text edge that moves as the reader scrolls.
- **Mostly no: take the brand and build to email standards.** What you keep is the palette, the
  typefaces, the logo, the copy, and the order the blocks come in. **Do not derive a scale factor at
  all**, and do not preserve a source proportion: build a 600 wide email with body copy at 16 on a
  conventional ramp (12, 14, 16, 20, 24 to 30), spacing in multiples of 8, and one content width for
  every section, normally 560 with 20/20 padding. Scaling the screenshot to 600 before you send it is
  still right, but that is framing one PNG rather than a factor entering the email. Say so to the user
  in a sentence, because it is good news rather than a compromise: a margin nobody chose carries no
  decision, and dividing it faithfully reproduces a guess more precisely than it was made.

**The rest of this section is for a design you judged authoritative.**

**Check that the source is at email scale before you convert it.** A past email or a comp you
wrote yourself is at email width by construction. A Figma design drawn for presentation, or a
web-first canvas, is often some multiple of it, which means every size authored in it (a 35px body,
a 53px headline) carries that multiple, and anything you read off it or hand the worker in
`promptInputs` carries it too until you divide it out. Two cheap
derivations catch it: the frame width divided by the email width from B1, and the authored type
sizes divided by the sizes email actually uses (a 35px body over 16, a 53px headline over 24).
Land near 1 and the source is at email scale. Land near some other number and that number is your
scale factor. When the two derivations disagree by more than a few percent, trust the type ramp: a
designer picks type sizes deliberately off a ramp, while a canvas width absorbs bleed, margins,
and whatever artboard someone happened to start on. Then do two things: scale the screenshot down
to the email width before you send it, because that is the input the worker was tuned for rather
than a lever on its output (it classifies at a canonical email scale and returns email numbers
whatever resolution you send, so do not expect its payload to carry the factor either way: R0.6),
and pin `emailWidth` in `promptInputs` (B3), which is the setting that actually fixes the body
width. Tell the user the factor you derived; it is a judgment they may want to correct.

**A factor you derive here is ONE number, applied to EVERY quantity it governs.** Whether you scale
the screenshot before sending it or divide a source measurement you carry across by hand, the same
factor governs type
sizes, line heights, the spacing scale, paddings, and spacer heights. Rounding is allowed, to
the nearest whole pixel, after the division. Choosing a converted value because it looks like a
size email usually uses is not rounding; it is a second factor invented for one element.

**Widths are the exception, and R0.6's TWO FACTOR TENSION is why.** Divide the source width by the
target email width and compare that ratio to the type factor you just derived. They agree only when
the source was drawn at an exact multiple of the email width, so usually they do not: a 1092 wide
source at a 600px body is 1.82 across the width against a 2.2 type factor. When they differ by more
than a couple of percent, say so to the user and name the split rather than picking one: the type
factor governs type sizes, line heights, and the spacing scale, and the target email width governs
the body width and everything measured across it (content width, column splits, image widths).

**Check it against the source's own ratios.** Divide the largest type size you ended up with by the
smallest, do the same in the source, and compare. More than a couple of percent apart means
something got rounded toward a pleasant number instead of divided. The failure looks like this,
measured on a real conversion: a source headline of 55 and body of 35, a ratio of 1.57, came out as
30 and 16, a ratio of 1.88, so 1.83 on the headline and 2.19 on the body. The email read as though
its padding were wrong even though every padding value was correct, which is why this is worth a
deliberate check rather than a glance. If a converted size looks wrong, the factor is the suspect
and not the style: re-derive the factor, re-divide everything, re-run the check.

Rendering, whichever HTML you start from. Codex has a shell, so do it locally:

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless=new --disable-gpu \
  --screenshot=/tmp/render.png \
  --window-size=600,4000 \
  --force-device-scale-factor=2 \
  file:///tmp/comp.html
```

Use the customer's email width for the first `--window-size` number and a height tall enough
for the whole email, then **trim any trailing blank space before sending**. A screenshot
padded with empty page invites the worker to invent spacers. On Linux substitute
`google-chrome` or `chromium`.

Never convert a competitor's email or an Email Love library preview. Same clone problem, and
the customer has no design system to restyle it into, so a clone stays a clone.

## B3: Send it to the design-converter worker

POST to `https://design-converter.andy-30d.workers.dev`:

- **Headers:** `Content-Type: application/json`, `Authorization: Bearer` with an **empty**
  token, and `X-Auth-Provider: gumroad`. That combination is an anonymous Free user, which is
  allowed; no license key is needed.
- **Body:** `{ "screenshot": "<raw base64, no data: prefix>", "screenshotMime": "image/png" }`.
  **Set the mime correctly.** It defaults to PNG and is passed straight through, so a JPEG
  declared as PNG is a silent quality loss.
- **`promptInputs` (optional, and worth it whenever you know the design).** The worker treats
  these as truth and the screenshot as a lossy reference, so anything you pin comes back
  exact and anything you leave unpinned gets re-derived from pixels and drifts. Supported
  fields: `emailWidth` (number), `textNodes` (per text run: `content`, `fontFamily`, `color`,
  `fontSize`, `fontWeight`, `lineHeight`, `letterSpacing`, `textAlign`, `textCase`,
  `textDecoration`, `hyperlink`), `imageNodes` (`{ width, height, name }`), `bgColors` (array
  of hex strings), `layoutText` (a plain-text frame tree with paddings and gaps). When you
  authored the comp yourself in B2 you know all of this: send it.
- **Query params:** `nocache=1` skips the cache entirely, read and write (results otherwise
  cache for 24h on the screenshot hash); `recache=1` skips the read but still writes, which
  is how you overwrite a bad cached result; `decomposeRasterized=1` asks the worker to OCR
  flat image-only regions into live text and buttons instead of one big image, for sources
  that are a single baked screenshot.
- **Response:** the MJML JSON. `X-Cache` says HIT or MISS. `X-Trivial-Response: true` means
  the result collapsed to a single image; re-run with `recache=1` and usually
  `decomposeRasterized=1`. A full-length email takes 20 to 40 seconds.

From the Codex shell:

```bash
B64=$(base64 -i /tmp/render.png | tr -d '\n')
printf '{"screenshot":"%s","screenshotMime":"image/png"}' "$B64" > /tmp/body.json

curl -sS --max-time 120 -D /tmp/headers.txt \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer' \
  -H 'X-Auth-Provider: gumroad' \
  --data-binary @/tmp/body.json \
  'https://design-converter.andy-30d.workers.dev' > /tmp/mjml.json
```

The `Authorization` value is the literal word `Bearer` with nothing after it. On Linux
`base64 -i` becomes `base64 -w0`. Read `/tmp/headers.txt` for `X-Cache` and
`X-Trivial-Response` before you trust the body.

**Save the JSON to disk before transcribing**, so the transcription and any later
re-verification work from a stable input.

**If your Figma MCP is read-only**, B4 cannot run and Path B is not dead: have the user paste
the render into their Figma file, select it, and hit Convert on the plugin's AI Import
screen. That calls this same worker and writes the frame for them, structure included. You
then pick up at B5 and B6 by reading the resulting frame back and telling them precisely what
to fix. Say up front that this is the route you are taking and why.

## B4: Transcribe per the render spec

**The render spec is the appendix at the end of this file.** Follow it exactly. It maps every
MJML tag and attribute to the Figma node, auto-layout, fill, and shared plugin data the
exporter reads back. Do not improvise a mapping. Run its post-build checklist (R9) per email
before moving on.

**Name every node twice** (R6). The MJML tag goes in the `name` shared plugin data key; the
layer name gets the plugin's own friendly display name for that tag ("Row (Contains columns
that sit side by side)", "Text Block", "Button Text"). The exporter resolves the tag from
plugin data and never reads the layer name for dispatch, so this costs nothing and it is the
difference between a file a designer can read and a wall of `mj-` strings. Never rely on the
layer-name fallback: a node with no plugin data tag can have the friendly label baked in as
its tag by the plugin's own naming helper, and it stops exporting.

What the spec maps: `mj-wrapper`, `mj-section`, `mj-group`, `mj-column`, `mj-column-inner`,
and the text, image, button, divider, and spacer leaves. **When the worker returns a tag the
spec does not map**, which in practice means a social icon row coming back as `mj-social`
with `mj-social-element` children, do not invent a node for it and do not silently drop it.
Rebuild that row from tags the spec does map: for social icons, an `mj-group` of one-column
`mj-image` pairs, each with its own `href`, which also keeps the icons side by side on
mobile. Composing from mapped primitives is the same move as rebuilding a pill as a button;
inventing an unmapped node is not. List every row you rebuilt this way in your report.

## B5: Repair what the worker gets wrong (every time, these are known)

The worker returns structure, not a finished email. Five gaps, all observed repeatedly:

1. **Pills and badges come back as `mj-text`** with an inline-styled `<div>` carrying a
   background color and a border radius. Rebuild every one as an `mj-button` (see the
   standing corrections below). A pill needs no link to be a button.
2. **The worker never emits `mj-group`.** Its whole vocabulary is `mj-wrapper`, `mj-section`,
   `mj-column`, `mj-text`, `mj-image`, `mj-button`, `mj-divider`, `mj-spacer`, and
   `mj-social` with `mj-social-element` children. Anything that must stay side by side on
   mobile comes back as plain sibling columns, which will stack. Decide which rows must not
   stack (badge rows, icon rows, two-up cards) and rebuild those as an `mj-group` per R3.3.
   The columns inside that group are pinned to pixel widths, so pin them with slack rather
   than at the width Figma hugged to (R3.3.1: a pinned column cannot grow, and the email
   renders a different font binary than the canvas does).
3. **Every `src` is `"placeholder"`.** Place the customer's real logo and imagery yourself;
   use flat gray fills at the correct dimensions everywhere else and list them in your
   report. When an image comes out of their own Figma design, export the RENDERED node, never
   the raw image fill behind it: a fill with `scaleMode: 'CROP'` loses its crop the moment you
   take the underlying asset, and you get the whole photograph instead of the picture the
   designer composed (R4.2.1, which also has the aspect-ratio rule).
4. **Unpinned colors, radii, and fonts drift** by a few units between runs, and unpinned
   fonts flatten to Arial. Correct them against the brand foundations rather than accepting
   what came back.
5. **The worker cannot see an overlap, so it never returns the Two Column Swap.** It infers
   structure from a flat screenshot, and email has no z-order to infer into, so a source block
   where a photo bleeds past its band or sits behind copy comes back either as a full-width
   `mj-image` stacked above the text or as the whole band flattened into one image. Neither is
   the answer. Rebuild it as a two column row per **R3.4.1**: one section, two columns, image in
   one and text in the other in source order, both columns pinned to widths that sum to the
   section content box, the image a rendered crop of the source region. R3.4.1 also has the two
   tells for spotting the pattern in the source, which you need because the screenshot you sent
   the worker hides the overflow by construction, so check the source nodes rather than the PNG.
   Do not improvise a container for the overlap and do not flatten the block to make it go away.
   State in your report that you applied the swap, and that the loss is the overlap and nothing
   else.

## B6: Apply the design system on top, then make it reusable

AI Import produces structure, not styling. It is not a pixel copier. Once the tree is
correct, apply the brand colors and type from B1 across every text node, button, and section
fill, and set the root frame's theme keys to the real brand values.

Then offer to make it reusable. Saving into the plugin's design system is an authenticated
plugin action on the user's current selection; you cannot push components into it. What you
can do is set it up so the save is one click.

**First decide what they are saving, because the two are different shapes and they go in
through different screens** (appendix R2):

- **The whole email, as a starting template.** That is the `mainFrame` root you already
  built. It stays exactly as it is; the marker is required.
- **One block, as a reusable module.** That is the `mj-wrapper` inside the email, not the
  email root. Uploading a `mainFrame` as a module does not fail, it archives as a whole
  email, so do not "promote the email frame" when what they wanted was a hero. Copy the
  wrapper out to a library page, make that copy a COMPONENT tagged `mj-wrapper`, and make
  sure it carries **no** `nodeType` key. R2.2 has the exact calls and R2.3 the plugin
  evidence.

Then, either way:

- **Rename it first.** The raw Figma layer name becomes both the component name and its
  storage path, and there is no rename field in the save dialog. A frame left at its import
  name saves as a component literally called `EmailLove_clone`.
- **Add properties to anything meant for reuse.** A one-off campaign email can stay a frame
  with no properties. A module gets the two to five properties a marketer will actually
  change, added to the wrapper component itself, since that is the component that directly
  owns the nodes. R7 and R8 cover why a COMPONENT root is safe (the plugin builds every
  wrapper as one), the rules that keep it working, and the exact per-element bindings. A
  property whose binding is wrong is worse than no property, so re-read each binding back off
  the node before you present.
- **Use the customer's real category names** when you propose where each upload goes. If the
  Email Love MCP is connected, `list_components` returns their categories; otherwise ask them
  to read the section names off the plugin's Assets sidebar, which ships 13 predefined
  sections: Pre-Header, Header, Heroes, Single Column, Two Column, Three Column, Four Column,
  Buttons, Reviews, Images, Lists, Order Tables, Footer. Classify by what the block
  structurally is: **Heroes** for a top-of-email feature block, **Single Column** for one
  full-width stack, **Two Column** or **Three Column** for side-by-side columns, **Order
  Tables** for line-item layouts, **Images** for image-only blocks. When nothing fits, choose
  the closest existing section and say so, rather than inventing one.
- **Then walk the uploads, and route each one by its shape.** A whole email template goes in
  through Custom Templates: "Select the email frame, make sure a design system is selected in
  the plugin, open Custom Templates, click **Add New Template**, pick a category." A module
  goes in through the Assets sidebar instead: "Pick the design system, open the Heroes
  section, select 'Hero, text led' on the canvas, click **Upload**, confirm; say done and I
  will queue the next." Selecting several wrappers at once uploads them as one batch. **That
  Upload button only renders for a user on a paid plan** (`AssetsComponent.tsx` gates the whole
  Assets header on the subscribed state), so a Free user will not find it; say so rather than
  sending them hunting. Custom Templates refuses a module with "Please select valid email
  template", because that path requires the `mainFrame` marker a module must not carry. Report
  the full checklist even if the user defers the uploads; it is the hand-off artifact.
- Do not write `saveCategory` or `saveName` plugin data. The plugin reads neither key today.

**What you have made here is a few reusable components, and that is not a design system. Do not
improvise one mid-build.** A real Email Love library has a shape: a prescribed page frame (Cover,
Getting Started, divider pages, Foundations, Type, Buttons, one page per component category,
Campaigns), color and spacing as Figma variables in two tiers with every component fill bound to a
semantic token, a Type page built as a specimen sheet, and one module per row of an audited
inventory. That comes out of the migration route, which audits the source, classifies how much of its
geometry is a specification, settles the scale factor once where one applies, and builds foundations
before any module. Inventing a page structure and a token set here, in
the middle of building one email, produces a file that looks like a design system and matches no
other customer's, which is exactly the divergence the prescribed structure exists to prevent. So
save the blocks that earn it, put them on a plainly named library page rather than a scaffolding of
your own, and say plainly that a full library is a separate piece of work.

Point the user at Email Love's migration flow (hello@emaillove.com), which ships as the separate
project-scoped Codex file that "If the ask is a migration, this is the wrong file" names at the top
of this file, with the command to fetch it. It is also the route to take for a whole legacy library
rather than one email: that is a migration, not a build.

---

# What always applies, on both paths

## The standing corrections

These are the mistakes that keep recurring. Check every build against all six. On Path A they
apply to the root and to anything you build outside an instance; they are never a reason to
open an instance and correct its internals, which the components already got right.

- **A pill, badge, tag, or chip is an `mj-button`, never a radiused column.** `mj-button`
  renders a padded, rounded, background-filled box with centered text **and the Outlook VML
  fallback**. A column with a border radius does not survive Outlook.
- **Elements that must stay side by side on mobile go in an `mj-group`.** The group is a
  child of `mj-section` and **never** of a column. MJML requires the columns inside a group
  to be sized in percentages rather than pixels, and you get that by giving each inner column
  an exact **fixed pixel width in Figma** and letting the exporter divide it by the group's
  content box (280 + 280 in a 560 group exports 50/50). Do not reach for FILL sizing to
  express the percentage. To stop a whole section stacking without a group at all, set
  `stackColumns` to `'false'` on the section instead.
- **An image is an `mj-image-Frame` containing a tagged `mj-image` rectangle**, as a pair.
  Never a frame with an image fill on itself: a childless wrapper exports as an empty cell.
  The same pairing applies to text, buttons, and dividers.
- **Alignment: set both axes to the same value.** The exporter reads `primaryAxisAlignItems`
  for **horizontal** alignment, so a vertical column that looks centered on canvas exports as
  left. Every auto-layout frame you create must have
  `primaryAxisAlignItems === counterAxisAlignItems`.
- **Sizing is not cosmetic: heights hug, widths are a decision.** Every frame you create,
  from the root down, is vertical HUG. A fixed height clips content in Outlook and breaks the
  first time the copy runs a line longer. Vertical rhythm is auto layout padding, never a
  taller frame and never manual positioning, which does not export at all. Widths are FILL or
  HUG except where a pixel number is load bearing (the root width, columns in a multi-column
  section, columns in a group, the image rectangle). And a button sized **FILL** is what
  makes it full width on mobile, while HUG or FIXED keeps its width there, so size buttons
  from the design, not from what tidies the canvas. **R0 in the appendix** has the full rule,
  the padding levels, and the one exception (`mj-spacer`).
- **Colors and type come from the design system and are applied on top of the structure.**
  Generated structure is a starting shape, not a styled email.

And the reason all of this is invisible: **untagged content does not fail loudly, it gets
flattened into a picture.** Anything the exporter does not recognize hits its
render-the-unknown-as-an-image path, and an unrecognized frame takes its entire subtree with
it. If your export shows images where you expected live text, that is the first thing to
check.

## Root frame

**This file builds EMAILS, so everything here is the email-template shape**: a `mainFrame`
root with `mj-wrapper` components stacked inside it. A reusable module is a different shape
(the wrapper IS the component, no `mainFrame` marker), and it only comes up when you save a
block into the design system in B6 or A5. R2 in the appendix has both side by side; do not
mix them.

Preferred: duplicate an existing Email Love email frame, which carries all of this already.
When you create a root from scratch, it is a top-level vertical auto-layout frame with its
width FIXED at the email width (600 or 640), its **height Hug** (R0.1: never a fixed height,
on the root or on anything inside it), and **all nine** keys set. Empty theme keys are not
neutral: the exporter substitutes dark defaults, which wrecks a light email.

```js
frame.setSharedPluginData('emaillove', 'nodeType', 'mainFrame')
frame.setSharedPluginData('emaillove', 'backgroundColor', '#ffffff')        // dark-mode page bg
frame.setSharedPluginData('emaillove', 'contentColor', '#ffffff')           // dark-mode section bg
frame.setSharedPluginData('emaillove', 'textColor', '#000000')
frame.setSharedPluginData('emaillove', 'linkColor', '#000000')
frame.setSharedPluginData('emaillove', 'buttonTextColor', '#ffffff')
frame.setSharedPluginData('emaillove', 'buttonContentColor', '#000000')
frame.setSharedPluginData('emaillove', 'lightThemeBackgroundColor', '#ffffff') // exports as mj-body bg
frame.setSharedPluginData('emaillove', 'fallBackFontName', 'Arial')
```

Setting the dark keys equal to the light design colors makes dark mode render like light,
which is the right default for a first pass. For a genuinely dark email, invert them
(backgroundColor `#000000`, contentColor `#1f1f1f`, textColor and linkColor `#ffffff`). All
of these stay editable in the plugin's settings panel afterward.

## Links, alt text, subject, and preheader

These live in plugin data, so set them as you build. **Node placement matters and is easy to
get wrong:**

```js
imageRect.setSharedPluginData('emaillove', 'href', 'https://example.com/pricing')  // the mj-image RECTANGLE
imageRect.setSharedPluginData('emaillove', 'altText', 'Spring collection lookbook')
buttonFrame.setSharedPluginData('emaillove', 'href', 'https://example.com/pricing') // the mj-button frame
root.setSharedPluginData('emaillove', 'emailSubject', '20% off Premium ends Sunday')
root.setSharedPluginData('emaillove', 'emailPreHeader', 'Use code SPRING20 at checkout')
```

`href` goes on the `mj-image` **rectangle** and on the `mj-button` **frame** (the inner one,
not the `-Frame` wrapper). `altText` goes on the `mj-image` rectangle. Subject and preheader
go on the root.

**Existing values win, and you cannot change them.** The plugin reads its own private data
first and falls back to the shared namespace only when the private value is empty. A link
someone set by hand in the plugin lives in private data you can neither read nor overwrite,
so your value is silently ignored. Setting these where nothing was set works; changing an
existing one appears to succeed and does nothing. Treat every link you set as provisional and
list them in your report, and when a user asks you to change an existing link, tell them
plainly to change it in the plugin.

## Mobile styles

Same pattern, on the element frame, same private-data caveat: `mobileStylesPaddingTop` /
`Right` / `Bottom` / `Left` (and `mobileStylesInnerPadding*`),
`mobileStylesHideInMobileDevice` / `mobileStylesHideInDesktopDevice` set to `'true'` (a
desktop-only and mobile-only variant of a region is two sibling nodes, one hidden each way),
`mobileStylesTextAlign` / `mobileStylesAlign`, and `stackColumns` on sections and wrappers.
Use them when the brief calls for mobile-specific behavior, and list every key you set so the
user can check the plugin's mobile preview.

## The footer token block

If any email in the file carries a small frame holding ESP tokens like `{{Footer}}`, that is
an `mj-raw` block and it is how the ESP footer gets injected. **Copy that existing block into
every email you build**, rather than writing one from scratch. Three things to know:

- An `mj-raw` frame **must** contain its text child. The exporter reads the first child
  without checking, so an empty one breaks the export.
- Raw content is **skipped in the plugin's preview but present in the export**. Tell the
  user, so they do not report it as a bug.
- **If the file has no such block yet**, which is the normal Path B case, and the customer
  told you in B1 that their ESP injects the footer with a token, this is the one structure
  you may create by hand: a frame tagged `mj-raw` whose single child is a TEXT node tagged
  `mj-raw-text` holding exactly the token string they gave you, and nothing else. Everything
  else in the footer, the address, the unsubscribe wording, the social icons, is ordinary
  structure and comes from Path A or Path B like the rest of the email. If they do not use a
  token, skip the raw block entirely.

Keep raw blocks small: they skip the plugin's structure handling, mobile styles, and dark
mode entirely, and hand-written markup is where cross-client rendering breaks. Say in your
report that any raw block needs a real inbox test.

## Foundations you do not change

The **email width**, the **breakpoint**, and the **fonts** already in use are brand decisions
someone made, not defaults to improve on. If a font will not load in your environment, do not
substitute one to get the edit through. Report it and leave the layer as you found it; a
silent swap changes the brand's typography everywhere it lands.

**The file's page structure and its tokens are foundations too.** The page list, the page names,
the text styles, and the variables were decided when the library was built (A1). Build inside them:
never rename or reorder a page, never edit a text style or repoint a variable to make one email
work, and never add a page or a token as a side effect of a build. If an email genuinely needs
something the foundations do not carry, that is a request for the designer, so name it in your
report and build the closest correct thing meanwhile.

**Dark mode overrides are read-only.** Per-node `contentColor`, `textColor`, `linkColor`,
`buttonContentColor`, `buttonTextColor` on a child node are a deliberate treatment someone
chose. Never clear or overwrite them, and do not strip them when you duplicate a donor. Name
the sections that carry them in your report. If the user explicitly asks you to set dark mode
on a section, write the keys and tell them to verify in the plugin's dark mode preview.

## Writing the content

Write like a person, not a template. Front-load the value in the first section, keep one
primary CTA, make everything scannable. For sequences, each email must escalate or advance
the story; if two emails in one recipient's path repeat the same theme, rewrite the later
one. Match the brand voice from existing copy in the file, informed by any Step 2
inspiration. Never use em dashes. Never invent statistics; flag any placeholder figures
clearly.

## Verify before you present

Screenshot every email and inspect it: no clipped text, no overlapping elements, spacing
consistent with the file's real campaigns. Then check structure:

- Root frame is a duplicated Email Love frame, or carries `nodeType = mainFrame` plus the eight
  theme keys, which is the nine of "Root frame" less the marker itself. It is an email, so the
  marker belongs there; the only nodes that must NOT carry it are any reusable modules you split
  out in A5 or B6.
- **Path A:** every section is a component instance (raw footer excepted), including
  inherited ones. No detached instances. No hand-built frames survived the donor vetting. No
  instance internals were restructured.
- **The library is as you found it, on Path A:** the page list has the same pages in the same
  order with the same names, no text style or variable was edited or repointed, and the email sits
  on the page the file's own structure puts it on (A1). Read the page names back rather than
  recalling them.
- **Path B:** the appendix post-build checklist (R9) passes: every node tagged, every leaf a
  complete pair, every `mj-button` with a direct TEXT child, both alignment axes equal on
  every auto-layout frame, all nodes visible, and column widths summing to the email's one
  content width rather than to the side margin the worker returned per screenshot (R0.3.1). Plus
  the five B5 repairs done, and any tag the spec does not map rebuilt from mapped primitives
  per B4. If the source had an overlapping or bleeding photo, that band is a two column row
  per R3.4.1, not a flattened image and not an attempted overlap.
- **Sizing, on both paths, for every frame you created:** vertical HUG everywhere, no fixed
  height except an `mj-spacer`, no FIXED width outside the load-bearing cases, every pinned
  width that carries text given slack (R3.3.1), all spacing expressed as padding, and every
  button's width chosen for how it should behave on mobile (R0).
- **Scale, on Path B:** the root is at the email width from B1, and type sizes, paddings, and
  image dimensions are at email scale rather than the source design's scale (R0.6). A frame
  built at source scale passes every other check in this list.
- **Path B naming and components:** every node carries the display name for its tag and a
  real tag in plugin data, with no friendly string in the plugin data key. Anything built for
  reuse is an `mj-wrapper` COMPONENT with **no `nodeType` key**, named for the module rather
  than the wrapper display string, a direct child of its page, with every property binding
  re-read and confirmed.
- Every `mj-raw` frame contains its text child. Dark mode overrides intact. Exactly one
  visible CTA button per email unless the user asked otherwise.

Fix what fails before presenting. Then report: what you built, which path and why, which
components you chose or what the converter returned and what you repaired, what you assumed,
which inspiration emails informed the work, and everything left as a placeholder.

## Hand off

1. Review the emails in Figma and comment or edit like any design work.
2. Select a finished frame, open the Email Love plugin, and set subject line and preheader in
   the settings panel. Propose copy for both: subject under 45 characters, preheader that
   extends it rather than repeating it.
3. Export through the plugin to their ESP. Building on the canvas is free; exports count
   against the Free plan (5 per month, unlimited on paid plans).

If the plugin says "Please select valid email template" on a frame you built, the root frame
is missing its marker (see "Root frame") or the plugin version predates shared-marker
support: ask the user to update the plugin.

---

# Appendix: the render spec

Codex cannot install a `references/` directory, so the transcription rules ship inline here.
This is the operative subset of `render-spec.md` and `structure.md` from the Claude skills,
which are derived from the plugin source (`email-love/Figma-plugin`), not from inference. The
full documents live at
https://raw.githubusercontent.com/email-love/claude-skills/main/skills/emaillove-eds-converter/references/render-spec.md
and `.../structure.md` if you ever need a case this appendix does not cover. Do not
reconstruct these rules from memory: that is hand-authoring by another name.

You may only use what an external agent can write: layer names, geometry, auto-layout,
fills/strokes/radii, TEXT node properties, `setSharedPluginData('emaillove', key, value)`,
and, for reusable modules, component creation plus component properties (R7, R8).

**Read R2 before you create anything.** This spec describes two different things, an EMAIL
TEMPLATE and a DESIGN-SYSTEM MODULE. They share every rule except the root, and the root is
where the difference is fatal.

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
- `mj-spacer` is the single node that ENDS with a fixed height, and R0.2 says why. A frame passes
  through a fixed vertical size in exactly one other place, the instance-resize remedy in R0.8,
  which requires it and puts it back; nothing else is ever left FIXED.

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
| FILL | `mj-wrapper` under the root; `mj-section` under a wrapper; a single `mj-column` in its section; `mj-column-inner`; every leaf pair wrapper as a column child; the `mj-text` TEXT node inside its frame; the `mj-divider` LINE for a full-width rule; an `mj-button` frame chosen full width (R0.4) |
| HUG | `mj-group` (its width comes from the fixed columns inside it); the `mj-button` frame when it is auto-width, which is R0.4's default rather than a rule of this table; `mj-button-text`; and the transient state of any frame you created but have not yet appended and set to FILL |
| FIXED | the four cases below, and nothing else except a button deliberately pinned per R0.4 |

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

#### R0.3.1 CONTENT WIDTH is decided once, for the whole email

Content width is the width text actually occupies inside a section: the body width minus the side
margins that hold the copy off the edge. **It is ONE number for the whole email, and on Path A one
number for the whole design system, not a per-section value taken from whatever the worker returned
for that screenshot.** The sizing modes above say which node owns the width; this says what the
number is.

**The mechanism, because it is structural rather than careless.** The worker sees ONE screenshot at
a time. It has no knowledge of the sections around the one it is converting, so the section and
column padding it returns is a guess made per screenshot BY CONSTRUCTION. Each guess is individually
defensible. Accepting each one as authoritative therefore does not risk drift, it guarantees it.
Measured across the modules of one assembled email: side margins of 48, 40, and 20, which is three
content widths in one email out of six independently reasonable guesses.

**The failure signature is what a reviewer actually notices: the text left edge MOVES as you
scroll.** 20px in, then 40px, then back to 20px. Nobody reads that as a padding value being wrong,
because no individual padding value IS wrong: 48, 40, and 20 are all ordinary column paddings, and
each looks correct inside the section it belongs to. What is wrong is that they are not the same
number, and that is only visible ACROSS sections, so it survives every other check here and gets
caught the first time somebody scrolls the finished email.

So fix the number once, before you transcribe anything, and use it everywhere: from the design
system on Path A, and on Path B from B2 (560 on a 600 body when the design is not authoritative
about geometry; the source's own margin, converted through the target width, when it is). What has to
equal that number is the TOTAL side inset, the section's horizontal padding plus the outer column's,
because the worker splits the margin across the two levels however it likes. Carry it on the section
and leave the outer column's horizontal padding at 0 unless the design needs an inner gutter: with a
600 body and a 560 content width every text-bearing section carries 20/20, and every section's text
starts at the same x. **Full-bleed image bands are the ONLY exception**, at the full body width,
because bleeding is the design intent rather than a padding difference.

For a multi-column row the content width is still the number the columns sum to (R3.3, R3.4, R5.4):
a 560 content width takes columns plus gutters summing to 560. Widening a row from 520 to 560 means
the added 40 goes to the column that has slack, normally the text column, holding the image column
and the gutter fixed, so the sum is re-derived rather than the margin quietly re-invented. Worked:
`40 + 136 + 24 + 360 + 40 = 600` becomes `20 + 136 + 24 + 400 + 20 = 600`.

### R0.4 Button width is a mobile behavior decision

- **FILL**: the plugin enables full width on mobile (`width: 100%`) and the exporter sets
  `applyFullWidth`. The button spans the column on desktop and on mobile.
- **HUG or FIXED**: the button keeps its width on mobile.

Choose from the source design, never from what makes the canvas look tidy. An edge to edge
CTA is FILL. An inline, auto-width button is HUG, which is what worker JSON buttons are by
default. FIXED only when the design system pins a button width. Record the choice in your
report when it is anything other than HUG.

Never set the button frame's height. It comes from the text height plus `inner-padding`, and
that padding is also how you get a tap target of at least 44px.

### R0.5 Where padding belongs, by level

| Level | Typical values | Notes |
| --- | --- | --- |
| `mj-wrapper` | 0 to 20 | Outer breathing room around a group of rows. This is where a visible gap between content and the outer background color comes from |
| `mj-section` | 0 to 20, often 0 | Many designs keep section padding at 0 and control spacing at column and element level. Horizontal section padding also defines the content box column percentages are computed against (R3.2), and its horizontal value comes from the email's one content width (R0.3.1), not from the worker |
| `mj-column` | 0 horizontal, 10 to 20 vertical | The most commonly adjusted level for VERTICAL room. Horizontal is different: a column's side padding is part of the TOTAL side inset R0.3.1 fixes, and R0.3.1 carries that inset on the section, so this stays 0 unless the design needs an inner gutter (a multi-column row's gutter is exactly that case) |
| Leaf pair wrapper | sparingly | Fine tuning one element, for example 10px above a button but not above the text over it |
| `mj-button` `inner-padding` | from the MJML, symmetric only | The button's tap target, not layout spacing. Asymmetric values round-trip wrong (R4.3) |

In a conversion the worker's paddings are authoritative with exactly ONE exception, and the
exception is horizontal: **the side inset that holds copy off the body edge comes from the email's one
content width (R0.3.1), never from the worker**, because that number is decided once for the whole
email and the worker's is a per-screenshot guess by construction. That inset is the section's
horizontal padding plus the outer column's, since the worker puts the margin at either level, and
R0.3.1 says to carry it on the section. Every other padding in the JSON, every
vertical value above all, is transcribed exactly, **as the number it already is**: they come back at
email scale whatever resolution you sent the screenshot at, so there is no scale conversion to apply
to them (R0.6). The
ranges above are for gaps you have to invent. Four things that keep padding honest: pick a
base unit (8px) and use multiples of it; padding sits inside the box and eats content width
(two 50 percent columns with 20px each side lose 80px total); Outlook ignores values under
5px and handles even numbers more predictably; mobile padding is a separate override
(`mobileStylesPadding*`), not a reason to compromise the desktop value.

### R0.6 Every number here is at EMAIL scale, never source scale

Widths, type sizes, paddings, radii, and image dimensions in this appendix are email pixels: a
600 or 640 body, a 16px body copy, a 20px section padding. On Path A the design system already
carries those numbers. **On Path B, how you arrive at them has two answers, and B2's first question
decides which: is the design you were handed AUTHORITATIVE about geometry or not?**

- **Authoritative** (a past email of theirs, a comp you wrote at the email width, a library drawn at
  600 with real styles, components, and repeating margins): its geometry is a specification. B2's
  scale check settles one factor before anything is sent to the worker, and the rest of this section
  applies.
- **Not authoritative** (an old mockup at no particular width, no styles, absolute positioning,
  margins that differ design to design): its geometry is an artefact of how the file got made, and
  preserving its proportions reproduces guesses. **There is NO factor.** Build to email standards
  instead, stated rather than derived: a 600 body, one content width of 560, body copy at 16 on a
  12/14/16/20/24-to-30 ramp, spacing in multiples of 8. Take the palette, the typefaces, the logo, the
  copy, and the order of the blocks from the source and nothing else. Skip to "No factor" at the end
  of this section. In a migration this is the audit's SOURCE FIDELITY tier, REFERENCE ONLY, and it is
  the audit that names it.

**The worker is scale-agnostic: its numbers do NOT arrive at the scale of the screenshot you sent.**
It classifies semantically at a canonical email scale rather than measuring your pixels. Measured: a
768px wide screenshot sent for a 600px build target came back with `mj-body` width 600 and round
email-scale values throughout (24, 16, 40), with nothing in the payload tracking the input
resolution. Still send a PNG at the target email width, because that is the input the worker was
tuned for, and still pin `emailWidth` in `promptInputs`, because that is the setting that actually
fixes the body width; just do not treat either as a lever on the arithmetic. Three consequences: do
not compute a scale conversion on the worker's returned numbers expecting it to matter, because it
is usually a no-op and treating it as meaningful invites a second factor into a system whose whole
rule is one factor; the factor still matters enormously, but for reading the SOURCE, which is what
the authored sizes divide by, and for cropping and sizing images taken out of it (R4.2.1); and do not
assume a future worker version behaves the same way, so sanity check ONE returned number, the root
`mj-body` width, against the width you are building to before trusting the whole payload. Never carry
a source pixel across untouched.

**The rest of this section, down to the "No factor" heading, is for a design whose geometry is a
specification.**

A frame built at source scale passes every other check in this appendix: it hugs, it is tagged,
it exports. It is simply two or three times too big, which shows up as a body size no email uses
and a root wider than the body, and on a single email there is nothing beside it to make that
obvious. So check the two numbers rather than trusting the canvas. In a migration the audit
settles the factor once, in its **Scale factor** section, and a fresh derivation there would
overrule a decision a designer already made, or, on a reference-only source, manufacture a decision
nobody made at all.

**Whatever the factor is, it is ONE number applied to EVERY quantity it governs**: type sizes, line
heights, the spacing scale, paddings, spacer heights, radii, border widths. Rounding is allowed, to
the nearest whole pixel, after the division. Choosing a value because it looks like a size email
usually uses is a second factor invented for one element, and the way to catch it is to divide the
largest converted type size by the smallest and compare that to the same ratio in the source. More
than a couple of percent apart and per-style rounding has crept in. A converted size that looks
wrong is evidence against the factor, never licence to nudge the one style. B2 has the measured
case: a 55 headline and a 35 body, a source ratio of 1.57, built as 30 and 16 for a ratio of 1.88,
and it read as a padding bug rather than a type bug.

**Widths are the one thing that factor does not govern, and this is the TWO FACTOR TENSION.**
Choosing a target email width AND a type factor independently reintroduces two factors, and the two
ratios agree only when the source happens to have been drawn at an exact multiple of the target
width, which a design drawn to present is not. Measured: a 1092 wide source built to a 600px body is
1092/600 = 1.82 across its width while its confirmed type factor was 2.2, and 1092/2.2 = 496 rather
than 600. So **run the check once, before you build: divide the source width by the target email
width and compare that ratio to the type factor.** If they differ by more than a couple of percent,
say so when you hand off and name the split: the type factor governs type sizes, line heights, and
the spacing scale, and the target email width governs the body width and everything measured across
it (content width, column splits, image widths). Neither quantity can be bent to make the ratios
meet, because the email width is a hard constraint from the clients and legibility is a hard
constraint on type. **This is a tension to declare, not a bug to fix.** What it must never be is
implicit: an email whose margins nobody can trace back to a decision is how the source's consistent
115px text margin became a 20px one that is neither 52 (through the type factor) nor 63 (through the
width ratio).

**No factor: what a design that is not authoritative about geometry gets instead.** Derive nothing,
not from the width, not from the ramp, and not "for information" beside the real numbers, because a
factor written down anywhere gets applied by whoever reads it next. The numbers are the standards
above, and there is no ratio check to run, since the ratio test proves one factor was applied
uniformly and there is no factor: a ramp eyeballed style by style has no ratio worth matching. What
replaces it is a read-back, that the built ramp is the standard ramp with body at 16. And say plainly,
in your report and to the user, that the geometry is yours by decision, so an email whose margins do
not match the source is correct rather than a defect somebody should later fix back. The measured
failure this prevents: a factor derived on such a source and applied faithfully produced a 16px body
inside 20px margins, both correctly divided out of a file where nobody had chosen either.

### R0.7 DOUBLE PADDING: a gap belongs to ONE block, never to both

The space between two stacked blocks is one decision, made once, on one node. When the block above
already carries a `paddingBottom`, the block below must NOT add a `paddingTop` for the same gap,
and the reverse. Setting both is not "a little more room": the two values add, so a 40 below the
section above plus a 30 above the block below renders as 70, and the email reads as broken to the
designer who drew it.

**Failure signature**, in the order you notice it:

- The gap looks roughly twice what the design shows, while each of the two paddings that produced
  it is individually plausible. That plausibility is why this survives review.
- A leaf frame's height exceeds its content by exactly the padding you wrote, and the email's total
  height is over by the same number. An `mj-image-Frame` measuring 362 around a 332 rectangle is a
  30 that should not exist.
- Removing either value alone fixes the look. That is the proof there were two.

**Where to put it: on the preceding block's `paddingBottom`.** Prefer trailing space over leading
space so that each block owns the gap that follows it. Then a block switched off (`visible =
false`, or a BOOLEAN component property, R8) takes its spacing away with it, instead of leaving a
hole where lead-in space on the next block used to be paid for by a neighbor that is now gone.

This holds at every level, not just section to section: wrapper to section, section to column,
column to leaf pair. Before writing any padding, read what the sibling above it already carries. On
Path B the worker's paddings are authoritative and already complete for vertical rhythm (R0.5; the
horizontal side padding is the one value you override, R0.3.1), so a vertical padding you add on top
of them is almost always this bug. On Path A the component you instanced already carries its
own spacing, so a padding you add around the instance is the same bug at wrapper level.

### R0.8 A geometry write inside an INSTANCE can silently NO-OP, so read it back

`resize()` on a node nested three or more levels deep inside a component instance does nothing.
Measured: no error is thrown, the call returns as though it worked, and the dimensions read back
unchanged, even after explicitly setting `layoutSizingVertical = 'FIXED'` on that node first to rule
out a sizing mode overriding the write. **Only the instance root accepts an explicit resize.** The
symptom is that it looks like the write succeeded, and that is the whole cost: no exception, no
warning, no partial result, so the time goes into re-checking the number, the units, the call order,
and the parent's sizing, while the thing that is actually wrong is that the write never landed.

**The working pattern:** set `layoutSizingVertical = 'FILL'` down the whole descendant chain, from
the instance's own child to the node you want to resize; set `primaryAxisSizingMode = 'FIXED'` on the
top-level INSTANCE, which on a VERTICAL frame is the same property R0.1 forbids and is the one thing
the API leaves no way around, since a frame hugging its primary axis absorbs the resize and reads
back unchanged; `resize()` the INSTANCE, which cascades to every FILL descendant; then read the
target node's dimensions back and confirm they moved. **Then put the sizing back where R0.1 wants
it**, because that FILL chain and FIXED instance root are how the height TRAVELS, not the shape you
hand off: set the target node's own vertical sizing to FIXED (a RECTANGLE carries its pixels and has
no hug, R4.2), return the descendant frames and the instance root to HUG, and read those back too.
What you hand off still has to pass checklist item 7, where nothing but an `mj-spacer` is left with
a fixed height.

**The habit this implies: after ANY geometry write inside an instance, READ IT BACK, and treat an
unchanged value as a FAILED WRITE rather than as a no-op that did not matter.** The same holds for
sizing modes and paddings written to instance internals. This is a Path A concern above all, because
A4's image fills sit on rectangles several levels inside an instance.

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
   and note it in your report.
10. **Line-height.** Worker values are unitless ratios ("1.5"). Set Figma
    `lineHeight = { unit: 'PERCENT', value: ratio * 100 }`. Exception: a ratio of exactly 1.2
    or 1 may be left as `{ unit: 'AUTO' }`; the exporter emits AUTO as `1.2`.
11. **Content HTML.** Worker `content` strings may contain inline HTML. Convert:
    `<br>`/`<br/>` to `\n`; `<a href="...">text</a>` to a `setRangeHyperlink` on that
    character range; `<b>`/`<strong>` to the Bold style on that range
    (`setRangeFontName`); strip any other tags. Characters must contain no leftover markup.
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
modules. This file mostly builds emails; it builds a module only in A5 and B6.

**A module is not a small email.** An email template root *contains* wrapper components; a
module *is* one of those wrapper components. So a module has no wrapper inside it and no
`mainFrame` above it.

R3 through R6 apply identically to both shapes. Only the root differs.

### R2.1 EMAIL TEMPLATE root (one per MJML document)

Create a top-level FRAME on the target page. It may be a COMPONENT instead (R7) when the
whole email is meant to be reused; nothing below changes.

- **Geometry:** `resize(W, 100)` where `W` is the numeric `mj-body` width (usually `600`),
  then `layoutMode = 'VERTICAL'` and immediately `layoutSizingVertical = 'HUG'`, horizontal
  FIXED at `W`. `primaryAxisAlignItems = counterAxisAlignItems = 'MIN'`. `itemSpacing = 0`,
  all paddings 0. The `100` is a throwaway that gets the node onto the canvas.
- **Layer name:** the email name (this becomes the component name and storage path if the
  frame is later saved). Do NOT put a tag in the root layer name, and do NOT write a `name`
  key on it: the root is identified by `nodeType`, not by a tag.
- **Shared plugin data (namespace `emaillove`), all REQUIRED:** the nine keys listed under
  "Root frame" above. `nodeType` = `mainFrame`; `backgroundColor` (dark-mode page background,
  from the mj-body or first-wrapper background hex); `contentColor` (dark-mode section
  background, the dominant section background hex); `textColor` (the dominant mj-text
  `color`); `linkColor` (the design link color, else same as textColor); `buttonTextColor`
  (the button label color); `buttonContentColor` (the button background color);
  `lightThemeBackgroundColor` (the mj-body background hex, exports as mj-body
  `background-color`); `fallBackFontName` (`Arial`).

  Empty theme keys are NOT neutral: the exporter substitutes dark defaults (`#000000`
  background, white text), which wrecks a light email. Where the values come from, in
  priority order: an established design-system palette used identically on every email root,
  and only when no such palette exists yet, this email's own MJML colors as a stand-in,
  flagged for review.
- Optional: `emailSubject`, `emailPreHeader` (plain strings).
- Also give the root frame a visible SOLID fill of the body background so the canvas looks
  right.
- Children: the `mj-wrapper` components in document order (R3.1). After appending each
  wrapper set its `layoutSizingHorizontal = 'FILL'`.

The `mjml`, `mj-head`, `mj-body` tags themselves produce NO Figma nodes; the exporter
reconstructs them (body width comes from the root frame's width).

### R2.2 DESIGN-SYSTEM MODULE root: the mj-wrapper IS the component

There is no separate root. Create a COMPONENT and tag it `mj-wrapper`. That component is not
a container that holds a wrapper; it **is** the wrapper, so R3.1 describes this exact node.

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
  selection as a saveable top-level block rather than a fragment.
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
  theme. `buttonContentColor` and `buttonTextColor` are worse: the exporter emits them
  unconditionally whenever they are non-empty, without comparing them to the enclosing email,
  so a module carrying them ships its own dark-mode CSS into every email it is placed in. A
  module inherits nothing and conflicts with everything, so the safe default is **no theme
  keys at all**; the email root supplies them.

### R2.3 The evidence, so this reads as ground truth rather than preference

Read at `origin/main` of `email-love/Figma-plugin`, all paths under `src/`.

1. **Every `mj-wrapper` the plugin builds is already a COMPONENT.** `UiParser.ts:1519-1522`:
   `if (tag === MjmlNodeType.Wrapper || isStandalone) frameNode = figma.createComponent()`.
   Purple wrapper components inside a plugin-built email are normal. Do not "fix" them into
   frames.
2. **The two shapes go in through two different screens, and each one rejects the other.**
   Custom Templates, Add New Template is the email-template route: `AddTemplate.tsx:62` is the
   only caller of `select-component` and always sends `customType: 'customProperties'`, which
   lands in `code.ts:3226-3236` and rejects any selection *without* the marker, with "Please
   select valid email template". A module has no marker, so that dialog can never take one. The
   module route is the **Assets sidebar Upload button** (`AssetsComponent.tsx:610-632`), which
   needs a selected design system and dispatches `syncTemplateUpload` (`code.ts:3861`), taking
   an array of node ids when more than one node is selected. (`select-component` also has a
   mirror-image module branch at `code.ts:3280-3307` that rejects a selection carrying the
   marker; no UI reaches it today.)
3. **The design-system upload path keys off the `mj-wrapper` tag, not the marker.**
   `code.ts:3892-3893` sets
   `isTopLevel = getName(getMetaName(selectedNode)).tagName === 'mj-wrapper'`. Only when
   `isTopLevel` is true does the plugin wrap a clone in its own temporary `mainFrame`
   envelope and generate the MCP companion JSON. A module root not tagged `mj-wrapper` is
   archived as if it were a whole email and gets no MCP JSON at all.
4. **Marking a node both ways is worse than either mistake.** In both serializers the
   `mainFrame` branch is tested before any wrapper handling, first match wins, so the output
   is a nested `mjml` document inside `mj-body` that nothing downstream can compile.

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

- Node: FRAME, child of a wrapper (or of the root if the MJML has no wrapper).
- Shared `name` = `mj-section`.
- Auto-layout: `layoutMode = 'HORIZONTAL'`, both sizing HUG, then FILL width as a child of
  the wrapper (height stays HUG),
  `primaryAxisAlignItems = counterAxisAlignItems = 'CENTER'` (primary exports as the section
  `text-align`: MIN left, MAX right, else center).
- Attribute mapping: same table as wrapper. Borders map to strokes (R5.6).
- Geometry matters: exported column widths are computed as
  `columnWidth / (section.width - section.paddingLeft - section.paddingRight) * 100%`. With
  the standard worker output (section 600 wide, padding-left/right 20, column width 560) that
  is exactly 100 percent. Set the section's horizontal padding from the email's one content width
  rather than from the worker (R0.3.1: a 560 content width on a 600 body is 20/20), keep its
  vertical padding as the worker gave it, and make the column pixel widths sum to that content
  width. Where the worker's side margin and the email's disagree, the email's wins and the column
  widths are re-derived to the new sum.
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
  280 + 280 exports 50%/50%.
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
  hardest.
- Horizontal sizing, per R0.3:
  - **Single column in its section: FILL.** It resolves to the section content box, which is the
    email's one content width once you have set the section's horizontal padding from it (R0.3.1),
    and exports `width: 100%`. Never HUG, which collapses the column to its content, and never
    FIXED, which exports the same 100 percent today and drifts silently the moment a padding
    changes (R0.3).
  - **Two or more columns in one section, or any column inside an `mj-group`: FIXED.** Load
    bearing: the exported percentage is derived from the pixel number. Start from the worker's
    `width` attrs for the RATIO between the columns, then re-derive the actual numbers so they sum
    to the email's content width rather than to the worker's (R0.3.1 has the worked example).
    When you are deriving a number from a Figma measurement, and the column contains text, add
    slack per R3.3.1 before you pin it.
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
nothing overlaps. This is a settled decision rather than a per-block judgment call, so do not
re-argue it per block and do not go hunting for a cleverer reproduction of the overlap.

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

- Both columns FIXED (R0.3 case 2, R3.4), with their widths summing to the section content box: a
  600 wide section carrying 20/20 padding takes columns summing to 560. Unequal splits only
  survive because both numbers are pinned; the exporter derives the percentages from them.
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
Stacking follows column order, and column order is the design's desktop order, not yours to choose:
when the design reads text then image on desktop but should read image then text on mobile, set
`reverseStack` = `'true'` on the section (R3.2) rather than reordering the columns.

**Why this is the default, so nobody relitigates it.** It keeps the text LIVE: the alternative,
flattening the whole block to one image, gives up selectable text, accessibility, and dark mode
for the sake of an effect. It degrades well, per the mobile note above. And the loss is small and
nameable, the overlap and nothing else, which is what you tell the customer at hand-off.

**When it is not this pattern.** Type set over a photographic collage where the lettering is part
of the artwork, or any treatment where copy and picture are one composited whole with no boundary
to cut on. The test: if you can name the rectangle the image belongs in and the rectangle the text
belongs in, it is this pattern, so build it. If you cannot, say so and let the customer decide
rather than flattening a block to an image on your own judgment.

### R3.5 mj-column-inner (rarely needed)

Use ONLY when a column needs a second, inner background or border box distinct from its own
(a card inside a colored column). Most card-in-column designs are expressible without it: put
the card fill, radius, and paddings directly on the `mj-column` and the outer color on the
section. Prefer that.

If you must use it: FRAME, the FIRST (and only) child of an `mj-column`, with the leaves
moved inside it. This is load bearing: the exporter checks `column.children[0]` and ONLY
there. In any other position its fill, radius, borders, and paddings are silently discarded
and its children flatten into the parent. Shared `name` = `mj-column-inner`;
`layoutMode = 'VERTICAL'`, vertical HUG, horizontal FILL,
`primaryAxisAlignItems = counterAxisAlignItems = 'CENTER'`.

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
- Fill: an IMAGE fill, `scaleMode: 'FILL'`, from an image already in the file.
  `figma.createImageAsync(src)` is NOT available to you as an external agent, so a worker `src`
  URL is not something you can turn into a fill directly, and R4.2.1 has the route for any image
  coming from the design you converted from. The worker returns `"placeholder"` for every `src`
  anyway, so substitute the customer's real asset when you have one; otherwise one SOLID light
  gray fill (`#E8E8E8`). The exporter re-exports the node's own pixels, so a gray rect exports as
  a gray image, which is correct placeholder behavior.
- `cornerRadius` from `border-radius`.
- Shared plugin data ON THE RECTANGLE (not the wrapper): `href` from MJML `href` (omit when
  absent; never write `#`), `altText` from MJML `alt`.
- Sizing note: if the rectangle width is LESS than the column content width the exporter
  drops `fluid-on-mobile`; if equal it keeps it. So measure against the column content width you
  actually built, which is the email's one content width (R0.3.1) rather than the side margin the
  worker returned: an image meant to fill its column takes that number and stays fluid, a 134 logo
  does not.

### R4.2.1 Bringing an image across from a source design: RENDER the node, never the raw fill

This is the Path B rule for every image you take out of a design the customer already has, above
all their own non-Email-Love Figma file (B2). An image in a design file is almost never the whole
photograph the designer started from, and two things routinely sit between the raw bytes and what
you see on the canvas. Neither one travels with the raw asset:

- **A crop transform.** An image fill with `scaleMode: 'CROP'` carries an `imageTransform` matrix:
  which part of the photograph is showing, and at what zoom. Export the raw fill and you get the
  full frame back with that transform discarded, including everything the designer cropped away.
  The symptom is dead space where the composition used to be tight: a subject that filled 56 to 59
  percent of a band now occupies 27 percent and floats small inside it, or sits half out of view.
  Nothing about the rectangle's geometry is wrong, which is exactly why this gets misdiagnosed and
  reported as a spacing bug.
- **Clipping by overlapping siblings.** Unstructured designs clip by z-order and not by masks: a
  shape, a band of background, or another image sits on top and hides part of the picture. What you
  see is a composite of several nodes, and those pixels exist in none of them on its own. Only a
  render captures it. This is also the second tell for the Two Column Swap (R3.4.1): if the sibling
  drawn over the photo is what stops it bleeding past its block, the block needs rebuilding as a
  two column row and this rule supplies the image inside it.

So, for every image you bring across: **render the node as it appears and use the render.** Never
the raw fill, never the asset behind `fills[0].imageHash`.

The route, since `figma.createImageAsync` is unavailable to an agent:

1. `download_assets` on the NODE in the source file (`get_screenshot` on the node, or
   `node.exportAsync`, do the same job), at 2x, to a local PNG. Reading `fills[0].imageHash` and
   fetching that asset instead is the mistake, not the shortcut.
2. `upload_assets` to place that PNG onto the `mj-image` rectangle in the build file. The crop is
   baked into the pixels now, so the fill is a plain `scaleMode: 'FILL'` with an identity transform
   and there is no crop left to reproduce.
3. Verify against a screenshot of the SOURCE NODE, never against the source's raw asset.

**Aspect ratio: preserve the render's, never stretch to fit a chosen width.** Measure the ratio on
the rendered PNG and derive the height from the width you picked: `height = round(targetWidth *
renderH / renderW)`. A 995 x 550 render placed at 600 wide is 332 tall, and 332 is not a number to
round to something tidier. If a height was decided earlier and it disagrees with the render, the
render wins and you re-derive the height. Forcing a render into the wrong box is either a
`scaleMode: 'FILL'` quietly cropping it a second time or a visibly squashed photo.

**NEVER PAD AN ASSET TO FIT A CONTAINER, and never stretch one either.** An email image is declared
with a width and takes its height from the file, so the rectangle has exactly one correct height.
Adding white to the exported PNG to reach a ratio you already have bakes that padding into the
asset, where no later change to the rectangle can remove it. Both defects read as a spacing bug
rather than an image bug, which is what makes them expensive: the dead space looks like a padding
value nobody can find in the auto layout. **Size the container to the asset, never the asset to the
container.**

**Width is a decision, so make it deliberately and state it.** A source image narrower than its
canvas (995 in a 1089 wide design, so about 91 percent) is inset by design, not full bleed. Either
reproduce the inset as horizontal padding on the `mj-image-Frame`, at email scale (R0.6) and snapped
to the spacing scale the brand already uses, or take it full bleed at the body width. Both are
defensible. Pick against the brand's own established patterns, and say which you chose and why when
you hand off. What this must never be is an accident of arithmetic.

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

Level 2, FRAME `mj-button`:
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
  R4.1, from the mj-button attrs.
- `color` attr to the TEXT fill (this exports as the button label color).
- `textAlignHorizontal = 'CENTER'`, `textAlignVertical = 'CENTER'`,
  `layoutSizingHorizontal = 'HUG'`, `layoutSizingVertical = 'HUG'`.

Do not add any other children. Button icon frames (`beforeIcon-Frame` / `afterIcon-Frame`)
are out of scope here, and they carry a naming trap: the library-save path finds them by a
raw layer-name substring check, so if you ever build them the literal substring must stay in
the layer name.

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
itemSpacing. **The content box itself is one decision for the whole email, not a per-section one**
(R0.3.1): the number a single column resolves to, and the number a multi-column split sums to, is
the content width you fixed before you started rather than the side margin the worker returned for
that screenshot. Reproduce the worker's paddings everywhere else; this is the one you override, and
full-bleed image bands at the body width are its only exception.

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
   matches nothing, and the node is dropped with no error.
3. **Button icon frames** are found by a raw layer-name substring check on the library-save
   path, so they must keep the literal `beforeIcon-Frame` / `afterIcon-Frame` substring. They
   are out of scope here, so the safe move is not to build them.

The root is the one node whose naming depends on the shape (R2): an EMAIL TEMPLATE root gets
no tag at all and its layer name is the email name; a DESIGN-SYSTEM MODULE root is tagged
`mj-wrapper` and its layer name is the module name rather than the wrapper display string.

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
the parsed tag syntax.

**Finding these nodes again later: `query()` does not match a layer name that contains a space.**
Measured: `query('FRAME[name*=Text Block]')` returns nothing against frames genuinely named `Text
Block`. Every display name in the table above contains a space, so `query()` is unusable for
finding nodes by the names this appendix prescribes, and the appendix is what created the trap.
Traverse `children`, or use `findAllWithCriteria` and filter on `node.name` yourself.

**The tags below the transcription set.** `mj-hero`, `mj-social`, `mj-navbar`, `mj-table`,
and their children are real plugin node types, which is why they appear in the display-name
table and in the visual-pattern mapping. This spec's detailed attribute mapping covers the
core set only (R3, R4). When the worker returns one of the others, compose the row from
mapped primitives instead (B4), and reserve `mj-hero` for the case where a design genuinely
needs live text over a full-bleed background image.

## R7. Components: when a node is a COMPONENT instead of a FRAME

**Make it a COMPONENT when it is meant to be reused**: a design-system module (always), a
section you built to fill a gap and intend to save into the library, a foundations button or
badge that other modules instance. Keep it a FRAME when it is a one-off campaign email that
nobody will instance.

This is safe. Confirmed against the plugin source: the export gate whitelists `FRAME`,
`INSTANCE`, `COMPONENT` at the root and at every container level; the Add New Template branch
tests plugin data only (`nodeType === 'mainFrame'`), never `node.type`; and every
`mj-wrapper` the plugin renders is created as a COMPONENT
(`UiParser.ts:1519-1522`). Instances work too, because an instance surfaces the main
component's plugin data.

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
   a page child and vanishes from the plugin's picker. A Figma SECTION swallows a root the
   same way, and that hazard applies to FRAME roots too.
2. **Do not leave instances of a template root on the page.** Instances inherit the main
   component's plugin data, so an instance of a template root also reads as a template. To
   show a module in use, place it inside an email root, not loose on the library page.
3. **Properties go on the component that owns the node** (R8), which is the MODULE, never the
   email root. Because every `mj-wrapper` is itself a COMPONENT, an email root cannot bind a
   property to anything inside its wrapper components: Figma rejects
   `componentPropertyReferences` on an instance sublayer.
4. **Do not write `isStandalone`.** The shipped plugin build ignores that key entirely, so a
   "standalone" section gets no wrapper-level controls and is not eligible for the Upload
   button. Keep `mj-wrapper` as the top-level block boundary.

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
image property type**, so an `mj-image` fill cannot be exposed as a property.

```js
// TEXT, bound to characters, for copy that changes per send.
// Bind the inner TEXT node, never the wrapper: mj-text, mj-button-text.
const headline = moduleRoot.addComponentProperty('Headline', 'TEXT', textNode.characters)
textNode.componentPropertyReferences = { characters: headline }

// BOOLEAN, bound to visible, for optional regions.
// Bind the block-level wrapper frame, never the inner leaf.
const showBtn = moduleRoot.addComponentProperty('Show Button', 'BOOLEAN', true)
ctaFrame.componentPropertyReferences = { visible: showBtn }

// INSTANCE_SWAP, bound to mainComponent, for style variants.
const style = moduleRoot.addComponentProperty('Button Style', 'INSTANCE_SWAP', primaryButton.key, {
  preferredValues: [
    { type: 'LOCAL_COMPONENT', key: primaryButton.key },
    { type: 'LOCAL_COMPONENT', key: inverseButton.key },
  ],
})
buttonInstance.componentPropertyReferences = { mainComponent: style }
```

BOOLEAN composes exactly with the exporter, which returns early on any node where `visible`
is false, so flipping it off genuinely removes the block from the exported HTML rather than
shipping a hidden element. VARIANT is only meaningful on a ComponentSetNode; skip it for
email modules, and remember rule 1 in R7.

**Which properties to add.** A property whose binding is wrong is worse than no property: it
looks editable, does nothing or edits the wrong node, and the person who trusted it ships the
mistake. Derive them from evidence, not imagination. A BOOLEAN needs a sibling design where
that region is genuinely absent. A TEXT needs evidence the copy changes between sends.
Boilerplate stays unbound: mailing address, legal lines, standing disclosures. Two to five
per module is the working range, and zero is legitimate for a fixed block like a logo header.
Name them in plain language ("Show Button", "Headline", "Body", "Button Style") and reuse the
same names across modules. Re-read `componentPropertyReferences` back off the node after you
set it.

**The known failure:** a button label that lives on a sublayer inside a nested button
instance cannot be bound from the module. The fix is to add the TEXT property to the
foundations button component itself and let it surface through the instance.

## R9. Post-build checklist (run per email or module before handing off)

1. **The root matches the shape you meant to build** (R2), and only one of these is true of
   it:
   - **EMAIL TEMPLATE:** shared `nodeType = mainFrame`, ALL theme color keys plus
     `lightThemeBackgroundColor` and `fallBackFontName`, no `name` key, and its direct
     children are `mj-wrapper` components.
   - **DESIGN-SYSTEM MODULE:** shared `name = mj-wrapper`, **no `nodeType` key anywhere in
     the tree**, no theme keys unless a designer asked for a dark-mode treatment, layer name
     is the module name, and its direct children are `mj-section` frames. Read `nodeType`
     back off the root and confirm it is empty.
2. Every FRAME/RECT/LINE/TEXT you created has shared `name` set to exactly one known tag;
   zero untagged frames anywhere in the tree; nothing relying on the layer-name fallback.
3. Every node's layer name is the display name for its tag (R6.1), and no friendly string was
   written into the plugin data `name` key. The one exception is a module root.
4. Every leaf is a complete pair; every `mj-button` has a direct TEXT child; no empty wrapper
   frames.
5. `primaryAxisAlignItems === counterAxisAlignItems` on every auto-layout frame.
6. All nodes `visible = true` (except a region deliberately left off via a BOOLEAN default);
   `itemSpacing = 0` everywhere; no stray fills.
7. **Every frame in the tree has `layoutSizingVertical === 'HUG'`.** Walk the whole tree, root
   included. The only FIXED height allowed is on an `mj-spacer`; the only hard heights are on
   the `mj-image` rectangle and the `mj-divider` line, neither of which is a frame.
8. **Every FIXED width is one of the four load-bearing cases** (root, columns in a
   multi-column section, columns in a group, the image rectangle). Lone columns are FILL and
   groups are HUG. A button is not one of the four: its width is R0.4's mobile-behavior
   decision, so HUG, FILL, and a deliberately pinned FIXED are all valid there, and item 10 is
   where it is checked.
9. **Every pinned-width column that contains text has slack, and every pinned string was
   sanity-checked against the exported font, not the canvas font** (R3.3.1). Columns in a group
   above all, since those never stack on mobile. `max(ceil(hug * 1.12), hug + 8)` plus
   horizontal padding, or 1.25 in place of 1.12 where the root's `fallBackFontName` is Verdana,
   Tahoma, or Georgia (R3.3.1), and the inner group percentages still sum to 100. A label that fits
   exactly on the Figma canvas is a wrap in the plugin Preview, because the canvas font and the
   font the email loads are different binaries. FILL columns are exempt.
10. **Every button's width sizing was a decision** (R0.4), and buttons are at least 44px tall,
    from `inner-padding` rather than a set height.
11. All vertical spacing is padding: no gaps produced by a taller frame, by `itemSpacing`, or
    by a manually positioned node.
12. Root width equals the mj-body width; vertical section paddings equal the worker attrs. All of
    those numbers are at email scale, not source scale
    (R0.6): the root is 600 or 640, and body copy is a size email actually uses.
    **And every text-bearing column resolves to the email's ONE content width**, not to the side
    margin the worker returned for that screenshot (R0.3.1): read the resolved width back off the
    column, compare it against the number you fixed before you started, and check that a
    multi-column split still sums to it. Full-bleed image bands at the body width are the only
    exception. That is the check you cannot do by looking at one section, only by comparing the
    sections to each other.
13. If it is a module: the root is a COMPONENT tagged `mj-wrapper`, a direct child of its
    category page, not inside a COMPONENT_SET or a Figma SECTION, with no stray instances
    left on the page, and no second `mj-wrapper` nested inside it.
14. Every component property you added was re-read back off the node to confirm the binding
    landed, and each one has a reason you can state in the report.
15. No em dashes in any layer name, plugin data value, or text characters.
16. Compare a fresh screenshot against the design you converted from, for spacing, alignment,
    and color parity. Small color and font-metric differences are acceptable; missing
    content, zero-height sections, clipped text, and alignment flips are not.
17. **No gap is paid for twice.** For every pair of stacked siblings, exactly one of them carries
    the padding that separates them, and it is the one above (R0.7). Any frame whose height
    exceeds its content by exactly a padding you wrote is this bug.
18. **Every image taken from a source design is a render of its node, not a raw fill** (R4.2.1),
    so any crop or z-order clipping is baked into the pixels. Each rectangle's height is the
    render's aspect ratio at the width you chose, and the width itself was a stated decision
    (full bleed or the source's inset), not an accident.
19. **Every overlap or edge bleed in the source became a two column row** (R3.4.1), never an
    improvised container and never a flattened image. Per swap: both columns FIXED with their
    widths summing to the section content box, the text column pinned with R3.3.1
    slack, the image column the remainder, the `mj-image` height the render's natural aspect at
    the image column's content width, no `mj-group`, and the gutter paid by one column only.
    Your report names the swap and states that the overlap is the whole of what was lost.
