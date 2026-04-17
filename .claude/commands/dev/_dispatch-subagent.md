# Dispatch to Skill Subagent

Inspect the ticket's `skill:` label(s) and invoke the matching subagent(s) using the Agent tool.

**If the skill label is missing or unrecognised:** Stop and report: "No skill label found on ticket — run `/tl` to process the sprint first."

## Context to Pass

Pass the following context to every subagent. **All context is passed directly — do NOT instruct subagents to fetch issues, read project files, or re-derive context:**

| Context | Source |
|---------|--------|
| Requirements | Story description + full `## Acceptance Criteria` section |
| Architecture context | Relevant TDD sections verbatim — architecture key decisions, components design, API specification, data models, alternatives considered, risks |
| Design instructions | Full design instructions issue (frontend only) — sprint-level document |
| Codebase config | Root path, test command, lint/build command (from project config) |

**Note:** Dev synthesizes scope and key decisions by reading relevant TDD sections (Components Design, API Spec, Data Models, Architecture Key Decisions) in context of the story's acceptance criteria.

## Dispatch Table

| Skill label | Subagent(s) | Execution |
|-------------|-------------|-----------|
| `skill:backend` only | `backend` | single |
| `skill:frontend` only | `frontend` | single |
| `skill:devops` only | `devops` | single |
| `skill:backend` + `skill:frontend` | `backend` + `frontend` | **parallel** |

If any subagent reports a blocker, `post_comment(ISSUE_NUMBER)` with the blocker and halt.
