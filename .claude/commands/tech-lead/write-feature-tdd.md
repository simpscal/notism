# Mode: Standard

Use `list_milestones()` to find the milestone with title `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

---

## Step 1 — Fetch All Issues

Call `list_issues($MILESTONE_ID)` once. Partition the result in memory:

- **$STORIES** — issues labelled `user-story`. Use `fetch_issue(id)` on each to read full body, acceptance criteria, and notes.
- **$REQUIREMENT** — single issue labelled `requirement`. Use `fetch_issue(requirement_id)` to read it in full. Hold as **$REQUIREMENT** — use this to understand the sprint goal, the user problem being solved, and what "done" looks like from the PO's perspective.
- **$TDD** — single issue labelled `technical-design` (may be absent). If one already exists, report "TDD already exists for Sprint N — run `/tech-lead sync-feature-tdd Sprint N` to update" and stop.
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

## Step 3 — Resolve Blocking Questions

Identify every decision that cannot be made from the code and stories alone. Use `AskUserQuestion` to present all blocking questions in a single message. Do not proceed until every question is resolved.

---

## Step 4 — Design the Solution

Work at the architecture and contract level — not the code level. Cover every area below. Skip nothing; write "N/A — reason" where an area does not apply.

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

For every major decision: name at least one alternative and explain why it was rejected.

**Output structure:**
- Lead with the key architectural decision — the one call that shapes everything else
- Present areas in logical order (data model → API → flows)
- Highlight risks and trade-offs explicitly
- End with an **Implementation Priority** table: P1 (unblocks others), P2 (core path), P3 (follow-on)
- Use Mermaid diagrams when clearer than prose; tables for contracts and schemas

Where design instructions exist, use the Layout and Components sections from $DESIGN to inform the solution design — let the layout drive the Components Design section structure, and use the Components table to list UI components alongside backend components (services, handlers, repositories) for a unified component map.

---

## Step 5 — Create TDD Issue

Use `create_issue(title, body, labels)`:
- **Title**: `Sprint N — Technical Design Document`
- **Body**: full TDD rendered via `render_template("issue-tdd", {...})`, with `Part of #N` at the very top
- **Labels**: `technical-design` label from project config

Capture the new issue number — referenced in Step 6.

---

## Step 6 — Create Feature Branches (new TDD only)

If this is a new TDD: Create sprint feature branches for each codebase listed in project config.

Skip if updating an existing TDD (branches already exist).

