# Mode: Standard

**Usage**: `/tl standard <sprint_number>`

Use `list_milestones()` to find the milestone with title `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

---

## S1 — Fetch All Stories

Use `list_issues($MILESTONE_ID)` to list all open issues in the milestone. Use `fetch_issue(id)` on each one to read the full body — description, acceptance criteria, and notes.

Also note each story's labels (`story-added`, `story-updated`, `story-removed`) to identify requirement changes.

---

## S2 — Fetch Requirement Context

`list_issues($MILESTONE_ID, labels: ["requirement"])` to find the requirement issue in this milestone.

`fetch_issue(requirement_id)` to read it in full. Hold as **$REQUIREMENT** — use this to understand the sprint goal, the user problem being solved, and what "done" looks like from the PO's perspective.

---

## S3 — Check for Existing TDD

`list_issues($MILESTONE_ID, labels: ["technical-design"])` to check for an existing TDD issue.

- **If no TDD exists**: Continue to S4 (new TDD flow)
- **If TDD exists**: `fetch_issue(tdd_id)` to read it in full. Hold this as the **current TDD** — subsequent steps will produce changes to this document, not a new design from scratch.

---

## S4 — Read the Architecture

-> Follow `_read-architecture.md`

---

## S5 — Resolve Open Questions Before Proceeding

-> Follow `_resolve-questions.md`

---

## S6 — Apply Technical Lead Methodology

-> Follow `_methodology.md` (all 4 stages)

**If existing TDD was found in S3:**
Use the current TDD as your starting document. For each element in Stage 3, evaluate whether the requirement changes affect it:
- **No impact**: Keep existing content unchanged
- **Impact**: Modify only the affected parts

Do not redesign unchanged areas.

---

## S7 — Create or Update TDD Issue

**If no existing TDD (new):**

Use `create_issue(title, body, labels)`:
- **Title**: `Sprint N — Technical Design Document`
- **Body**: full TDD from Stage 4, with `Part of #N` (parent requirement issue) at the very top
- **Labels**: `technical-design` and `tl-reviewed` labels from project config

Capture the new issue number — referenced in S8 and S9.

**If existing TDD (update):**

-> Follow `_tdd-update-triggers.md` to evaluate which sections need changes.

Apply changes to the current TDD document. Sections not affected by requirement changes must be preserved exactly. Then: `update_issue_body(tdd_id, updated_body)`.

---

## S8 — Create Feature Branches (new TDD only)

If this is a new TDD: Create sprint feature branches for each codebase listed in project config.

Skip if updating an existing TDD (branches already exist).

---

## S9 — Update the Requirement Issue (new TDD only)

If this is a new TDD:

Use `update_labels($REQUIREMENT.id, add: [tl-reviewed], remove: [sprint-ready])`

Skip if updating an existing TDD.
