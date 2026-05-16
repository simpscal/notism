# Comment: Redesign Hub

## OUTPUT FORMAT

```
## Redesign Navigation

### Preview UI
[sprint-{N}/index.html](<design catalog blob URL>)

### Per-surface Artifacts
| Surface | Mock UI | Design Instructions |
|---------|---------|---------------------|
| <name>  | [<file>.html](<mock blob>) | [<file>.md](<design instructions blob>) |

### Priority Implementation Table
| Priority | Story | Type | Depends on | Reason |
|---------:|-------|------|------------|--------|
| 1 | #<n> — <title> | Design Primitives | — | <reason> |
| 2 | … |
```

---

## FIELDS

| Field | Req | Notes |
|-------|-----|-------|
| `preview_ui` | yes | Single URL to `sprint-{N}/index.html` design catalog (orchestrator blob URL) |
| `per_surface_artifacts` | yes | Table: per row, the surface name + its mock UI blob URL + its design instructions blob URL |
| `priority_table` | yes | Ranked story implementation table (Design Primitives rows above Page rows). Source-of-truth for Phase 3 ordering. |
