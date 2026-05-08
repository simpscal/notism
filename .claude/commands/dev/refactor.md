# Mode: Refactor

---

## Step 1 — Fetch Issue

Fetch the issue. Guard: must have `refactoring` label — if absent, stop with:
> Error: Issue does not have the `refactoring` label. This mode is for refactoring tasks only.

Extract from the issue body:
- **Problem Statement**
- **Scope** (bullet list of files / modules / layers)
- **Technical Approach** (numbered steps)
- **Affected Codebases** (backend / frontend / infrastructure)
- **Definition of Done** (checklist items)

Add label `in-progress` to the issue.

---

## Step 2 — Git Setup

Refactoring tasks branch from `main` — there is no sprint milestone.

Checkout `main` and pull latest — one call per codebase path listed in **Affected Codebases**.

---

## Step 3 — Dispatch Agents

Spawn only agents matching the **Affected Codebases** field — `backend`, `frontend`, `devops` — in a single parallel message. Pass context as a `<context>` XML block per the dispatch-agents protocol.

Include in context:
- Problem Statement
- Scope (full bullet list)
- Technical Approach (full numbered steps — agents follow these exactly)
- Definition of Done items

---

## Step 4 — Git Branch Setup

For each subagent that returned `<no_work>` — skip, no branch needed.

For each subagent that completed work:
- Create refactor branch for issue `<ISSUE_NUMBER>` — one call per codebase path (git skill: Create Refactor Branch)

---

## Step 5 — Commit and Push

Commit and push all changed files in each codebase path.
Commit message: `refactor(#<ISSUE_NUMBER>): <imperative-tense description>`.

---

## Step 6 — Open PR

Create PR for issue `<ISSUE_NUMBER>` — one call per codebase path.
- **PR title:** `refactor(#<ISSUE_NUMBER>): <short description>`
- **PR body:** Render the `pr-refactor` template with `{problem}`
- **Target branch:** `main`

---

## Step 7 — Notify

-> Notify refactor complete