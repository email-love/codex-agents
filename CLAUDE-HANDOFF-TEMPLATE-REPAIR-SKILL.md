# Claude handoff: Email Love Template Repair skill

## Objective

Add a focused Email Love Template Repair skill to the Claude plugin. The skill repairs existing
Email Love email templates, reusable modules, and component instances in Figma. It does not build a
new campaign from an ordinary comp and it does not migrate a legacy library.

The Codex implementation is release-ready as plugin version 4.8.0 in
`email-love/codex-agents`. Port the behavior, diagnostic references, routing tests, and release
documentation into `email-love/claude-skills` using Claude-native plugin metadata and Figma tools.

## Codex source files

The authoritative repair behavior is in:

- `plugins/email-love/skills/email-love-template-repair/SKILL.md`
- `plugins/email-love/skills/email-love-template-repair/references/diagnostic-workflow.md`
- `plugins/email-love/skills/email-love-template-repair/references/symptom-cause-matrix.md`
- `plugins/email-love/skills/email-love-template-repair/references/repair-verification.md`

Integration and regression coverage is in:

- `plugins/email-love/.codex-plugin/plugin.json`
- `tests/evals.json`
- `tests/submission-cases.json`
- `scripts/validate_repo.py`
- `README.md`
- `SUBMISSION.md`
- `CHANGELOG.md`

Do not port `agents/openai.yaml`. That file is Codex-specific discovery metadata.

## Required behavior contract

### Trigger only for existing Email Love structures

Use the repair skill when the target is one of these:

- a whole Email Love email with `nodeType = mainFrame`;
- a reusable COMPONENT tagged `mj-wrapper` with no `mainFrame` marker;
- an Email Love component instance whose main component carries valid exporter tags.

Route an ordinary Figma comp or a new campaign to the Claude Figma Builder skill. Route a legacy
library to the Claude Design System Migration skill. A frame that only looks like an email is not a
broken Email Love template.

### Diagnose before writing

Capture the first failing evidence surface separately:

1. Figma canvas.
2. Email Love plugin Preview.
3. Production HTML export.
4. Desktop and mobile production renders.
5. Supplied ESP or inbox evidence.

Walk the complete ancestor chain around the failing node. Check root shape, exact exporter tags,
direct-child relationships, visibility, sizing, padding, alignment, fills, instance boundaries,
mobile metadata, links, images, raw blocks, and component-property bindings.

State one measured hypothesis and its expected desktop and mobile effect before making a change.

### Preserve the original and control impact

- Repair a duplicate campaign root unless the user explicitly authorizes changing the original.
- Before modifying a reusable source component, ask whether to repair it in place or create a
  replacement. In-place repair can update every instance.
- Record node ids, text and image counts, component-property counts, property bindings, and the
  last verified state before writing.
- Never detach instances, rename pages or tokens, change design-system foundations, or clear
  deliberate dark-mode overrides.

### Repair one proven cause at a time

- Make one change, read it back, then render.
- Treat an unchanged read-back as a failed write.
- Treat a clean read-back with a bad render as a disproven hypothesis.
- Revert a disproven change on the working copy.
- After two failed local patches on the same section, stop patching.
- Reconstruct only that section from an intact Email Love component or the customer's own source,
  converter output, and the authoritative Email Love render specification.
- Never invent unknown MJML scaffolding from memory and never flatten a section to hide a defect.

### Respect private plugin data

Shared plugin data cannot override an existing private Email Love value. If a link or another
setting continues to use the private value, stop repeating the shared-data write and direct the
user to the exact Email Love plugin control.

### Use three separate verification states

Report `canvas`, `structure`, and `exporter` as `pass`, `fail`, or `deferred`.

- Canvas: fresh screenshot matches intent with no new visual defect.
- Structure: root, tags, hierarchy, geometry, content counts, instances, properties, links, images,
  raw blocks, and mobile metadata pass read-back checks.
- Exporter: production desktop and mobile renders compile and the reported symptom is gone.

Use the word `fixed` only when all three pass. An unavailable exporter, a private plugin control,
or a client-specific inbox test must remain an explicit handoff, not a silent pass.

## Shared Email Love ground truth

The repair skill should link to the existing Claude builder and converter references rather than
copy the render specification into a second place. Map the Codex references to the equivalent
Claude sources for:

- root shapes and theme keys;
- container geometry and mobile behavior;
- leaf pairs and exact exporter tags;
- component properties and structural validation;
- Path A instance-only rules.

Use the current file names in `email-love/claude-skills`. Do not preserve Codex relative paths if
the Claude repository has a different package layout.

## Claude-specific adaptations

- Replace Codex tool-catalog language with the actual Claude Figma tool names and availability
  checks.
- Preserve the requirement for Figma metadata, screenshots, and write access before promising a
  canvas repair.
- Use the Email Love MCP exporter and preview tools when Claude exposes them. Keep the same
  `operationType: "preview"` no-quota verification path.
- Replace the Codex authorization command with the current Claude connector or MCP authorization
  instructions. Do not tell a Claude user to run `codex mcp login emaillove`.
- Add the new skill to the Claude plugin manifest, discovery metadata, or marketplace files using
  that repository's conventions.
- Keep the repair `SKILL.md` compact and load the three repair references only when the skill
  activates.

## Required routing and regression cases

Add automated cases equivalent to these:

1. Invalid template root: preserve the original, prove email versus module shape, and do not add
   `mainFrame` blindly.
2. Flattened live content: inspect the ancestor chain, avoid freehand reconstruction, and prove the
   text survives production export.
3. Broken mobile header: compare desktop and mobile, choose group, stack, or recomposition from
   evidence, and do not trust metadata read-back over the render.
4. Shared footer component: ask in-place versus replacement before a write and preserve component
   properties.
5. Exporter unavailable: diagnose or apply a narrow repair, report exporter as deferred, and do not
   call it fixed.
6. Ordinary non-Email-Love comp: route to Builder instead of Repair.

Also add one public reviewer case for a campaign where an unrecognized helper frame causes live
content and a button to export as an image.

## Release and documentation updates

- Bump the Claude plugin minor version because this is an additive skill.
- Add Repair beside Builder and Migration in the README, plugin listing, starter prompts, and
  changelog.
- Explain the completion rule: canvas plus structure plus desktop and mobile exporter verification.
- Document that campaign originals are preserved by default and source-component impact requires a
  user choice.
- Keep existing Builder and Migration behavior unchanged.
- Run the Claude repository's skill, plugin, routing, and packaging validators before release.

## Suggested task for Claude

```text
Implement the Email Love Template Repair skill described in
CLAUDE-HANDOFF-TEMPLATE-REPAIR-SKILL.md in the email-love/claude-skills repository.

Use the Codex repair skill and its three references as the behavioral source. Adapt only platform
metadata, tool names, authorization guidance, and relative reference paths for Claude. Add routing
and regression coverage, update plugin and release documentation, validate the package, and show me
the final diff. Do not publish or push until I approve it.
```

## Acceptance checklist

- Repair activates for existing Email Love structures and routes other work correctly.
- Campaign repair preserves the original by default.
- Shared source-component changes require an explicit impact choice.
- The workflow records a baseline, forms one measured hypothesis, and changes one cause at a time.
- Two failed patches trigger authoritative section reconstruction.
- Instances, properties, foundations, content counts, and deliberate dark-mode overrides remain
  protected.
- Canvas, structure, and exporter states are reported separately.
- `fixed` is never used with deferred exporter or inbox verification.
- Builder and Migration regression suites still pass.
