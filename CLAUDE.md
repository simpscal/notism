# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Bootstrap

At the start of every conversation, before taking any other action:

Read the tracker adapter at `.claude/trackers/github-tracker.md` — all issue tracker operations must use the operations it defines.

Never hardcode repo slugs, label names, paths, or branch patterns.

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

## Labels

| Purpose | Label |
|---------|-------|
| PO requirement | `requirement` |
| BA-created story | `user-story` |
| Awaiting TL | `sprint-ready` |
| TL complete | `tl-reviewed` |
| TDD issue | `technical-design` |
| Design instructions issue | `design` |
| Design complete | `design-reviewed` |
| Dev in progress | `in-progress` |
| Story amended after creation | `story-updated` |
| Story removed during requirement change | `story-removed` |
| Story added during requirement change | `story-added` |
| Requirement updated after change | `requirement-updated` |
| Sprint closed | `sprint-completed` |
| Bug issue | `bug` |
| Bug resolved and closed | `bug-fixed` |
| Dev implementation complete | `implemented` |

---

## Commands

| Codebase | Test | Lint / Build |
|----------|------|-------------|
| backend | `cd ../notism-api && dotnet test` | `cd ../notism-api && dotnet build` |
| frontend | `cd ../notism-web && bun run test` | `cd ../notism-web && bun run lint` |
