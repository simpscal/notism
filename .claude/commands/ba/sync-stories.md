# Mode: Requirement Change

Extract `req_issue_number` (the token after `sync-stories`).

---

## Step 1 — Read Current Requirement

1. `fetch_issue(req_issue_number)` to read the requirement body in full.
2. Extract the **Goals** section for scope comparison.

---

## Step 2 — Fetch All Relevant Stories

1. Determine the requirement's sprint milestone by checking `req_issue_number`'s milestone field.
2. `list_issues(milestone_id: <sprint_milestone>, labels: ["user-story"], state: "open")` to fetch all open user stories in the current sprint.
3. Filter for **Linked stories**: Stories with `link_to(req_issue_number)` or `#req_issue_number` in body.
4. `fetch_issue` each one to read full body and current state.
5. **Safety check**: If any linked story has label `story-removed` and state `open`, stop immediately and output:
   > ⚠️ Cannot proceed: Story #<number> is labeled `story-removed` but still open. Dev must revert this orphaned work before new requirement changes can be processed.

---

## Step 3 — Classify Scope Changes

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

## Step 4 — Clarify with PO

For any classified scope change that is ambiguous, run a full discovery session:

1. **Synthesise first.** State your current understanding of the scope delta — what changed, what's new, what's removed.

2. **Surface every gap.** Identify ambiguities in classification, conflicting signals, and missing context that would materially change which stories are created, updated, or removed.

3. **Open the dialogue.** Ask all blocking questions in one structured message:
   - Lead: *"Here is what I understand — please correct anything wrong."*
   - Follow: *"Before I proceed, I need to clarify:"* — list specific questions.
   - Do NOT drip-feed questions one at a time.

4. **Incorporate and iterate.** After each response, re-synthesise. Repeat until fully unambiguous.

5. **Confirm alignment.** State final understanding before producing output.

Do not proceed to execution until all classifications are clear.

---

## Step 5 — Present Change Plan

Use `AskUserQuestion` to present the complete change plan:

**Stories to update:**
- List each story to update with summary of AC changes

**Stories to create:**
- List each new story title and scope it covers

**Stories to remove:**
- List each story to be labeled as removed (including orphaned)

Get explicit PO approval: *"Please confirm this change plan, or specify adjustments."*

---

## Step 6 — Execute Changes

Execute the approved change plan in order:

### 1. Update Existing Stories

For each **Updatable** story:
1. Run the AC amendment flow (classify changes, present plan, get approval, execute)
2. Rewrite `## Acceptance Criteria` with updated AC set
3. Update `## Notes` for new edge cases/dependencies
4. `update_issue_body(story_id, updated_body)`
5. If story has label `implemented`: `update_labels(story_id, add: ["story-updated"], remove: [])`
6. Validate the amended story (no contradictions, complete coverage, every AC testable)

### 2. Create New Stories

For each **New** scope item:
1. If ambiguity exists, run a discovery session
2. Decompose into INVEST-compliant user stories:

   | Letter | Criterion | What it means |
   |---|---|---|
   | **I** | Independent | Can be built and delivered alone |
   | **N** | Negotiable | Describes the need, not the spec |
   | **V** | Valuable | Delivers something the user actually cares about |
   | **E** | Estimable | Clear enough to size |
   | **S** | Small | Fits in a sprint increment |
   | **T** | Testable | A stakeholder can verify it without reading code |

   **Story format**: `As a <user>, I want <action> so that <benefit>`

3. Write ACs for each story. **AC format**: *"When X, then Y"* or *"Given X, when Y, then Z"*

   **AC testability checklist** — every AC must pass:
   - Observable without reading code?
   - Describes a specific condition and a specific outcome?
   - Could a non-engineer verify it in a running system?

   Include a **Notes** section for edge cases, dependencies, constraints.

4. Use `render_template("acceptance-criteria", {criteria, notes})` for each story
5. `create_issue("[Story] <title>", body, ["user-story"], milestone_id)` where body comes from `render_template("issue-user-story", {user_story, acceptance_criteria, notes, requirement_issue})` linked to `req_issue_number`
6. Create all issues first, then back-fill `link_to(id)` references in Notes for dependency links

### 3. Remove Obsolete Stories

For each **Removed** or **Orphaned** story:
- If story has label `implemented`: `update_labels(story_id, add: ["story-removed"], remove: [])`
- If story does NOT have label `implemented`: `close_issue(story_id)`

Do not modify the issue body — the label signals removal.

---

## Constraints

- Never add technical details to stories — that is the architect's job
- Never invent scope — if unclear, run discovery
- Never produce tracker output until the user confirms the picture is correct
- Output is format-agnostic — produce clean markdown the user can paste wherever they need it
- Every AC must be observable without reading code, describe a specific condition and outcome, and be verifiable by a non-engineer in a running system
