# Issue TDD Template

Technical Design Document posted to GitHub by `/tech-lead` (standard mode S5, change mode C6, requirement-change mode RC6).

---

## OUTPUT FORMAT

````markdown
Part of #<requirement_issue_number>

---

# Sprint N — Technical Design Document

## 1. Executive Summary

**Status**: Draft | Approved | Deprecated
**Author**: | **Reviewer**:

### Problem Statement
<2–3 sentences: gap/pain, why now>

### Goals
- <What user gains>

### Non-Goals
- <What not addressed>

---

## 2. Architectural Design

### High-Level Diagram
<Mermaid: services, databases, caches, third-party>

### Integration Flows

#### Happy Path
<Mermaid sequence: user → services → storage → response>

#### Unhappy Path
<Mermaid sequence: failure scenario, system response>

### Technology Stack
<New languages/frameworks/libraries/infrastructure>

### Components Design
<Mermaid: internal component structure>

---

## 3. Data & Interface Contracts

### Data Models
<ERD or JSON schema, include indexes>

### API Specification
| Method | Route | Auth | Request Body | Response | Status Codes |

### Event Schemas
<Topic, event structure, producer, consumer, or N/A>

---

## 4. Risk & Trade-offs

### Alternatives Considered
| Decision | Chosen | Alternative | Why Rejected |

### Security
<Auth, authz, encryption>

### Scalability & Performance
<Throughput, latency targets, scaling strategy>

### Failure Modes
| Scenario | Impact | Mitigation |

---

## 5. Migration Plan

<Data migration, cutover, rollback>

### Monitoring & Alerting
<Metrics, thresholds>

---

## Architecture Key Decisions
<Canonical summary for dev agents>

---

## Implementation Priority

| Priority | Stories |
|----------|---------|
| P1 | #<story_number> |

---

## Lead's Review Checklist
- [ ] Single point of failure? (If yes, documented with mitigation in §4)
- [ ] Tech debt regret in 6 months? (If yes, justified)
- [ ] Developer can build from doc alone?
````

---

## FIELDS

### Part of
**REQUIRED** | text | Format: `Part of #<requirement_issue_number>`

**Rules**: First line before title, followed by `---`

### Document Title
**REQUIRED** | heading | Pattern: `# Sprint N — Technical Design Document`

**Rules**: Match milestone number

### Status
**REQUIRED** | enum[Draft | Approved | Deprecated]

**Default**: `Draft`
**After review**: `Approved`
**If superseded**: `Deprecated`

### Author & Reviewer
**OPTIONAL** | text | Format: `**Author**: <name> | **Reviewer**: <name>`

**Rules**: May leave blank, use `|` separator

### Problem Statement
**REQUIRED** | text | 2-3 sentences

**Rules**:
- Sentence 1: Gap/pain
- Sentence 2: Why now
- Sentence 3 (optional): Expected impact
- Business-focused, not technical

### Goals
**REQUIRED** | list | 2-6 items

**Rules**: User-centric outcomes, not implementation

### Non-Goals
**REQUIRED** | list

**Rules**: Clarify out of scope, prevent creep

### High-Level Diagram
**REQUIRED** | mermaid-graph

**Show**: Services, databases, caches, third-party tools, data flow arrows

**Rules**: Label new vs existing

### Integration Flows - Happy Path
**REQUIRED** | mermaid-sequence

**Show**: User action → services → storage → response (complete end-to-end)

**Wrong**: ❌ Incomplete flow, ❌ Missing user/storage

### Integration Flows - Unhappy Path
**REQUIRED** | mermaid-sequence

**Show**: Key failure scenario, system response, user error handling

### Technology Stack
**REQUIRED** | text or list

**If no new tech**: `No new technologies — uses existing stack`
**If new**: List each with purpose

**Wrong**: ❌ Listing existing stack

### Components Design
**REQUIRED** | mermaid-graph

**Show**: All new/modified components, responsibilities, communication arrows

**Components**: Services, handlers, repositories, UI components

### Data Models
**REQUIRED** | mermaid-erd or json-schema

**Include**: New/modified entities, key indexes, relationships

**If no changes**: `No new data models — uses existing schema`

### API Specification
**REQUIRED** | table | 6 columns

**Include**: All new/modified endpoints, all status codes

### Event Schemas
**CONDITIONAL** | text or table

**If no message bus**: `N/A`
**If message bus**: Topic, schema, producer, consumer

### Alternatives Considered
**REQUIRED** | table | 4 columns

**Rules**: Min 1 major decision, explain rejection

**Wrong**: ❌ No rationale

### Security
**REQUIRED** | text

**Cover**: Authentication, Authorization, Data encryption (rest/transit)

### Scalability & Performance
**REQUIRED** | text

**Include**: Throughput/latency targets, scaling approach, concrete numbers

### Failure Modes
**REQUIRED** | table | 3 columns

**Rules**: Key scenarios, min 2, include impact and mitigation

### Migration Plan
**CONDITIONAL** | text

**If no migration**: `N/A — no data migration required`
**If migration**: Cutover strategy, rollback plan

### Monitoring & Alerting
**REQUIRED** | text

**Include**: Key metrics, alert thresholds (error rate, latency, volume)

### Architecture Key Decisions
**REQUIRED** | text (structured)

**Include**:
- Layer responsibilities
- Naming conventions
- Feature checklist
- Cross-cutting patterns
- File organization
- Reference to full docs

**Purpose**: Canonical summary for dev agents (replaces re-reading full arch docs)

### Implementation Priority
**REQUIRED** | table | 2 columns

**Rules**:
- Use P1, P2, P3
- `story-removed` always P1
- Multiple stories may share priority
- No rationale needed
- All milestone stories listed

### Lead's Review Checklist
**REQUIRED** | checklist (3 items, all unchecked)

**Fixed content**:
```
- [ ] Single point of failure? (If yes, documented with mitigation in §4)
- [ ] Tech debt regret in 6 months? (If yes, justified)
- [ ] Developer can build from doc alone?
```

---

## CHECKLIST

- [ ] "Part of #N" before title
- [ ] Sprint number matches milestone
- [ ] Status is "Draft"
- [ ] Problem Statement 2-3 sentences
- [ ] Goals user-centric, 2-6 items
- [ ] Non-Goals clarify scope
- [ ] High-Level Diagram valid Mermaid
- [ ] Happy Path complete end-to-end
- [ ] Unhappy Path shows failure
- [ ] Components Design shows all new/modified
- [ ] Data Models has indexes or "No new"
- [ ] API Spec lists all endpoints
- [ ] Event Schemas is "N/A" or complete
- [ ] Alternatives min 1 decision
- [ ] Security covers auth/authz/encryption
- [ ] Scalability has targets
- [ ] Failure Modes min 2 scenarios
- [ ] Migration Plan is "N/A" or has rollback
- [ ] Monitoring has metrics/thresholds
- [ ] Arch Key Decisions has 5 subsections
- [ ] Priority includes all stories
- [ ] story-removed are P1
- [ ] Review Checklist 3 unchecked
