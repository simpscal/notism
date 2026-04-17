# Comment TL Annotation Template

Posted by `/tl` (bug mode T6).

---

## OUTPUT FORMAT

```
## Technical Lead Annotation

**Skill**: <frontend | backend | both>
**Complexity**: <S | M | L>

### Root Cause
[frontend | backend | devops] <which layer/module is responsible and why>

### Scope
<which layers and specific files are touched>

### Fix Approach
[frontend | backend | devops | frontend + backend | ...] <what needs to change — 1–3 sentences>

### Key Decisions
- <Decision: what was chosen and why>

### Risk
<Low — logic fix only | Migration required: <details> | etc.>
```

---

## FIELDS

### Skill
**REQUIRED** | enum[frontend | backend | both]

**Rules**:
- `frontend`: Bug in React/UI layer only
- `backend`: Bug in .NET API/database only
- `both`: Changes span multiple codebases

**Wrong**: ❌ "Frontend", "Back-end", "fullstack", "ui"

### Complexity
**REQUIRED** | enum[S | M | L]

| Size | Time | Scope |
|------|------|-------|
| S | <4h | Single layer, isolated |
| M | 4-8h | Standard pattern, one layer, multiple files |
| L | >8h | Cross-cutting, multiple layers, refactoring |

**Wrong**: ❌ "Small", "s", "medium", "1"

### Root Cause
**REQUIRED** | text | 1-3 sentences

**Rules**:
- Open with `[frontend]`, `[backend]`, or `[devops]` tag to identify which side originates the bug
- Identify specific layer/module responsible
- Explain WHY bug occurs, not just WHAT
- Technical but understandable to developer

**Wrong**: ❌ "Code is broken" (not specific), ❌ Describes symptom not cause, ❌ Missing side tag

### Scope
**REQUIRED** | text

**Include**:
- Which architectural layers affected
- Specific file paths (relative to codebase root)
- May use wildcards (e.g., `*.Service.cs`)

**Wrong**: ❌ "Backend files", "Multiple services"

### Fix Approach
**REQUIRED** | text | 1-3 sentences

**Rules**:
- Open with `[frontend]`, `[backend]`, or `[devops]` tag (or combined, e.g. `[frontend + backend]`) to identify which side(s) need changes
- Describe WHAT to change, not HOW to code
- No code snippets
- Actionable guidance
- Use imperative: "Add", "Update", "Remove", "Change"

**Wrong**: ❌ "Fix the bug", ❌ Code examples, ❌ "Developer should refactor everything", ❌ Missing side tag

### Key Decisions
**REQUIRED** | list | Min 1 decision

**Format**: `<Decision>: <Rationale>`

**Include**: Trade-offs, rejected alternatives with reasons

**Wrong**: ❌ "Use best practices" (no decision), ❌ No rationale

### Risk
**REQUIRED** | text

**Patterns**:
- `Low — logic fix only`
- `Low — no breaking changes`
- `Medium — migration required: <details>`
- `High — breaking API change: <impact>`
- `High — data integrity risk: <mitigation>`

**Wrong**: ❌ "No risk", "Some risk", "Risky"

---

## CHECKLIST

- [ ] Skill is frontend | backend | both
- [ ] Complexity is S | M | L
- [ ] Complexity matches time/impact
- [ ] Root Cause opens with [frontend | backend | devops] tag
- [ ] Root Cause explains WHY, not WHAT
- [ ] Scope has specific file paths
- [ ] Fix Approach opens with side tag(s)
- [ ] Fix Approach actionable, no code
- [ ] Min 1 Key Decision with rationale
- [ ] Risk level clearly stated
