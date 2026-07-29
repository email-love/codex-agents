# Email Love: building emails in Figma

## What this file is, and how to use it

This is a **configuration file for OpenAI Codex**, not a prompt and not a task. It teaches
Codex to build real, export-ready emails inside your Figma file from your Email Love design
system. It is the Codex port of the Email Love Figma Builder skill for Claude
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

## Setup the user must do once

- Connect the **remote** Figma MCP server (`https://mcp.figma.com/mcp`). The local/desktop
  server does not expose the write tools this workflow needs.
- Export a Figma personal access token before launching Codex:
  `export FIGMA_TOKEN=figd_...`, generated at Figma → Account Settings → Personal Access
  Tokens, with at least these scopes: Current user, File content, File metadata, Library
  content.
- Install the Email Love Figma plugin (latest version) in Figma, with a synced design
  system in the file. See help.emaillove.com/plugin/components/design-systems.
- **Approve the `use_figma` tool calls when Codex asks.** Every canvas write goes through
  that one tool, and a build fires dozens of them. This is the most common failure: if the
  calls are declined, or the session cannot prompt you, Codex reports that the Figma write
  tools "aren't connected" and builds nothing, even though the server is connected fine.
  Approve when prompted, or start Codex in an approval mode that does not stop on every MCP
  call. For fully unattended runs (`codex exec`), pass
  `--dangerously-bypass-approvals-and-sandbox`, since a non-interactive session auto-cancels
  every approval request.

## Before you start: check your tools

This workflow depends on `use_figma`, the general-purpose Figma write tool that executes
Plugin API code. Confirm it is in your Figma tool catalog before promising a build.
`get_metadata` and `get_screenshot` are also required.

If `use_figma` is missing, stop and tell the user plainly: their Figma MCP connection is
read-only, so you cannot build on the canvas. Offer to write the email plan (structure,
copy, subject lines) instead, and mention that Claude with the Email Love skill covers the
building workflow. Do not fake it by generating a picture of an email.

## Why structure matters more than looks

These are not mockups. The frames you assemble export to production HTML through the Email
Love plugin. A frame can look pixel-perfect in Figma and still fail to export if the
underlying structure is wrong, which is the entire reason these instructions exist.

The plugin decides whether a frame is an email template by reading a marker on the root
frame. It reads its own private plugin data first, then falls back to the shared
`emaillove` namespace, which is the one external tools like you can write.

## Step 1: Get the brief

Collect the essentials before touching the canvas. If the user's message already answers a
question, do not re-ask it. Ask what is missing, in one batch, with lettered options so the
user can answer in a single line:

1. What email or emails? (a) promo (b) announcement (c) newsletter (d) a sequence such as
   welcome, onboarding, or winback. If a sequence, how many and what each one does.
2. The goal and the one CTA. One visible button per email outperforms several competing
   ones, so push for one unless the user says otherwise.
3. Key content: the offer, dates, product names, proof points, links. Real facts, not vibes.
4. The Figma file link, if not already shared.

Go deeper only when it earns its keep: vague answers ("make it good") warrant asking for an
example email they like or a brand they admire; sequences warrant asking how the story
escalates between emails; a file with several synced brands warrants asking which brand;
lifecycle emails warrant asking what the recipient just did, since that shapes tone far
more than brand adjectives. Two rounds of questions maximum, then proceed on sensible
assumptions and state them.

## Step 2: Inventory the design system

Do a real inventory, not a glance at the nearest campaign frame. A shallow inventory
produces every email as a re-skin of one existing campaign; a real one produces emails whose
sections fit their content.

1. List every page in the file. Email Love design systems usually keep the component library
   on dedicated pages (Hero variants, Cards, Lists, Copy Blocks, Data/Stats, Footer),
   separate from the campaigns page.
2. Enumerate COMPONENT and COMPONENT_SET nodes across those pages, one call per page. Build
   a palette grouped by section type.
3. Study 2 or 3 of the user's existing email frames (top-level frames around 600 to 640px
   holding stacked sections). Learn their voice, copy length, section rhythm, imagery
   habits, and footer conventions, including whether the footer uses an `mj-raw` token block.
   These are also your donor candidates for the root frame.
4. Report the palette to the user in one compact list.

## Step 3: Ask who picks the components

Ask on every build whether the user wants to choose the sections themselves or have you
choose by content fit. Skip the ceremony only when the brief already dictates exact sections
(a numbered section-by-section brief): confirm that list in one line instead.

If they defer, pick by content fit and say what you chose and why. If they want to choose,
Codex runs in a terminal, so the strongest option is to let them pick on the canvas:

- **Pick in Figma (preferred here).** Lay out a temporary top-level frame named
  "Component menu, delete me" beside the build area, containing labeled instances of the 3
  or 4 candidates for the current section. Ask the user to click their choice in Figma and
  say "picked". Read `figma.currentPage.selection`, confirm what you saw by name, and move to
  the next section. Delete the menu frame when the picking is done. The user judges
  components at full size and never squints at a thumbnail.
- **Numbered list fallback.** If the user would rather not switch to Figma, list candidates
  per section with a one-line note on fit and your recommendation tagged, and let them answer
  with numbers. You can also save `get_screenshot` output to local files and tell the user
  the paths so they can open them.

Choose section types by matching content to component: statistics want a stats or data card,
steps want a list, social proof wants a testimonial, product roundups want grid or listing
cards, a single announcement wants a hero plus a copy block. If your section stack is
identical to an existing campaign's, that is a signal you matched the donor, not the content.

## Step 4: Build

### How the frame structure works

The plugin resolves what each layer *is* from a plugin data key called `name`, and falls back
to the Figma layer name when that key is absent. Getting this wrong produces a frame that
looks perfect on the canvas and silently drops content on export, so it is worth understanding
before you build anything.

Every email nests in this order:

```
mainFrame                          the root; carries the marker and theme colors
└── section component instance     Header, Hero, Copy block: your library's sections
    └── mj-section
        └── mj-column
            └── mj-text-Frame | mj-image-Frame | mj-button-Frame
                └── the content: a TEXT node, an image RECTANGLE, or an
                    instance of a button style component
```

An `mj-wrapper` may sit above `mj-section` when a section needs a full-width background.

**Rule 1: declare the tag, do not just name the layer after it.** There are two supported
conventions, and you should prefer the first:

- **Metadata (what the plugin itself uses, and the most robust).** Write the MJML tag into the
  `name` key: `node.setSharedPluginData('emaillove', 'name', 'mj-section')`. The layer name is
  then free, so you can label it anything a human will understand ("Report CTA row"). This is
  why the design system's own sections have friendly names like "Hero — FARE Act" and still
  export correctly, and why the docs say you can rename layers without breaking the export.
- **Layer name (the fallback, used when no `name` key exists).** The layer name must resolve to
  the tag on its own, either exactly (`mj-section`) or in the parenthesized form the plugin
  parses (`Report CTA, (mjml:mj-section)`).

The trap sits between the two. `mj-section — Report CTA` with no `name` key fails, because the
entire string is read as the tag and matches nothing. Never append a suffix to a bare tag name;
either set the metadata key or use the parenthesized form.

**Rule 2: content lives in a leaf element frame, never directly in a column.** Button styles
in a design system (for example "Blue Text White") are **sub-components, not sections**. They
carry no email structure of their own, which is deliberate: the team updates the button style
in one place and every email inherits it. A button instance must sit inside an
`mj-button-Frame`, which is what the exporter recognizes. Dropping a button component straight
into an `mj-column` exports nothing. The same holds for text and images, which belong in
`mj-text-Frame` and `mj-image-Frame`.

Because both mistakes are invisible on the canvas, the safest path is to **not hand-build this
scaffold at all**. Duplicate a section that already has the correct structure and replace its
content. Only assemble the hierarchy yourself when no existing section fits, and then copy the
naming from a working section rather than inventing it.

### Do not change the template's foundations

Read these before building and preserve them exactly: the **email width** (the root frame's
width, usually 600 or 640), the **breakpoint**, and the **fonts** already in use. These are
brand decisions someone made, not defaults to improve on.

Fonts deserve specific care. If a font in the file will not load in your environment, do not
substitute a different one to get the edit through. Report that the font was unavailable and
leave the layer as you found it, because a silent swap changes the brand's typography
everywhere it lands and is easy to miss in review.

### Root frame

**Preferred: duplicate an existing Email Love email frame.** The copy carries every plugin
setting with it. But the donor's value is its root settings, not its body, and duplicating
also duplicates its flaws, so vet what you inherit: keep inherited sections only if they are
component instances or an `mj-raw` block. A hand-built section inside the donor (a plain
frame that is not a component instance) is invisible to the exporter and must be replaced
with a library component instance or removed. Freely delete inherited sections you do not
need and instantiate fresh ones from the palette.

**If you create the root frame from scratch,** opt it in with the shared marker, then seed
the six theme colors, because empty color settings silently export with dark-theme defaults:

```js
frame.setSharedPluginData('emaillove', 'nodeType', 'mainFrame')
frame.setSharedPluginData('emaillove', 'backgroundColor', '#ffffff')
frame.setSharedPluginData('emaillove', 'contentColor', '#ffffff')
frame.setSharedPluginData('emaillove', 'textColor', '#000000')
frame.setSharedPluginData('emaillove', 'linkColor', '#000000')
frame.setSharedPluginData('emaillove', 'buttonTextColor', '#ffffff')
frame.setSharedPluginData('emaillove', 'buttonContentColor', '#000000')
```

Those values are for a light email. For a dark email invert them: backgroundColor `#000000`,
contentColor `#1f1f1f`, textColor and linkColor `#ffffff`, buttonTextColor `#000000`,
buttonContentColor `#ffffff`. All stay editable in the plugin's settings panel afterward.
The root should be a top-level vertical auto-layout frame at the design system's email width,
usually 640px.

### Filling the email

- Instantiate from the library palette. Do not settle for whatever sections the donor
  happened to contain.
- Include the `mj-raw` block. If any email frame in the file carries a small frame holding
  ESP tokens like `{{Footer}}`, copy it into every email you build, even when your donor
  lacks one. It is how the ESP footer gets injected.
- Never detach an instance. Change its text instead; detaching severs the structure the
  exporter reads.
- Load fonts before editing text: read the node's current fonts, await the load, then mutate.
  Skipping this is the most common build failure. Get fonts from the text node itself rather
  than assuming.
- One visible CTA button per email unless the user asked for more. Hide competing built-in
  buttons and text links via component properties.
- Imagery: place user-supplied images as fills on the components' image blocks at their
  existing dimensions, watching crop and focal point; the plugin handles hosting at export.
  With nothing supplied, set image blocks to flat gray fills and say so in your report.
- Leave final CTA URLs alone. Links are wired at export time in the plugin.
- Lay out multiple emails side by side, each in its own frame.

### Links, alt text, subject, and preheader

These live in plugin data, so you can set them as you build rather than leaving them all to
the user:

```js
// Link: on the element frame (mj-button-Frame, mj-image-Frame, hero image)
el.setSharedPluginData('emaillove', 'href', 'https://example.com/pricing')
// Alt text: on the same image frame
el.setSharedPluginData('emaillove', 'altText', 'Two-bedroom in Park Slope')
// Subject and preheader: on the ROOT frame
root.setSharedPluginData('emaillove', 'emailSubject', '20% off Premium ends Sunday')
root.setSharedPluginData('emaillove', 'emailPreHeader', 'Use code SPRING20 at checkout')
```

Put `href` and `altText` on the **element frame**, not the nested style component. Element
types are read slightly differently and a couple of them look at the frame's first child
instead, so when you are unsure write the same value to both the frame and its first child.
Extra plugin data on a node nothing reads is harmless.

**Existing values win, and you cannot change them.** The plugin reads its own private data
first and falls back to the shared namespace only when the private value is empty. A link or
alt text a person set by hand in the plugin lives in private data you can neither read nor
overwrite, so your value is silently ignored. Setting these on elements that do not have them
works; "changing" one that does will appear to succeed and do nothing. When a user asks you to
change an existing link, say plainly that they need to change it in the plugin.

Because you cannot verify which nodes already carry private values, treat every link you set as
provisional: list them in your report so the user can spot any that did not take.

### The full element vocabulary

Beyond text, image, and button, the plugin has first-class element types. Use them rather than
imitating them, because a faked element looks right on the canvas and exports wrong:

- `mj-divider` for a horizontal rule. Never fake one with a thin rectangle.
- `mj-spacer` for vertical space. Never fake it with an empty frame.
- `mj-navbar` containing `mj-navbar-link` for a link row.
- `mj-table` containing `mj-table-row` for tabular data.
- `mj-hero` for a hero with a background image.
- `mj-raw` for raw passthrough code, covered below.

If the design system has a component for one of these, instantiate that instead of assembling
the frame by hand; the library version carries styling the raw type does not.

### Custom code sections (mj-raw)

Some content cannot be built from components: ESP-specific markup, Handlebars or merge-field
blocks, dynamic listing or product cards, tracking snippets. For those, build an **mj-raw**
section, which the plugin passes through to the export verbatim.

The structure the exporter looks for is exact:

- A **frame** whose name is `mj-raw`. (The plugin resolves the name from the `name` plugin
  data key first and falls back to the layer name, so naming the layer `mj-raw` is enough.)
- Containing **exactly one text node** as its first child, conventionally named `mj-raw-text`.
- That text node's characters are the raw code, emitted as-is into the email.

Two things that will bite you:

- **The frame must contain that text child.** The exporter reads the first child without
  checking it exists, so an empty `mj-raw` frame breaks the export rather than exporting
  nothing. Never create the frame without its text node.
- **mj-raw content is skipped in the plugin's preview but included in the export.** A raw
  section that looks missing in Preview is usually working correctly. Tell the user this
  when you build one, so they do not report it as a bug.

Keep raw sections small and purposeful. Everything that can be a component should be a
component, because raw blocks skip the plugin's structure handling, mobile styles, and dark
mode entirely. When you add one, say in your report what it contains and that it needs
testing in a real inbox, since hand-written markup is where cross-client rendering breaks.

### Dark mode

The plugin supports per-node dark mode overrides, and they live in the same five keys as the
root frame's theme colors, set on the individual node rather than the root: `contentColor`,
`textColor`, `linkColor`, `buttonContentColor`, `buttonTextColor`. A node carrying any of
these has a deliberate dark mode treatment that someone chose.

Treat existing dark mode settings as read-only. Never clear or overwrite these keys on nodes
that already have them, and do not strip them when you duplicate a donor frame; they should
ride along with the copy. When your build inherits nodes that carry dark mode overrides, say
so in your report and name the sections, so the user knows what is already handled and what
still needs a designer.

If the user explicitly asks you to set dark mode on a section, write those keys on that node
and tell them to verify in the plugin's dark mode preview, because dark mode rendering varies
enough across clients that it warrants a human check.

### Writing the content

Write like a person, not a template. Front-load the value in the first section, keep one
primary CTA, make everything scannable. For sequences, each email must escalate or advance
the story; if two emails in one recipient's path repeat a theme, rewrite the later one to
build on the first. Match the brand voice from existing copy in the file. Never use em
dashes. Never invent statistics; flag any placeholder figures clearly.

## Step 5: Verify before you hand off

Screenshot every email you built and inspect it for clipped text, overlapping elements, and
spacing consistent with the file's real campaigns. Then check structure programmatically:

- Root frame is a duplicated Email Love frame, or carries the shared marker plus theme colors.
- Every section is a component instance, `mj-raw` excepted. This includes inherited ones: no
  hand-built frames survived the donor vetting.
- The `mj-raw` block is present if any email in the file has one, and every `mj-raw` frame you
  created contains its text child.
- Dark mode overrides on inherited nodes are intact, not cleared.
- No detached instances.
- Exactly one visible CTA button per email, unless the user asked otherwise.

Fix what fails before presenting. Report what you built, which components you chose and why,
what you assumed, and anything left as a placeholder.

## Step 6: Hand off

Tell the user to review in Figma and comment like any design work, then select a finished
frame, open the Email Love plugin to set the subject line and preheader, and export to their
ESP. Propose a subject (under 45 characters) and a preheader that extends rather than repeats
it, for every email you built. Building on the canvas is free; exports are what count against
the Free plan.

If the plugin says "Please select valid email template" on a frame you built, the root frame
is missing the marker or the user's plugin predates shared-marker support, so ask them to
update the plugin.
