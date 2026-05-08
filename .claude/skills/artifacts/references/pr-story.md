# PR: Story

## OUTPUT FORMAT

```
## Summary
<1-2 sentences: what built and why>

## Acceptance criteria
- [x] <AC — copied verbatim from issue>

Refs #<parent_issue>
```

---

## FIELDS

| Field | Req | Notes |
|-------|-----|-------|
| `summary` | yes | 1-2 sentences: what built + why |
| `manual_verification` | yes | At least 1 specific, actionable step |
| `acceptance_criteria` | yes | Copied verbatim from issue, all checked `[x]` |
| `parent_issue` | yes | Parent story issue number (no `#`) — rendered as `Refs #N`, no auto-close |
