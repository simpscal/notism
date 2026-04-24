# Comment Dev Investigation Template

Posted by `/dev` (bug mode, after root cause investigation, before implementation).

---

## OUTPUT FORMAT

```
## Dev Investigation

**Complexity**: <S | M | L>

### Root Cause
- <plain-English explanation of WHY the bug occurs — no technical terms, file names, or layer names>
- <additional cause if multi-cause bug>

### Scope
<plain-English description of which part of the product is affected — no file paths, no layer names>

### Fix Approach
[frontend | backend | devops | frontend + backend | ...]

- **<Action>** — <rationale>
- **<Action>**:
  - <sub-bullet with detail>
  - <sub-bullet with detail>

### Risk
<Low — logic fix only | Migration required: <details> | etc.>
```

---

## FIELDS

### Complexity
**REQUIRED** | enum[S | M | L]

| Size | Time | Scope |
|------|------|-------|
| S | <4h | Single layer, isolated |
| M | 4-8h | Standard pattern, one layer, multiple files |
| L | >8h | Cross-cutting, multiple layers, refactoring |

**Wrong**: ❌ "Small", "s", "medium", "1"

### Root Cause
**REQUIRED** | plain-language bullets

**Audience**: Non-technical stakeholders (PO, BA) — no jargon, no file names, no layer names.

**Rules**:
- One bullet per distinct cause — WHY the bug occurs, not WHAT happens
- Use everyday language: "The system was saving the wrong value" not "userId was assigned to sessionToken in AuthService.cs"
- Causality allowed: "X was missing, so Y happened" — but keep it simple
- Single-cause bugs: one bullet. Multi-cause: multiple bullets.

**Wrong**: ❌ File paths, class names, technical layer names, ❌ Describes symptom not cause

### Scope
**REQUIRED** | plain-language text

**Audience**: Non-technical stakeholders — describe WHAT part of the product is affected, not WHERE in the code.

**Rules**:
- Name the feature area or user-facing surface (e.g., "the login page", "email notifications", "the dashboard summary")
- No file paths, no layer names (domain, application, infrastructure), no class names

**Wrong**: ❌ "src/Auth/AuthService.cs", ❌ "Application layer and domain services", ❌ "Multiple services"

### Fix Approach
**REQUIRED** | structured bullets

**Rules**:
- Open with `[frontend]`, `[backend]`, or `[devops]` tag (or combined, e.g. `[frontend + backend]`) on its own line
- One bullet per distinct change — bold the action verb or subject
- Use indented sub-bullets for detail (e.g. listing specific field mappings, enum values)
- Describe WHAT to change, not HOW to code — no code snippets
- Use imperative: "Add", "Update", "Remove", "Change"

**Wrong**: ❌ Prose paragraph instead of bullets, ❌ Code examples, ❌ Missing side tag

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

- [ ] Complexity is S | M | L
- [ ] Complexity matches time/impact
- [ ] Root Cause uses plain language — no file paths, class names, or layer names
- [ ] Root Cause explains WHY (cause), not WHAT (symptom)
- [ ] Scope names the product area, not code locations
- [ ] Fix Approach opens with side tag(s) on its own line
- [ ] Fix Approach uses bullets, actionable, no code
- [ ] Risk level clearly stated
