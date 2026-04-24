# Mode: Standard

`fetch_issue(requirement_issue_number)` to read the requirement in full.

---

## Step 1 — Discovery Session with PO

Run a discovery session with the PO. Goal: state in one unambiguous sentence what the sprint goal is.

---

## Step 2 — Decompose into Stories

Analyse the requirement and decompose into 3–20 INVEST-compliant user stories, each with acceptance criteria and a Notes section.

---

## Step 3 — Create Sprint Milestone

`list_milestones()` to determine next sprint number.
`create_milestone("Sprint N", sprint_goal)`

---

## Step 4 — Create User Story Issues

For each story: `create_issue("[Story] <title>", body, ["user-story"], milestone_id)` where body comes from `render_template("issue-user-story", {user_story, acceptance_criteria, notes, requirement_issue})`.

> **Dependency linking**: Create all issues first, then back-fill `link_to(id)` references in Notes for both `Depends on` and `Blocks` directions.

