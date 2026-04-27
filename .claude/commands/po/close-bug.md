# Bug Close — Release Manager

## Workflow

### Step 1 — Parse Arguments

Parse `$ARGUMENTS` as the bug issue number (e.g. `42`).

If `$ARGUMENTS` is empty: list all open issues labeled `bug-production` from the tracker adapter and show the results for the user to choose from, then stop.

### Step 2 — Fetch Issue

Read issue `#issue_number` from the tracker adapter to get its title, labels, and state.

- If the issue does not have the `bug-production` label, stop:
  ```
  ⛔ Issue #N is not a bug (labels: <labels>). Use /po close-bug only for bug issues.
  ```
- If the issue is already closed, stop:
  ```
  ℹ Issue #N is already closed.
  ```

### Step 3 — Readiness Gate

Before doing anything destructive, verify the bug is ready to close:

For each codebase repo (derive slug: owner from tracker config + directory name from codebase path), list open pull requests with branch prefix `fix/issue-{N}-` to detect any unmerged PRs.

Collect results from all codebases. If any open PRs are found across any repo, stop:

```
⛔ Bug not ready to close. Unmerged PR(s) found for #N:
  - <pr_title> (<pr_url>)

Merge all PRs first, then run /po close-bug {N} again.
```

If no open PRs in any codebase repo, proceed.

### Step 4 — Update Labels and Close

1. Add label `bug-fixed` and remove labels `in-progress` and `implemented` from issue `#issue_number`.
2. Close issue `#issue_number`.

Output:
```
✓ Closed #N — <title>
```

### Step 5 — Check for EF Core Migrations (Backend Only)

For the backend codebase, find the merged fix PR:

List closed pull requests with branch prefix `fix/issue-{N}-` in the backend codebase repo and filter client-side for `merged: true`. Take the first result as `pr_number`.

If a PR number is found, fetch pull request `#pr_number` and inspect its `files[]` for paths matching `/Migrations/` (case-insensitive).

- If no merged backend PR found: note "No backend PR found for #N — skipping migration check."
- If migration files found: capture the list. This output is used in Step 7.
- If no migration files found: note "No database migrations in this bug fix."

### Step 6 — Delete Bug Branch

For each codebase listed in the project config:

List remote branches matching `fix/issue-{N}-` in each codebase repo.

For each branch found, delete it from the remote.

If the branch no longer exists on the remote, skip silently.

Output one line per deletion:
```
✓ Deleted {branch_name} from {codebase_name}
```

### Step 7 — Post Bug Summary

Render the `comment-bug-summary` template with `{issue_number, title, closed_date, migrations}`, then post it as a comment on issue `#issue_number`.

## Constraints

- Only operate on issues with the `bug-production` label. Reject all others.
- Never merge any PR — only gate on them.
- Confirmation required before any mutating action.
- Migration check is backend-only. Skip silently if no merged backend PR is found.
- All label names and branch patterns come from `project.md`. Do not hardcode them.
