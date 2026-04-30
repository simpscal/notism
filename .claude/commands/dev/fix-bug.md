# Mode: Bug Fix

Implement **one bug fix per invocation** — do not batch.

---

## Step 1 — Fetch Issue

Read issue `#bug_issue_number` in full. Add label `in-progress` to the issue.

If the issue does not have the `bug-production` label, halt:
```
⛔ Issue #<N> is not a bug (labels: <labels>). Use /dev fix-bug only for bug issues.
```

---

## Step 2 — Extract Context

From the issue body extract:
- Bug Report (Description, Steps to Reproduce, Expected Behaviour, Actual Behaviour, Severity)
- Acceptance Criteria section

---

## Step 3 — Root Cause Investigation

Inspect the relevant source files. Derive:

- **Root Cause** — plain language: why the bug occurs (no file paths, class names, or layer names)
- **Scope** — plain language: which product area / user-facing surface is affected (no file paths or layer names)
- **Fix Approach** — technical: what to change (not how to code it); opens with `[frontend]`, `[backend]`, or `[devops]` tag
- **Risk** — `Low — logic fix only` / `Medium — migration required: <details>` / `High — <impact>`
- **Complexity** — `S` (<4h, isolated) / `M` (4-8h, one layer) / `L` (>8h, cross-cutting)

---

## Step 4 — Post Investigation Comment

Render the `comment-dev-investigation` template with `{complexity, root_cause, scope, fix_approach, risk}`, then post it as a comment on issue `#issue_number`.

---

## Step 5 — Git Setup

`cd` into each relevant codebase path, checkout `main`, and pull latest.

For multi-skill bugs, run checkout independently in each codebase path.

---

## Step 6 — Dispatch to Skill Subagent

-> Follow `_dispatch-subagent.md`

Architecture context = investigation verbatim (Root Cause, Scope, Fix Approach, Risk).

---

## Step 7 — Git Branch Setup

For each subagent that returned `NO_WORK:` — skip, no branch needed.

For each subagent that completed work:
- Derive the bugfix branch name from the issue number and title
- Create bug branch in that codebase path

---

## Step 8 — Commit and Push

Commit and push in each codebase path using the files each subagent reported. Commit message: `fix(#<ISSUE_NUMBER>): <imperative-tense description>`.

---

## Step 9 — Open PR

Open a pull request from the bug branch into `main` from inside the codebase path:

**PR title:** `fix(#<ISSUE_NUMBER>): <short description>`
**PR body:** Render the `pr-story` template with `{summary, changes, test_command, lint_command, manual_verification, acceptance_criteria, closes}`

For multi-skill bugs, open one PR per skill — each from its own codebase path, each targeting `main`.

---

## Step 10 — Notify

-> Follow `_notify-complete.md`
