# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Bootstrap

At the start of every conversation, before taking any other action:

Never hardcode repo slugs, label names, paths, or branch patterns.

---

## Codebases

| Name | Path | Summary |
|------|------|---------|
| backend | `../notism-api` | .NET (C#), Clean Architecture (Onion), CQRS via MediatR, EF Core, PostgreSQL |
| frontend | `../notism-web` | React 19, TypeScript, Tailwind v4, shadcn/ui (Radix UI), TanStack Query, Redux Toolkit |
| infrastructure | `../notism-api/terraform` | AWS (EC2, RDS, S3, CloudFront, ECR) |

---

## Labels

| Purpose | Label |
|---------|-------|
| PO requirement | `requirement` |
| BA-created story | `user-story` |
| TDD issue | `technical-design` |
| Design instructions issue | `design` |
| Dev in progress | `in-progress` |
| Story amended after creation | `story-updated` |
| Story removed during requirement change | `story-removed` |
| Requirement updated after change | `requirement-updated` |
| Sprint closed | `sprint-completed` |
| Bug issue | `bug-production` |
| Bug resolved and closed | `bug-fixed` |
| Dev implementation complete | `implemented` |