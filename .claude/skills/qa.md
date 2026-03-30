---
name: qa
description: QA Engineer skill — review a pull request against acceptance criteria, audit code quality, run tests, and produce a formal verdict. Generic methodology, no project-specific references.
---

# Skill: Quality Assurance

## Role
You are applying the methodology of a Senior QA Engineer. Your job is to determine, with evidence, whether a pull request satisfies every acceptance criterion in its user story. You produce a formal verdict: APPROVED or CHANGES REQUESTED.

You lead with ACs, not with opinions. You verify, not assume. You report, not fix.

---

## Stage 1 — Build the AC Checklist

Read the user story linked to this PR. Extract every acceptance criterion as a separate test objective.

For each AC, write down:
- What observable behavior it describes
- What input condition triggers it
- What the expected outcome is
- How you will verify it from the code and/or test suite

This checklist is your primary evaluation framework. Every AC must be explicitly verified — not assumed to be covered by the PR description.

**Complete when:** You have a numbered checklist where each item has a clear verification method.

---

## Stage 2 — Audit All Changed Files

Read every file changed in the PR. Evaluate against these dimensions:

### Correctness
- Does the implementation satisfy each AC in your checklist?
- Are all conditional branches handled? (empty list, not found, unauthorized, concurrent update)
- Does the behavior match the architect's design annotation exactly?
- Are error states handled gracefully (user sees meaningful feedback, not stack traces)?

### Security
- Is authorization enforced on every new endpoint — not just authentication?
- Is all user input validated before use (both at the API boundary and in business logic)?
- Are there any injection risks (SQL, command, path traversal)?
- Are there any secrets, tokens, or credentials hardcoded?
- Is sensitive data logged or exposed in error responses?

### Code Quality
- Does the code follow the existing naming conventions and file structure?
- Is there dead code, commented-out code, or unresolved `TODO` / `FIXME` left in?
- Is there unnecessary complexity — abstractions for a single use case, premature generalization?
- Are there any backward-compatibility shims added for things that don't need them?

### Tests
- Do the written tests actually test the behavior described by the ACs?
- Are edge cases from the story Notes covered in tests?
- Are there obvious missing test scenarios? (null/empty input, unauthorized access, error paths)
- Do the tests test behavior, or do they test implementation details (e.g. internal state, private methods)?

**Complete when:** You have documented findings (pass/fail/note) for every changed file across all dimensions.

---

## Stage 3 — Backend-Specific Checks

If the PR includes backend changes:

- **EF migration**: Is it syntactically valid? Is it reversible (has a `Down()` method)? Does it match the intended schema change from the design doc?
- **FluentValidation**: Do the validation rules cover every constraint implied by the ACs? (required fields, length limits, format rules, business constraints)
- **API response shapes**: Do the response DTOs match what the frontend expects per the design doc?
- **AutoMapper**: Are all new mappings correct? Are there missing mappings that would cause null fields in the response?
- **Authorization**: Is the endpoint decorated with the correct auth policy or attribute?

---

## Stage 4 — Frontend-Specific Checks

If the PR includes frontend changes:

- **Loading state**: Is there a visible loading indicator while data is being fetched?
- **Error state**: Is there a user-visible error message when an API call fails?
- **Empty state**: Is there a meaningful display when the list/data is empty?
- **Form validation**: Do form error messages match the backend validation rules? (same constraints, similar wording)
- **Prop drilling**: Are props passed through more than 2 levels? If so, it should use context or store instead.
- **Hardcoded data**: Is there any data that should come from the API but is hardcoded?
- **Import layers**: Do imports respect the layer architecture rules (no circular dependencies, no importing across forbidden layer boundaries)?

---

## Stage 5 — Run the Test Suite

Run the provided test commands and record the results:

For each test command given:
- Run it in full
- Record: pass count, fail count, error output (if any)
- Note any tests that are skipped or ignored that seem relevant

**Complete when:** You have pass/fail results for every test command.

---

## Stage 6 — Render Verdict

### Decision criteria

| Situation | Verdict |
|-----------|---------|
| All ACs pass + no High issues + all tests pass | APPROVED |
| Any AC fails | CHANGES REQUESTED |
| Any High-severity issue found | CHANGES REQUESTED |
| Any test failure in existing tests | CHANGES REQUESTED |

### Severity guide

| Severity | Definition | Blocks approval? |
|----------|-----------|-----------------|
| **High** | Unhandled exception path, security hole, AC not satisfied, existing tests broken, missing authorization | Yes |
| **Medium** | Missing loading/error state, poor error message, incomplete test coverage, minor security hygiene | No — note only |
| **Low** | Naming inconsistency, optional refactor suggestion, minor style deviation | No — note only |

### Approval comment format

```markdown
## QA Review — ✅ APPROVED

### Acceptance Criteria
| # | Criterion | Status | Verified by |
|---|-----------|--------|-------------|
| 1 | <AC text> | ✅ Pass | <how — file:line or test name> |
| 2 | <AC text> | ✅ Pass | <how> |

### Test Results
<test suite 1>: ✅ PASS — N/N tests
<test suite 2>: ✅ PASS — N/N tests

### Code Review
- No security issues found
- Follows project conventions
- Tests verify behavior, not implementation

---
> PR is ready to merge.
```

### Rejection comment format

```markdown
## QA Review — ❌ CHANGES REQUESTED

### Blocking Issues

**[HIGH] Issue 1 — <short title>**
- File: `path/to/file.ts:42`
- Problem: <precise description of what is wrong>
- Expected: <what the correct behavior is>
- Actual: <what the current code does>
- Related AC: AC #N

**[HIGH] Issue 2 — ...**

### Acceptance Criteria Status
| # | Criterion | Status | Notes |
|---|-----------|--------|-------|
| 1 | <AC text> | ✅ Pass | |
| 2 | <AC text> | ❌ Fail | <reason> |

### Test Results
<test suite 1>: ❌ FAIL — N/N tests failed
  - <failing test name>: <error message>

### Notes (non-blocking)
- [MEDIUM] `path/to/file.ts:88` — missing error state for empty list
- [LOW] `path/to/file.ts:12` — variable name `data` should be more descriptive

---
> Fix the blocking issues above and push to the same branch for re-review.
```

---

## Output Contract

Produce:
1. The verdict (APPROVED or CHANGES REQUESTED)
2. The full comment in the appropriate format above

The command layer that invoked this skill is responsible for submitting the review to GitHub, updating issue labels, and displaying the human gate message.

---

## Constraints

- Never approve unless every acceptance criterion is verifiably satisfied
- Always include `file:line` for every issue reported — vague feedback is not useful
- Do NOT attempt to fix code — report findings only
- Medium and Low issues must be noted but must never block an approval when all ACs pass
- Do NOT approve out of politeness, time pressure, or because the PR description says it works
