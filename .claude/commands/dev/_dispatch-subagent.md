# Dispatch to Skill Subagent

Inspect the requirements and architecture context to determine which subagent(s) to invoke.

## Context to Pass

Pass the following context to every subagent. **All context is passed directly — do NOT instruct subagents to fetch issues, read project files, or re-derive context:**

| Context | Source |
|---------|--------|
| Requirements | Story description + full `## Acceptance Criteria` section |
| Architecture context | **Story**: Relevant TDD sections verbatim — architecture key decisions, components design, API specification, data models, alternatives considered, risks. **Bug**: Dev investigation verbatim — Root Cause, Scope, Fix Approach, Risk. |
| Design instructions | Full design instructions issue (frontend only) — sprint-level document |

**Note:** Dev synthesizes scope and key decisions by reading relevant TDD sections (Components Design, API Spec, Data Models, Architecture Key Decisions) in context of the story's acceptance criteria.

## Dispatch Table

Agent determines which subagent(s) to invoke based on requirements and architecture context:

| Condition | Subagent(s) | Execution |
|-----------|-------------|-----------|
| Backend work only | `backend` | single |
| Frontend work only | `frontend` | single |
| DevOps work only | `devops` | single |
| Backend + Frontend | `backend` + `frontend` | **parallel** |
| Backend + DevOps | `backend` + `devops` | **parallel** |
| Frontend + DevOps | `frontend` + `devops` | **parallel** |
| All three | `backend` + `frontend` + `devops` | **parallel** |

If any subagent reports a blocker, `post_comment(ISSUE_NUMBER)` with the blocker and halt.
