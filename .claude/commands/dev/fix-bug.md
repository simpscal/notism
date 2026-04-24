# Mode: Bug Fix

Implement **one bug fix per invocation** — do not batch.

---

## B1 — Fetch Issue

`fetch_issue(bug_issue_number)`. Read in full. `update_labels(issue_number, add: [in-progress], remove: [])`.

If the issue does not have the `bug` label, halt:
```
⛔ Issue #<N> is not a bug (labels: <labels>). Use /dev fix-bug only for bug issues.
```

---

## B2 — Extract Context

From the issue body extract:
- Bug Report (Description, Steps to Reproduce, Expected Behaviour, Actual Behaviour, Severity)
- Acceptance Criteria section

---

## B3 — Root Cause Investigation

Inspect the relevant source files. Derive:

- **Root Cause** — plain language: why the bug occurs (no file paths, class names, or layer names)
- **Scope** — plain language: which product area / user-facing surface is affected (no file paths or layer names)
- **Fix Approach** — technical: what to change (not how to code it); opens with `[frontend]`, `[backend]`, or `[devops]` tag
- **Risk** — `Low — logic fix only` / `Medium — migration required: <details>` / `High — <impact>`
- **Complexity** — `S` (<4h, isolated) / `M` (4-8h, one layer) / `L` (>8h, cross-cutting)

---

## B4 — Post Investigation Comment

`render_template("comment-dev-investigation", {complexity, root_cause, scope, fix_approach, risk})`, then `post_comment(issue_number, body)`.

---

## B5 — Git Setup

- `base_branch` = `main`
- Branch name from git-strategy Bugfix pattern: `fix/issue-{N}-{short-description}` (single-skill) or `fix/issue-{N}-{short-description}-backend` / `-frontend` (multi-skill)

`cd` into the codebase path for the relevant skill, then:

```bash
git fetch origin
git checkout main && git pull
git checkout -b <bug-branch>
git push -u origin <bug-branch>
```

For multi-skill bugs, run setup independently in each codebase path.

---

## B6 — Dispatch to Skill Subagent

-> Follow `_dispatch-subagent.md`

Architecture context = investigation verbatim (Root Cause, Scope, Fix Approach, Risk).

---

## B7 — Commit and Push

-> Follow `_commit-push.md`

---

## B8 — Open PR

Use `create_pr(title, body, head: bug-branch, base: main)` from inside the codebase path:

**PR title:** `fix(#<ISSUE_NUMBER>): <short description>`
**PR body:** `render_template("pr-story", {summary, changes, test_command, lint_command, manual_verification, acceptance_criteria, closes})`

For multi-skill bugs, open one PR per skill — each from its own codebase path, each targeting `main`.

---

## B9 — Notify

-> Follow `_notify-complete.md`
