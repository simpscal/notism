# Comment TL Annotation Template

Posted by `/tl` (bug mode T6).

---

## OUTPUT FORMAT

```
## Technical Lead Annotation

**Skill**: <frontend | backend | both>
**Complexity**: <S | M | L>

### Root Cause
[frontend | backend | devops]

**<Group label — e.g. PRIMARY, SECONDARY, or descriptive heading>:**
- <specific cause bullet>
- <specific cause bullet>

**<Group label>:**
- <specific cause bullet>
- <specific cause bullet>

### Scope
<which layers and specific files are touched>

### Fix Approach
[frontend | backend | devops | frontend + backend | ...]

- **<Action>** — <rationale>
- **<Action>**:
  - <sub-bullet with detail>
  - <sub-bullet with detail>

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
**REQUIRED** | structured bullets

**Rules**:
- Open with `[frontend]`, `[backend]`, or `[devops]` tag on its own line
- Group bullets under bold headings (e.g. `**PRIMARY — <label>:**`, `**SECONDARY — <label>:**`)
- Each bullet explains one specific cause — WHY it occurs, not just WHAT happens
- Use `→` to show causality within a bullet when useful
- Single-cause bugs may use one group; multi-cause bugs use multiple groups

**Wrong**: ❌ Prose paragraph instead of bullets, ❌ Describes symptom not cause, ❌ Missing side tag

### Scope
**REQUIRED** | text

**Include**:
- Which architectural layers affected
- Specific file paths (relative to codebase root)
- May use wildcards (e.g., `*.Service.cs`)

**Wrong**: ❌ "Backend files", "Multiple services"

### Fix Approach
**REQUIRED** | structured bullets

**Rules**:
- Open with `[frontend]`, `[backend]`, or `[devops]` tag (or combined, e.g. `[frontend + backend]`) on its own line
- One bullet per distinct change — bold the action verb or subject
- Use indented sub-bullets for detail (e.g. listing specific field mappings, enum values)
- Describe WHAT to change, not HOW to code — no code snippets
- Use imperative: "Add", "Update", "Remove", "Change"

**Wrong**: ❌ Prose paragraph instead of bullets, ❌ Code examples, ❌ Missing side tag

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
- [ ] Root Cause opens with [frontend | backend | devops] tag on its own line
- [ ] Root Cause uses grouped bullets, explains WHY not WHAT
- [ ] Scope has specific file paths
- [ ] Fix Approach opens with side tag(s) on its own line
- [ ] Fix Approach uses bullets, actionable, no code
- [ ] Min 1 Key Decision with rationale
- [ ] Risk level clearly stated
