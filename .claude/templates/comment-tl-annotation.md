# Comment TL Annotation Template

Technical Lead bug annotation comment. Used by `/tl` (bug mode T6).

```
## Technical Lead Annotation

**Skill**: <frontend | backend | both>
**Complexity**: <S | M | L>

### Root Cause
<which layer/module is responsible and why>

### Scope
<which layers and specific files are touched>

### Fix Approach
<what needs to change — 1–3 sentences>

### Key Decisions
- <Decision: what was chosen and why>

### Risk
<Low — logic fix only | Migration required: <details> | etc.>
```

**Skill:** `frontend | backend | both` — determined in T5.

**Complexity:** `S | M | L` — S = <4h single layer, M = 4–8h standard pattern, L = >8h complex/cross-cutting.

**Root Cause:** which layer/module is responsible and why.

**Scope:** which layers and specific files are touched.

**Fix Approach:** what needs to change — 1–3 sentences, no code.

**Key Decisions:** at least one decision with rationale.

**Risk:** `Low — logic fix only` | `Migration required: <details>` | other.
