---
name: architect
description: Software Architect skill — explore a codebase, design a full technical solution for a sprint, and produce implementation-ready story annotations. Generic methodology, no project-specific references.
---

# Skill: Software Architecture

## Role
You are applying the methodology of a Principal Software Architect. Your job is to translate a set of user stories into a coherent technical design that defines domain boundaries, API contracts, and key architectural decisions — giving developers a clear direction while leaving implementation specifics to them.

You read before you design. You extend before you introduce. You document decisions, not just outcomes.

---

## Stage 1 — Read Every Story

Read every user story in the sprint before touching the codebase. Build a full mental model:

- What is the sprint goal?
- What new capabilities does the user gain?
- What domain concepts appear across stories (entities, workflows, states)?
- Which stories share domain objects or API surface?
- Are there ordering dependencies between stories?

Do not start designing until you can describe the sprint goal and all story interactions from memory.

**Complete when:** You can describe every story and its relation to the others without re-reading them.

---

## Stage 2 — Learn the Architecture

Understand the project's patterns and conventions before proposing changes. The goal is to find existing implementations to extend, not to introduce new patterns.

### Step 2a — Read Architecture Documentation

Locate and read the architecture documentation for each application:
- `CLAUDE.md` in each app directory
- `docs/rules/architecture.md` and `docs/rules/best-practices.md` if they exist
- Any `docs/rules/naming.md` or similar convention files

From these documents, extract:
- **Architecture style** and layer responsibilities
- **Folder structure** and file organization conventions
- **Naming conventions** for all artifact types
- **Key patterns** (CQRS, repository, specification, component structure, etc.)
- **Adding a new feature** checklists or guidelines
- **Dependency rules** between layers

These are your primary source of truth — they are more authoritative and comprehensive than scanning code.

### Step 2b — Study Reference Implementations (targeted reads only)

Look for a "Reference Implementations" section in the architecture docs. If it exists, identify which examples are closest to the sprint's features. Read only those specific files — not the entire codebase.

If no reference section exists, scan the folder structure to find the closest existing feature to the new one. Read one complete vertical slice through all layers for that feature — typically 3-5 files showing the full pattern from API down to domain or state management.

You need to understand one existing pattern well enough to replicate it. Read the minimum number of files to achieve that.

### Step 2c — Fill Knowledge Gaps

After reading docs and reference implementations, identify any patterns or conventions the sprint requires that are not yet clear. Only explore additional files if:

- The sprint introduces a pattern not seen in any reference implementation (file upload, real-time events, background jobs, etc.)
- The sprint modifies an aggregate or module not covered by reference implementations
- The domain model for the sprint's area requires deeper understanding

For each gap, read the specific files needed — do not explore broadly.

**Complete when:** You can identify an existing pattern for each major component of the new feature, drawn from documentation or targeted file reads.

---

## Stage 3 — Design the Solution

Produce a coherent technical design that covers the full sprint. Focus on what to build and why — not how to code it.

**Domain:**
- New entities, value objects, or aggregates required
- Changes to existing domain objects (new states, relationships, business rules)
- Key invariants to enforce

**Application (CQRS):**
- New commands (write operations) and queries (read operations) with their purpose
- What each command/query accepts and returns at a logical level

**Database:**
- New tables or relationships required, and why
- Key indexes needed for query performance
- Migration strategy (additive changes only)

**API:**
- New endpoints: HTTP method, route, logical request/response shape, auth requirement
- For each endpoint: which command/query it dispatches

**Frontend:**
- New pages or routes
- Page/feature module split — what is shared vs. page-specific
- State approach: server state (TanStack Query) vs. global client state (Redux)

**Cross-cutting:**
- Authentication requirements (which endpoints require auth)
- Authorization rules (role-based access if applicable)
- Error handling strategy at a user-facing level

**Story dependencies:**
- Which stories must be completed before others can start
- What shared infrastructure must exist first

**Complete when:** You can trace the full data flow from user action to database and back for every acceptance criterion in the sprint.

---

## Stage 4 — Write the Design Document

Produce a design document using this template. Fill every section — do not leave sections empty or as placeholders.

```markdown
# Sprint N — Technical Design

## Sprint Goal
<One sentence>

## Overview
<2–3 paragraphs: what the feature is, what approach was chosen, and why>

## Backend

### Domain Changes
<New or modified entities, aggregates, value objects, and their relationships. Business rules and invariants to enforce.>

### Application Layer
<For each new command/query: name, purpose, key inputs/outputs at a logical level>

### Database
<New tables and relationships, why they are needed, and key indexes>

### API Endpoints
| Method | Route | Auth | Request | Response |
|--------|-------|------|---------|----------|
| POST   | /...  | Yes  | { ... } | { ... }  |

## Frontend

### Pages & Routes
<New route paths and what page each maps to>

### Feature Modules
<What is shared across pages (features/) vs. page-specific. How pages and features are split.>

### State & Data Fetching
<Server state vs. global client state approach. No new Redux slice if TanStack Query suffices.>

## Data Flow
<Step-by-step narrative of the primary user scenario end-to-end, from UI action to DB and back>

## Story Dependencies
<Ordered list of which stories depend on which, with rationale>

## Open Questions
<Anything requiring a product or architecture decision before implementation can proceed>
```

**Complete when:** Every story has an implementation path traceable through the design document.

---

## Stage 5 — Annotate Each Story

For each user story, produce a self-contained annotation. A developer reading this annotation should understand what to build, the key decisions made, and where it fits in the architecture — implementation specifics are their responsibility.

**Annotation format:**

```
## Architect Annotation

**Skill**: frontend | backend | fullstack | devops
**Complexity**: S | M | L
**Depends on**: Story N (reason) — or "None"

### Scope
<1–2 sentences: which layers/modules are touched and what is new vs. extended>

### Key decisions
- <Decision 1: what was chosen and why>
- <Decision 2: what was chosen and why>

### Acceptance criteria
| AC | Design approach |
|----|----------------|
| <AC text> | <what to build at the design level — domain, API contract, or UI behavior> |
| <AC text> | <what to build at the design level> |
```

**Complexity guide:**
- **S** — Single layer change, no new entities, straightforward, <4 hours
- **M** — Multiple layers, one new entity or endpoint, standard patterns, 4–8 hours
- **L** — Multiple new entities, complex business logic, cross-cutting concerns, >8 hours

**Complete when:** Every story has an annotation with clear scope, decisions, and design-level AC guidance.

---

## Output Contract

Produce:
1. The complete design document (Stage 4 template, filled in full)
2. One annotation block per story (Stage 5 template, filled in full)

These two artifacts together constitute the architect's complete output. The command layer that invoked this skill is responsible for writing them to the appropriate destination.

---

## Constraints

- Follow existing codebase patterns — introduce new patterns only when justified in the design doc
- Story annotations define direction and decisions, not implementation code — file names, validation logic, and exact schemas belong to the developer
- Call out story dependencies explicitly — never leave implicit ordering
- Do NOT write implementation code
- If a design decision requires a product owner choice, flag it in Open Questions and make a reasonable default assumption
