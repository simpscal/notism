# Issue User Story Template

Posted to GitHub by `/ba` (standard mode S4, requirement-change mode RC4).

Read `.claude/templates/acceptance-criteria.md` for AC format.

---

## OUTPUT FORMAT

```
## User Story
<As a ... I want ... so that ...>

<Acceptance Criteria + Notes from acceptance-criteria.md>

---
Part of <link_to(requirement_issue_number)>
```

---

## FIELDS

### User Story
**REQUIRED** | text

**Pattern**: `As a <user type>, I want <action> so that <goal/benefit>`

**Rules**:
- Include all three: role, action, benefit
- Focus on user need, not implementation
- Specific user type, not generic "user" unless truly generic

**User roles**: Admin, Manager, Regular user, Guest, Customer, Employee, Auditor, System administrator

**Wrong**: ❌ Vague role/action/benefit, ❌ "Implement feature" (not user story), ❌ Technical details, ❌ Missing "so that"

### Acceptance Criteria + Notes
**REQUIRED** | sections

**Include**: `## Acceptance Criteria` and optionally `## Notes`

**See**: `.claude/templates/acceptance-criteria.md` for detailed specs

### Part of
**REQUIRED** | text with link

**Format**: `Part of <link_to(requirement_issue_number)>`

**Rules**:
- Separated by `---` horizontal rule
- Use `link_to()` function from tracker adapter
- Issue number is parent requirement

**Wrong**: ❌ "Related to #142", ❌ Direct `#142` (must use link_to), ❌ Missing `---`

---

## CHECKLIST

- [ ] Follows "As a... I want... so that..." pattern
- [ ] Specific user role, not generic
- [ ] Clear benefit in "so that" clause
- [ ] AC section with 2-8 criteria
- [ ] All ACs observable and testable
- [ ] Notes if edge cases/dependencies exist
- [ ] `---` separates story from footer
- [ ] "Part of" uses link_to() with correct issue number
