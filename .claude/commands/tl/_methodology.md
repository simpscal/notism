# TL Methodology

Apply all five stages fully before writing any output to the tracker.

---

## Stage 1 — Read Every Story

Read every user story in the sprint. Build a full mental model:
- What is the sprint goal?
- What new capabilities does the user gain?
- What domain concepts appear across stories (entities, workflows, states)?
- Which stories share domain objects or API surface?
- Are there ordering dependencies between stories?

**Complete when:** You can describe every story and its relation to the others without re-reading them.

---

## Stage 2 — Learn the Architecture

Read the architecture documentation for each repo involved. Extract:
- **Architecture style** and layer responsibilities
- **Folder structure** and file organisation conventions
- **Naming conventions** for all artifact types
- **Key patterns** (CQRS, repository, specification, component structure, etc.)
- **"Adding a new feature"** checklists or guidelines
- **Dependency rules** between layers

**Complete when:** You understand the architecture style, layer responsibilities, folder structure, key patterns, and dependency rules for each repo involved.

---

## Stage 3 — Design the Solution

Produce a coherent system-level design covering the full sprint. Work at the architecture and contract level — not the code level.

| Area | What to define |
|------|----------------|
| Services & integrations | Which services, databases, caches, third-party tools involved? New vs. existing? |
| Integration flows | Happy path + one unhappy path as Mermaid sequence diagrams |
| API contracts | Method, route, auth, request/response shape, status codes |
| Data models | ERD or JSON schema with key indexes |
| Frontend scope | New/changed pages and routes |
| Security | Authentication, authorisation, encryption |
| Failure modes | What happens when each external dependency fails? Mitigation for each |
| Scalability | Expected TPS, latency targets, scaling approach |
| Migration & rollout | Data migration, flag-day vs canary, rollback plan |

For each major decision: document at least one alternative and why it was rejected.

**Complete when:** A senior engineer who was not in any planning meeting could start building from this design alone.

---

## Stage 4 — Write the Technical Design Document (TDD)

Use `render_template("issue-tdd", {sprint, requirement_issue, problem_statement, goals, non_goals, high_level_diagram, happy_path, unhappy_path, tech_stack, components_design, data_models, api_spec, event_schemas, alternatives, security, scalability, failure_modes, migration, monitoring, arch_decisions, implementation_priority})`, then pass as the body to `create_issue`.

Include an **Implementation Priority** table assigning each user story a priority level (P1, P2, or P3). Multiple stories can share the same priority. No rationale needed.

**Complete when:** Every story has an implementation path traceable through the TDD, every story is assigned a priority, and the Lead's Review Checklist passes.
