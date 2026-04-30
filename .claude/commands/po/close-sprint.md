# Sprint Finish — Release Manager

## Workflow

### Step 1 — Parse Arguments

Parse `$ARGUMENTS` as the milestone ID or sprint number (e.g. `3` or `Sprint 3`).

If `$ARGUMENTS` is empty: list all milestones with details from the tracker adapter and show the results for the user to choose from, then stop.

### Step 1 — Fetch Sprint Snapshot

List all issues in the milestone (open and closed) from the tracker adapter. For each issue, note its number, title, labels, and state.

Partition issues into four groups:
- **Stories**: issues with the `user-story` label
- **TDD**: issue with the `technical-design` label
- **Design**: issue with the `design` label
- **Requirement**: issue with the `requirement` label

Derive sprint branch name for sprint N (from milestone title).

### Step 2 — Readiness Gate

Before doing anything destructive, verify the sprint is complete:

For each story that is still **open**:
- Check its labels for `in-progress`
- For each codebase repo (derive slug: owner from tracker config + directory name from codebase path), run:
  list open pull requests for story branches of issue N in each codebase repo to detect any unmerged PRs

If any open story has an unmerged PR or is still in-progress, stop and output:

```
⛔ Sprint not ready to close. The following stories have unmerged work:
  - #N <title> (labels: <labels>)

Merge all story PRs into the sprint branch, then run /po close-sprint again.
```

If all stories are merged or already closed, proceed.

### Step 3 — Label and Close All Sprint Issues

For every issue in the milestone (stories, TDD issue, requirement issue, design issue):

1. Add label `sprint-completed` and remove labels `in-progress` and `story-updated` from the issue.
2. Close the issue.

Output one line per issue as it completes:
```
✓ Closed #N — <title>
```

### Step 4 — Delete Story Sub-branches

Story branches (not sprint branches) must be deleted at sprint close.

For each codebase:

List story branches for sprint N in each codebase repo. Only delete story branches — sprint branches must not be deleted.

For each story branch found, delete it from the remote.

Output one line per deletion:
```
✓ Deleted {branch_name} from {codebase_name}
```

### Step 5 — Check for EF Core Migrations (Backend Only)

Get the list of files changed between `main` and `{sprint_branch}` in the backend repo.

Filter that list for paths containing `/Migrations/`.

Capture the filtered list (if any). This output is used in Step 7 and Step 8.

If no migration files are found, note: "No database migrations in this sprint."

### Step 6 — Create Release PRs (Sprint Branch → Main)

For each codebase, create sprint release PR for sprint N with title `feat(sprint-N): {milestone description}`, base `main`, body rendered from `pr-release` template.

### Step 7 — Post Sprint Summary

Render the `comment-sprint-summary` template with `{sprint, closed_date, stories, release_prs, migrations}`, then post it as a comment on the requirement issue.

