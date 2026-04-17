# PR Story Template

Posted to GitHub by `/dev` (standard mode S5, change mode C5).

---

## OUTPUT FORMAT

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

---

## FIELDS

### Summary
**REQUIRED** | text | 1-2 sentences

**Rules**:
- Sentence 1: What built
- Sentence 2 (optional): Why built (if not obvious from AC)
- Match user story/issue description
- Understandable without code

**Wrong**: ❌ "Made changes" (vague), ❌ 3+ sentences, ❌ Only tech details

### Changes
**REQUIRED** | list | Format: `` - `path/to/file` — <what changed> ``

**Rules**:
- Include all modified files (or group related)
- Use backticks around path
- Use em dash `—` between path and description
- Path relative to codebase root
- Description, focus on WHAT not HOW
- May group: `` - `src/components/*.tsx` — Added export components ``

**Wrong**: ❌ No backticks, ❌ Hyphen not em dash, ❌ Absolute paths, ❌ Vague descriptions

### Test plan
**REQUIRED** | checklist | Min 3 items

**Include**:
- Test command from project config
- Lint/build command from project config
- At least 1 manual verification step

**Commands** (from project.md):
- Backend test: `cd ../notism-api && dotnet test`
- Backend build: `cd ../notism-api && dotnet build`
- Frontend test: `cd ../notism-web && bun run test`
- Frontend lint: `cd ../notism-web && bun run lint`

**Rules**:
- All items unchecked `- [ ]`
- Match project.md exactly
- Manual steps specific and actionable

**Wrong**: ❌ Generic "Test everything", ❌ Pre-checked, ❌ Wrong codebase commands, ❌ No manual steps

### Acceptance criteria
**REQUIRED** | checklist | All checked

**Rules**:
- Copy ACs from issue verbatim
- All checked `- [x]`
- Include all ACs (don't omit)

**Wrong**: ❌ Unchecked items, ❌ Modified text, ❌ Omitted ACs

### Closes
**REQUIRED** | text | Format: `Closes #<ISSUE_NUMBER>`

**Rules**:
- Own line at end
- Pattern: `Closes #[0-9]+`
- Issue number is story this PR implements
- GitHub auto-closes on merge

**Wrong**: ❌ "Fixes #142", "Resolves #142", "Closes: #142"

---

## CHECKLIST

- [ ] Summary 1-2 sentences, what and why
- [ ] All modified files in Changes
- [ ] Paths use backticks and em dash
- [ ] Test command matches codebase
- [ ] Lint/build matches codebase
- [ ] Min 1 manual verification step
- [ ] All test plan items unchecked
- [ ] All ACs copied verbatim
- [ ] All ACs checked
- [ ] "Closes #N" at end
