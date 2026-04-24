# Mode: Standard

Use `list_milestones()` to find the milestone with title `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

---

## Step 1 — Fetch All Stories

Use `list_issues($MILESTONE_ID)` to list all open issues in the milestone. Use `fetch_issue(id)` on each one to read the full body — description, acceptance criteria, and notes.

Also note each story's labels (`story-added`, `story-updated`, `story-removed`) to identify requirement changes.

---

## Step 2 — Fetch Requirement Context

`list_issues($MILESTONE_ID, labels: ["requirement"])` to find the requirement issue in this milestone.

`fetch_issue(requirement_id)` to read it in full. Hold as **$REQUIREMENT** — use this to understand the sprint goal, the user problem being solved, and what "done" looks like from the PO's perspective.

---

## Step 3 — Check for Existing TDD

`list_issues($MILESTONE_ID, labels: ["technical-design"])` to check for an existing TDD issue.

- **If no TDD exists**: Continue to Step 4 (new TDD flow)
- **If TDD exists**: `fetch_issue(tdd_id)` to read it in full. Hold this as the **current TDD** — subsequent steps will produce changes to this document, not a new design from scratch.

---

## Step 4 — Read the Architecture

-> Read each codebase's `CLAUDE.md`

---

## Step 5 — Resolve Blocking Questions

Identify every decision that cannot be made from the code and stories alone. Use `AskUserQuestion` to present all blocking questions in a single message. Do not proceed until every question is resolved.

---

## Step 6 — Design the Solution

Apply the `tl` skill's **Feature Design Mode** to produce the solution design.

**If existing TDD was found in Step 3:**
Use the current TDD as the starting document. Evaluate each design area against the requirement changes — keep unchanged areas exactly, modify only affected parts. Do not redesign unchanged areas.

---

## Step 7 — Create or Update TDD Issue

**If no existing TDD (new):**

Use `create_issue(title, body, labels)`:
- **Title**: `Sprint N — Technical Design Document`
- **Body**: full TDD rendered via `render_template("issue-tdd", {...})`, with `Part of #N` at the very top
- **Labels**: `technical-design` label from project config

Capture the new issue number — referenced in Step 8 and Step 9.

**If existing TDD (update):**

Evaluate every section of the TDD template against the revised design. Sections not affected must be preserved exactly. Sections that change must be fully rewritten — do not summarise or abbreviate.

| TDD Section | Update trigger |
|-------------|----------------|
| Executive Summary — Problem Statement / Goals / Non-Goals | Scope added or removed |
| High-Level Diagram | Any service, database, cache, or integration added or removed |
| Integration Flows (happy + unhappy paths) | Request or response flow changed |
| Technology Stack | New library or infrastructure introduced |
| Components Design | Any component added, removed, or restructured |
| Data Models | Any entity added, removed, or field changed |
| API Specification | Any endpoint added, removed, or its contract changed |
| Event Schemas | Any event added, removed, or its structure changed |
| Alternatives Considered | Any decision revisited |
| Security | Auth or encryption requirements changed |
| Scalability & Performance | Load characteristics changed |
| Failure Modes | Any new external dependency or failure scenario |
| Migration Plan | Data model or cutover strategy changed |
| Architecture Key Decisions | Naming, layering, or cross-cutting patterns changed |
| Implementation Priority | Any story added, removed, or implementation order reconsidered |

Apply changes to the current TDD document. Sections not affected by requirement changes must be preserved exactly. Then: `update_issue_body(tdd_id, updated_body)`.

---

## Step 8 — Create Feature Branches (new TDD only)

If this is a new TDD: Create sprint feature branches for each codebase listed in project config.

Skip if updating an existing TDD (branches already exist).

