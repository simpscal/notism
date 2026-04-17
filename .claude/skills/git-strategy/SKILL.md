---
name: git-strategy
description: Git branching strategy — branch naming patterns.
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
| Revert (single-skill) | `revert/issue-{N}-{short-description}` |
| Revert (multi-skill) | `revert/issue-{N}-{short-description}-backend` / `-frontend` |
| Bugfix (single-skill) | `fix/issue-{N}-{short-description}` |
| Bugfix (multi-skill) | `fix/issue-{N}-{short-description}-backend` / `-frontend` |

`short-description` is derived from the issue title — lowercase, hyphens, max 4 words, strip any `[Tag]` prefix.

