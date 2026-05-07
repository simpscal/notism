---
name: init
description: Initialize Project Config — generate config.md interactively.
tools: Read, Write, Glob, Bash, AskUserQuestion
---

# /init — Initialize Project Config

Generate `config.md` for this project. Run once when adopting this workflow in a new project, or to regenerate after project structure changes.

---

## Step 1 — Gather Codebase Names and Paths

Use `AskUserQuestion` to ask the user for each of the following codebases — ask all in one call with separate questions:

1. **API / backend** — name and path (e.g. `api` at `../my-api`)
2. **Web / frontend** — name and path (e.g. `web` at `../my-web`)
3. **Infrastructure** — name and path (e.g. `infrastructure` at `../my-api/terraform`). If none, user can skip.

Parse name and path for each codebase from their response. Omit any that the user skips.

## Step 2 — Detect Tech Stack

For each codebase path, read the repo to identify the tech stack. Look for:

- `package.json` — Node.js / framework (check `dependencies` and `devDependencies` for Next.js, React, Vue, Express, NestJS, etc.)
- `*.csproj` or `*.sln` — .NET (check `TargetFramework` for version, check for EF Core packages)
- `requirements.txt` or `pyproject.toml` or `setup.py` — Python (check for Django, FastAPI, Flask, etc.)
- `pom.xml` — Java/Spring
- `go.mod` — Go
- `Gemfile` — Ruby/Rails
- `Cargo.toml` — Rust
- `pubspec.yaml` — Flutter/Dart
- `build.gradle` — Kotlin/Java
- `*.tf` + `versions.tf` — Terraform (check provider and resource types for AWS/GCP/Azure, note version constraint)

Resolve the path relative to the repo root. Use `Glob` and `Read` to inspect these files. Compose a one-line summary per codebase (e.g. `Next.js 14 frontend with TypeScript`, `ASP.NET Core 8 REST API with EF Core`).

## Step 3 — Gather Migration Detection

Use `AskUserQuestion` to ask the user:

> "Does any codebase run database migrations that should be detected in PRs? If yes, describe how (e.g. 'EF Core migrations live in the backend codebase at paths containing `/Migrations/`. Filter changed files for `/Migrations/` case-insensitively.'). If no, reply 'none'."

## Step 4 — Write config.md

Write `config.md` to the repo root with the collected data. The Labels section is static and identical across all projects — always include it verbatim.

```markdown
# Project Config

## Codebases

| Name | Path | Summary |
|------|------|---------|
{one row per codebase: | {name} | `{path}` | {summary} |}

---

## Migration Detection

{user's migration detection description, or "No migration detection configured." if none}

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
| QA test cases verified by human | `qa-passed` |
| QA test cases have failures | `qa-blocked` |
```

## Step 5 — Confirm

Show the written `config.md` content to the user and confirm it looks correct.
