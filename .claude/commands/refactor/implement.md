
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

## Step 2 — Check Git State

For each codebase path in **Affected Codebases** (git skill — branch naming pattern is owned by the skill, do not assume it here):
- List refactor branches for issue `<ISSUE_NUMBER>` — check if a refactor branch for this issue exists on remote.
- List open refactor PRs for issue `<ISSUE_NUMBER>` — check for an open PR.
- If a PR is found: fetch the PR (title, body, head branch) and the list of changed files.

Hold per codebase: `$REFACTOR_BRANCH` (head branch name returned by the skill, or `none`), `$PR_URL` (or `none`), `$PR_FILES` (or `none`).

Compute **$EXISTING_PR**: true if any codebase has an open refactor PR for this issue, else false.

---

## Step 3 — Git Setup

Per codebase path in **Affected Codebases**:

- **If $PR_URL is `none` for this codebase**: checkout the default base branch and pull latest (git skill).
- **If $PR_URL is set**: checkout `$REFACTOR_BRANCH` and pull latest (git skill: Checkout Branch).

---

## Step 4 — Dispatch Agents

Spawn only agents matching the **Affected Codebases** field — `backend`, `frontend`, `devops` — in a single parallel message. Pass context as a `<context>` XML block per the dispatch-agents protocol.

Always include in `<context>`:
- Problem Statement
- Scope (full bullet list)
- Technical Approach (full numbered steps — agents follow these exactly)
- Definition of Done items

**If $EXISTING_PR is true**, also include for each affected codebase a `<delta>` block:

| Section | Content |
|---------|---------|
| Already implemented | Files and changes on the branch (derived from `$PR_FILES` and PR body) |
| Aligned with plan | Existing work that still satisfies the current Technical Approach — keep as-is |
| Drifted from plan | Existing work that conflicts with or no longer matches the current Technical Approach — rewrite to align |
| Not yet started | Steps from the Technical Approach not yet reflected in `$PR_FILES` |

Add `<constraints>` with: *"A PR for this refactor already exists. Re-align existing work with the Technical Approach: keep aligned files, rewrite drifted files, add missing steps. Do not re-implement work already aligned with the plan."*

**If $EXISTING_PR is false**, dispatch with full requirements only — no delta.

---

## Step 5 — Git Branch Setup

For each subagent that returned `<no_work>` — skip, no branch action needed.

For each subagent that completed work:
- **If $PR_URL was `none`** for this codebase: create refactor branch for issue `<ISSUE_NUMBER>` (git skill: Create Refactor Branch).
- **If $PR_URL was set**: skip — already on the existing refactor branch.

---

## Step 6 — Commit and Push

Commit and push all changed files in each codebase path.
Commit message: `refactor(#<ISSUE_NUMBER>): <imperative-tense description>`.

---

## Step 7 — Open or Update PR

For each codebase path:
- **If $PR_URL was `none`**: create PR for issue `<ISSUE_NUMBER>` (git skill — base branch resolved by the skill).
  - **PR title:** `refactor(#<ISSUE_NUMBER>): <short description>`
  - **PR body:** Render the `pr-refactor` template with `{problem, parent_issue: <ISSUE_NUMBER>, parent_issue_url: $(gh issue view <ISSUE_NUMBER> --json url -q .url)}`
- **If $PR_URL was set**: no PR action — the push in Step 6 updates the existing PR.

---

## Step 8 — Notify

-> Notify refactor complete
