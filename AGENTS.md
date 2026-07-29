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

## Version and staying current

These instructions are **version 2.3.2** (2026-07-29). They track the
`emaillove-figma-builder` Claude skill at 2.3.0, plus the render spec that skill loads by
reference, from the `emaillove-eds-converter` skill at 1.10.0. The appendix here is a copy of
that render spec, so it can gain a rule without the builder skill's own version moving: when
that happens, only the patch number changes.

Unlike a Claude plugin, this file does not update itself: you downloaded a copy. If you have
web access, check once per conversation (quietly, without narrating it) whether a newer
version exists by fetching
https://raw.githubusercontent.com/email-love/codex-agents/main/AGENTS.md and comparing the
version line above. If yours is older, tell the user once at hand-off and give them the
refresh command:

```bash
curl -o ~/.codex/AGENTS.md https://raw.githubusercontent.com/email-love/codex-agents/main/AGENTS.md
```

**Version 2.0.0 was a rewrite, so anything built with a 1.x copy is worth re-checking.**
The 1.x instructions taught you to assemble `mj-section` / `mj-column` scaffolding by hand.
That is now the one thing this file forbids, because hand-built structure looks correct on
the canvas and silently drops content on export. Emails built from a 1.x copy can contain
buttons, badges, and whole sections that exported as flat images instead of live text.

**Version 2.3.1 added R3.3.1**, the slack rule for pinned columns that carry text. An email
built with an earlier copy can have a badge, label, or two-up row that looks correct on the
Figma canvas and wraps in the plugin Preview, so those rows are worth re-checking.

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
2. **Study 2 or 3 of their past emails.** Screenshot and read the frames the user named as
   their best, or the most recent. Learn voice, copy length, section rhythm, imagery habits,
   and footer conventions, including whether the footer uses an `mj-raw` token block. These
   are also your donor candidates for the root frame.
3. **Report the palette** to the user in one compact list.

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
  handles hosting.
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

The worker returns structure, not a finished email. Four gaps, all observed repeatedly:

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
   report.
4. **Unpinned colors, radii, and fonts drift** by a few units between runs, and unpinned
   fonts flatten to Arial. Correct them against the brand foundations rather than accepting
   what came back.

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

For a whole legacy library rather than one email, that is a migration, not a build: point the
user at Email Love's migration flow (hello@emaillove.com), which ships as a separate Codex
instruction file at
https://raw.githubusercontent.com/email-love/codex-agents/main/migration/AGENTS.md.

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

- Root frame is a duplicated Email Love frame, or carries `nodeType = mainFrame` plus all
  nine keys. It is an email, so the marker belongs there; the only nodes that must NOT carry
  it are any reusable modules you split out in A5 or B6.
- **Path A:** every section is a component instance (raw footer excepted), including
  inherited ones. No detached instances. No hand-built frames survived the donor vetting. No
  instance internals were restructured.
- **Path B:** the appendix post-build checklist (R9) passes: every node tagged, every leaf a
  complete pair, every `mj-button` with a direct TEXT child, both alignment axes equal on
  every auto-layout frame, all nodes visible, column widths matching the worker JSON. Plus
  the four B5 repairs done, and any tag the spec does not map rebuilt from mapped primitives
  per B4.
- **Sizing, on both paths, for every frame you created:** vertical HUG everywhere, no fixed
  height except an `mj-spacer`, no FIXED width outside the load-bearing cases, every pinned
  width that carries text given slack (R3.3.1), all spacing expressed as padding, and every
  button's width chosen for how it should behave on mobile (R0).
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
| FILL | `mj-wrapper` under the root; `mj-section` under a wrapper; a single `mj-column` in its section; `mj-column-inner`; every leaf pair wrapper as a column child; the `mj-text` TEXT node inside its frame; the `mj-divider` LINE for a full-width rule |
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
default. FIXED only when the design system pins a button width. Record the choice in your
report when it is anything other than HUG.

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
  280 + 280 exports 50%/50%.
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
  hardest.
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
- Fill: if the worker `src` is a real URL, create the image via `figma.createImageAsync(src)`
  and set an IMAGE fill, `scaleMode: 'FILL'`. If `src` is `"placeholder"` or unavailable,
  substitute the customer's real asset when you have one; otherwise one SOLID light gray fill
  (`#E8E8E8`). The exporter re-exports the node's own pixels, so a gray rect exports as a
  gray image, which is correct placeholder behavior.
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
itemSpacing.

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
13. If it is a module: the root is a COMPONENT tagged `mj-wrapper`, a direct child of its
    category page, not inside a COMPONENT_SET or a Figma SECTION, with no stray instances
    left on the page, and no second `mj-wrapper` nested inside it.
14. Every component property you added was re-read back off the node to confirm the binding
    landed, and each one has a reason you can state in the report.
15. No em dashes in any layer name, plugin data value, or text characters.
16. Compare a fresh screenshot against the design you converted from, for spacing, alignment,
    and color parity. Small color and font-metric differences are acceptable; missing
    content, zero-height sections, clipped text, and alignment flips are not.
