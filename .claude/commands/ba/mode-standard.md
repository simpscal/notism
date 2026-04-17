# Mode: Standard

**Usage**: `/ba standard <requirement_issue_number>`

`fetch_issue(requirement_issue_number)` to read the requirement in full.

---

## S1 — Discovery Session with PO

-> Follow `_discovery.md`

Context for synthesis:
- Who is the user?
- What do they want to achieve?
- What does "done" look like?
- What constraints or boundaries are stated or implied?

Goal: State in one unambiguous sentence what the sprint goal is.

---

## S2 — Decompose into Stories

### Stage 1 — Understand the Requirement

Extract:
- **Core user need**: Who? What action? What outcome?
- **Stated constraints**: Explicit limitations
- **Implicit assumptions**: What must be true?

**Synthesis checklist** (answer all before moving on):
1. Who is the primary user?
2. What is the single most important thing they want to achieve?
3. What does "done" look like from the PO's perspective?
4. What is explicitly out of scope?
5. Any regulatory, UX, or integration constraints not stated?

### Stage 2 — Define Scope

Produce:
- **Sprint goal**: One sentence — what user can do after sprint that they cannot do today
- **In scope**: Explicitly included
- **Out of scope**: Explicitly excluded or deferred
- **Assumptions**: What you assume to proceed

### Stage 3 — Decompose into User Stories

Break into **3-20 user stories**. Apply INVEST:

| I | Independent — can be built/delivered alone |
| N | Negotiable — describes need, not spec |
| V | Valuable — delivers something user cares about |
| E | Estimable — clear enough to size |
| S | Small — fits in sprint increment |
| T | Testable — stakeholder can verify without reading code |

**Format**: `As a <user>, I want <action> so that <benefit>`

### Stage 4 — Write Acceptance Criteria

Fill in `acceptance-criteria.md` for each story.

Include **Notes** section: edge cases, UX questions, dependencies, constraints. Use `link_to(id)` for inter-story references — back-fill once all issues created.

### Stage 5 — Validate

-> Follow `_validation.md` (Story Set Validation)

---

## S3 — Create Sprint Milestone

`list_milestones()` to determine next sprint number.
`create_milestone("Sprint N", sprint_goal)`

---

## S4 — Create User Story Issues

For each story: `create_issue("[Story] <title>", body, ["user-story"], milestone_id)` using `issue-user-story.md`.

> **Dependency linking**: Create all issues first, then back-fill `link_to(id)` references in Notes for both `Depends on` and `Blocks` directions.

---

## S5 — Label the Requirement

`update_labels(requirement_issue_number, add: [sprint-ready], remove: [])`
