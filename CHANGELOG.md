# Changelog

## 4.0.0 - 2026-08-02

Ports the migration feature range from Claude commits `cb25519` through `b437b5a`. The
comparison contains 19 feature commits plus upstream status and provenance updates.

- Adds Phase 0 source selection and 12 read-only adapters: Local Folder, Klaviyo, Marketo,
  Customer.io, Google Drive, SharePoint, Brevo, Kit, ActiveCampaign, Iterable, Omnisend, and
  HubSpot. Figma remains the richest source and the default when available.
- Replaces sampled foundations with complete type-ramp, palette, and role-based spacing
  censuses. Audit reports now require dedicated Spacing system and Palette sections that gate
  foundations and every later module batch.
- Requires native whole-design rendering plus deterministic local content-band crops for
  unstructured sources, while every real image asset is still rendered from its own source node.
  Logos retain their intrinsic dimensions.
- Adds the inline shared plugin-data contract and an up-front packaged-reference precondition.
- Fixes Getting Started so its instructions are vertically HUG, unclipped, and accurate about
  editing image fills rather than nonexistent image component properties.
- Adds WCAG contrast reporting for foundations, module-root button label properties, explicit
  node-id violation lists, semantic-token bind counts, spacing-system enforcement, and
  deterministic content-band padding correction.
- Documents the five-link navigation exception to the mobile group rule.
- Adds one exported-HTML sniff test per batch for body width, media queries, mobile classes, and
  column-width sums.
- Adds a final campaign send-readiness pass covering theme keys, subject and preheader, fallback
  fonts, links, alt text, legal address, and unsubscribe behavior.
- Pins upstream provenance to `b437b5a91102b352dadb1df2fffda7d3c6035cf1`, migration tag
  `emaillove-migration-audit-v1.17.0`, and converter tag
  `emaillove-eds-converter-v1.29.0`.

## 3.0.1 - 2026-08-01

Ports two Claude-side commits: model-choice guidance (Claude commit `c0719be`) and Portsmouth
batch 1 defect fixes (Claude commit `0c67f86`).

- Both skills now include model-choice guidance. If your Codex environment lets you pick a
  model tier or reasoning-effort setting, use your strongest for the migration skill and for
  Path B in the builder skill (one-time, high rule-count work). A faster or lower-effort model
  is fine for routine Path A campaign builds against an already-verified design system.
- Migration `module-conversion.md`: Phase 3 step 3 renamed from "Merge the mobile twin" to
  "Decide mobile behavior" and split into Part A (mandatory: record a stacking decision per
  multi-column section) and Part B (conditional: merge the mobile twin if one exists). The
  old wording silently skipped step 3 when there was no mobile twin, which is the common case
  on unstructured legacy sources, and shipped header lockups that stacked on mobile as a
  result.
- Migration `module-conversion.md`: new "A lockup is an mj-group" bullet in the visual-pattern
  section, with three concrete tells (unequal columns with one small and fixed, columns
  sharing a continuous background, header or footer strips). Patterned on the bleed
  concession's recognizing-this-is-its-own-step treatment.
- Migration `module-conversion.md` step 5: mobile check reworded to require an explicit
  stacking decision per multi-column section (empty list is no longer a pass), and the visual
  check now takes a second screenshot at mobile width so group-vs-loose-columns mistakes
  surface visually.
- Migration `foundations.md` step 7 and `module-conversion.md` step 5: wrapper instance sizing
  is FIXED at the target email width, on the component AND on every instance placed in the
  root email frame. R0.3's FILL rule is for frames INSIDE a wrapper, not for the wrapper
  itself.
- Migration `audit.md`: lockup rows added to the recognized build-constraints vocabulary. The
  audit walks the whole library at once and can notice that six header rows across six emails
  are all the same lockup, which the converter cannot, meeting each row alone with only a
  desktop screenshot.

## 3.0.0 - 2026-07-29

- Repackaged the builder and migration workflows as a Git-installable Codex plugin.
- Split the two workflows into focused skills with progressively loaded references.
- Replaced the oversized global `AGENTS.md` installation path with a supported plugin
  marketplace flow.
- Preserved the complete 2.9.0 builder and 1.19.0 migration files as immutable legacy
  snapshots.
- Added official Figma MCP dependencies to both skills.
- Removed the default recommendation to bypass all approvals and sandboxing.
- Added compatibility notices at the old builder and migration `AGENTS.md` paths so stale
  installation commands direct users to the plugin instead of failing silently.
- Pinned the Claude-source provenance to immutable commit
  `d0d88b62656f8c54cc66abb20368546544c110cc`.
- Added repository validation, routing fixtures, CI, and data-handling documentation.

## 2.9.0 - 2026-07-29

- Added the Path B geometry-fidelity decision.
- Distinguished authoritative geometry from reference-only geometry.
- Added canonical content-width handling to prevent changing text margins between modules.

## 2.8.1

- Resolved contradictions in worker padding scale, temporary instance sizing, button sizing,
  and mobile reverse-stack guidance.

## 2.8.0

- Corrected the design converter's scale behavior.
- Added geometry-write readback for nested component instances.
- Documented Figma `query()` limitations for layer names containing spaces.

## 2.7.0

- Added the prescribed Email Love library page structure and semantic token conventions.

## 2.6.0

- Added measurable progress reporting at section and module boundaries.

## 2.5.0

- Required one scale factor across all applicable source measurements and added a type-ratio
  acceptance check.

## 2.4.0

- Added the Two Column Swap for source designs that use image overlap or edge bleed.

## 2.3.4

- Added double-padding detection and source-node image rendering.

## 2.3.3

- Required every measurement to be interpreted at email scale.

## 2.3.1

- Added fallback-font slack for pinned text-bearing columns.

## 2.0.0

- Replaced hand-built `mj-section` and `mj-column` structure with component instances or
  design-converter output.
