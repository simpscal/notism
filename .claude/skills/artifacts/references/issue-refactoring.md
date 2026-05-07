# Issue: Refactoring Task

## OUTPUT FORMAT

```
## Refactoring Task

### Problem Statement
<why this refactor is needed — tech debt, tight coupling, performance, maintainability>

### Motivation
<what this unlocks or improves once complete>

### Scope
- <file / module / layer>

### Technical Approach
1. <step>

### Affected Codebases
- <backend | frontend | infrastructure>

### Definition of Done
- [ ] All existing tests pass
- [ ] No user-visible behavior change
- [ ] <additional specific DoD item>
```

---

## FIELDS

| Field | Req | Notes |
|-------|-----|-------|
| `problem_statement` | yes | 2–3 sentences — specific and technical, not vague |
| `motivation` | yes | 1–2 sentences — what improves or becomes possible |
| `scope` | yes | Bullet list of specific files, modules, or layers |
| `technical_approach` | yes | Numbered steps — sequential, concrete, implementable |
| `affected_codebases` | yes | `backend` \| `frontend` \| `infrastructure` — one per line |
| `definition_of_done` | yes | Always include "All existing tests pass" and "No user-visible behavior change"; add specifics |
