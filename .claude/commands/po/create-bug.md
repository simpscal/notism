# Mode: Bug

## Step 1 — Gather Bug Details

Parse the raw description. Identify which fields are already answered:

- **What is broken?** — a clear description of the defective behaviour
- **Steps to reproduce** — numbered list of exact steps to trigger the bug
- **Expected behaviour** — what should happen
- **Actual behaviour** — what actually happens
- **Severity** — critical / high / medium / low

If any fields are missing, use `AskUserQuestion` to ask for all missing fields in a single message. If all fields are present, skip `AskUserQuestion` and proceed immediately.

---

## Step 2 — Create Issue

Create an issue via the tracker adapter with:

- **Title**: `[Bug] <concise description of what is broken>`
- **Labels**: `["bug-production"]`
- **Milestone**: `null`

**Body**: Render the `issue-bug-report` template with `{description, steps, expected, actual, severity}`.

---

## Step 3 — Output

Output the issue number and title.
