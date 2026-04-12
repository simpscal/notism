# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Bootstrap

At the start of every conversation, before taking any other action:

1. Read `.claude/project.md` — hold in memory: tracker adapter path, repo, codebase paths, tech stack, label names, branch patterns, test/lint commands.
2. Read the tracker adapter at the path from step 1 — all issue tracker operations must use the operations it defines.

Never hardcode repo slugs, label names, paths, or branch patterns.

---

## Repo

This repo (`simpscal/notism`) is the **workflow layer only** — it contains no application code. It orchestrates development across two sibling codebases:

| Name | Path | Stack |
|------|------|-------|
| backend | `../notism-api` | C# / .NET, Clean Architecture, CQRS via MediatR, EF Core, PostgreSQL |
| frontend | `../notism-web` | React 19, TypeScript, Tailwind v4, shadcn/ui, TanStack Query, Redux Toolkit |

When working on application code, read the target codebase's CLAUDE.md and docs before making changes.

---

## Commands

```bash
# Backend
cd ../notism-api && dotnet build
cd ../notism-api && dotnet test

# Frontend
cd ../notism-web && bun run lint
cd ../notism-web && bun run test
```

---

## Workflow Architecture

All commands and agents are project-agnostic. Values come from `project.md` — never from hardcoded strings.

### Pipeline roles and their command files

| Role | File | Modes |
|------|------|-------|
| Product Owner | `.claude/commands/po.md` | `standard`, `change` |
| Business Analyst | `.claude/commands/ba.md` | `standard`, `bug`, `change`, `requirement-change` |
| Designer | `.claude/commands/design.md` | `standard`, `change`, `requirement-change` |
| Technical Lead | `.claude/commands/tl.md` | `standard`, `bug`, `change`, `requirement-change` |
| Developer | `.claude/agents/` | auto-selected by `skill:` label |
| Sprint Finish | `.claude/commands/sprint-finish.md` | — |
| Orchestrator | `.claude/commands/workflow.md` | `new`, `resume`, `bug`, `change` |

### Developer agents

`/dev` selects the agent from `skill:` labels on the ticket:

| Label | Agent |
|-------|-------|
| `skill:backend` | `.claude/agents/backend.md` |
| `skill:frontend` | `.claude/agents/frontend.md` |
| `skill:devops` | `.claude/agents/devops.md` |

Multi-skill tickets activate multiple agents in parallel.

### Tracker abstraction

All issue tracker operations (`fetch_issue`, `create_issue`, `update_labels`, `post_comment`, `create_pr`, etc.) are defined in the active tracker adapter (`.claude/trackers/github-tracker.md`). Commands call operations by name — never call GitHub CLI or MCP tools directly from command files.

### Branch patterns

- Sprint branch: `feature/sprint-{N}`
- Story branch (single skill): `feature/issue-{N}-{short-description}`
- Story branch (multi-skill): `feature/issue-{N}-{short-description}-backend` / `-frontend`
- Bug branch: `fix/issue-{N}-{short-description}`

### Change management

When a requirement changes mid-pipeline, the Requirement Change Cascade propagates updates downstream: PO updates the requirement → BA re-evaluates stories → TL and Designer re-evaluate if their artifacts already exist.

---

## Architecture Docs for Application Codebases

Read in this order before touching application code:

1. `../notism-api/CLAUDE.md`
2. `../notism-api/docs/rules/architecture.md`
3. `../notism-api/docs/rules/best-practices.md`
4. `../notism-api/docs/rules/naming.md`
5. `../notism-web/CLAUDE.md`
6. `../notism-web/docs/rules/architecture.md`
7. `../notism-web/docs/rules/best-practices.md`
8. `../notism-web/docs/rules/naming.md`

Files marked "(if it exists)" — skip silently if absent.
