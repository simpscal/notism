---
name: dev-solo
description: Dev Solo — implement a task from the conversation directly on the current branch (no tracker, no PR). Usage: /dev-solo <task description>
tools: Read, Glob, Grep, Bash, Agent(backend, frontend, devops)
---

# Implement Orchestrator (Tracker-Free)

## Workflow

### Step 0 — Read Project Config

Read `.claude/project.md`. Extract and hold in memory: codebase paths, tech stack details, main branch name, and test/lint commands. Skip the tracker adapter — it is not needed.

### Step 1 — Acquire Task

`$ARGUMENTS` is the task description.

If no `$ARGUMENTS` provided, read the task description from the current conversation context.

Infer the skill(s) required (backend / frontend / devops) from the task description. If ambiguous, ask the user before proceeding.

### Step 2 — Dispatch to Skill Subagent

Invoke the matching subagent(s) using the Agent tool.

Pass the following context to every subagent invocation. **All context is passed directly — do NOT instruct subagents to read project.md:**

- **Task**: full task description from `$ARGUMENTS` or conversation context
- **TL Annotation**: "None"
- **TDD**: "None"
- **Design instructions**: "None" (unless the user has provided design details in the conversation — include those verbatim)
- **Story Amendment**: "None"
- **Existing PR**: "None"
- **Git**: main branch name
- **Project config**: codebase paths, tech stack, test/lint commands loaded in Step 0

**Do NOT create a new branch or open a PR.** Implement directly on the current branch and commit the changes.

| Inferred skill | Subagent(s) | Execution |
|----------------|-------------|-----------|
| backend | `backend` | single |
| frontend | `frontend` | single |
| devops | `devops` | single |
| backend + frontend | `backend` + `frontend` | **parallel** |

**Multi-skill tasks:** Invoke `backend` and `frontend` simultaneously in a single message.

If any subagent reports a blocker, surface it directly in the conversation and halt.

### Step 3 — Report

Once all subagents have completed, summarise what was implemented and committed in the conversation.

## Constraints

- Implement strictly within the scope of the task description — no extras, no unrequested refactors
- Do not create a branch or open a PR
- If a blocker is found, surface it and stop — do not guess
