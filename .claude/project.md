# Project Configuration

This file is the single source of truth for all project-specific values. Commands and skills read it at startup and use its values throughout — nothing is hardcoded in the workflow files.

---

## Issue Tracker

- **Type**: github
- **Repo**: simpscal/notism
- **Tracker adapter**: `.claude/trackers/github-tracker.md`

---

## Codebases

| Name | Path | Summary |
|------|------|---------|
| backend | `../notism-api` | .NET (C#), Clean Architecture (Onion), CQRS via MediatR, EF Core, PostgreSQL |
| frontend | `../notism-web` | React 19, TypeScript, Tailwind v4, shadcn/ui (Radix UI), TanStack Query, Redux Toolkit |

---

## Architecture Docs

Read in this order when studying the codebase:
- `../notism-api/CLAUDE.md`
- `../notism-api/docs/rules/architecture.md` (if it exists)
- `../notism-api/docs/rules/best-practices.md` (if it exists)
- `../notism-api/docs/rules/naming.md` (if it exists)
- `../notism-web/CLAUDE.md`
- `../notism-web/docs/rules/architecture.md` (if it exists)
- `../notism-web/docs/rules/best-practices.md` (if it exists)
- `../notism-web/docs/rules/naming.md` (if it exists)

---

## Tech Stack Details

### Backend
- **Language**: C# / .NET
- **Architecture**: Clean Architecture (Onion) with CQRS via MediatR
- **Validation**: FluentValidation (inline in command/query files)
- **ORM**: EF Core + PostgreSQL
- **Result pattern**: `Result<T>` / `ResultFailureException`
- **Query pattern**: Specification classes
- **Testing**: xUnit + FluentAssertions + NSubstitute

### Frontend
- **Language**: TypeScript / React 19
- **Styling**: Tailwind v4
- **Component library**: shadcn/ui (Radix UI primitives)
- **Server state**: TanStack Query
- **Global client state**: Redux Toolkit
- **Forms**: React Hook Form + Zod
- **Testing**: Vitest + MSW

---

## Labels

| Purpose | Label |
|---------|-------|
| PO requirement | `requirement` |
| BA-created story | `user-story` |
| Awaiting TL | `sprint-ready` |
| TL complete | `tl-reviewed` |
| TDD issue | `technical-design` |
| Design complete | `design-reviewed` |
| Dev in progress | `in-progress` |
| Story amended after creation | `story-updated` |
| Story removed during requirement change | `story-removed` |
| Requirement updated after change | `requirement-updated` |
| Sprint closed | `sprint-completed` |
| Skill prefix | `skill:` (e.g. `skill:frontend`) |
| Bug issue | `bug` |
| Dev implementation complete | `implemented` |

---

---

## Commands

| Codebase | Test | Lint / Build |
|----------|------|-------------|
| backend | `cd ../notism-api && dotnet test` | `cd ../notism-api && dotnet build` |
| frontend | `cd ../notism-web && bun run test` | `cd ../notism-web && bun run lint` |
