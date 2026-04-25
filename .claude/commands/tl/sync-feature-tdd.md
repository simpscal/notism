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

Apply the `tl` skill's **Feature Design Mode** to produce the updated solution design.

Use the current TDD as the starting document. Evaluate each design area against the changed stories — keep unchanged areas exactly, modify only affected parts. Do not redesign unchanged areas.

---

## Step 6 — Update TDD Issue

Evaluate every section of the TDD template against the revised design. Sections not affected must be preserved exactly. Sections that change must be fully rewritten — do not summarise or abbreviate.

| TDD Section | Update trigger |
|-------------|----------------|
| Executive Summary — Problem Statement / Goals / Non-Goals | Scope added, updated, or removed |
| High-Level Diagram | Any service, database, cache, or integration added, updated, or removed |
| Integration Flows (happy + unhappy paths) | Request or response flow added, updated, or removed |
| Technology Stack | New library or infrastructure introduced or updated |
| Components Design | Any component added, updated, removed, or restructured |
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
