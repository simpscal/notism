# PR Story Template

Story PR body posted to GitHub. Used by `/dev` (standard mode S5, change mode C5).

```
## Summary
<What was built and why>

## Changes
- `path/to/file` — <what changed>

## Test plan
- [ ] <test command from project config> passes
- [ ] <lint/build command from project config> passes
- [ ] <manual verification step>

## Acceptance criteria
- [x] <AC — satisfied>

Closes #<ISSUE_NUMBER>
```

**Summary:** what was built and why — 1–2 sentences.

**Changes:** one bullet per file — `` `path/to/file` — <what changed> ``

**Test plan:** fill from project config test/lint commands; add at least one manual verification step.

**Acceptance criteria:** copy ACs from the issue, all checked `[x]`.

**Closes:** `#<ISSUE_NUMBER>` — GitHub will auto-close the issue on merge.
