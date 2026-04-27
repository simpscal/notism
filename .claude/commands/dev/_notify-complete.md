# Notify Implementation Complete

Post a comment on issue `#ISSUE_NUMBER` with the following body:

## Single-skill stories

```
## Implementation Complete

- PR #<pr-number>

---
> Pause Human gate: Review the PR diff. When approved, merge into the sprint branch.
```

## Multi-skill stories (two PRs)

```
## Implementation Complete

- Backend: PR #<pr-number>
- Frontend: PR #<pr-number>

---
> Pause Human gate: Review both PR diffs. When approved, merge into the sprint branch.
```

Then add label `implemented` and remove labels `in-progress` and `story-updated` from issue `#ISSUE_NUMBER`.

---

## Revert stories (story-removed)

### Single-skill

```
## Revert Ready

Story #<ISSUE_NUMBER> was removed from scope. Implementation has been reversed.

- Revert PR: #<revert-pr-number>

---
> Pause Human gate: Review the revert PR diff. When approved, merge into the sprint branch.
```

### Multi-skill (two revert PRs)

```
## Revert Ready

Story #<ISSUE_NUMBER> was removed from scope. Implementation has been reversed across all codebases.

- Backend revert PR: #<revert-pr-number>
- Frontend revert PR: #<revert-pr-number>

---
> Pause Human gate: Review both revert PR diffs. When approved, merge into the sprint branch.
```

Then add label `implemented` and remove labels `in-progress`, `story-updated`, and `story-removed` from issue `#ISSUE_NUMBER`.
