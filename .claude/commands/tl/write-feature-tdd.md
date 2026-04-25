# Mode: Standard

Use `list_milestones()` to find the milestone with title `Sprint N`. Hold its GitHub ID as `$MILESTONE_ID`.

---

## Step 1 — Fetch All Issues

Call `list_issues($MILESTONE_ID)` once. Partition the result in memory:

- **$STORIES** — issues labelled `user-story`. Use `fetch_issue(id)` on each to read full body, acceptance criteria, and notes.
- **$REQUIREMENT** — single issue labelled `requirement`. Use `fetch_issue(requirement_id)` to read it in full. Hold as **$REQUIREMENT** — use this to understand the sprint goal, the user problem being solved, and what "done" looks like from the PO's perspective.
- **$TDD** — single issue labelled `technical-design` (may be absent). If one already exists, report "TDD already exists for Sprint N — run `/tl sync Sprint N` to update" and stop.

---

## Step 2 — Read the Architecture

-> Read each codebase's `CLAUDE.md`

---

## Step 3 — Resolve Blocking Questions

Identify every decision that cannot be made from the code and stories alone. Use `AskUserQuestion` to present all blocking questions in a single message. Do not proceed until every question is resolved.

---

## Step 4 — Design the Solution

Apply the `tl` skill's **Feature Design Mode** to produce the solution design.

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

