
Implement **one story per invocation** — do not batch.

Check labels on the fetched issue:
- Has `story-updated` → **Revisit branch** — ACs changed after implementation began; implement the delta only.
- Otherwise → **Fresh branch** — full implementation from scratch.

Both branches share Step 1 (context gathering) and Step 4 (dispatch agents). Other steps differ — follow the steps tagged for your branch.

---

## Step 1 — Gather Story Context in Parallel

Run in parallel:

1. **Issue body + comments** — the ticket already fetched (hold it). Extract current ACs.

2. **TDD** *(optional)* — list issues labeled `technical-design` in the milestone. If found, read in full and extract:
   - Problem statement
   - Goals
   - High-level diagram
   - Integration flows (happy + unhappy path)
   - Technology stack
   - Components design
   - Infrastructure design
   - Data models
   - API specification
   - Event schemas
   - Security
   - Failure modes
   - Migration plan
   - Implementation priority

   If no TDD issue exists, note it — subagents will derive scope from the story ACs and the existing codebase.

3. **Design Instructions** (frontend only) — list issues labeled `design` in the milestone. Read it in full — the document covers the entire sprint's UI design.

Add label `in-progress` to the story issue.

---

## Step 2 — Git Setup

**Fresh branch:**

Sprint number N: read from the issue's milestone title (format: `Sprint N`).

Checkout sprint branch for sprint N — one call per codebase path.

For multi-skill stories, run independently in each codebase path.

**Revisit branch:**

For each in-scope codebase, discover the existing PR state:

- List story branches for issue `<N>`.
- **Open PR found** → hold PR number, checkout story branch.
- **No open PR** → find merged PR, hold PR number. If sprint branch does not exist, halt. Create story branch from sprint branch.
- For multi-skill: run independently per codebase path.

---

## Step 3 — [Revisit branch only] Diff Analysis

Fetch PR(s) from Step 2. Produce a **delta summary**:

| Section | Content |
|---------|---------|
| Already implemented / correct | ACs still satisfied — do not change |
| New / changed ACs | ACs in the updated issue not yet satisfied |
| Removed ACs | ACs from original PR no longer in the updated issue |
| TDD delta | TDD drift from current PR — if $TDD loaded |
| Design delta | [frontend] Design drift from current PR — if $DESIGN loaded |
| Affected files | Files already in the PR — do not duplicate work |

Include TDD delta and Design delta only if loaded and drift exists.

---

## Step 4 — Dispatch Agents

Spawn `backend`, `frontend`, and `devops` in a single parallel message. Pass context as a `<context>` XML block per the dispatch-agents protocol.

**Revisit branch:** Include `<constraints>` containing the delta summary and:

```xml
<instruction>Implement the delta only. Do not re-implement ACs already satisfied. Do not modify already-correct files unless an AC explicitly requires a change.</instruction>
```

---

## Step 5 — [Fresh branch only] Git Branch Setup

For each subagent that returned `<no_work>` — skip, no branch needed.

For each subagent that completed work:
- Create story branch for issue `<ISSUE_NUMBER>` and `<short-description>` — one call per codebase path.

---

## Step 6 — Commit and Push

Once all subagents complete, commit and push all changed files from this implementation in each codebase path.

**Fresh branch:** `feat(#<ISSUE_NUMBER>): <imperative-tense description>`

**Revisit branch:** `feat(#<ISSUE_NUMBER>): update <short description> per story change`

---

## Step 7 — Open or Update PR

**Fresh branch:** Create PR for issue `<ISSUE_NUMBER>` — one call per codebase path.
- **PR title:** `feat(#<ISSUE_NUMBER>): <short description>`
- **PR body:** Render the `pr-story` template with `{summary, manual_verification, acceptance_criteria, parent_issue: <ISSUE_NUMBER>, parent_issue_url: $(gh issue view <ISSUE_NUMBER> --json url -q .url)}`

For multi-skill stories, open one PR per skill — each from its own codebase path, each targeting the sprint branch.

**Revisit branch:**
- **Open PR case** — no PR action needed.
- **Merged PR case** — create PR for issue `<N>` targeting the sprint branch — one call per codebase path.

---

## Step 8 — [Revisit branch only] Remove Label

Remove the `story-updated` label from the issue.

---

## Step 9 — Notify

**Fresh branch:** Notify implementation complete.

**Revisit branch:** Notify only in the merged-PR case (the open-PR case has no new PR to announce).
