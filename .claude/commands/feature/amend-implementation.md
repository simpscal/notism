
Extract `issue_number` (the token after `amend-implementation`).

---

## Step 1 — Fetch Issue and Determine Type

Read issue `#issue_number` in full. Check labels:

- **`user-story`** → follow the **Story path** throughout
- **`bug-production`** → follow the **Bug path** throughout
- Neither → halt: `⛔ Issue #N is not a user story or bug.`

---

## Step 2 — Load Full Context

**Story path — run all three in parallel:**

1. Hold issue as **$STORY**. Extract: title, user story statement, acceptance criteria, notes, milestone, labels.

2. From `$STORY`'s milestone, find the `technical-design` issue. Read it in full. Hold as **$TDD**. Extract: problem statement, components design, API specification, data models, architecture key decisions, implementation priority.

3. Find the `design` issue in the milestone (may be absent). If present, read it in full. Hold as **$DESIGN**.

**Bug path:**

Hold issue as **$BUG**. Extract: bug report (Description, Steps to Reproduce, Expected Behaviour, Actual Behaviour, Severity), Acceptance Criteria section, any existing investigation comment (Root Cause, Scope, Fix Approach, Risk).

---

## Step 3 — Check Git State

**Story path:**
- List story branches for issue `<N>` — check if story branch exists on remote.
- List open story PRs for issue `<N>` — check for open PR.
- If PR found: fetch list of files changed in that PR.
- Hold: `$STORY_BRANCH`, `$SPRINT_BRANCH`, `$PR_URL` (or "none"), `$PR_FILES` (or "none").

**Bug path:**
- List bugfix branches for issue `<N>` — check if bugfix branch exists on remote.
- List open bugfix PRs for issue `<N>` — check for open PR.
- If PR found: fetch list of files changed in that PR.
- Hold: `$BUG_BRANCH`, `$PR_URL` (or "none"), `$PR_FILES` (or "none").

---

## Step 4 — Reconstruct the Mental Model

Work through all loaded material silently. Produce no output in this step.

**Story path — build understanding from:**

- **$STORY**: story goal, every AC and whether it is clearly testable, unresolved questions in Notes
- **$TDD**: which components need to be created or modified, API endpoints and data model changes, architecture constraints (layering, naming, patterns)
- **$DESIGN** (if present): UI components, layout changes, tokens, states, interactions specified
- **Git state**: has implementation started? open PR? which files already modified?

**Bug path — build understanding from:**

- **$BUG report**: intended behaviour vs actual broken behaviour, what user need the bug fails to satisfy, what "fixed" looks like observably
- **ACs** (if present): conditions and outcomes the fix must satisfy, edge cases specified
- **Investigation comment** (if posted): root cause, fix approach, which layers are touched, assessed risk
- **Git state**: has fix started? open PR? which files already modified?

Complete when: you can state the goal or root cause, name every component or layer involved, describe what already exists on the branch, and assess what still needs to change — without re-reading.

When complete, activate using this format:

> Developer active — #issue_number. Full knowledgebase loaded: [list what was loaded]. Ready to discuss changes or alternatives.

Do not proceed to Step 5 until activation is complete.

---

## Step 5 — Open Amendment Dialog

Ask a single `AskUserQuestion`:

> What changed, and why? Describe the problem with the current implementation and the direction you want to go — or share options you'd like to evaluate.

Hold the response as **$CHANGE_INPUT**. Do not proceed until answered.

Use $CHANGE_INPUT to engage in discussion — answer trade-off questions, surface constraints from the mental model, flag risks from loaded material. Continue iterating until the final direction is confirmed.

---

## Step 6 — Implement

Derive the implementation delta from the confirmed change:

- Restate what needs to change as concrete, testable conditions
- Identify which codebase(s) are in scope (`backend`, `frontend`, `devops`)

**If a branch already exists (open or merged PR found in Step 3):**

Produce a delta summary:

| Section | Content |
|---------|---------|
| Already implemented | What is already on the branch (from PR files + body) |
| New / changed work | What the confirmed change requires that is not yet on the branch |
| Affected files | Files already touched — agents must not duplicate this work |

Spawn agents in a single parallel message. Pass context per the dispatch-agents protocol with `<constraints>` containing the delta summary and the instruction appropriate to the change type:

- Standard delta → "Implement the delta only. Do not re-implement work already on the branch."
- Breaking change → "Replace the affected implementation. Remove or rewrite anything that conflicts before adding new code."
- Structural change → "Full revisit required. Treat affected files as blank slate."

**If no branch exists:**

Spawn `backend`, `frontend`, and `devops` agents in a single parallel message. Pass full requirements and context — no delta constraints.

---

## Step 7 — Commit and Push

Once all agents complete, commit and push changed files in each codebase path.

**Story path:** commit message `feat(#<N>): <short description>`
**Bug path:** commit message `fix(#<N>): <short description>`

---

## Step 8 — Open or Update PR

**Open PR exists** — no PR action needed.

**No open PR (new branch or merged PR case):**

**Story path:** create PR for issue `<N>` targeting the sprint branch — one call per codebase path.
**Bug path:** create PR for issue `<N>` targeting `main` — one call per codebase path.
