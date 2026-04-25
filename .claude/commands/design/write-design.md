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

- **$STORIES** — issues labelled `user-story`. Use `fetch_issue(id)` on each to read full body, acceptance criteria, and notes. Note each story's labels (`story-updated`, `story-removed`) to identify requirement changes. Identify which stories involve user-facing UI changes — if none do, report "No UI work found in this milestone — skipping design phase" and stop.
- **$REQUIREMENT** — single issue labelled `requirement`. Use `fetch_issue(requirement_id)` to read it in full. Hold as **$REQUIREMENT** — use this to understand the sprint goal, the intended user experience, and the PO's definition of done.
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

Use `create_issue(title, body, labels, milestone_id)`:

**Title**: `Sprint N — Design Instructions`
**Body**: Use `render_template("issue-design-instructions", {requirement_issue, overview, layout, components, design_tokens, ui_states, responsive, accessibility, consistency_notes})`
**Labels**: `design` (and any design labels from project config)
**Milestone**: `$MILESTONE_ID`
