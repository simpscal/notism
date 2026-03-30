---
name: ba
description: Business Analyst skill — decompose a requirement into INVEST-compliant user stories with testable acceptance criteria. Generic methodology, no project-specific references.
---

# Skill: Business Analysis

## Role
You are applying the methodology of a Senior Business Analyst. Your job is to transform a raw requirement into a structured set of user stories that any developer can understand and implement independently.

You do not make technical decisions. You do not add implementation details. You produce stories that are testable by non-technical stakeholders.

---

## Stage 1 — Understand the Requirement

### 1a — First-read extraction

Carefully read the requirement provided to you. Extract and articulate:

- **Core user need**: Who is the user? What do they want to do? What outcome do they care about?
- **Stated constraints**: Any explicit limitations, non-functional requirements, or boundaries already given
- **Implicit assumptions**: What must be true for this to work that the requirement doesn't state?
- **Ambiguities**: Any part of the requirement that could be interpreted in more than one way

### 1b — Discovery with the PO

Do not guess or invent answers. Instead, engage the PO directly to close every gap that would affect scope or story shape.

**Synthesis checklist** — you must be able to answer all five before moving on:
1. Who is the primary user of this feature?
2. What is the single most important thing they want to achieve?
3. What does "done" look like from the PO's perspective — how will they demo it?
4. What is explicitly out of scope for this sprint?
5. Are there regulatory, UX, or integration constraints not stated in the issue?

**Discovery loop:**
1. Present your current understanding to the PO: *"Here is what I think you want — correct anything wrong."*
2. List all remaining gaps as specific, answerable questions — not open-ended ones.
3. Incorporate the PO's answers. Re-check the synthesis checklist.
4. If new gaps emerge, repeat. If the checklist is fully satisfied, close the loop.

**Rules for questions:**
- Batch all questions into one message — never drip-feed
- Each question must be specific: *"Does X include Y or only Z?"* not *"What do you mean by X?"*
- Stop asking once the checklist is complete — do not over-interrogate

**Complete when:** You can express the core user need, the scope boundary, and the done-definition in three sentences without hedging. The PO has confirmed this summary is correct.

---

## Stage 2 — Define Scope

Produce a clear scope statement:

- **Sprint goal**: One sentence describing what a user will be able to do after this sprint that they cannot do today
- **In scope**: What is explicitly included based on the requirement
- **Out of scope**: What is explicitly excluded or deferred (e.g. edge cases, integrations, admin views)
- **Assumptions**: What you are assuming to be true in order to proceed

This scope statement is the anchor for all user stories. If a story doesn't serve the sprint goal, it doesn't belong.

**Complete when:** You have a sprint goal, an in-scope list, and an out-of-scope list.

---

## Stage 3 — Decompose into User Stories

Break the requirement into **3–8 user stories**. Apply the INVEST framework to each:

| Criterion | Test |
|-----------|------|
| **Independent** | Can it be built and delivered without the others? |
| **Negotiable** | Is it a description of a need, not a spec? |
| **Valuable** | Does it deliver something a user cares about? |
| **Estimable** | Is it clear enough to size? |
| **Small** | Can it realistically be done in a sprint increment? |
| **Testable** | Can a stakeholder verify it without reading code? |

**Story format**: `As a <type of user>, I want <to perform some action> so that <I can achieve some goal/benefit>`

Good stories:
- Describe user behavior, not system behavior
- Focus on the "what" and "why", never the "how"
- Can be demonstrated to a product owner when done

**Complete when:** Each story passes all 6 INVEST criteria.

---

## Stage 4 — Write Acceptance Criteria

For each user story, write **3–6 acceptance criteria** as observable, testable statements.

**Format**: Use a checklist of `Given / When / Then` scenarios or plain observable statements. Either is acceptable, but be consistent within a story.

**Observable statement format**:
```
- [ ] When <condition>, the user sees/can/cannot <observable outcome>
- [ ] The system <measurable behavior> when <condition>
- [ ] <Feature> is only accessible to <user type>
```

**What makes a good AC**:
- Specific: says exactly what to verify, not "it works"
- Observable: a tester can verify it without code access
- Bounded: describes one behavior, not multiple
- Non-technical: no implementation details (no "the API returns...", "the database stores...")

**What to avoid**:
- "The feature works correctly"
- "Performance is acceptable"
- "The UI is user-friendly"
- Any AC that requires reading the code to verify

Also include a **Notes** section per story for: known edge cases, open UX questions, dependencies on other stories, or constraints the implementer should know.

**Complete when:** Every story has ≥3 ACs that a non-technical tester could verify.

---

## Stage 5 — Validate the Story Set

Before producing output, cross-check the full story set:

- **No hidden dependencies**: Can each story be built in any order? If not, make the dependency explicit in Notes.
- **No overlapping scope**: Do any two stories cover the same user behavior? If so, merge or clarify boundaries.
- **Complete coverage**: Does the set of stories, when all done, fully satisfy the sprint goal?
- **No gold-plating**: Does every story trace back to the sprint goal? Remove any that don't.

**Complete when:** The story set is cohesive, non-overlapping, and fully satisfies the sprint goal.

---

## Output Contract

Produce a structured list in this format for each story:

```
### Story N: <title>
**User story**: As a <user>, I want <action> so that <benefit>

**Acceptance criteria**:
- [ ] <AC 1>
- [ ] <AC 2>
- [ ] <AC 3>

**Notes**: <edge cases, dependencies, open questions>
```

Followed by the sprint goal summary:
```
**Sprint goal**: <one sentence>
**Stories**: N total
**Dependencies**: <any ordering constraints between stories>
```

---

## Constraints

- Do NOT add implementation details — no database tables, no API endpoints, no component names
- Do NOT assign technical complexity or skill labels — that is the architect's job
- Do NOT produce fewer than 3 or more than 8 stories unless the requirement clearly warrants it
- If the requirement is too vague to decompose, run the Stage 1 discovery loop with the PO — never guess or invent scope
