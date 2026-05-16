---
name: setup
description: One-off project setup — generate config.md, PRODUCT.md, and DESIGN.md interactively.
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

# /setup — Initialize Project Config

Generate `config.md`, `PRODUCT.md`, and `DESIGN.md` for this project. Run once when adopting this workflow in a new project, or to regenerate after project structure changes.

---

## Step 1 — Check Existing Files

Before any other step, check the repo root for `config.md`, `DESIGN.md`, and `PRODUCT.md`. For each file that exists, ask the user via `AskUserQuestion` whether to **Skip** (keep current file untouched) or **Regenerate** (overwrite). Default option: Skip.

Apply the answers to gate later steps:

- **`config.md` exists and user chose Skip** → skip Steps 2–6 entirely (config gathering, write, and label creation). Read the existing `config.md` to recover the registered codebases (needed by Step 7 to know whether a web codebase exists).
- **`PRODUCT.md` exists and user chose Skip** → skip Step 7 entirely.
- **`DESIGN.md` exists and user chose Skip** → skip Step 8 entirely.
- **No files exist** → proceed straight through Steps 2–9 with no prompt.

If all three files exist and the user chose Skip for all three, exit early with a one-line note that nothing needed regenerating.

## Step 2 — Gather Codebase Names and Paths

Use `AskUserQuestion` to ask the user for each of the following codebases — ask all in one call with separate questions:

1. **API / backend** — name and path (e.g. `api` at `../my-api`)
2. **Web / frontend** — name and path (e.g. `web` at `../my-web`)
3. **Infrastructure** — name and path (e.g. `infrastructure` at `../my-api/terraform`). If none, user can skip.

Parse name and path for each codebase from their response. Omit any that the user skips.

## Step 3 — Detect Tech Stack

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

## Step 4 — Gather Migration Detection

Use `AskUserQuestion` to ask the user:

> "Does any codebase run database migrations that should be detected in PRs? If yes, describe how (e.g. 'EF Core migrations live in the backend codebase at paths containing `/Migrations/`. Filter changed files for `/Migrations/` case-insensitively.'). If no, reply 'none'."

## Step 5 — Write config.md

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

## Step 6 — Create GitHub Labels

Skip this step if `config.md` was kept in Step 1 (Skip chosen) — labels are assumed to already exist from a prior setup run.

Otherwise, run the labels script to create the workflow's GitHub labels:

```bash
bash .claude/scripts/create-github-labels.sh
```

The script uses `gh label create --force`, so re-running is safe and will update any existing label colors or descriptions to match.

If the script fails (e.g. `gh` not authenticated, or the hardcoded `REPO` does not match this repository), report the error to the user and stop. The user must resolve auth or repo setup before continuing.

## Step 7 — Generate PRODUCT.md

Create `PRODUCT.md` at the repo root.

## Step 8 — Generate DESIGN.md (Web Codebase Only)

Skip this step if no web/frontend codebase was registered in Step 2.

Generate `DESIGN.md` at the repo root for the registered web codebase, sourcing tokens from the codebase where possible and from a guided design-direction interview otherwise.

## Step 9 — Confirm

Show only the files that were (re)written in this run to the user and confirm they look correct. Skipped files are not re-displayed. Mention whether GitHub labels were (re)created.

---

## Constraints

- This command writes project-level docs (`config.md`, `PRODUCT.md`, `DESIGN.md`). Never overwrite without explicit user confirmation if a file already exists.

### Step Tracking

After completing each numbered step, emit exactly:

> STEP [N] COMPLETE
