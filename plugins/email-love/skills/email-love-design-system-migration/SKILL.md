---
name: email-love-design-system-migration
description: Audit and migrate an entire legacy email design system or library into an Email Love Figma design system. Use when the user asks to assess migration readiness, inventory legacy email modules, determine source fidelity or scale, create Email Love foundations, convert a legacy library in batches, or move a whole existing design system into Email Love. The source Figma file remains read-only and all conversion happens in a separate target file. Do not use for building one campaign email; use email-love-figma-builder for that.
---

# Email Love Design System Migration

Audit a legacy email library, establish its trustworthy foundations, and convert it into a
reviewable Email Love design system in a separate Figma target file.

## Non-negotiable boundaries

- Keep the source Figma file read-only at all times.
- Build only in a separate target file.
- Never convert an unaudited library.
- Never convert the entire library in one unreviewed pass.
- Never invent Email Love structure from visual intuition. Use the design-converter worker
  and the packaged render rules.
- Never start conversion while required human gates remain unresolved.
- Never present an individual module as a complete design system.

## Before doing anything

1. Confirm the official remote Figma MCP exposes `use_figma`, `get_metadata`, and
   `get_screenshot`.
2. Before calling `use_figma`, read the Figma MCP's current `figma-use` skill or equivalent
   instructions in full.
3. If `use_figma` is missing, limit work to the read-only audit and a precise migration
   report. Do not promise conversion.
4. Confirm whether the user wants:
   - audit only;
   - foundations only after an accepted audit;
   - a specific conversion batch; or
   - the complete staged migration.
5. Obtain the source file link, and for conversion obtain or create a separate target file
   link.

Do not ask the user to disable the sandbox or bypass all approvals. Use normal tool
approvals. For unattended work, recommend a trusted isolated environment with narrowly
scoped permissions.

## Load references by phase

Read references completely before acting in the corresponding phase:

- **Audit:** [audit.md](references/audit.md)
- **Any run longer than a couple of minutes:** [progress.md](references/progress.md)
- **Conversion entry and gates:** [conversion-overview.md](references/conversion-overview.md)
- **Foundations:** [foundations.md](references/foundations.md)
- **Module batches:** [module-conversion.md](references/module-conversion.md)
- **Before any module transcription, all three render references:**
  - [render-geometry.md](references/render-geometry.md)
  - [render-nodes.md](references/render-nodes.md)
  - [render-components-validation.md](references/render-components-validation.md)

The render references are deliberately split by topic. Search them by rule number (`R0` to
`R9`) or exact tag when re-checking a rule, but read all three completely before the first
module transcription in a run.

## Phase 1: Audit

Read the audit reference, then:

1. Scope every source page and design included.
2. Inventory pages, frames, components, component sets, styles, variables, email widths,
   mobile twins, and repeated modules with read-only calls.
3. Classify source fidelity:
   - **AUTHORITATIVE:** geometry is a deliberate specification.
   - **PARTIAL:** preserve repeated deliberate values and standardize inconsistent ones.
   - **REFERENCE ONLY:** preserve brand, copy, and structure, but build geometry to email
     standards.
4. For AUTHORITATIVE and PARTIAL sources, derive both width and type evidence, select one
   scale factor, apply it consistently, and prove that type ratios survive.
5. Split designs into reusable modules before classifying them.
6. Record the canonical body width, content width, type ramp, spacing, colors, radii,
   buttons, images, and fallbacks.
7. Produce the migration report in the exact structure defined in the audit reference.

Every reported count must come from actual reads. Every judgment must name its evidence.

## Human gate after the audit

Do not begin conversion until the user confirms:

- the migration scope;
- the source-fidelity tier when it involved judgment;
- the scale factor for AUTHORITATIVE or PARTIAL sources;
- any blocking flag affecting how modules will be built.

A missing component source file blocks conversion. A REFERENCE ONLY source does not need a
fabricated scale factor.

## Phase 2: Foundations

Read the conversion overview and foundations references. Build foundations once per
customer, before any module:

- prescribed page structure;
- cover and getting-started guidance;
- two-tier primitive and semantic color variables;
- spacing and radius variables;
- type specimen and text styles;
- button foundations;
- email-template proof root;
- target body and content widths;
- source-specific image and font handling.

Bind component fills to semantic variables, never primitives or raw hex. Keep plugin-data
theme keys literal because variables cannot bind them.

Run the complete foundations checklist before approving batch 1. Do not use module
conversion to patch missing foundations.

## Phase 3: Module conversion

Read the module-conversion reference and all render references.

1. Convert in batches of no more than five modules.
2. Before the first write, name the batch and its module count and give a rough estimate.
3. For each module:
   - read its audit row and build constraints;
   - screenshot the source node at the target email width;
   - send only that customer's source render to the converter;
   - save the returned JSON;
   - transcribe according to the render references;
   - apply the library's foundations and canonical content width;
   - repair known worker limitations;
   - create a reusable `mj-wrapper` component with no `mainFrame` marker;
   - add only evidence-backed component properties;
   - verify and screenshot it.
4. Stop after the batch report for human review.
5. Continue only after the batch is accepted.

Never send a competitor email or Email Love inspiration preview to the converter.

## Progress contract

Follow the exact audit, foundations, batch, stopping, and resumable-state contract in
`progress.md`.

At the start, state the phase, item count, named items, and estimate.

For audit work, report only meaningful completed units such as pages or audit stages. For
conversion, report after each finished module:

> Batch 2, module 3 of 5 done, 60 percent: Testimonial, quote led.

Before every converter request, say that the conversion may take several seconds to roughly
half a minute and that transcription is the longer step. When retrying with `recache=1` or
after a trivial response, say so immediately.

Revise estimates at the next module boundary when pace changes materially.

## Verification

Use the phase checklist and R9 from the references. At minimum verify:

- source file unchanged;
- prescribed target pages present in the correct order;
- foundations and semantic bindings intact;
- one canonical body width and content width;
- module root is a direct-page-child COMPONENT tagged `mj-wrapper`;
- no `nodeType` exists anywhere in a module tree;
- every created node has the exact plugin tag and friendly display name;
- every frame is vertically HUG except `mj-spacer`;
- fixed widths are documented load-bearing cases;
- pinned text widths include fallback slack;
- images use source-node renders with preserved aspect ratios;
- overlaps use the Two Column Swap;
- component-property bindings were read back;
- fresh screenshots match the accepted fidelity tier;
- the batch contains no unreviewed modules beyond its declared scope.

Fix failures before presenting a batch.

## Final handoff

Deliver:

- the audit and accepted human decisions;
- foundations created;
- modules converted by batch;
- concessions and placeholders;
- categories and component properties;
- known limitations;
- verification results;
- the exact Email Love plugin upload sequence;
- a recommendation to assemble one real sample email, export it, and send an inbox test.

Never use an em dash in module copy, Figma layer names, or plugin-data values.
