# Bug Close — Release Manager

## Workflow

### Step 1 — Parse Arguments

Parse `$ARGUMENTS` as the bug issue number (e.g. `42`).

If `$ARGUMENTS` is empty: run `gh issue list --repo {repo} --label bug --state open --json number,title --jq '.[] | "#\(.number) \(.title)"'` and list the results for the user to choose from, then stop.

### Step 2 — Fetch Issue

Use `fetch_issue(issue_number)` from the tracker adapter to read the issue's title, labels, and state.

- If the issue does not have the `bug` label, stop:
  ```
  ⛔ Issue #N is not a bug (labels: <labels>). Use /po close-bug only for bug issues.
  ```
- If the issue is already closed, stop:
  ```
  ℹ Issue #N is already closed.
  ```

### Step 3 — Readiness Gate

Before doing anything destructive, verify the bug is ready to close:

For each codebase repo (derive slug: owner from tracker config + directory name from codebase path), run:
  `gh pr list --repo {codebase_repo} --state open --json number,title,url,headRefName --jq '[.[] | select(.headRefName | startswith("fix/issue-{N}-"))]'` to detect any unmerged PRs

Collect results from all codebases. If any open PRs are found across any repo, stop:

```
⛔ Bug not ready to close. Unmerged PR(s) found for #N:
  - <pr_title> (<pr_url>)

Merge all PRs first, then run /po close-bug {N} again.
```

If no open PRs in any codebase repo, proceed.

### Step 4 — Update Labels and Close

Show the confirmation prompt (tracker adapter confirmation protocol):

```
## Planned Tracker Actions

1. update_labels(#{N}, add: [bug-fixed], remove: [in-progress, sprint-ready, tl-reviewed, design-reviewed, implemented])
2. gh issue close {N} --repo {repo}

Proceed with these actions? (y/n)
```

On confirmation:

1. `update_labels(issue_number, add: [bug-fixed], remove: [in-progress, sprint-ready, tl-reviewed, design-reviewed, implemented])`
2. `gh issue close {issue_number} --repo {repo}`

Output:
```
✓ Closed #N — <title>
```

### Step 5 — Check for EF Core Migrations (Backend Only)

For the backend codebase, find the merged fix PR and inspect its changed files:

```bash
gh pr list --repo {backend_codebase_repo} --state merged \
  --json number,headRefName \
  --jq '[.[] | select(.headRefName | startswith("fix/issue-{N}-"))] | .[0].number'
```

If a PR number is found, check for migration files:

```bash
gh pr view {pr_number} --repo {backend_codebase_repo} --json files \
  --jq '[.files[].path | select(test("/Migrations/"; "i"))]'
```

- If no merged backend PR found: note "No backend PR found for #N — skipping migration check."
- If migration files found: capture the list. This output is used in Step 7.
- If no migration files found: note "No database migrations in this bug fix."

### Step 6 — Delete Bug Branch

For each codebase listed in the project config:

```bash
cd {codebase_path}
git fetch --prune origin
git branch -r | grep "origin/fix/issue-{N}-" | sed 's|  origin/||'
```

For each branch found, delete it from the remote:

```bash
git push origin --delete {branch_name}
```

If the branch no longer exists on the remote (already pruned), skip silently.

Output one line per deletion:
```
✓ Deleted {branch_name} from {codebase_name}
```

### Step 7 — Post Bug Summary

Use `render_template("comment-bug-summary", {issue_number, title, closed_date, migrations})`, then `post_comment(issue_number, body)`.

## Constraints

- Only operate on issues with the `bug` label. Reject all others.
- Never merge any PR — only gate on them.
- Confirmation required before any mutating action.
- Migration check is backend-only. Skip silently if no merged backend PR is found.
- All label names and branch patterns come from `project.md`. Do not hardcode them.
