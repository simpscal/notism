# Mode: Standard

---

## Step 1 — Load Sprint Context

-> Load Sprint Snapshot for Sprint N (github skill). Hold $MILESTONE_ID, $STORIES, $REQUIREMENT, $TDD, $DESIGN.

**Mode-specific guards** (stop immediately if any fail):
- `$DESIGN` already exists → `Design Instructions already exist for Sprint N — run \`/design sync-design N\` to update.`

Identify stories with user-facing UI changes from `$STORIES`. If none found, report "No UI work found in this milestone — skipping design phase" and stop.

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
