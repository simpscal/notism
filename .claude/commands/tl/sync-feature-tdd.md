# Mode: Requirement Change

Extract `sprint_number` (the token after `sync-feature-tdd`).

---

## Step 1 — Fetch All Issues

Use `list_milestones()` to find the milestone with title `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

Call `list_issues($MILESTONE_ID)` once. Partition the result in memory:

- **$STORIES** — issues labelled `user-story`. Use `fetch_issue(id)` on each to read full body, acceptance criteria, and notes.
  - Identify **changed stories**: those with label `story-updated` or `story-removed`.
  - If no changed stories exist, report "No story changes found — TDD is already in sync" and stop.
- **$REQUIREMENT** — single issue labelled `requirement`. Use `fetch_issue(id)` to read it in full.
- **$TDD** — single issue labelled `technical-design`. Use `fetch_issue(id)` to read it in full. Hold as the **current TDD**.
  - If no TDD exists, report "No TDD found for Sprint N — run `/tl Sprint N` first" and stop.
- **$DESIGN** — single issue labelled `design` (may be absent). If present, use `fetch_issue(id)` to read it in full — use for UI component context in Components Design.

Before proceeding, build a mental model from `$STORIES`:
- What is the feature goal? What capability does the user gain?
- What domain concepts appear across stories (entities, workflows, states)?
- Which stories share domain objects or API surface?
- Are there ordering dependencies?

Complete when: you can describe every story and its relationship to the others without re-reading them.

---

## Step 2 — Read the Architecture

-> Read each codebase's `CLAUDE.md`

---

## Step 3 — Classify Scope Changes

For each changed story, classify the technical impact against the current TDD:

| Classification | Condition | Planned Action |
|----------------|-----------|----------------|
| **New scope** | `story-updated` introduces new behaviour not in current TDD, OR any story exists that the current TDD does not cover | Add to affected TDD sections |
| **Modified scope** | `story-updated` story changes existing behaviour, data, or contracts | Update affected TDD sections only |
| **Removed scope** | `story-removed` story covered functionality that no longer exists | Remove or mark obsolete in TDD |

Output a **Change Plan Table** listing every changed story and its classification.

If any classification is ambiguous, ask for clarification before proceeding.

---

## Step 4 — Resolve Blocking Questions

Identify every decision that cannot be made from the code and stories alone. Use `AskUserQuestion` to present all blocking questions in a single message. Do not proceed until every question is resolved.

---

## Step 5 — Design the Solution

Use the current TDD as the baseline. For each design area below, evaluate whether changed stories affect it — keep unchanged areas exactly, rewrite only affected parts. Do not redesign unchanged areas.

| Area | What to define |
|------|----------------|
| Services & integrations | Which services, databases, caches, third-party tools? New vs existing? |
| Integration flows | Happy path + one key unhappy path — sequence or flow, not prose |
| API contracts | Method, route, auth, request/response shape, status codes |
| Data models | Entities, relationships, key indexes — ERD or schema fragment |
| Frontend scope | New or changed pages, routes, component responsibilities |
| Security | Authentication, authorisation, encryption at rest and in transit |
| Failure modes | What happens when each external dependency fails? Mitigation for each |
| Performance | Critical-path latency targets, query design (indexes, N+1 risks), caching strategy, async offloading |
| Scalability | Expected load, horizontal vs vertical scaling approach, stateless constraints |
| Migration & rollout | Data migration, rollback plan, or "N/A — no migration required" |

For any new or changed decision: name at least one alternative and explain why it was rejected.

**Output structure:** lead with the key architectural decision, present areas in logical order (data model → API → flows), highlight risks and trade-offs explicitly, end with an **Implementation Priority** table: P1 (unblocks others), P2 (core path), P3 (follow-on). Use Mermaid diagrams when clearer than prose; tables for contracts and schemas.

Where design instructions exist, use the Layout and Components sections from $DESIGN to inform the solution design — let the layout drive the Components Design section structure, and use the Components table to list UI components alongside backend components (services, handlers, repositories) for a unified component map.

---

## Step 6 — Update TDD Issue

Evaluate every section of the TDD template against the revised design. Sections not affected must be preserved exactly. Sections that change must be fully rewritten — do not summarise or abbreviate.

| TDD Section | Update trigger |
|-------------|----------------|
| Executive Summary — Problem Statement / Goals / Non-Goals | Scope added, updated, or removed |
| High-Level Diagram | Any service, database, cache, or integration added, updated, or removed |
| Integration Flows (happy + unhappy paths) | Request or response flow added, updated, or removed |
| Technology Stack | New library or infrastructure introduced or updated |
| Components Design | Any component added, updated, removed, or restructured, OR design instructions updated |
| Data Models | Any entity added, updated, removed, or field changed |
| API Specification | Any endpoint added, updated, removed, or its contract changed |
| Event Schemas | Any event added, updated, removed, or its structure changed |
| Alternatives Considered | Any decision revisited or updated |
| Security | Auth or encryption requirements added, updated, or changed |
| Scalability & Performance | Load characteristics added or changed |
| Failure Modes | Any new or updated external dependency or failure scenario |
| Migration Plan | Data model or cutover strategy added, updated, or changed |
| Architecture Key Decisions | Naming, layering, or cross-cutting patterns added, updated, or changed |
| Implementation Priority | Any story added, updated, removed, or implementation order reconsidered |

Apply changes to the current TDD document. Then: `update_issue_body($TDD.id, updated_body)`.
