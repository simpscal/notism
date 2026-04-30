# Dispatch to Skill Subagent

Always spawn all three subagents (`backend`, `frontend`, `devops`) in **parallel**. Each subagent self-evaluates scope and reports back. Do NOT pre-filter.

## Context to Pass

Pass the following context to every subagent. **All context is passed directly — do NOT instruct subagents to fetch issues, read project files, or re-derive context:**

| Context | Source |
|---------|--------|
| Requirements | Story description + full `## Acceptance Criteria` section |
| Decisions | **Story**: Relevant TDD sections verbatim — architecture key decisions, components design, API specification, data models, alternatives considered, risks. Pass `none` if no TDD exists — subagents derive scope from the story ACs and existing codebase. **Bug**: Dev investigation verbatim — Root Cause, Scope, Fix Approach, Risk. |
| Design instructions | Full design instructions issue (frontend only) — sprint-level document |

## Dispatch Rules

Always launch all three subagents in a single parallel message:

```
backend + frontend + devops  →  parallel (always)
```

## Orchestrator Response

After all three subagents complete:

- Subagent returns `NO_WORK: …` → log it, take no further action for that domain.
- Subagent returns work done → verify output, mark domain complete.
- Subagent reports a blocker → post a comment on issue `#ISSUE_NUMBER` with the blocker details and halt all remaining work.
