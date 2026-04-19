# Mode: Bug

**Usage**: `/po bug [description]`

Treat `$ARGUMENTS` (everything after `bug`) as the raw bug description (may be empty or partial).

Read `.claude/templates/issue-bug-report.md`.

---

## B1 — Gather Bug Details

Parse the raw description. Identify which fields are already answered:

- **What is broken?** — a clear description of the defective behaviour
- **Steps to reproduce** — numbered list of exact steps to trigger the bug
- **Expected behaviour** — what should happen
- **Actual behaviour** — what actually happens
- **Severity** — critical / high / medium / low

If any fields are missing, use `AskUserQuestion` to ask for all missing fields in a single message. If all fields are present, skip `AskUserQuestion` and proceed immediately.

---

## B2 — Create Issue

Use `create_issue(title, body, labels, milestone_id: null)` from the tracker adapter with:

- **Title**: `[Bug] <concise description of what is broken>`
- **Labels**: `["bug"]`
- **Milestone**: `null`

**Body**: Use `issue-bug-report.md`.

---

## B3 — Output

Output the issue number and title.
