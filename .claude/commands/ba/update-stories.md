# Mode: Requirement Change

**Usage**: `/ba requirement-change <requirement_issue_number>`

Extract `req_issue_number` (the token after `requirement-change`).

---

## RC1 — Read Current Requirement

1. `fetch_issue(req_issue_number)` to read the requirement body in full.
2. Extract the **Goals** section for scope comparison.

---

## RC2 — Fetch All Relevant Stories

1. Determine the requirement's sprint milestone by checking `req_issue_number`'s milestone field.
2. `list_issues(milestone_id: <sprint_milestone>, labels: ["user-story"], state: "open")` to fetch all open user stories in the current sprint.
3. Filter for **Linked stories**: Stories with `link_to(req_issue_number)` or `#req_issue_number` in body.
4. `fetch_issue` each one to read full body and current state.
5. **Safety check**: If any linked story has label `story-removed` and state `open`, stop immediately and output:
   > ⚠️ Cannot proceed: Story #<number> is labeled `story-removed` but still open. Dev must revert this orphaned work before new requirement changes can be processed.

---

## RC2.5 — Clean Previous Change Labels

For all linked stories fetched in RC2:
- `update_labels(story_id, add: [], remove: ["story-added", "story-updated"])`

This resets change tracking labels before applying new classifications. `story-removed` labels are preserved (and block via RC2 safety check).

---

## RC3 — Classify Scope Changes

Compare the requirement's Goals against linked stories only. For each scope item AND each linked story, apply this classification:

| Classification | Condition | Planned Action |
|----------------|-----------|----------------|
| **Covered** | Linked story fully covers scope item | No change needed |
| **Updatable** | Linked story partially covers scope | Update story ACs |
| **New** | No existing story covers scope | Create new story |
| **Removed** | Linked story covers scope no longer in requirement | Label `story-removed` |
| **Orphaned** | Linked story doesn't match any current scope | Label `story-removed` |

Output a **Change Plan Table** listing every scope item and affected story with its classification.

---

## RC4 — Clarify with PO

For any classified scope change that is ambiguous:
-> Follow `_discovery.md`

Do not proceed to execution until all classifications are clear.

---

## RC5 — Present Change Plan

Use `AskUserQuestion` to present the complete change plan:

**Stories to update:**
- List each story to update with summary of AC changes

**Stories to create:**
- List each new story title and scope it covers

**Stories to remove:**
- List each story to be labeled as removed (including orphaned)

Get explicit PO approval: *"Please confirm this change plan, or specify adjustments."*

---

## RC6 — Execute Changes

Execute the approved change plan in order:

### 1. Update Existing Stories

For each **Updatable** story:
1. Follow AC update flow per `_ac-classification.md`
2. Rewrite `## Acceptance Criteria` with updated AC set
3. Update `## Notes` for new edge cases/dependencies
4. `update_issue_body(story_id, updated_body)`
5. If story has `## Implementation Complete` comment: `update_labels(story_id, add: ["story-updated"], remove: [])`
6. -> Follow `_validation.md` (Amended Story Validation)

### 2. Create New Stories

For each **New** scope item:
1. If ambiguity exists: -> Follow `_discovery.md`
2. Decompose into stories using INVEST framework:

| I | Independent — can be built/delivered alone |
| N | Negotiable — describes need, not spec |
| V | Valuable — delivers something user cares about |
| E | Estimable — clear enough to size |
| S | Small — fits in sprint increment |
| T | Testable — stakeholder can verify without reading code |

**Format**: `As a <user>, I want <action> so that <benefit>`

3. Fill in `acceptance-criteria.md` for each story
4. Include **Notes** section for edge cases, dependencies, constraints
5. `create_issue("[Story] <title>", body, ["user-story", "story-added"], milestone_id)` using `issue-user-story.md` and link to `req_issue_number`
6. Create all issues first, then back-fill `link_to(id)` references in Notes for dependency links

### 3. Remove Obsolete Stories

For each **Removed** or **Orphaned** story:
- `update_labels(story_id, add: ["story-removed"], remove: [])`

Do not modify the issue body — the label signals removal.
