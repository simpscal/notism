# Mode: Standard

Implement **one ticket per invocation** — do not batch.

---

## Step 1 — Gather Story Context in Parallel

1. **Issue body + comments** — the ticket already fetched in Step 1 (hold it)

2. **TDD** *(optional)* — list issues labeled `technical-design` in the milestone to find it. If found, read in full and extract:
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

3. **Design Instructions** (frontend only) — list issues labeled `design` in the milestone to find the design instructions issue. Read it in full — the document covers the entire sprint's UI design.

Add label `in-progress` to the story issue.

---

## Step 2 — Git Setup

Sprint number N: read from the issue's milestone title (format: `Sprint N`).

Checkout sprint branch for sprint N — one call per codebase path.

For multi-skill stories, run independently in each codebase path.

---

## Step 3 — Dispatch to Skill Subagent

-> Follow `_dispatch-subagent.md`

---

## Step 4 — Git Branch Setup

For each subagent that returned `NO_WORK:` — skip, no branch needed.

For each subagent that completed work:
- Create story branch for issue `<ISSUE_NUMBER>` and `<short-description>` — one call per codebase path

---

## Step 5 — Commit and Push

Once all subagents complete, commit and push all changed files from this implementation in each codebase path.
Commit message: `feat(#<ISSUE_NUMBER>): <imperative-tense description>`.

---

## Step 6 — Open PR

Create PR for issue `<ISSUE_NUMBER>` — one call per codebase path.
- **PR title:** `feat(#<ISSUE_NUMBER>): <short description>`
- **PR body:** Render the `pr-story` template with `{summary, changes, test_command, lint_command, manual_verification, acceptance_criteria, closes}`

For multi-skill stories, open one PR per skill — each from its own codebase path, each targeting the sprint branch.

---

## Step 7 — Notify

-> Follow `_notify-complete.md`
