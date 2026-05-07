# Mode: Create Refactor

---

## Step 1 — Discovery Dialog

Use `AskUserQuestion` to collect the following in a single call. Do not write any issue until all answers are resolved.

- **What is the problem?** — What pain point drives this refactor? (tech debt, tight coupling, performance, maintainability, enabling a future feature)
- **What is the scope?** — Which modules, layers, or files are affected?
- **Which codebases?** — backend / frontend / infrastructure (multiSelect)
- **Definition of done** — What should be true after the refactor that is not true now?

Synthesize the answers. If any answer is too vague to design from, fire a follow-up `AskUserQuestion` before proceeding.

---

## Step 2 — Explore Codebase

From the discovery session, derive the targeted exploration scope per codebase.

Spawn one `Explore` subagent per in-scope codebase **in parallel**. Give each a targeted brief — exactly what to find:

**Backend subagent** (if backend in scope):
- Find the specific files, classes, services, and patterns that need to change
- Identify coupling points, duplication, or structural issues
- Return: file paths, class/method names, current pattern, what needs changing and why

**Frontend subagent** (if frontend in scope):
- Find relevant components, hooks, utilities, or state management affected
- Identify shared code, duplication, or abstraction gaps
- Return: file paths, component names, current pattern, what needs changing and why

**Infrastructure subagent** (if infrastructure in scope):
- Find relevant Terraform resources, modules, or config affected
- Return: file paths, resource names, current pattern, what needs changing and why

---

## Step 3 — Resolve Blocking Questions

Try to answer each question from the exploration findings first. Only raise questions the codebase cannot answer. Collect all blockers and present in a single `AskUserQuestion` call. Do not proceed until every question is resolved.

| Category | Decisions to resolve |
|----------|----------------------|
| **Scope boundary** | Any files or modules that should be excluded even if they look related? |
| **Backward compatibility** | Must public contracts (API, events, DB schema) remain unchanged during and after the refactor? |
| **Migration** | Any data or state that needs migrating as part of this change? |
| **Dependencies** | Does any other in-progress work share the affected files? Risk of conflicts? |
| **Non-functional targets** | Any latency, throughput, or memory goals this refactor must hit or preserve? |

Skip categories that clearly do not apply.

---

## Step 4 — Design Refactoring Plan

Using exploration findings, draft the full refactoring plan. Do NOT write implementation code.

Produce the following sections:

- **Problem Statement** — 2–3 sentences: the specific issue in the codebase, concrete and technical
- **Motivation** — what this refactor unlocks or improves once complete
- **Scope** — bullet list of specific files, modules, or layers in scope
- **Technical Approach** — numbered steps describing how to execute the refactor in sequence
- **Affected Codebases** — list each codebase and the area of change
- **Definition of Done**:
  - Always include: "All existing tests pass" and "No user-visible behavior change"
  - Add specifics derived from the problem and approach (e.g., "No circular dependencies in X module", "Response time for Y endpoint unchanged")

---

## Step 5 — Create Refactoring Issue

Create a GitHub issue:
- **Title**: `refactor: <short imperative description>`
- **Label**: `refactoring`
- **Body**: render `issue-refactoring` template with all fields from Step 4
- **No milestone** — standalone, not sprint-tied

Post the issue URL. Instruct: run `/dev <issue_number>` to implement.