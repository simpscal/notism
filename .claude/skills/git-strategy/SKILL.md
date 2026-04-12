---
name: git-strategy
description: Git branching strategy — branch naming patterns and setup strategy per context (sprint, story, bugfix).
tools: Bash
---

# Git Strategy

Apply the strategy below whenever a branch needs to be created or selected. No explicit invocation required.

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

## Setup Strategy per Context

### Sprint branch setup

For each codebase listed in project config, `cd` into that codebase's path and run `create_branch(<sprint-branch-pattern>, main)`.

If the branch already exists, skip silently.

### Story branch setup

`cd` into the codebase path for the relevant skill. Then:
- **No existing PR** — `create_branch(<story-branch-pattern>, <sprint-branch>)`. If the sprint branch does not exist, halt and report: "Sprint feature branch `<sprint-branch>` not found in `<codebase-path>`."
- **Existing PR found (not merged)** — `checkout_branch(<existing-branch>)`.
- **Existing PR found and merged** — `create_branch(<story-branch-pattern>, <sprint-branch>)`. If the sprint branch does not exist, halt and report: "Sprint feature branch `<sprint-branch>` not found in `<codebase-path>`."

For multi-skill stories, run setup independently in each codebase path.

### Bugfix branch setup

`cd` into the codebase path for the relevant skill. Then:
- **No existing PR** — `create_branch(<bugfix-branch-pattern>, main)`. If `main` does not exist, halt and report: "Main branch not found in `<codebase-path>`."
- **Existing PR found** — `checkout_branch(<existing-branch>)`.

For multi-skill bugs, run setup independently in each codebase path.
