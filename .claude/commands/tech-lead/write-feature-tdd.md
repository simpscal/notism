# Mode: Standard

List all milestones to find the one titled `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

---

## Step 1 — Fetch All Issues

List all issues in the sprint milestone once. Partition the result in memory:

- **$STORIES** — issues labelled `user-story`. Read each in full — body, acceptance criteria, and notes.
- **$REQUIREMENT** — single issue labelled `requirement`. Read it in full. Hold as **$REQUIREMENT** — use this to understand the sprint goal, the user problem being solved, and what "done" looks like from the PO's perspective.
- **$TDD** — single issue labelled `technical-design` (may be absent). If one already exists, report "TDD already exists for Sprint N — run `/tech-lead sync-feature-tdd Sprint N` to update" and stop.
- **$DESIGN** — single issue labelled `design` (may be absent). If present, read it in full — use for UI component context in Components Design.

Before proceeding, build a mental model from `$STORIES` and `$REQUIREMENT`:
- What is the feature goal? What capability does the user gain?
- What domain concepts appear across stories (entities, workflows, states)?
- Which stories share domain objects or API surface?
- Are there ordering dependencies?
- **Scope of changes**: which parts of the system are touched? For each, are changes additive (new), extending (modify existing), or replacing (remove and rebuild)?

Complete when: you can describe every story, its relationship to the others, and the full change surface without re-reading them.

---

## Step 2 — Explore Codebase & Resolve Blocking Questions

### 2a — Derive exploration scope

From the mental model built in Step 1, extract the targeted scope for each codebase. Only include a codebase if stories or requirement touch it.

| Scope dimension | What to identify |
|-----------------|-----------------|
| **Domain concepts** | Entity names, aggregate roots, value objects that appear in stories |
| **Operations** | Commands and queries the feature introduces or extends |
| **API surface** | Endpoint paths or patterns likely touched |
| **UI areas** | Page names, component families, or routes involved |
| **Infrastructure areas** | Storage, queues, caches, or cloud resources referenced in stories |

### 2b — Spawn codebase subagents

For each in-scope codebase, spawn an `Explore` subagent in parallel. Give each a targeted brief — exactly what to find, not "explore everything":

**Backend subagent** (if backend in scope):
- Find existing entities, domain models, or DB tables for each domain concept
- Find existing command/query handlers, services, or repositories related to the operations
- Find existing API controllers or route definitions matching the API surface
- Find existing auth/authz patterns (policies, middleware, decorators)
- Return: file paths, class/method names, patterns in use, gaps where nothing exists

**Frontend subagent** (if frontend in scope):
- Find existing pages, routes, or feature folders related to the UI areas
- Find existing components used in those pages
- Find existing API client calls or hooks for the relevant endpoints
- Find existing state slices or query keys touching the domain
- Return: file paths, component names, patterns in use, gaps

**Infrastructure subagent** (if infrastructure in scope):
- Find existing Terraform modules or resources for the infrastructure areas
- Return: resource names, types, existing config that would be extended, gaps

Aggregate all subagent output into **`$CODEBASE_CONTEXT`**.

### 2c — Resolve blocking questions

For each category below, try to answer from `$CODEBASE_CONTEXT`, stories first. Only questions that remain unresolvable after that become blockers. Collect all blockers and present in a single `AskUserQuestion` call. Do not proceed until every question is resolved.

| Category | Decisions to resolve |
|----------|----------------------|
| **Data ownership** | New table vs. extending existing? Which service/DB owns the data? Any shared ownership across codebases? |
| **Auth & authorisation** | Which roles/permissions apply? Resource-level or role-level authz? Consistent with existing patterns or new model needed? |
| **API surface** | New endpoints or extend existing? Synchronous REST or event-driven? Any versioning constraints? |
| **Integration boundaries** | External services or third-party APIs involved? Who owns each integration? Are contracts already defined? |
| **Non-functional requirements** | Latency / throughput targets? Expected data volume or user load? Any SLA that shapes design? |
| **Real-time vs. async** | Does the feature require live updates, webhooks, polling, or is batch sufficient? |
| **Migration & compatibility** | Existing data to migrate? Destructive schema changes allowed? Backward compatibility required during rollout? |
| **Infrastructure constraints** | Hard limits on cloud services, regions, or cost? Anything off-limits (e.g. no new queues, must reuse existing cluster)? |
| **Rollout strategy** | Feature flag? Gradual rollout by cohort? All users at once? Rollback trigger? |
| **Cross-team dependencies** | Other teams blocking or blocked by this? Shared contracts to agree before implementation starts? |

Skip categories that clearly do not apply. If `$CODEBASE_CONTEXT` fully answers a category, skip it — do not ask the user about things already known.

---

## Step 3 — Design the Solution

Work at the architecture and contract level — not the code level. Cover every area below. Skip nothing; write "N/A — reason" where an area does not apply.

| Area | TDD field | What to define |
|------|-----------|----------------|
| High-level diagram | `high_level_diagram` | Services, databases, caches, third-party — label new vs existing |
| Happy path | `happy_path` | Mermaid sequence: user → services → storage → response |
| Unhappy path | `unhappy_path` | Key failure scenario and system response |
| Technology stack | `tech_stack` | New languages/frameworks/libraries/infra only |
| Infrastructure | `infrastructure` | Cloud resources added/modified; IaC module changes; environment-specific config |
| Components design | `components_design` | All new/modified components — Mermaid graph |
| Data models | `data_models` | Entities, relationships, key indexes — ERD or schema; include indexes |
| API specification | `api_spec` | Method, route, auth, request/response shape, status codes |
| Event schemas | `event_schemas` | Topic, event structure, producer, consumer — or N/A |
| Alternatives considered | `alternatives` | Min 1 row: Decision, Chosen, Alternative, Why Rejected |
| Security | `security` | Auth, authz, encryption at rest and in transit |
| Scalability & performance | `scalability` | Throughput/latency targets, query design, caching, async offloading |
| Failure modes | `failure_modes` | Min 2 rows: Scenario, Impact, Mitigation |
| Migration plan | `migration` | Data migration, cutover, rollback — or N/A |
| Monitoring & alerting | `monitoring` | Key metrics, alert thresholds |

**Output structure:**
- Lead with the key architectural decision — the one call that shapes everything else
- Present areas in logical order (data model → API → flows)
- Highlight risks and trade-offs explicitly
- End with an **Implementation Priority** table: P1 (unblocks others), P2 (core path), P3 (follow-on)
- Use Mermaid diagrams when clearer than prose; tables for contracts and schemas

Ground every design decision in `$CODEBASE_CONTEXT` — extend existing patterns rather than introducing new ones where possible. Call out explicitly when the design diverges from existing patterns and why.

Where design instructions exist, use the Layout and Components sections from $DESIGN to inform the solution design — let the layout drive the Components Design section structure, and use the Components table to list UI components alongside backend components (services, handlers, repositories) for a unified component map.

---

## Step 4 — Create TDD Issue

Create an issue:
- **Title**: `Sprint N — Technical Design Document`
- **Body**: full TDD rendered via the `issue-tdd` template, with `Part of #N` at the very top
- **Labels**: `technical-design`
- **Milestone**: `$MILESTONE_ID`

Capture the new issue number — referenced in Step 6.

---

## Step 5 — Create Feature Branches (new TDD only)

Skip if updating an existing TDD (branches already exist).

For each codebase in CLAUDE.md's Codebases table (not the orchestration repo): create sprint branch from `main`.

