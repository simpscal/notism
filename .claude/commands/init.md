# /init — Initialize Project Config

Generate `config.md` for this project. Run once when adopting this workflow in a new project, or to regenerate after project structure changes.

---

## Steps

### Step 1 — Gather Codebases

Ask the user:

> "List your project codebases. For each, provide:
> - **name** — logical identifier used by agents (e.g. `backend`, `frontend`, `infrastructure`)
> - **path** — relative to this repo root (e.g. `../my-api`)
> - **summary** — one-line tech stack description
>
> Reply in any format."

Wait for response. Parse name, path, and summary for each codebase.

### Step 2 — Gather Migration Detection

Ask the user:

> "Does any codebase run database migrations that should be detected in PRs? If yes, describe how (e.g. 'EF Core migrations live in the backend codebase at paths containing `/Migrations/`. Filter changed files for `/Migrations/` case-insensitively.'). If no, reply 'none'."

Wait for response.

### Step 3 — Write config.md

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

### Step 4 — Confirm

Show the written `config.md` content to the user and confirm it looks correct.
