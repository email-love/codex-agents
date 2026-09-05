# Changelog

## 4.11.4 - 2026-09-05

Repins the ESP templating skills to esp-skills 1.5.0: all ten gain the shared three-mode
editing contract (edits preserve unrelated HTML byte-for-byte) and structural-only URL
validation (personalized action links are never opened to check them). No other changes.

## 4.11.3 - 2026-09-05

Server-enforced MCP tool boundary (2026-09-05 review, R3; owner-approved).

- The plugin's `emaillove` connection now points at
  `https://mcp.emaillove.com/plugin/mcp`, a trimmed endpoint serving exactly the twelve
  research, conversion, and verification tools (campaign/brand/journey research plus the
  ChatGPT search/fetch aliases, `emaillove_convert_design`, `emaillove_export_figma`,
  `emaillove_preview_email`, `emaillove_validate_email`). No free-form generation tools are
  exposed there; "not a free-form HTML generator" is now enforced by the server's
  tool catalog, not by skill prose. The full `/mcp` endpoint is unchanged for direct users.

## 4.11.2 - 2026-09-05

Codex's own repository review (CLAUDE-HANDOFF-CODEX-IMPROVEMENTS-2026-09-05), applied.

- **Setup by surface (R1):** the README separates the ChatGPT app (connector UI, no shell,
  no assumption the listing carries an integration), Codex CLI public install (add + login),
  and Git install (bundled declaration, login only), and distinguishes unconfigured,
  unauthorized, and unavailable states before prescribing a remedy.
- **Distribution-true metadata (R2):** the Git artifact's starter prompts no longer
  advertise ESP skills its archive does not contain (build-time trim, verifier-asserted);
  the portal artifact keeps them.
- **Completion standard in Builder (R4):** probes the exporter tools before delegating
  verification, and ends every build with exactly one of three evidence-backed states;
  desktop never substitutes for mobile.
- **Alignment summary (R5):** Step 6's checklist line carries the documented multi-column
  top-align exception (the detailed references already did).
- **One release record (R6):** sources.json gitRelease names the supported Git install tag;
  the validator derives the required compatibility command from it instead of a stale
  literal; README, AGENTS.md, and migration guidance all point at the tag released with this version.
- **Release verification plumbing (R7):** CI checks out the pinned esp-skills commit once
  and passes it to both build and verify; ESP byte-equality is required (the verifier clones
  the pin itself when no checkout is supplied) instead of silently skipped; the drift check
  fails hard instead of falling back to claude-skills main.
- **Build safety:** a user-supplied ESP_SKILLS_DIR is validated, never checked out; only the
  build's own temporary clone may be moved.
- Deferred to their own decisions: the live MCP tool-boundary enforcement (R3, owner product
  call) and recorded behavioral runs (R7's second half, the paid-eval lane).

## 4.11.1 - 2026-09-05

Mirror of the claude-skills 1.7.0 usability and consistency pass; safeguards unchanged.

- **Repair routing by measured provenance:** a template whose root marker is missing, wrong,
  or misplaced stays in Repair when any Email Love provenance survives (tags in the subtree,
  wrapper-shaped ancestry, display names, a data-bearing sibling or main component, or a
  history of exporting); only frames with no provenance reroute to Builder, and ambiguity
  gets one focused question before any mutation.
- **Alignment consistency:** the builder's Path B checklist carries the documented
  multi-column top-align exception instead of contradicting the render rules.
- **Migration Phase 0:** the source question is asked only when the source is missing or
  genuinely ambiguous; a named or linked source is confirmed in one line, no menu.
- **SECURITY.md:** documents the optional authenticated Email Love MCP routes (server-side
  conversion, headless export with CDN-hosted images and preview tokens, preview renders,
  research queries) with retention explicitly unknown where undocumented.
- Upstream repinned to the canonical claude-skills 1.7.0 commit.

## 4.11.0 - 2026-09-02

Adds campaign research and source-led Figma AI Import to the existing authenticated Email Love
MCP.

- **One MCP endpoint:** `emaillove` at `https://mcp.emaillove.com/mcp` now supplies campaign
  search, individual email research, brand insights, lifecycle journeys, and the existing
  design-system, headless export, and desktop/mobile preview tools through one connection.
- **Source-led Figma AI Import:** `emaillove_convert_design` accepts a Figma `fileKey` and
  `nodeId` or a screenshot URL, renders source nodes server-side, and returns conversion output
  for agent transcription. Conversion is not a free-form HTML generator.
- **Distribution:** keeps the existing four Email Love workflow skills unchanged and continues
  to stage the ten pinned ESP templating skills into the OpenAI portal skill bundle.
- **Reviewer coverage:** replaces one redundant migration reviewer case with an inspiration
  search case that verifies the MCP returns research rather than generated output.

## 4.10.2 - 2026-08-30

Final cleanup from the second review pass; wording and documentation consistency only.

- **Truthful per-artifact MCP claims:** the skills-only manifest's description now says the
  Email Love MCP is a separately configured connection (the bundled-connection sentence
  stays only in the Git-backed artifact, where it is true), and the verifier asserts both
  claims per artifact. Template repair no longer assumes a bundled server: it distinguishes
  an unconfigured server, one needing authorization, and unavailable tools, and never sends
  an unconfigured installation straight to login.
- **Schema example regression:** the snapshot-schema example's census matches its own
  property list, and the validator self-test parses the example from the Markdown and
  validates it unchanged.
- **Gate 3 prose:** bans UNDOCUMENTED unequal auto-layout axes and names the supported
  `top-aligned-multi-column` exception, matching the validator and schema.

## 4.10.1 - 2026-08-30

Hardens 4.10.0 against an external review's five findings; no new capability.

- **Truthful distribution metadata (F1):** the skills-only portal manifest no longer declares
  `mcpServers` (it ships no `.mcp.json`), the verifier asserts manifest paths resolve inside
  each archive, and the migration skill distinguishes an UNCONFIGURED, UNAUTHORIZED, and
  UNAVAILABLE Email Love MCP instead of assuming a bundled unauthorized connection.
- **Fail-closed snapshot validation (F2):** non-empty module list required for acceptance
  batches; images/groups/properties inventories required even when audited empty and
  cross-checked against a measured node census; unknown or mistyped measurements are errors,
  never silent zeros; malformed input returns a structured error, not a traceback.
- **Documented exceptions honored (F3):** top-aligned multi-column axis pairs are declarable
  via `axisExceptions` and bordered-group width headroom via `borderHeadroom` plus a stated
  reason; undocumented mismatches and unexplained gaps still fail.
- **Icon alpha as heuristic (F4):** four outcomes (pass, needs-review, not-applicable,
  error); a fully opaque asset is not-applicable rather than a false fail; only pass is
  automatic, and approved artwork is never altered to satisfy the heuristic.
- **One proof-batch rule (F5):** the migration entrypoint's eight-module single-batch
  allowance is replaced by the proof-batch gate; a user approval does not substitute for
  missing render evidence.

## 4.10.0 - 2026-08-29

Adds `email-love-figma-quality-gates`, an independent acceptance skill distilled from a real
customer design-system migration run where the documented rules existed but were not enforced
as stop gates, and patches the three existing workflows to hand off to it.

- **New skill:** routes work first (builder vs migration vs repair vs acceptance), then audits
  a batch through ten gates: source authority, proof batch (at most four modules covering
  photo-crop, grouped icon-and-text, multi-column property, and footer/social risks before any
  normal batch), Email Love structure, image and icon assets, a mobile geometry ledger at 320,
  375, and 390px computed against the inner content box (section AND column padding
  subtracted), component-property completeness, canvas QA, production Preview/export, and
  end-user handoff. Reports exactly one of four completion states; a deferred production
  render can never be called complete. Ships two Python validators (`validate_batch_snapshot.py`
  for the JSON audit snapshot, `check_icon_perimeter.py` for clipped icon alpha) with
  self-tests wired into CI.
- **Design-system migration:** batch 1 is a proof batch; every `mj-group` decision records the
  inner-box ledger; the batch gate names the acceptance skill as an independent pass.
- **Builder:** scope escalation is a reroute (library work stops the builder and enters the
  migration workflow), and reusable modules created mid-build get an acceptance offer.
- **Template repair:** four new symptom rows (mobile-only group icon distortion, clipped
  social icons, BOOLEAN false-state holes, color-block image fills); an unproven earlier fix
  is a new repair attempt, never an inherited completion claim.
- **Distribution:** portal skills-only artifact now carries 14 skills (4 repo + 10 ESP); the
  Git-backed artifact carries 4. Upstream repinned to the canonical claude-skills commit;
  shared-rule drift check extended to 43 sentences; two new routing eval cases; Git-backed
  compatibility installs move to the v4.9.0 tag.

## 4.9.0 - 2026-08-23

Ports the quality-gate behavior validated in claude-skills (see sources.json for the canonical
commit) and adds verifiable distribution builds. Codex-specific tool names, `codex mcp login
emaillove` guidance, namespaced skill names, and progress language are unchanged.

- **Template repair:** source fidelity is a boundary (a defect screenshot is symptom evidence;
  visual and structural authority are named separately, and intended geometry never comes from
  the broken canvas when a source exists). A pre-write mutation barrier freezes a compact,
  proportional Repair Contract in three classes - `property_patch`, `instance_replacement`,
  `section_reconstruction` - with escalations re-frozen and explicitly authorized after two
  disproved patches. The diagnostic record separates observations, derivations, and inferences.
  Verification reports five states (canvas desktop, canvas mobile only when a mobile source
  exists, structure, exporter desktop, exporter mobile); an untested viewport is `deferred`,
  never `pass`. New notch/crescent/stepped-seam symptom row compares resolved outer bounds and
  is forward-test-gated.
- **Design-system migration:** a compact batch Fact Pack is frozen before each batch's first
  write (contradictory evidence stops the batch); batch verification is a component-by-breakpoint
  acceptance matrix where `deferred` (consciously postponed, with a reason) is distinct from
  `missing` (never covered - fails the gate); approvals are conversational and scoped to the
  batch; the audit report's Source fidelity section opens with the evidence-authority order
  conversion inherits. One-tree responsive, continuous-surface, and
  no-silent-desktop-simplification are recorded as forward-test-gated preferences with the
  paired-section escape hatch intact.
- **Evals:** five new repair fixtures (wrong-target mapping, late-arriving source evidence,
  binding preservation, missing mobile exporter proof, permitted reconstruction after two
  disproofs); repository validation contract text updated to the new rules.
- **Distribution:** deterministic builds of two clearly separated artifacts - the full
  Git-backed plugin ZIP (includes `.mcp.json`) and the OpenAI portal skills-only ZIP (no
  `.mcp.json`, and no claim of MCP configuration) - with allowlist staging, symlink/traversal/
  executable rejection, two-way source parity, SHA256SUMS, and a byte-identical-rebuild check.
- **CI:** actions pinned to SHAs, `contents: read`, `persist-credentials: false`; adds the
  cross-repository shared-rule drift check against the canonical claude-skills commit and full
  distribution verification. `scripts/check_shared_drift.py` asserts 25 shared rule sentences
  exist in both repositories.

- **ESP skill family in the official ChatGPT plugin (owner decision, 2026-08-23):** the OpenAI
  portal skills-only artifact now bundles the ten release-ready ESP templating skills (Braze
  Liquid, Customer.io Liquid, HubSpot HubL, Iterable Handlebars, Klaviyo Django, Marketo
  Velocity, MoEngage Jinja, Sailthru Zephyr, SFMC AMPscript, Zeta ZML) for thirteen skills
  total. They are staged at BUILD TIME from an email-love/esp-skills checkout verified at the
  commit pinned in sources.json (espSkills lane) and byte-compared by the verifier; they are
  deliberately not committed into this repository, and the full Git-backed artifact stays
  repo-faithful at three skills. esp-skills remains the single canonical home. Every ESP
  description states it works with any email HTML, not only Email Love exports. Manifest
  description, keywords, and starter prompts updated; four routing/collision eval cases added
  (named ESP tasks route to ESP skills, Figma work stays with Builder/Repair, "fix my email"
  asks one clarifying question).

Minor bump: shared behavioral additions to two skills, the ESP capability expansion in the
portal artifact, and new packaging; no breaking changes. Any packaged-byte change requires a
version newer than 4.8.0, and 4.8.0 is never rebuilt.

## 4.8.0 - 2026-08-22

Adds `email-love-template-repair`, a focused third skill for diagnosing and repairing existing
Email Love email templates, reusable modules, and component instances.

- Reproduces the failure across the canvas, plugin Preview, production exporter, mobile render,
  and supplied inbox evidence before making changes.
- Preserves campaign originals by default and requires an explicit impact choice before changing
  a library source component that can update many instances.
- Uses a symptom-to-cause matrix, complete ancestor-chain inspection, and one measured repair at a
  time. A disproven render is reverted, and two failed local patches trigger authoritative section
  reconstruction instead of indefinite tweaking.
- Protects root shape, component attachment, content counts, component properties, tokens, pages,
  and deliberate dark-mode overrides.
- Reports canvas, structure, and exporter states separately. The word `fixed` is reserved for a
  repair where all three states pass on desktop and mobile.
- Adds repair routing and regression fixtures, public submission coverage, repository validation,
  and a Claude handoff specification.

Minor bump: this is a new additive skill. Builder and migration behavior remain unchanged.

## 4.7.0 - 2026-08-10

Port from claude-skills fb96b26 (batch 13): exporter-first discipline from a design-system
build postmortem. Batch reports carry three verification states per module (canvas, structure,
exporter); deferred is a state, never a pass. New repair discipline: measure before restructuring,
never retry a render-disproven change, reconstruct after two local patches, compare property counts
across repairs, and keep a resumable record. Supplied source HTML is authoritative for both
breakpoints (DOM plus media-query inventory before building). The stacking decision is three-way:
group, stack, or recomposed as paired sections under the observed visibility keys, with a mandatory
desktop-versus-mobile comparison for headers and footers. Never create a combined raster from
independently linked assets. `stackColumns` reading back cleanly while the render is wrong joins
read-back-is-not-sufficient.

Minor bump: additive conventions and discipline; nothing removed.

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
