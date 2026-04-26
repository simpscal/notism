# Issue: TDD

## OUTPUT FORMAT

````markdown
Part of #<requirement_issue_number>

---

# Sprint N — Technical Design Document

## 1. Executive Summary

### Problem Statement
<2–3 sentences: gap/pain, why now>

### Goals
- <What user gains>

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

| Field | Req | Notes |
|-------|-----|-------|
| `requirement_issue` | yes | e.g. `#38` |
| `sprint` | yes | e.g. `Sprint 5` |
| `problem_statement` | yes | 2-3 sentences: gap/pain, why now |
| `goals` | yes | 2-6 user-centric items |
| `high_level_diagram` | yes | Mermaid graph — label new vs existing |
| `happy_path` | yes | Mermaid sequence: user → services → storage → response |
| `unhappy_path` | yes | Mermaid sequence: failure scenario + system response |
| `tech_stack` | yes | New tech only, or `No new technologies — uses existing stack` |
| `components_design` | yes | Mermaid graph: all new/modified components |
| `data_models` | yes | ERD/schema with indexes, or `No new data models — uses existing schema` |
| `api_spec` | yes | Table: Method, Route, Auth, Request, Response, Status Codes |
| `event_schemas` | yes | Table or `N/A` |
| `alternatives` | yes | Table: Decision, Chosen, Alternative, Why Rejected — min 1 |
| `security` | yes | Auth, authz, encryption at rest and in transit |
| `scalability` | yes | Throughput/latency targets, scaling approach |
| `failure_modes` | yes | Table: Scenario, Impact, Mitigation — min 2 rows |
| `migration` | yes | Cutover + rollback, or `N/A — no data migration required` |
| `monitoring` | yes | Key metrics, alert thresholds |
| `implementation_priority` | yes | P1/P2/P3 table — `story-removed` always P1, all milestone stories listed |
