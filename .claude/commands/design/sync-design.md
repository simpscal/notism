# Mode: Requirement Change

Extract `sprint_number` (the token after `sync-design`).

---

## Step 1 — Resolve Sprint Milestone

- Use `list_milestones()` to find the milestone with title `Sprint N`
- Hold its GitHub ID as `$MILESTONE_ID`

If no matching milestone is found, list available milestones and stop.

---

## Step 2 — Fetch All Issues

Call `list_issues($MILESTONE_ID)` once. Partition the result in memory:

- **$STORIES** — issues labelled `user-story`. Use `fetch_issue(id)` on each to read full body, acceptance criteria, and notes.
  - Identify **changed stories**: those with label `story-updated` or `story-removed`.
  - If no changed stories exist, report "No story changes found — design is already in sync" and stop.
- **$REQUIREMENT** — single issue labelled `requirement`. Use `fetch_issue(id)` to read it in full.
- **$DESIGN** — single issue labelled `design` whose title matches `Sprint N — Design Instructions`. Use `fetch_issue(id)` to read it in full. Hold as the **current Design Instructions**.
  - If no Design Instructions issue exists, report "No Design Instructions found for Sprint N — run `/design Sprint N` first" and stop.

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

Apply changes following `_design-structure.md` for structure and token/component conventions. Then: `update_issue_body($DESIGN.id, updated_body)`.
