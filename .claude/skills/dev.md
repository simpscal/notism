---
name: dev
description: Developer skill — implement a user story following TL guidance, project conventions, design instructions, and code quality standards. Tech-stack-agnostic; specific tools and frameworks are defined in .claude/project.md.
---

# Skill: Software Development

## Role
You are applying the methodology of an experienced developer. Your job is to implement a user story exactly as specified by the TL's annotation — no more, no less. You write clean, readable, tested, convention-following code.

You read before you write. You follow patterns you find, not patterns you invent. You do not merge — you deliver a PR and stop.

The specific tech stack, frameworks, test tools, and branch patterns for this project are defined in `.claude/project.md`. Read it (via the command that invoked you) before applying this skill.

---

## Stage 1 — Understand the Ticket

Read the user story in full:
- Every acceptance criterion — these are your done criteria
- The TL's annotation — this defines your implementation approach and scope
- The TDD — this gives you sprint-wide context (API contracts, data shapes, DB schema, patterns)

Before proceeding, confirm:
- Every story dependency listed in the TDD is already complete (its issue is closed or its PR is merged)
- You can map every AC to a specific implementation action
- You know which layers/files are in scope per the annotation's Scope section

**If a dependency is not met:** Stop and flag the blocker: "Blocked — depends on story N which is not yet complete." Do not guess or work around it.

**If anything else is ambiguous:** Document the specific question and stop. Do not invent scope.

**Complete when:** You can map every AC to a specific implementation action with no open questions.

---

## Stage 2 — Explore Relevant Code

**Frontend only — read design instructions first:**
If design instructions were found (Figma link, mockup, UI spec), read them before opening any code file. Note:
- Overall layout and component structure
- Specific component names or variants to use
- Spacing, typography, and color decisions
- All UI states shown: loading, error, empty, success, disabled

Only after noting the design requirements, proceed to reading code.

**All skills — read reference code:**
Read every file listed in the TL annotation's Scope. Then read at least one adjacent existing implementation using the same pattern.

**Backend:**
- Closest existing command/query handler — read fully to understand the pattern
- Corresponding API endpoint — understand the routing and dispatch pattern
- Data model/entity file for the relevant aggregate
- One existing handler test — understand structure, mocking, and assertion patterns

**Frontend:**
- Closest existing feature module — directory structure and key files
- One existing data-fetching hook (query/mutation) — understand the pattern
- Relevant API client module — understand the fetch function pattern
- Closest form component — understand the validation schema and form library pattern

**Complete when:** You have read enough that you could write the new code without re-reading anything.

---

## Stage 3 — Implement

Write the implementation following the TL's guidance exactly. Use the tech stack and conventions defined in the project config — refer to the specific framework names, patterns, and tooling loaded from `.claude/project.md`.

### Code Quality Standards (all skills)

These apply to every line written:

- **Readability**: names must describe intent. No `data`, `result`, `temp`, `item` for domain objects — use the domain term. Functions do one thing. If a function needs a comment to explain what it does, it needs a better name or needs splitting.
- **Maintainability**: no magic numbers or strings — extract to named constants. No logic duplicated in more than one place. No inline expressions that would need to change in multiple locations.
- **No dead code**: no commented-out code, no unused imports, no unused variables, no `TODO`/`FIXME` left in — unless the story Notes explicitly call out a known gap.
- **No over-engineering**: do not add abstractions, interfaces, or generics for a single use case. Follow the complexity level of adjacent existing code.

### Backend Implementation

Follow the architecture pattern defined in the project config:

- Place new features in the correct application layer directory, following the project's folder conventions
- Each new operation (write or read) gets its own unit: input model, validator, handler, and response model — colocated as shown by existing examples
- Use the project's command/query dispatcher pattern — handlers are the only place business logic lives
- Use the project's validation framework — colocate validation rules with the input model
- Use the project's result/error pattern — handlers return typed results, not exceptions for expected failures
- Use the project's ORM and query patterns — follow existing examples for database access and query logic
- API endpoints delegate entirely to the dispatcher — no business logic in the routing layer
- Follow the project's entity configuration and migration patterns for any database changes

### Frontend Implementation

**UI Design Adherence:**
- If a design was provided: implement to match it. Layout, component choices, spacing, and interaction states must reflect the design. Do not improvise where the design is explicit.
- If no design was provided: match the closest existing page or feature in the codebase — use existing components and layouts.
- Every UI state must be handled: loading, error, empty, success. If the design shows a state, implement it. If not, follow the nearest existing pattern.

Follow the conventions from the project config:

- New features go in the correct feature module directory, following the project's folder structure
- Use the project's server-state library for all data fetching and mutations (not manual fetch/effect)
- Use the project's global-state library only for true cross-feature client state
- Use the project's form and validation library — define the validation schema first, derive the TypeScript type from it
- Use the project's component library primitives — do not create new UI primitives from scratch
- Follow the project's API client patterns for all backend communication
- Respect import layer rules — no importing across forbidden layer boundaries

### DevOps

- Read existing infrastructure configuration before changing anything
- Change only what the ticket requires — do not refactor adjacent infrastructure
- Verify every change is reversible before applying

**Complete when:** Every AC is satisfied by the implementation and code quality standards are met.

---

## Stage 4 — Write Tests

Tests are not optional. Every implementation must have test coverage. Use the test framework and tooling defined in the project config.

### Backend Tests

For each new handler, write a test class following the project's test conventions:
- **Location**: follow the existing test project structure
- **Naming**: mirror the source file name with a `Tests` suffix
- **Structure**: one class per handler, one test per scenario

Required scenarios:
- Happy path: valid input → expected result
- One failure case per AC (invalid input, not found, unauthorized, business rule violation)
- Edge cases from story Notes

Use the project's mocking and assertion libraries following existing test patterns.

### Frontend Tests

For each new feature component:
- Renders correctly in the default state
- Renders loading state
- Renders error state when API fails
- User interactions trigger expected mutations
- Form validation shows correct error messages

Mock API responses using the project's API mocking tool. Test user-visible behavior, not internal state.

**Complete when:** All tests pass locally using the test commands from the project config.

---

## Stage 5 — Git Workflow

Use the branch patterns and main branch name from the project config.

**Branch strategy:**
1. Sprint feature branch: `{sprint branch pattern from config}` — shared base for all stories in this sprint
   - If it doesn't exist: stop and report: "Sprint feature branch not found — the Technical Lead must create it first."
   - If it exists: check it out and pull latest
2. Story branch: `{story branch pattern from config}` — branched from the sprint feature branch, not from main
3. Commit all implementation and test changes on the story branch
4. Push the story branch

**Commit message format:**
```
feat(<ticket-id>): <imperative-tense description>
```
Example: `feat(STORY-42): add user profile update endpoint`

Use multiple commits for multiple logical units — all prefixed with the same issue reference.

---

## Output Contract

Produce:
1. All implementation files committed on the story branch
2. All test files, passing locally
3. Story branch pushed and ready for PR creation

The command layer is responsible for opening the PR on the issue tracker (targeting the sprint feature branch) and notifying on the issue.

---

## Constraints

- Implement ONLY what the ACs require — no extra features, refactors, or improvements
- Do NOT modify files outside the TL annotation's scope unless truly unavoidable — explain in the PR
- If a blocker is found that cannot be resolved from the codebase, stop and document it — do not guess
- Do NOT skip tests — untested code is incomplete code
- Do NOT merge the PR — that is the command layer's responsibility to signal the human gate
- Story branch must always be created from the sprint feature branch, not from main
