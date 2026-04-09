---
name: git-workflow
description: Git workflow — the single source of truth for branch naming patterns, git operations, and setup strategy.
tools: Bash
---

# Git Workflow

Apply the strategy below whenever a branch operation is needed. No explicit invocation required.

---

## Branch Patterns

| Context | Pattern |
|---------|---------|
| Main | `main` |
| Sprint | `feature/sprint-{N}` |
| Story (single-skill) | `feature/issue-{N}-{short-description}` |
| Story (multi-skill) | `feature/issue-{N}-{short-description}-backend` / `-frontend` |
| Bugfix (single-skill) | `fix/issue-{N}-{short-description}` |
| Bugfix (multi-skill) | `fix/issue-{N}-{short-description}-backend` / `-frontend` |

`short-description` is derived from the issue title — lowercase, hyphens, max 4 words, strip any `[Tag]` prefix.

---

## Operations

All operations run inside the relevant codebase path. The caller `cd`s to the correct path before invoking.

### `create_branch(branch_name, from_branch)`
Create a new branch from a base branch and push it to origin.
```bash
git checkout {from_branch}
git pull
git checkout -b {branch_name}
git push -u origin {branch_name}
```

### `checkout_branch(branch_name)`
Switch to an existing branch and pull the latest.
```bash
git checkout {branch_name}
git pull
```

---

## Setup Strategy per Context

### Sprint branch setup

For each codebase listed in project config, `cd` into that codebase's path and run `create_branch(<sprint-branch-pattern>, main)`.

If the branch already exists, skip silently.

### Story branch setup

`cd` into the codebase path for the relevant skill. Then:
- **No existing PR** — `create_branch(<story-branch-pattern>, <sprint-branch>)`. If the sprint branch does not exist, halt and report: "Sprint feature branch `<sprint-branch>` not found in `<codebase-path>`."
- **Existing PR found** — `checkout_branch(<existing-branch>)`.

For multi-skill stories, run setup independently in each codebase path.

### Bugfix branch setup

`cd` into the codebase path for the relevant skill. Then:
- **No existing PR** — `create_branch(<bugfix-branch-pattern>, main)`. If `main` does not exist, halt and report: "Main branch not found in `<codebase-path>`."
- **Existing PR found** — `checkout_branch(<existing-branch>)`.

For multi-skill bugs, run setup independently in each codebase path.
