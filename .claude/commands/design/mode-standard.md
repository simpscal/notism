# Mode: Standard

**Usage**: `/design standard <sprint_number>`

Use `list_milestones()` to find the milestone with title `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

---

## S1 — Resolve Sprint Milestone

Resolve the sprint argument to a GitHub milestone ID:
- Use `list_milestones()` from the tracker adapter
- Find the milestone whose title is `Sprint N`
- Hold its GitHub ID as `$MILESTONE_ID`

If no matching milestone is found, list available milestones and stop.

---

## S2 — Fetch Sprint Context

Use `list_issues($MILESTONE_ID)` to list all issues in the milestone. Use `fetch_issue(id)` on each one to read it in full — body, acceptance criteria, and notes.

Also note each story's labels (`story-added`, `story-updated`, `story-removed`) to identify requirement changes.

Identify which stories involve user-facing UI changes by reading their descriptions and acceptance criteria. If no stories involve UI changes, report "No UI work found in this milestone — skipping design phase" and stop.

---

## S3 — Fetch Requirement Context

`list_issues($MILESTONE_ID, labels: ["requirement"])` to find the requirement issue in this milestone.

`fetch_issue(requirement_id)` to read it in full. Hold as **$REQUIREMENT** — use this to understand the sprint goal, the intended user experience, and the PO's definition of done.

---

## S4 — Check for Existing Design Instructions

Use `list_issues($MILESTONE_ID, labels: ["design-reviewed"])` to check for an existing Design Instructions issue whose title matches `Sprint N — Design Instructions`.

- **If no Design Instructions exists**: Continue to S5 (new Design Instructions flow)
- **If Design Instructions exists**: `fetch_issue(id)` to read it in full. Hold this as the **current Design Instructions** — subsequent steps will produce changes to this document, not a new design from scratch.

---

## S5 — Read the Design System

-> Follow `_read-design-system.md`

---

## S6 — Sketch Layouts

-> Follow `_sketch-layouts.md`

**If existing Design Instructions were found in S4:**
Only sketch layouts for UI surfaces affected by requirement changes. Preserve existing layouts for unchanged surfaces.

---

## S7 — Design Sprint UI

-> Follow `_design-structure.md` to produce the full design instructions.

**If existing Design Instructions were found in S4:**
Use the current Design Instructions as your starting document. For each section, evaluate whether the requirement changes affect it:
- **No impact**: Keep existing content unchanged
- **Impact**: Modify only the affected parts, noting deviations under Consistency Notes

Do not redesign unchanged areas.

---

## S8 — Create or Update Design Instructions Issue

**If no existing Design Instructions (new):**

Use `create_issue(title, body, labels, milestone_id)`:

**Title**: `Sprint N — Design Instructions`
**Body**: Use `issue-design-instructions.md`
**Labels**: `design-reviewed` (and any design labels from project config)
**Milestone**: `$MILESTONE_ID`

**If existing Design Instructions (update):**

Apply changes to the current Design Instructions document. Sections not affected by requirement changes must be preserved exactly. Then: `update_issue_body(id, updated_body)`.
