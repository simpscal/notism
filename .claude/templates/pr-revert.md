# PR Revert Template

Posted to GitHub by `/dev` (revert mode — one per story PR being reverted).

---

## OUTPUT FORMAT

```
## Summary

Reverts the implementation of story <story_number> — <story_title>.

The story was removed from the requirement scope and the implementation must be undone.

## Reverts

- Original PR: <original_pr>
- Merge commit: `<merge_commit>`

## Acceptance Criteria

- [ ] All changes introduced by <original_pr> are absent from the sprint branch after merge
- [ ] Tests pass: `<test_command>`
- [ ] Build passes: `<lint_command>`

Closes <story_number>
```

---

## FIELDS

### story_number
**REQUIRED** | string | Format: `#<N>`

GitHub issue number of the story being reverted.

**Wrong**: ❌ Plain number "45", ❌ "issue #45"

### story_title
**REQUIRED** | string | Short story title

Copy verbatim from the issue title (strip `[Story]` prefix if present).

### original_pr
**REQUIRED** | string | Format: `#<N>`

PR number of the original implementation being reverted.

### merge_commit
**REQUIRED** | string | SHA or fallback message

- If PR was merged: full merge commit SHA (from `mergeCommitSha`)
- Never omit — always populated from Step 2

### test_command
**REQUIRED** | string | From project config

Exact test command for the affected codebase.

**Commands** (from project.md):
- Backend: `cd ../notism-api && dotnet test`
- Frontend: `cd ../notism-web && bun run test`

### lint_command
**REQUIRED** | string | From project config

Exact lint/build command for the affected codebase.

**Commands** (from project.md):
- Backend: `cd ../notism-api && dotnet build`
- Frontend: `cd ../notism-web && bun run lint`

---

## CHECKLIST

- [ ] story_number uses `#N` format
- [ ] story_title copied verbatim (no `[Story]` prefix)
- [ ] original_pr uses `#N` format
- [ ] merge_commit is the SHA from `mergeCommitSha`
- [ ] test_command matches codebase from project config
- [ ] lint_command matches codebase from project config
- [ ] `Closes #N` references the story issue, not the original PR
