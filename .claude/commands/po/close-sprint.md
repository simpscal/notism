# Sprint Finish — Release Manager

## Workflow

### Step 1 — Parse Arguments

Parse `$ARGUMENTS` as the milestone ID or sprint number (e.g. `3` or `Sprint 3`).

If `$ARGUMENTS` is empty: run `gh api repos/{repo}/milestones --jq '[.[] | {number: .number, title: .title, open_issues: .open_issues}]'` and list the results for the user to choose from, then stop.

### Step 1 — Fetch Sprint Snapshot

Use `list_issues(milestone_id)` from the tracker adapter to fetch **all** issues in the milestone (open and closed). For each issue, note its number, title, labels, and state.

Partition issues into three groups:
- **Stories**: issues with the `user-story` label
- **TDD**: issue with the `technical-design` label
- **Requirement**: issue with the `requirement` label

Derive the sprint branch name from the milestone title: `Sprint N` → `feature/sprint-N`.

### Step 2 — Readiness Gate

Before doing anything destructive, verify the sprint is complete:

For each story that is still **open**:
- Check its labels for `in-progress`
- For each codebase repo (derive slug: owner from tracker config + directory name from codebase path), run:
  `gh pr list --repo {codebase_repo} --state open --json number,title,url,headRefName --jq '[.[] | select(.headRefName | startswith("feature/issue-{N}-"))]'` to detect any unmerged PRs

If any open story has an unmerged PR or is still in-progress, stop and output:

```
⛔ Sprint not ready to close. The following stories have unmerged work:
  - #N <title> (labels: <labels>)

Merge all story PRs into the sprint branch, then run /po close-sprint again.
```

If all stories are merged or already closed, proceed.

### Step 3 — Label and Close All Sprint Issues

For every issue in the milestone (stories, TDD issue, requirement issue):

1. `update_labels(issue_id, add: [sprint-completed], remove: [in-progress, sprint-ready, tl-reviewed, design-reviewed, story-updated])`
2. `gh issue close {issue_id} --repo {repo}`

Output one line per issue as it completes:
```
✓ Closed #N — <title>
```

### Step 4 — Delete Story Sub-branches

Story branches follow the pattern `feature/issue-{N}-{description}` (with optional `-backend` / `-frontend` suffix). Sprint branches (`feature/sprint-{N}`) must **not** be deleted.

For each codebase listed in the project config:

```bash
cd {codebase_path}
git fetch --prune origin
git branch -r | grep 'origin/feature/issue-' | sed 's|  origin/||'
```

For each story branch found, delete it from the remote:

```bash
git push origin --delete {branch_name}
```

If the branch no longer exists on the remote (already pruned), skip silently.

Output one line per deletion:
```
✓ Deleted {branch_name} from {codebase_name}
```

### Step 5 — Check for EF Core Migrations (Backend Only)

For the backend codebase:

```bash
cd {backend_path}
git fetch origin
git diff origin/main...origin/{sprint_branch} --name-only | grep -i '/Migrations/'
```

Capture the list of migration files (if any). This output is used in Step 7 and Step 8.

If no migration files are found, note: "No database migrations in this sprint."

### Step 6 — Create Release PRs (Sprint Branch → Main)

For each codebase, create a PR via `create_pr(title, body, head, base)`:

- **Title**: `feat(sprint-N): {milestone description}`
- **Base**: `main`
- **Head**: `feature/sprint-N`
- **Body**: Use `render_template("pr-release", {sprint, stories, migrations})`.

### Step 7 — Post Sprint Summary

Use `render_template("comment-sprint-summary", {sprint, closed_date, stories, release_prs, migrations})`, then `post_comment(requirement_issue_id, body)`.

## Constraints

- Never delete a sprint branch (`feature/sprint-{N}`). Only delete story branches (`feature/issue-{N}-*`).
- Never merge any PR — only create them. Merging is a human action.
- Do not proceed past Step 2 if any story has unmerged work.
- All label names and branch patterns come from `project.md`. Do not hardcode them.
