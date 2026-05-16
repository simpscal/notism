---
name: dispatch-agents
description: Use when spawning backend, frontend, or devops agents. Defines context-passing and output-handling protocol; auto-invokes on every such spawn.
tools: Agent
---

# Dispatch Agents

## Context to Pass

Pass the following to every spawned agent as a `<context>` XML block. All context is passed directly — do NOT instruct agents to fetch issues, read files, or re-derive context:

```xml
<context>
  <requirements>
    <story>[user story statement]</story>
    <acceptance_criteria>
- [ ] [AC 1]
- [ ] [AC 2]
    </acceptance_criteria>
  </requirements>
  <decisions type="tdd|investigation|none">
    [verbatim TDD sections or investigation fields — use "none" if no TDD exists]
  </decisions>
  <design_instructions>
    [full design issue content — frontend only; omit this tag entirely for backend/devops]
  </design_instructions>
  <constraints>
    [orchestrator-provided scope restrictions — omit this tag entirely if none]
  </constraints>
</context>
```

## Output Handling

After all spawned agents complete:

- Agent returns `<no_work>` → log the `<reason>`, take no further action for that domain.
- Agent returns `<result>` → verify `<files_changed>`, mark domain complete.
- Agent returns `<blocked>` → post a comment on issue `#ISSUE_NUMBER` with the `<reason>` details and halt all remaining work. Output to the user:

  ```
  ⛔ Blocked on #<ISSUE_NUMBER>: <reason summary>
  ```
