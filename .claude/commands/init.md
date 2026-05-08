---
name: init
description: Initialize Project Config — generate config.md and DESIGN.md interactively.
tools: Read, Write, Glob, Grep, Bash, AskUserQuestion
---

# /init — Initialize Project Config

Generate `config.md` and `DESIGN.md` for this project. Run once when adopting this workflow in a new project, or to regenerate after project structure changes.

---

## Step 0 — Check Existing Files

Before any other step, check the repo root for `config.md` and `DESIGN.md`. For each file that exists, ask the user via `AskUserQuestion` whether to **Skip** (keep current file untouched) or **Regenerate** (overwrite). Default option: Skip.

Apply the answers to gate later steps:

- **`config.md` exists and user chose Skip** → skip Steps 1–5 entirely (config gathering, write, and label creation). Read the existing `config.md` to recover the registered codebases (needed by Step 6 to know whether a web codebase exists).
- **`DESIGN.md` exists and user chose Skip** → skip Step 6 entirely.
- **Neither file exists** → proceed straight through Steps 1–7 with no prompt.

If both files exist and the user chose Skip for both, exit early with a one-line note that nothing needed regenerating.

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

## Step 5 — Create GitHub Labels

Skip this step if `config.md` was kept in Step 0 (Skip chosen) — labels are assumed to already exist from a prior init run.

Otherwise, run the labels script to create the workflow's GitHub labels:

```bash
bash .claude/scripts/create-github-labels.sh
```

The script uses `gh label create --force`, so re-running is safe and will update any existing label colors or descriptions to match.

If the script fails (e.g. `gh` not authenticated, or the hardcoded `REPO` does not match this repository), report the error to the user and stop. The user must resolve auth or repo setup before continuing.

## Step 6 — Generate DESIGN.md (Web Codebase Only)

Skip this step if no web/frontend codebase was registered in Step 1.

Generate `DESIGN.md` at the repo root following the **DESIGN.md format spec** at https://github.com/google-labs-code/design.md/blob/main/docs/spec.md. The goal is a single, agent-readable source of truth that downstream agents (designer, frontend) reference for consistent UI output.

### 5.1 Detect theme tokens from the web codebase

Search the web codebase for existing design tokens. Use `Glob`, `Grep`, and `Read` to locate them. Common locations (framework-agnostic — adapt to whatever the codebase uses):

- **CSS variables**: any `*.css`, `*.scss`, `*.less` file containing `@theme`, `:root`, `.dark`, `--color-*`, `--radius`, `--font-*` declarations
- **Utility-first config**: `tailwind.config.*`, `unocss.config.*`, `windicss.config.*` — extract color, font, radius, spacing scales
- **Theme objects in code**: any file matching `theme.*`, `tokens.*`, `design-tokens.*`, `palette.*` exporting a token map (CSS-in-JS, styled-system, Chakra, MUI, etc.)
- **Design-system registries**: `components.json`, `theme.json`, or similar config files
- **Font loading**: HTML entry points and framework font imports (Google Fonts links, `next/font`, `expo-font`, `@font-face` rules)
- **Component primitives**: locate the project's primitives directory by reading its config (e.g. `components.json` `aliases`, framework conventions, or by globbing for `button.*`, `input.*`, `card.*`, `badge.*`). Observe default radius, height, padding to confirm detected tokens.

Convert OKLCH/HSL/RGB values to hex (SRGB) — the spec requires hex. Record: primary + accent palettes, surface/neutral, semantic (error and any others), font family + fallbacks, radius scale, spacing scale, default control height + radius, component variants and their state suffixes.

If NO tokens are found, fall back to `AskUserQuestion` for: brand name, primary hex color, font family, default radius, light/dark mode support.

### 5.2 Detect surface coverage

Inspect the project's route/page/feature directory structure (whichever the framework uses) to identify the major surface families and layout shells present in the project. Use this only to inform the **Overview** prose and to decide which domain-specific components to include — never invent surfaces or components that the codebase does not have.

### 5.3 Compose brand description

Use `AskUserQuestion` to ask **one** question:

> "Give a one-sentence brand voice description (tone, audience, what the product does). Skip to use a generic description."

### 5.4 Write DESIGN.md per the format spec

Author the file following the spec linked above (frontmatter schema, section order, token references, naming, variants — all defined there). The linter in 5.5 enforces compliance.

Workflow guardrails (not in the spec):

- **Preserve detected token names.** If the project already uses `primary` / `primary-foreground` (shadcn) or any other convention, keep those names — do not rename to spec's recommended convention.
- **Do not invent.** Components, palettes, surfaces, and signature features must come from the codebase scan (5.1) and surface scan (5.2). If something isn't in the project, it doesn't go in DESIGN.md.
- **Brand voice.** The Overview prose should be specific to this product (from 5.3) — not generic UX language.

### 5.5 Validate

Run the official linter against the written file:

```bash
npx -y @google/design.md lint DESIGN.md
```

If the linter reports errors (broken token refs, invalid colors, schema violations, duplicate sections), fix and re-run until clean before proceeding.

## Step 7 — Confirm

Show only the files that were (re)written in this run to the user and confirm they look correct. Skipped files are not re-displayed. Mention whether GitHub labels were (re)created.
