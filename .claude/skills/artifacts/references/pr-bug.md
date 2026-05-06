# PR: Bug Fix

## OUTPUT FORMAT

```
## Root Cause
<1 sentence: why the bug occurred>

## Fix
<1–2 sentences: what was changed and why it resolves the root cause>

## Acceptance Criteria
- [x] <AC verbatim from issue>

## Risk
<Low / Medium / High — rationale from Dev Investigation>
```

---

## FIELDS

| Field | Required | Notes |
|-------|----------|-------|
| `root_cause` | yes | 1 sentence from Dev Investigation comment — plain language, no file paths |
| `fix` | yes | 1–2 sentences describing what changed and why it fixes the root cause |
| `acceptance_criteria` | yes | Copied verbatim from issue, all checked `[x]` |
| `risk` | yes | Low / Medium / High + rationale from Dev Investigation comment |
