# PR: Story

## OUTPUT FORMAT

```
## Summary
<1-2 sentences: what built and why>

## Test plan
- [ ] <test command from project config> passes
- [ ] <lint/build command from project config> passes
- [ ] <manual verification step>

## Acceptance criteria
- [x] <AC — copied verbatim from issue>

Closes #<ISSUE_NUMBER>
```

---

## FIELDS

| Field | Req | Notes |
|-------|-----|-------|
| `summary` | yes | 1-2 sentences: what built + why |
| `test_command` | yes | From project config |
| `lint_command` | yes | From project config |
| `manual_verification` | yes | At least 1 specific, actionable step |
| `acceptance_criteria` | yes | Copied verbatim from issue, all checked `[x]` |
| `closes` | yes | `#N` — `Closes #N` on own line at end (not "Fixes" or "Resolves") |
