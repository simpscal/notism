# Comment: Design Hub

## OUTPUT FORMAT

```
## Design Navigation

### Per-surface Artifacts
| Surface | Mock UI | Design Instructions |
|---------|---------|---------------------|
| <name>  | [<file>.html](<mock blob>) | [<file>.md](<design instructions blob>) |
```

---

## FIELDS

| Field | Req | Notes |
|-------|-----|-------|
| `per_surface_artifacts` | yes | Table: per row, the surface name + its mock UI blob URL + its design instructions blob URL. URLs point at the orchestrator's sprint branch — mockups at `<orchestrator-root>/sprint-<N>/mockups/<surface-slug>.html` and instructions at `<orchestrator-root>/sprint-<N>/instructions/<surface-slug>.md`. |

Posted as a comment on the sprint's scope-of-record issue (the requirement issue in the feature workflow). The comment is the navigation hub for the sprint's design artifacts — implementers follow the per-surface links to read the design instructions and inspect the mockup before writing code.
