# Changelog

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
