# Mode: Add Story

Extract `req_issue_number` (the token after `add-story`).

---

## Step 1 — Read the Requirement

Read issue `#req_issue_number` in full — title, body, labels, milestone.

Validate:
- If labels do NOT contain `requirement` → stop immediately and output:
  > ⚠️ Cannot proceed: Issue #`<req_issue_number>` does not have a `requirement` label.
- If the issue has no milestone → stop immediately and output:
  > ⚠️ Cannot proceed: Issue #`<req_issue_number>` has no sprint milestone. Run `/ba write-stories <req_issue_number>` first.

Hold the milestone as `$SPRINT_MILESTONE` (title and GitHub ID).

> **Important:** The requirement text itself has NOT changed. This mode adds stories for business rules that were missed during the original breakdown — not for new scope. Do not treat the requirement as modified.

---

## Step 2 — Ask PO for Missing Rules

Use `AskUserQuestion` to open the dialogue:

> "I have loaded requirement #`<req_issue_number>`: **`<title>`**, currently in `<$SPRINT_MILESTONE>`.
>
> Which business rules were missed during story decomposition? Describe each one in plain language — I will analyse them against the existing stories and requirement to write the new stories."

Wait for the PO's response before continuing.

---

## Step 3 — Load Baseline

Read the following in full:
1. The requirement issue body (already read in Step 1).
2. All open issues labelled `user-story` in `$SPRINT_MILESTONE` whose body contains `#req_issue_number`.

Build a **Coverage Snapshot**: one-line summary per existing story of what business behaviour it covers. This baseline is used to ensure new stories do not overlap with existing ones.

---

## Step 4 — Discovery

Analyse the PO's stated rules against the requirement and Coverage Snapshot:

1. **Synthesise first.** For each rule the PO described, state:
   - Your understanding of what it means in user-visible terms
   - Whether any existing story partially covers it (reference by `#issue_number`)
   - Any ambiguity in scope or behaviour

2. **Surface every gap.** Identify:
   - Is each rule fully absent from existing stories, or only partially covered?
   - Are there edge cases or user roles implied by the rule that need their own story?
   - Does any rule conflict with an existing story's ACs?

3. **Open the dialogue.** Ask all blocking questions in one structured message via `AskUserQuestion`:
   - Lead: *"Here is what I understand about each missed rule — please correct anything wrong."*
   - Follow: *"Before I proceed, I need to clarify:"* — list specific questions per rule.
   - Do NOT drip-feed questions one at a time.

4. **Incorporate and iterate.** After each response, re-synthesise. Repeat until every rule is unambiguous and confirmed non-overlapping with existing stories.

5. **Confirm alignment.** State exactly which rules are being added before moving on.

Do not proceed to Step 5 until all rules are fully resolved.

---

## Step 5 — Decompose into INVEST Stories

For each confirmed rule, decompose into the minimum number of user stories needed. Apply INVEST to every story:

| Letter | Criterion | What it means |
|---|---|---|
| **I** | Independent | Can be built and delivered alone |
| **N** | Negotiable | Describes the need, not the spec |
| **V** | Valuable | Delivers something the user actually cares about |
| **E** | Estimable | Clear enough to size |
| **S** | Small | Fits in a sprint increment |
| **T** | Testable | A stakeholder can verify it without reading code |

**Format**: `As a <user>, I want <action> so that <benefit>`

For each story, write ACs immediately:

**AC format**: *"When X, then Y"* or *"Given X, when Y, then Z"*

**AC testability checklist** — every AC must pass:
- Names the specific user-visible area where the change appears (e.g. "in the comment panel", "on the settings page")?
- Observable without reading code?
- Describes a specific condition and a specific outcome?
- Could a non-engineer verify it in a running system?

Rewrite any AC that fails until it passes. Avoid vague language: "should work", "handles errors", "is fast".

Include a **Notes** section per story for: edge cases, UX considerations, dependencies on existing stories (reference by `#issue_number`), open questions.

**Validate the story set:**
- No story duplicates or overlaps with any existing linked story
- No story exceeds the requirement's stated scope
- No gold-plating — every story traces back to a confirmed missed rule
- All inter-story dependencies (new-to-new and new-to-existing) are explicit

---

## Step 6 — Present Story Plan and Gate on PO Approval

Use `AskUserQuestion` to present:

```
## New Stories — Requirement #<req_issue_number>: <title>
Sprint: <$SPRINT_MILESTONE>

**Stories to create** (<count>):

### Story 1: <title>
As a <role>, I want <action> so that <benefit>

**ACs:**
- [ ] <AC 1>
- [ ] <AC 2>

**Notes:** <edge cases, dependencies>

...

**Existing stories NOT affected** (<count>): #N, #N, ...
```

Ask: *"Please confirm this story plan, or specify adjustments before I proceed."*

Do NOT call any mutating operation until the user confirms.

---

## Step 7 — Create Issues

After PO approval:

For each confirmed story:
1. Render the `acceptance-criteria` template with `{criteria, notes}`.
2. Create an issue titled `[Story] <title>` with label `user-story`, where the body comes from the `issue-user-story` template with `{user_story, acceptance_criteria, notes, requirement_issue}` linked to `#req_issue_number`.
3. Set the milestone to `$SPRINT_MILESTONE`.

> **Dependency linking**: Create all issues first, then back-fill dependency references in Notes for both `Depends on` and `Blocks` directions, linking to relevant issue numbers (new or existing).
