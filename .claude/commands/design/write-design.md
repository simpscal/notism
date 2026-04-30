# Mode: Standard

List all milestones to find the one titled `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

---

## Step 1 — Resolve Sprint Milestone

Resolve the sprint argument to a GitHub milestone ID:
- List all milestones from the tracker adapter
- Find the milestone whose title is `Sprint N`
- Hold its GitHub ID as `$MILESTONE_ID`

If no matching milestone is found, list available milestones and stop.

---

## Step 2 — Fetch All Issues

List all issues in the sprint milestone once. Partition the result in memory:

- **$STORIES** — issues labelled `user-story`. Read each in full — body, acceptance criteria, and notes. Note each story's labels (`story-updated`, `story-removed`) to identify requirement changes. Identify which stories involve user-facing UI changes — if none do, report "No UI work found in this milestone — skipping design phase" and stop.
- **$REQUIREMENT** — single issue labelled `requirement`. Read it in full. Hold as **$REQUIREMENT** — use this to understand the sprint goal, the intended user experience, and the PO's definition of done.
- **$DESIGN** — single issue labelled `design` whose title matches `Sprint N — Design Instructions` (may be absent). If one already exists, report "Design Instructions already exist for Sprint N — run `/design sync Sprint N` to update" and stop.

---

## Step 3 — Read the Design System

Read `DESIGN.md` at the repo root in full. This is the authoritative reference for all design tokens, component inventory, and page patterns. Capture exact token names and component names — these will be prescribed in design instructions.

---

## Step 4 — Sketch Layouts

-> Follow `_sketch-layouts.md`

---

## Step 5 — Design Sprint UI

-> Follow `_design-structure.md` to produce the full design instructions.

---

## Step 6 — Create Design Instructions Issue

Create an issue:

**Title**: `Sprint N — Design Instructions`
**Body**: Render the `issue-design-instructions` template with `{requirement_issue, overview, layout, components, design_tokens, ui_states, responsive, accessibility, consistency_notes}`
**Labels**: `design`
**Milestone**: `$MILESTONE_ID`
