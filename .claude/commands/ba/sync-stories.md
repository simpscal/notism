# Mode: Sync Stories

Extract `req_issue_number` (the token after `sync-stories`).

---

## Step 1 — Read Current Requirement

1. Read issue `#req_issue_number` in full.
2. Extract the **Goals** section for scope comparison.

---

## Step 2 — Fetch All Relevant Stories

1. Determine the requirement's sprint milestone by checking `req_issue_number`'s milestone field.
2. List open issues labeled `user-story` in the sprint milestone to fetch all open user stories.
3. Filter for **Linked stories**: Stories with `#req_issue_number` referenced in the body.
4. Read each linked story in full to get its body and current state.
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

### 0. Prune Stale Dependencies (All Stories)

Before any other changes, scan all open story issues involved in this sync. Remove any `Depends on:` or `Blocks:` reference that points to a closed issue. Keep dependency lists accurate.

### 1. Update Existing Stories

For each **Updatable** story:
1. Run the AC amendment flow (classify changes, present plan, get approval, execute)
2. Rewrite `## Acceptance Criteria` with updated AC set
3. Update `## Notes` for new edge cases/dependencies
4. **Prune stale dependencies.** Scan `Depends on:` and `Blocks:` lines — any reference to a closed issue must be removed. Dependency lists must only reference active (open) issues.
5. Update the body of the story issue with the amended content.
6. If story has label `implemented`: add label `story-updated` to the story issue.
7. Validate the amended story (no contradictions, complete coverage, every AC testable)

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
   - Names the specific user-visible area where the change appears (e.g. "in the comment panel", "on the settings page")?
   - Observable without reading code?
   - Describes a specific condition and a specific outcome?
   - Could a non-engineer verify it in a running system?

   Include a **Notes** section for edge cases, dependencies, constraints.

4. Render the `acceptance-criteria` template with `{criteria, notes}` for each story.
5. Create an issue titled `[Story] <title>` with label `user-story` and the sprint milestone, where the body comes from the `issue-user-story` template with `{user_story, acceptance_criteria, notes, requirement_issue}` linked to `#req_issue_number`.
6. Create all issues first, then back-fill dependency references in Notes for both `Depends on` and `Blocks` directions.

### 3. Remove Obsolete Stories

For each **Removed** or **Orphaned** story:
- If story has label `implemented`: add label `story-removed` to the story issue.
- If story does NOT have label `implemented`: close the story issue.

Do not modify the issue body — the label signals removal.

---

