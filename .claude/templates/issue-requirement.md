# Issue Requirement Template

Posted to GitHub by `/po`.

---

## OUTPUT FORMAT

```
## Summary
<2–3 sentence summary of what is needed and why>

## Goals
- <Goal 1>
- <Goal 2>

## Out of Scope
<Anything explicitly excluded, or "Not specified">
```

---

## FIELDS

### Summary
**REQUIRED** | text | 2-3 sentences

**Rules**:
- Sentence 1: What needed
- Sentence 2: Why now
- Sentence 3 (optional): Expected outcome
- Business-focused, no tech details
- Understandable to non-technical stakeholders

**Wrong**: ❌ Single run-on sentence, ❌ Vague, ❌ Technical details, ❌ 4+ sentences

### Goals
**REQUIRED** | list | 2-6 items

**Rules**:
- Start with verb or describe outcome
- Specific and measurable where possible
- User-centric (focus on user benefits)
- No implementation details

**Wrong**: ❌ Only 1 goal, ❌ "Make system better" (vague), ❌ "Use CSV library" (technical)

### Out of Scope
**REQUIRED** | text or list

**If nothing excluded**: Use exact phrase `Not specified`
**If items excluded**: List clearly (prose or bullets)

**Rules**:
- Clarify boundaries to prevent scope creep
- Mention related features deliberately excluded

**Wrong**: ❌ "None", "N/A", "Nothing" (use "Not specified"), ❌ "Everything else"

---

## CHECKLIST

- [ ] Summary exactly 2-3 sentences
- [ ] Summary explains WHAT and WHY
- [ ] Summary business-focused, no tech
- [ ] Goals list has 2-6 items
- [ ] Each goal specific and user-centric
- [ ] Goals no implementation details
- [ ] Out of Scope lists exclusions OR "Not specified"
