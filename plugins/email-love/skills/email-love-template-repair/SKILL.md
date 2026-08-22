---
name: email-love-template-repair
description: Diagnose and repair an existing Email Love email template or reusable module in Figma when the plugin rejects it, the canvas and export disagree, content flattens into images, Outlook clips text, mobile stacking or spacing is wrong, links or images fail, dark mode breaks, or component properties stop working. Use for targeted repair of Email Love structures that already exist. Do not use to create a new campaign, convert an ordinary Figma comp, or migrate a legacy library; route those to email-love-figma-builder or email-love-design-system-migration.
---

# Email Love Template Repair

Repair the smallest proven defect in an existing Email Love template or module, preserve what
already works, and verify the result through the production exporter before calling it fixed.

## Non-negotiable boundaries

- Diagnose before writing. Reproduce the reported failure and identify the node, breakpoint,
  and mechanism.
- Preserve the original. For a campaign template, repair a duplicate unless the user explicitly
  authorizes editing the original. For a library module, ask whether to repair the source component
  in place, which updates its instances, or create a replacement.
- Never detach an instance, rewrite design-system foundations, rename pages or tokens, or clear
  deliberate dark-mode overrides.
- Never build unknown `mj-section`, `mj-column`, or leaf scaffolding from memory. Replace a broken
  component with an intact library instance, or reconstruct converter-built structure strictly from
  the packaged render contract.
- Never treat a clean plugin-data read-back or a good canvas screenshot as proof of a good email.
  Desktop and mobile exporter renders are the arbiter.
- Never say `fixed` when exporter verification is deferred. Say exactly what remains unverified.

## Route the request

Confirm that the target is already an Email Love structure:

- A whole email has a root with `nodeType = mainFrame` and Email Love wrappers below it.
- A reusable module is a COMPONENT tagged `mj-wrapper` and carries no `mainFrame` marker.
- An Email Love component instance surfaces its main component's plugin data.

If none of those is true, stop. Use `email-love-figma-builder` for one ordinary Figma comp or new
campaign, and `email-love-design-system-migration` for a legacy library. A random frame that merely
looks like an email is not a broken Email Love template.

## Check the tools

Before promising a repair, confirm the Figma tool catalog includes `use_figma`, `get_metadata`, and
`get_screenshot`. If `use_figma` is absent, perform read-only diagnosis and give the user an exact
handoff; do not promise a canvas fix.

Probe for `emaillove_export_figma` and `emaillove_preview_email` before deferring export checks. If
the bundled Email Love MCP needs authorization, tell the user to run `codex mcp login emaillove`,
then start a new task. A missing or unauthorized exporter makes the exporter state `deferred`, not
`pass`.

## Load the repair references

Read these three repair references for every task:

- [Diagnostic workflow](references/diagnostic-workflow.md)
- [Symptom and cause matrix](references/symptom-cause-matrix.md)
- [Repair verification and report](references/repair-verification.md)

Load the shared exporter ground truth before any structural repair:

- [Shared Email Love rules](../email-love-figma-builder/references/shared-rules.md)
- [Geometry and root shapes](../email-love-figma-builder/references/render-geometry.md)
- [Container and leaf mappings](../email-love-figma-builder/references/render-nodes.md)
- [Components and validation](../email-love-figma-builder/references/render-components-validation.md)

When the target is composed from design-system instances, also read
[Path A](../email-love-figma-builder/references/path-a.md). Do not open instance internals to
repair them. Replace the instance or fix the source component under the user's chosen scope.

## Run the repair

### 1. Capture the failure

Record the file, page, target node id, root shape, reported symptom, affected breakpoint or email
client, and whether the issue appears on the canvas, in plugin Preview, in exported HTML, or only
after ESP delivery. Save a before screenshot and exporter render when available.

For HTML supplied by the user or exported by the plugin, treat the HTML as authoritative for the
structure it contains. Inspect its desktop DOM and mobile media behavior separately. A screenshot
does not overrule supplied HTML.

### 2. Protect the working state

For a campaign, duplicate the whole email root and name the copy `Repair working copy - <name>`.
Keep the original untouched. Record the new root id.

For a module or main component, stop before the first write and settle impact with the user:
repairing the source in place changes every instance; a replacement changes none until swapped.
Never make that choice silently.

Record node ids, component-property counts, property bindings, and the last verified state. This is
the resumable record if the task is interrupted.

### 3. Form one measured hypothesis

Use the symptom matrix to identify the narrowest plausible mechanism. Inspect the complete ancestor
chain around the failing node, not only the visible leaf. State the evidence and expected render
change before writing.

Apply one repair at a time. Read every geometry write back. Re-read
`componentPropertyReferences` and compare property counts after structural changes. Shared plugin
data cannot override an existing private plugin value; when private data wins, direct the user to
the exact Email Love plugin control instead of repeating a write that cannot land.

### 4. Escalate instead of patching indefinitely

If a rendered result disproves a change, revert that change on the working copy and do not repeat
the same idea elsewhere. After two failed local patches on the same section, stop patching.

Reconstruct only that section from an intact Email Love component or, when it was converter-built,
from the user's own source plus the converter and packaged render rules. Never flatten a section or
rebuild it from memory to make the symptom disappear.

### 5. Verify all three states

Run the verification reference. A repair is complete only when all three are `pass`:

- `canvas`: the Figma screenshot matches the intended design;
- `structure`: the root, tags, geometry, bindings, and content checks pass;
- `exporter`: both desktop and mobile production renders pass.

If the issue was reported in a named inbox client or ESP, exporter Preview is necessary but may not
be sufficient. State when a real inbox or ESP test still belongs to the user.

## Progress contract

Before the first write, tell the user which target and copy you will repair, the suspected class of
failure, and a rough range in minutes. Update only at these boundaries:

1. Failure reproduced and baseline captured.
2. Structural repair applied and read back.
3. Desktop and mobile exporter verification completed or explicitly deferred.

Revise the estimate when the evidence changes the repair scope.

## Hand off

Return the repair report from the verification reference. Include the original and working-copy
node ids, the proven cause, every node changed, before and after evidence, the three verification
states, any private-data or inbox-test handoff, and whether the original remained untouched.
