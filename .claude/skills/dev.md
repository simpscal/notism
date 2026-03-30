---
name: dev
description: Developer skill — implement a user story following architect guidance, project conventions, and test-driven practices. Parameterized by skill type: frontend | backend | fullstack | devops.
---

# Skill: Software Development

## Role
You are applying the methodology of an experienced developer. Your job is to implement a user story exactly as specified by the architect's annotation — no more, no less. You write clean, tested, convention-following code.

You read before you write. You follow patterns you find, not patterns you invent. You do not merge — you deliver a PR and stop.

---

## Stage 1 — Understand the Ticket

Read the user story in full:
- Every acceptance criterion — these define your done criteria, not the architect's annotation
- The architect's annotation — this defines your implementation approach
- The sprint design document — this gives you the full context (API contracts, data shapes, DB schema)

Confirm before proceeding:
- You know every file you need to create or modify (from the architect's annotation)
- You understand which AC maps to which implementation step
- You have identified any story dependencies (and confirmed they are complete)

**If anything is ambiguous:** Document the specific question and stop. Do not guess. Do not invent scope.

**Complete when:** You can map every acceptance criterion to a specific implementation action.

---

## Stage 2 — Explore Relevant Code

Read every file listed in the architect's "Files to create / modify" section. Then read at least one adjacent existing implementation that uses the same pattern — this is your reference.

**For backend work:**
- Find the closest existing command/query handler in `Application/Features/` — read it fully
- Read the corresponding endpoint — understand the minimal API pattern used
- Read the DbContext entry for the relevant aggregate
- Read one existing test file for a handler — understand the test structure and mocking pattern

**For frontend work:**
- Find the closest existing feature module — read its directory structure and key files
- Read one existing TanStack Query hook (useQuery or useMutation) for the pattern
- Read the relevant API client file to understand the fetch/mutation function pattern
- Check the existing Zod schema in the closest form component

**Complete when:** You have read enough existing code that you could write the new code without re-reading anything.

---

## Stage 3 — Implement

Write the implementation following the architect's guidance exactly. Apply these conventions:

### Backend (.NET / Clean Architecture)

**Commands and Queries:**
- Placed in `Application/Features/<FeatureName>/Commands/` or `/Queries/`
- Each file contains: command/query record, validator (FluentValidation inline), and handler
- Handler returns a typed result (use the existing result type pattern in the codebase)
- Validator uses FluentValidation rules — match every constraint implied by the ACs

**Handlers:**
- Inject only what is needed (repository/DbContext, mapper, external services)
- Map domain object → DTO using AutoMapper in the handler
- No business logic in the handler — delegate to domain methods

**API Endpoints:**
- Minimal API extension method in `API/Endpoints/<FeatureName>/`
- Follow the existing endpoint registration pattern exactly
- Map command/query result to HTTP response

**Database:**
- Add EF Core migration: `dotnet ef migrations add <MigrationName> --project <Infrastructure> --startup-project <API>`
- Never edit existing migrations
- Use the existing DbContext pattern for new entity sets

### Frontend (React / TypeScript)

**Feature module structure:**
- New feature in `src/features/<feature-name>/`
- API functions in `src/apis/<resource>/`
- Follow the existing feature module layout exactly

**Data fetching:**
- Use TanStack Query (`useQuery` for reads, `useMutation` for writes) for all server state
- Only use Redux Toolkit for true client-global state (auth, cross-feature UI state)
- Define query keys consistently with existing patterns

**Forms:**
- React Hook Form + Zod schema validation
- Define the Zod schema first, derive the TypeScript type from it
- Match validation rules to backend FluentValidation constraints exactly

**Components:**
- Use existing Radix UI / shadcn components — do not create new primitives
- Handle all states: loading, error, empty, success
- Respect import layer rules — check the architecture docs for allowed import directions

### DevOps

- Read the existing Docker/Terraform configuration before changing anything
- Change only what the ticket requires — do not refactor adjacent infrastructure
- Verify every change is reversible before applying

**Complete when:** Every acceptance criterion in the story is satisfied by the implementation.

---

## Stage 4 — Write Tests

Tests are not optional. Every implementation must have test coverage.

### Backend Tests (xUnit + FluentAssertions + NSubstitute)

For each command/query handler, write a test class:
- **File location**: `tests/<Project>.Tests/Features/<FeatureName>/`
- **Naming**: `<HandlerName>Tests.cs`
- **Structure**: one test class per handler, one `[Fact]` per scenario

Required scenarios per handler:
- Happy path: valid input → expected result
- At least one failure case per AC (invalid input, not found, unauthorized, business rule violation)
- Any edge case called out in the story's Notes

Use NSubstitute to mock dependencies. Assert with FluentAssertions (`.Should().Be()`, `.Should().Contain()`, etc.).

### Frontend Tests (Vitest + MSW)

For each new feature component, write tests that verify:
- Renders correctly in the default state
- Renders loading state while data is fetching
- Renders error state when the API fails
- User interactions trigger the expected mutations
- Form validation shows correct error messages on invalid input

Use MSW to mock API responses. Test user-visible behavior, not internal state.

**Complete when:** All tests pass locally with `dotnet test` (backend) and `bun run test` (frontend).

---

## Stage 5 — Commit

Create a feature branch and commit following these conventions:

**Branch name**: `feature/issue-<N>-<short-kebab-description>`
- Example: `feature/issue-42-banking-checkout`

**Commit message format**:
```
feat(#<N>): <imperative-tense description of what was implemented>
```
- Example: `feat(#42): add VNPay banking checkout to order flow`
- Use multiple commits for multiple logical units, all with the same `feat(#N):` prefix

---

## Output Contract

Produce:
1. All implementation files (created or modified), committed on the feature branch
2. All test files, passing locally
3. A PR description ready for the command layer to use — include:
   - Summary of what was built
   - List of files changed
   - Test plan (manual steps to verify)
   - AC coverage checklist

The command layer that invoked this skill is responsible for pushing the branch and opening the PR on GitHub.

---

## Constraints

- Implement ONLY what the acceptance criteria require — no extra features, refactors, or "improvements"
- Do NOT modify files outside the architect's annotation (unless truly unavoidable — explain in PR)
- If a blocker is found that cannot be resolved from the codebase, stop and document the question — do not guess
- Do NOT skip tests — untested code is incomplete code
- Do NOT merge the PR — that is the command layer's responsibility to signal the human gate
