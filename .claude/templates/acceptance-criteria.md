# Acceptance Criteria Template

Used across all story and bug templates.

---

## OUTPUT FORMAT

```
## Acceptance Criteria
- [ ] <AC 1>
- [ ] <AC 2>

## Notes
<Edge cases, open questions, dependencies, constraints>
```

---

## FIELDS

### Acceptance Criteria
**REQUIRED** | checklist | 2-8 items | 10-150 chars each

**Patterns**:
- User action: `When <condition>, user can/sees/cannot <outcome>`
- System: `System <behavior> when <condition>`
- Access: `<Feature> only accessible to <role>`
- Validation: `<Field> errors when <invalid>`

**Rules**:
- Observable to non-technical stakeholder
- Testable without code
- Pass/fail, no ambiguity
- No implementation details

**Wrong**:
- ❌ "Implement export" (not observable)
- ❌ "Use Redux" (implementation)
- ❌ "Make fast" (not measurable)
- ❌ "Handle edge cases" (vague)

### Notes
**OPTIONAL** | text | 0-500 chars

**Include**: Edge cases, open questions, dependencies (use `link_to(id)`), constraints

---

## CHECKLIST

- [ ] All ACs observable by non-engineer
- [ ] No implementation details in ACs
- [ ] Each AC has clear pass/fail
- [ ] Notes use `link_to(id)` for references
- [ ] No `<AC 1>` placeholders remain
