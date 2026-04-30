# Mode: Standard

Implement **one ticket per invocation** — do not batch.

---

## Step 1 — Gather Story Context in Parallel

1. **Issue body + comments** — the ticket already fetched in Step 1 (hold it)

2. **TDD** — list issues labeled `technical-design` in the milestone to find it, then read the TDD issue in full. Extract:
   - Problem statement
   - Proposed solution
   - Architecture key decisions
   - Components design
   - API specification
   - Data models
   - Risks
   - Implementation priority

3. **Design Instructions** (frontend only) — list issues labeled `design` in the milestone to find the design instructions issue. Read it in full — the document covers the entire sprint's UI design.

Add label `in-progress` to the story issue.

---

## Step 2 — Git Setup

Sprint number N: read from the issue's milestone title (format: `Sprint N`).

`cd` into each relevant codebase path, checkout the sprint branch for sprint N, and pull latest.

For multi-skill stories, run checkout independently in each codebase path.

---

## Step 3 — Dispatch to Skill Subagent

-> Follow `_dispatch-subagent.md`

---

## Step 4 — Git Branch Setup

For each subagent that returned `NO_WORK:` — skip, no branch needed.

For each subagent that completed work:
- Derive the story branch name from the issue number and title
- Create that branch from the sprint branch in that codebase path

---

## Step 5 — Commit and Push

Once all subagents complete:

-> Follow `_commit-push.md`

---

## Step 6 — Open PR

Open a pull request from the story branch into the sprint branch from inside the codebase path:

**PR title:** `feat(#<ISSUE_NUMBER>): <short description>`
**PR body:** Render the `pr-story` template with `{summary, changes, test_command, lint_command, manual_verification, acceptance_criteria, closes}`

For multi-skill stories, open one PR per skill — each from its own codebase path, each targeting the sprint branch.

---

## Step 7 — Notify

-> Follow `_notify-complete.md`
