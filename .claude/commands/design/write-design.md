# Mode: Standard

Use `list_milestones()` to find the milestone with title `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

---

## Step 1 — Resolve Sprint Milestone

Resolve the sprint argument to a GitHub milestone ID:
- Use `list_milestones()` from the tracker adapter
- Find the milestone whose title is `Sprint N`
- Hold its GitHub ID as `$MILESTONE_ID`

If no matching milestone is found, list available milestones and stop.

---

## Step 2 — Fetch All Issues

Call `list_issues($MILESTONE_ID)` once. Partition the result in memory:

- **$STORIES** — issues labelled `user-story`. Use `fetch_issue(id)` on each to read full body, acceptance criteria, and notes. Note each story's labels (`story-added`, `story-updated`, `story-removed`) to identify requirement changes. Identify which stories involve user-facing UI changes — if none do, report "No UI work found in this milestone — skipping design phase" and stop.
- **$REQUIREMENT** — single issue labelled `requirement`. Use `fetch_issue(requirement_id)` to read it in full. Hold as **$REQUIREMENT** — use this to understand the sprint goal, the intended user experience, and the PO's definition of done.
- **$DESIGN** — single issue labelled `design` whose title matches `Sprint N — Design Instructions` (may be absent).
  - **If no Design Instructions exists**: Continue to Step 3 (new Design Instructions flow)
  - **If Design Instructions exists**: `fetch_issue(id)` to read it in full. Hold this as the **current Design Instructions** — subsequent steps will produce changes to this document, not a new design from scratch.

---

## Step 3 — Read the Design System

Read `DESIGN.md` at the repo root in full. This is the authoritative reference for all design tokens, component inventory, and page patterns. Capture exact token names and component names — these will be prescribed in design instructions.

---

## Step 4 — Sketch Layouts

-> Follow `_sketch-layouts.md`

**If existing Design Instructions were found in Step 2:**
Only sketch layouts for UI surfaces affected by requirement changes. Preserve existing layouts for unchanged surfaces.

---

## Step 5 — Design Sprint UI

-> Follow `_design-structure.md` to produce the full design instructions.

**If existing Design Instructions were found in Step 2:**
Use the current Design Instructions as your starting document. For each section, evaluate whether the requirement changes affect it:
- **No impact**: Keep existing content unchanged
- **Impact**: Modify only the affected parts, noting deviations under Consistency Notes

Do not redesign unchanged areas.

---

## Step 6 — Create or Update Design Instructions Issue

**If no existing Design Instructions (new):**

Use `create_issue(title, body, labels, milestone_id)`:

**Title**: `Sprint N — Design Instructions`
**Body**: Use `render_template("issue-design-instructions", {requirement_issue, overview, layout, components, design_tokens, ui_states, responsive, accessibility, consistency_notes})`
**Labels**: `design` (and any design labels from project config)
**Milestone**: `$MILESTONE_ID`

**If existing Design Instructions (update):**

Apply changes to the current Design Instructions document. Sections not affected by requirement changes must be preserved exactly. Then: `update_issue_body(id, updated_body)`.
