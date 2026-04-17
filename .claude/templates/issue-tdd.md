# Issue TDD Template

Technical Design Document issue body posted to GitHub. Used by `/tl` (standard mode S5, change mode C6, requirement-change mode RC6).

````
# Sprint N — Technical Design Document

## 1. Executive Summary

**Status**: Draft | Approved | Deprecated
**Author**: | **Reviewer**:

### Problem Statement
<2–3 sentences: what gap or pain does this sprint address and why now?>

### Goals
- <What the user gains>

### Non-Goals
- <What this sprint explicitly does not address>

---

## 2. Architectural Design

### High-Level Diagram
<Mermaid diagram showing all services, databases, caches, and third-party tools involved>

### Integration Flows

#### Happy Path
<Mermaid sequence diagram: user action → service(s) → storage → response>

#### Unhappy Path
<Mermaid sequence diagram: key failure scenario(s) and how the system responds>

### Technology Stack
<Any new languages, frameworks, libraries, or infrastructure this sprint introduces>

### Components Design
<Mermaid diagram showing the internal component structure for this feature. Use component diagram syntax showing:

- **Components**: All new or modified components needed (e.g., services, handlers, repositories, UI components)
- **Component responsibilities**: Label each component with its key responsibilities
- **Interactions**: Show how components communicate (API calls, events, data flow) with arrows indicating direction

Example format:
```mermaid
componentDiagram
    A[UI Component] --> B[API Handler]
    B --> C[Service Layer]
    C --> D[Repository]
    D --> E[(Database)]
```
>

---

## 3. Data & Interface Contracts

### Data Models
<ERD or JSON schema for each new or modified entity. Include key indexes.>

### API Specification
| Method | Route | Auth | Request Body | Response | Status Codes |
|--------|-------|------|-------------|----------|--------------|

### Event Schemas
<If a message bus is used: topic name, event structure, producer, consumer. Otherwise: N/A>

---

## 4. Risk & Trade-offs

### Alternatives Considered
| Decision | Chosen | Alternative | Why Alternative Was Rejected |
|----------|--------|-------------|------------------------------|

### Security
<Authentication, authorisation, data encryption at rest and in transit>

### Scalability & Performance
<Expected throughput (TPS), latency targets, horizontal vs. vertical scaling strategy>

### Failure Modes
| Scenario | Impact | Mitigation |
|----------|--------|------------|

---

## 5. Migration Plan

<How existing data is migrated; cutover strategy (flag-day vs. canary); rollback plan>

### Monitoring & Alerting
<Key metrics to track (error rate, latency, queue depth); threshold that pages on-call>

---

## Architecture Key Decisions
<Canonical summary for downstream dev subagents — read THIS instead of re-reading full architecture docs. Include:>
- **Layer responsibilities**: which layers own what
- **Naming conventions**: key naming patterns enforced in this codebase
- **Adding a new feature checklist**: steps recommended for extending this codebase
- **Cross-cutting patterns**: error handling, result pattern, validation approach, layer communication
- **Component/file organisation**: folder structure conventions, where new files of each type belong

> Full architecture docs are available at the paths in project config — read them for deep-dives.

---

## Implementation Priority

| Priority | Stories |
|----------|---------|
| P1 | #<story_number>, #<story_number> |
| P2 | #<story_number> |
| P3 | #<story_number>, #<story_number> |

Stories labeled `story-removed` are always P1 — orphaned work must be reverted first to clean the board. For remaining stories, assign priority based on implementation order. Multiple stories can share the same priority. No rationale needed.

---

## Lead's Review Checklist
- [ ] Is there a single point of failure? (If yes, it is documented with a mitigation in §4)
- [ ] Does this design introduce technical debt we'll regret in 6 months? (If yes, it is justified)
- [ ] Could a developer who wasn't in the meetings build this from this document alone?
````

**Status:** `Draft` on creation; updated to `Approved` after human review.

**Part of:** prepend `Part of #<requirement_issue_number>` at the very top before the document title.

**Integration Flows:** use Mermaid sequence diagrams; cover happy path + at least one unhappy path.

**Components Design:** use Mermaid component diagram; show all new/modified components with responsibilities and directional arrows.

**API Specification:** one row per endpoint — method, route, auth required, request body shape, response shape, status codes.

**Event Schemas:** if no message bus: write `N/A`.

**Migration Plan:** if no data migration: write `N/A`.

**Architecture Key Decisions:** canonical summary for dev subagents — they read this section instead of re-reading full architecture docs.
