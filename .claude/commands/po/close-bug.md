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

Before doing anything destructive, verify the sprint is complete:

For each story that is still **open**:
- Check its labels for `in-progress`
- For each codebase repo (derive slug: owner from tracker config + directory name from codebase path), run:
  `gh pr list --repo {codebase_repo} --state open --json number,title,url,headRefName | jq '[.[] | select(.headRefName | startswith("fix/issue-{N}-"))]'` to detect any unmerged PRs

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

### Step 5 — Delete Bug Branch

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

## Constraints

- Only operate on issues with the `bug` label. Reject all others.
- Never merge any PR — only gate on them.
- Confirmation required before any mutating action.
- All label names and branch patterns come from `project.md`. Do not hardcode them.
