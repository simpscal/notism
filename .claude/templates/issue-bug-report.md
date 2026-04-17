# Issue Bug Report Template

Posted to GitHub by `/bug-report`.

---

## OUTPUT FORMAT

```
## Bug Report

### Description
<concise summary of the defective behaviour>

### Steps to Reproduce
1. <step>
2. <step>

### Expected Behaviour
<what should happen>

### Actual Behaviour
<what actually happens>

### Severity
<critical | high | medium | low>
```

---

## FIELDS

### Description
**REQUIRED** | text | 1-2 sentences

**Rules**:
- Focus on impact, not tech details
- Understandable to non-technical stakeholder
- Answer: What broken, what user impact

**Wrong**: ❌ "CartService throws NullReference" (too technical), ❌ "Something wrong" (vague)

### Steps to Reproduce
**REQUIRED** | numbered list | 2-15 steps

**Rules**:
- Numbered, chronological order
- Each step actionable (specific user action or state)
- Include preconditions (logged in, specific data, etc.)

**Wrong**: ❌ "Try checkout with lots of items" (not specific), ❌ Out of order, ❌ Missing prerequisites

### Expected Behaviour
**REQUIRED** | text | 1-2 sentences

**Rules**:
- Describe what SHOULD happen
- Specific and observable
- Reference requirements/specs if known

**Wrong**: ❌ "It should work" (not specific), ❌ "No error" (describes absence)

### Actual Behaviour
**REQUIRED** | text | 1-3 sentences

**Rules**:
- Describe what ACTUALLY happens
- Specific and observable
- Include error messages if visible
- May include technical details (console errors, status codes)

**Wrong**: ❌ "It doesn't work" (not specific), ❌ Only tech details without user impact

### Severity
**REQUIRED** | enum[critical | high | medium | low]

| Level    | When to use                                            |
| -------- | ------------------------------------------------------ |
| critical | System unusable, data loss, security breach, all users |
| high     | Core feature broken, many users affected               |
| medium   | Feature impaired, workaround exists, some users        |
| low      | Cosmetic, minor inconvenience, edge case               |

**Wrong**: ❌ "Critical", "HIGH", "p1", "blocker"

---

## CHECKLIST

- [ ] Description explains user impact
- [ ] Steps specific, numbered, ordered
- [ ] Steps include preconditions
- [ ] Expected describes what SHOULD happen
- [ ] Actual describes what DOES happen
- [ ] Severity matches criteria
- [ ] Understandable without codebase access
