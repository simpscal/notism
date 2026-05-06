# Mode: Requirement Change

Extract `sprint_number` (the token after `sync-design`).

---

## Step 1 — Load Sprint Context

-> Load Sprint Snapshot for Sprint N (github skill). Hold $MILESTONE_ID, $STORIES, $REQUIREMENT, $TDD, $DESIGN.

**Precondition checks** (stop immediately if any fail):

- `$REQUIREMENT` is absent → `⛔ No requirement issue found in Sprint N. Cannot sync design without a requirement.`
- `$STORIES` is empty → `⛔ No user stories found in Sprint N. Run \`/ba write-stories <requirement_issue>\` first.`
- `$DESIGN` is absent → `⛔ No Design Instructions found for Sprint N — run \`/design write-design N\` first.`

Identify **changed stories**: those with label `story-updated` or `story-removed`.
If no changed stories exist, report "No story changes found — design is already in sync" and stop.

---

## Step 3 — Read the Design System

Read `DESIGN.md` at the repo root in full. Capture exact token names and component names.

---

## Step 4 — Classify Scope Changes

For each changed story, determine which UI surfaces are affected and classify the impact:

| Classification | Condition | Planned Action |
|----------------|-----------|----------------|
| **New surface** | Story introduces a UI interface not covered in current Design Instructions | Add new sections and layouts |
| **Modified surface** | `story-updated` story changes behaviour or content on an existing surface | Update affected sections only |
| **Removed surface** | `story-removed` story covered a UI surface that no longer exists | Remove or mark obsolete in design |

Output a **Change Plan Table** listing every affected surface, its changed story, and its classification.

If any classification is ambiguous, ask for clarification before proceeding.

---

## Step 5 — Sketch Layouts for Affected Surfaces

-> Follow `_sketch-layouts.md`

Only sketch layouts for UI surfaces affected by changed stories. Preserve existing layouts for unchanged surfaces.

---

## Step 6 — Update Design Instructions

Use the current Design Instructions as the base document. For each section, evaluate whether the changed stories affect it:

- **No impact**: Keep existing content unchanged
- **Impact**: Modify only the affected parts

Apply changes following `_design-structure.md` for structure and token/component conventions. Then update the body of the design issue with the revised content.
