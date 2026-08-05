# Changelog

## 4.6.1 - 2026-08-05

Corrects the public submission package before the MCP-backed portal upload.

- Replaces stale skills-only wording with the correct skills-and-MCP submission type.
- Updates current install and compatibility examples to the `v4.6.1` release tag.
- Keeps exactly five positive and three negative portal reviewer cases, retaining the new
  headless-export verification case while leaving read-only Figma fallback coverage in the
  internal eval suite.
- Corrects the companion `.mcp.json` to use the required `mcpServers` wrapper and explicit
  HTTP transport, then adds repository checks for that declaration and the portal case counts.
- No runtime skill behavior changed.

## 4.6.0 - 2026-08-05

Bundles the Email Love MCP connection and makes the exporter path self-explanatory.

- The plugin manifest now declares the Email Love MCP (`emaillove`,
  `https://mcp.emaillove.com/mcp`) via `mcpServers`, so installing the plugin registers the
  connection and one `codex mcp login emaillove` authorizes it. No more unexplained manual
  server-add step.
- The migration skill's batch-check gate now treats absent exporter tools as an unauthorized
  connection rather than a missing capability: it hands the user the one-time login step,
  names the sign-in flow (Email Love's normal account screen, shared with the Figma plugin),
  and distinguishes this server from the Email Love inspiration MCP. Ports claude-skills
  converter 1.43.1 (commit 000502d).
- README, SUBMISSION.md, and the reviewer test cases updated for the bundled-MCP submission
  type; adds a sixth positive reviewer case covering headless export verification.
- No workflow or check behavior changed otherwise.

## 4.5.0 - 2026-08-05

Ports claude-skills batch 12 from `eb2cc3a`: source-content parity, typography fidelity,
binding and contrast checks, asset identity, and mandatory per-module screenshots.

- Adds a required `T/I` content census to every audit inventory row: source TEXT nodes and
  image-bearing nodes, including frame backgrounds. Content margins now measure resolved leaf
  positions and report category-level distributions instead of relying on container padding or
  a single average.
- Adds Group 0 as the first module gate. Every source/build pair must match text counts and
  strings, image counts and dimensions, text alignment, and band fills. Only documented optional
  hidden regions, inventory-directed consolidations, and named source-defect fixes may differ.
- Verifies typography family and weight against the audit census and requires each style name to
  match its read-back value. A consistently named ramp no longer passes when its actual weights
  differ from the source.
- Fixes semantic-binding verification for Figma's empty `boundVariables` object by checking
  `.boundVariables?.color`, and adds text-to-nearest-background contrast reporting below 3.0
  without silently altering brand colors.
- Adds asset-identity checks for luminance context, icon-set fidelity, sprite-sheet aspect ratios,
  and `upload_assets` placement. Asset transfer must use `download_assets` and `upload_assets`.
- Requires one fresh desktop screenshot per module and opens every batch report with the Group 0
  source/build parity table.

Pins upstream provenance to `000502dec6215da200995a2367539bf8cc0d93b5`, migration tag
`emaillove-migration-audit-v1.23.0`, converter tag
`emaillove-eds-converter-v1.43.0`, and unchanged builder tag
`emaillove-figma-builder-v2.9.2`.

## 4.4.0 - 2026-08-05

Ports claude-skills batches 10 and 11 from `ab8d3dd`: the corrected dark-mode mechanism,
three library-construction rules, two audit census fixes, and headless exporter verification.

- Corrects the dark CSS mechanism: global `contentColor` paints each module wrapper while
  section and column fills are forced transparent. Module fills are erased rather than
  recolored, producing the same flattened dark-mode surface. Cards do not remain visually
  distinct, and baked image backgrounds are unsafe under forced-light text.
- Gives the inter-module gap one owner library-wide: wrapper `paddingBottom` from the audit's
  spacing ladder, with zero on the final module. Section padding no longer double-serves as
  the space between modules.
- Documents unsupported art behind live card text: `mj-column` has no background-image
  mapping, so use an in-flow `mj-image` with evidence-based BOOLEAN visibility rather than
  baking the card. Adds the fill-less outer column plus filled `mj-column-inner` construction
  for cards that need a gutter.
- Makes the palette census inspect text fills at segment level and makes the asset survey
  search other designs for clean vector instances before prescribing a fused-raster rebuild.
- Runs migration export sniffs headlessly through `emaillove_export_figma` when the Email Love
  MCP exposes it. `operationType: "preview"` charges no export quota, accepts a bare wrapper,
  compiles through the production export pipeline, and returns a token for
  `emaillove_preview_email` mobile QA.
- Keeps the human plugin-Export fallback for an absent tool and for CoverageError nodes outside
  the core tag set. Deferred verification now contains only checks that neither the MCP nor a
  human could run.
- Applies universal render corrections to both the migration and email-builder skills and adds
  an Email Love MCP setup note to the repository documentation.

Pins upstream provenance to `ab8d3dd8451c227afb995802f2c3fa50999d3727`, migration tag
`emaillove-migration-audit-v1.22.0`, converter tag
`emaillove-eds-converter-v1.42.0`, and unchanged builder tag
`emaillove-figma-builder-v2.9.2`.

## 4.3.0 - 2026-08-04

Completes the combined port from claude-skills `fff9223`, spanning verification
consolidation, default text properties, and batches 7 through 9. Version 4.2.0 already
contained batch 6, so this release preserves that published tag and advances the completed
combined state to 4.3.0.

- Consolidates module verification into one ASCII-safe read-back pass evaluated against five
  predicate groups, followed by one desktop screenshot. Mobile render and export sniff now run
  once per batch after provisional upload, with a Deferred verification list when the paid-seat
  plugin clicks cannot run in-session. Libraries of eight or fewer modules may use one batch.
- Chooses direct source-tree reads for authoritative or partial Figma sources with real
  components, auto layout, and target-width frames. Unstructured, flattened, and non-Figma
  sources continue through the design-converter worker.
- Makes customer-facing copy TEXT properties the default, with boilerplate and link-bearing
  text as the exceptions. BOOLEAN and INSTANCE_SWAP remain evidence-gated. Module buttons are
  inline so their labels can be exposed at module-root level.
- Adds the audit and foundations corrections: ASCII-safe metadata chunking, semantic checks for
  apparent `mj-*` structure, type clustering within families, direct source-button measurement,
  Arimo, Gelasio, and Tinos fallback clones, and neutral global `contentColor` proposals.
- Adds the render corrections: two sanctioned content-width exceptions with a band-edge
  invariant, range-write read-back, geometry-first asset masks, local component ids for
  INSTANCE_SWAP, colored spacer fills, narrower and bordered group handling, mobile group
  expansion, and the full-bleed decorative-art group pattern.
- Forbids fills on `mj-group`, because dark-mode CSS does not recolor groups. Band fills now live
  on columns and any filled group fails validation.
- Documents the `manage-preferences.com` injection trap. Only Klaviyo replaces it with a merge
  tag, so preference wording must always carry an explicit safe link.
- Supports single-surface dark treatments as per-node `contentColor` overrides written once on
  the module main component, while keeping the global root value neutral unless most content
  surfaces share the treatment.
- Applies universal render corrections to both the migration and email-builder skills.

Pins upstream provenance to `fff9223a784686bf16efb1aa10983230024609d8`, migration tag
`emaillove-migration-audit-v1.21.0`, converter tag
`emaillove-eds-converter-v1.40.0`, and unchanged builder tag
`emaillove-figma-builder-v2.9.2`.

## 4.2.0 - 2026-08-03

Batch 6 port from claude-skills `23f0d9b`: verified mobile schemas, a complete mobile type
ramp, corrected dark-mode roots, asset transparency, and multi-column top alignment.

- Replaces guessed mobile plugin-data fields with the two observed schemas. Container padding
  uses `mobileStylesPadding*` plus `isPaddingActive = 'true'`; mobile type uses `fontSize` plus
  `fontSize_mode = 'override'` on the inner TEXT node. Read-back proves storage and plugin Preview
  proves effect.
- Makes the audit derive a two-anchor mobile type compression with a 14px floor, records it in a
  required Mobile styles report section, and applies it to every migrated text node.
- Makes Phase 3 mobile work unconditional. Every stacking column except the last receives 28px
  mobile bottom padding, and measured source mobile differences override the default.
- Requires percentage line heights, reapplies line height after range font changes, and checks
  each text node returns one styled line-height segment.
- Corrects the six root theme keys to dark-mode-only values. The light body background now lives
  only in `lightThemeBackgroundColor`; absent brand guidance uses the documented house defaults.
- Treats UI icons and brand logos differently when removing baked backgrounds, and requires a
  contrast check before a logo is made transparent.
- Top-aligns unequal multi-column rows by default while preserving independent horizontal
  alignment through `counterAxisAlignItems`.
- Applies the universal mobile-schema, dark-mode, and multi-column rules to the builder's shared
  render references as well as the migration workflow.

Minor version bump: the audit report gains a required Mobile styles section. Pins upstream
provenance to `23f0d9b508478fa7a0a286209e2c196f25fa60ac`, migration tag
`emaillove-migration-audit-v1.19.0`, and converter tag
`emaillove-eds-converter-v1.35.0`. The builder tag remains
`emaillove-figma-builder-v2.9.2`.

## 4.1.1 - 2026-08-02

Port from claude-skills `e6b532b` (task #52): multi-column gutter guardrail.

Codex built a three-column component with zero column padding during a v4.1.0 shakedown;
geometry validated because zero-gutter columns sum to the content width trivially, but adjacent
card headlines visually concatenated into one sentence. The arithmetic gate could not see it.

Adds a Phase 3 step 5 blocking checklist rule: a section with more than one column and zero
horizontal column padding is a FAIL unless the source design has a measured zero gutter and the
batch report says so. Every multi-column section must list horizontal padding per column and
confirm that at least one side of each internal boundary carries the source gutter.

Adds render rule R3.4.0, generalising R3.4.1's spacing-on-one-side-only rule to every
multi-column row. The named failure signature is concatenated headlines, touching card images,
or a button a pixel from its neighbour. The worked example uses three equal cards in a 560px
content box with a 16px source gutter, expressed as 186.67px column boxes with 8px horizontal
padding on each side. Card width must not be inferred by dividing content width by column count
unless the measured source gutter is zero. R3.4.0 numbering keeps the Two Column Swap at R3.4.1.

Patch bump: the audit report structure is unchanged and partly audited migrations remain
compatible. Pins upstream provenance to `e6b532b2c4b3681fc4a1ac2d2090ec7e87afd2ae`
and converter tag `emaillove-eds-converter-v1.34.0`.

## 4.1.0 - 2026-08-02

Batch port from claude-skills commits `252bc05` through `73e3038`: ten defect fixes
surfaced by a Red Paddle Co end-to-end migration.

- Adds render rule R3.3.2 for `mj-group` columns that shrink proportionally on mobile,
  including the resolved-width formula and per-column text or image requirement. Module
  verification now computes it at 375px, preventing navigation from rendering as
  `CHA / NGI / NG` and `G / E / A / R`.
- Moves mobile visual QA to `emaillove_preview_email` after provisional upload. Figma has
  no mobile breakpoint, so `get_screenshot` at 390px only rescales desktop-shaped pixels.
- Documents the portable `unsubscribe.com` magic link and forbids invented unsubscribe URLs.
- Makes the worker-versus-source split explicit: STRUCTURE from the worker, NUMBERS from
  measurement, with a foundations decision for missing type-ramp steps.
- Adds the cap-height measurement method for settling type sizes against the approved ramp.
- Requires opening every exported PNG before placement and checking baked-in white,
  neighboring content, and accidentally fused rows.
- Checks installed Figma fonts before building the type ramp and uses Arimo when Arial or
  Helvetica is unavailable, with the export consequence reported.
- Maps `mj-navbar` to one reflowing `mj-text` with a hyperlink range per label.
- Extends the audit palette census to cluster by role, including text-node fills, and adds a
  recommended 12px minimum type floor.
- Documents the Cloudflare 403 `error code: 1010` browser User-Agent workaround.

Minor version bump: the audit report structure is unchanged and partly audited migrations
remain compatible. Pins upstream provenance to
`73e30383fd32659975a78667af97410d014aaba0`, migration tag
`emaillove-migration-audit-v1.18.0`, and converter tag
`emaillove-eds-converter-v1.33.2`.

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
