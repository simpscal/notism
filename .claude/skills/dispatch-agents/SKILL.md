---
name: dispatch-agents
description: Agent dispatch protocol — context passing and output handling. Auto-invoked whenever backend, frontend, or devops agents are spawned.
tools: Agent
---

# Dispatch Agents

## Context to Pass

Pass the following to every spawned agent. All context is passed directly — do NOT instruct agents to fetch issues, read files, or re-derive context:

| Context | Source |
|---------|--------|
| Requirements | Story description + full `## Acceptance Criteria` section |
| Decisions | **Story**: relevant TDD sections verbatim — architecture key decisions, components design, API specification, data models, alternatives considered, risks. Pass `none` if no TDD exists. **Bug**: dev investigation verbatim — Root Cause, Scope, Fix Approach, Risk. |
| Design instructions | Full design instructions issue (frontend only) — sprint-level document |
| Constraints | Orchestrator-provided scope restrictions and supporting data — omit if none |

## Output Handling

After all spawned agents complete:

- Agent returns `NO_WORK: …` → log it, take no further action for that domain.
- Agent returns work done → verify output, mark domain complete.
- Agent reports a blocker → post a comment on issue `#ISSUE_NUMBER` with the blocker details and halt all remaining work.
