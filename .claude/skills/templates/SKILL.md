---
name: templates
description: Generates formatted GitHub issues, PRs, and comments from templates. Automatically invoked when any command needs to produce a tracker artifact (issue, PR, comment, design doc). Commands MUST use `render_template()` from this skill instead of referencing `.claude/templates/` files. Use this skill whenever producing: user stories, requirements, bug reports, TDD documents, design instructions, PR descriptions, release PRs, or sprint/comment artifacts. Invoke by name: `templates`
tools: Read, Glob
---

# Templates Skill

All tracker artifact generation flows through this skill. No command should reference `.claude/templates/` files directly.

---

## Render Template Function

**Signature**: `render_template(name, fields) → markdown string`

Call this function to generate any template. Pass template name and a dict of field values. Returns the fully formatted markdown.

### Usage Pattern

```
render_template("issue-user-story", {
  user_story: "As a Manager, I want to export reports as PDF so that I can share them with stakeholders",
  acceptance_criteria: ["Export button visible on report page", "PDF downloads within 5 seconds", "File includes report title and date"],
  notes: "Depends on #42 (chart library upgrade)",
  requirement_issue: "#38"
})
```

---

## Template Index

| Template | Name for `render_template()` | Posted by |
|---------|-------------------------------|-----------|
| Issue User Story | `issue-user-story` | `/ba` |
| Issue Requirement | `issue-requirement` | `/po` |
| Issue Bug Report | `issue-bug-report` | `/po create-bug` |
| Issue TDD | `issue-tdd` | `/tl` |
| Issue Design Instructions | `issue-design-instructions` | `/design` |
| Acceptance Criteria | `acceptance-criteria` | (embedded in issue-user-story, issue-bug-report) |
| PR Story | `pr-story` | `/dev` |
| PR Release | `pr-release` | `/po close-sprint` |
| Comment Sprint Summary | `comment-sprint-summary` | `/po close-sprint` |
| Comment Dev Investigation | `comment-dev-investigation` | `/dev` (bug mode) |
| Comment Bug Summary | `comment-bug-summary` | `/po close-bug` |

---

## `issue-user-story`

**Used by**: `/ba create-stories`, `/ba update-stories` (story-change mode)
**Reference**: `.claude/templates/issue-user-story.md`

### Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `user_story` | string | yes | "As a <role>, I want <action> so that <benefit>" |
| `acceptance_criteria` | list of strings | yes | 2-8 items, observable, no implementation details |
| `notes` | string | no | Edge cases, dependencies, constraints |
| `requirement_issue` | string | yes | GitHub issue number, e.g. "#38" |

### Output Structure

```
## User Story
<user_story>

## Acceptance Criteria
- [ ] <AC 1>
- [ ] <AC 2>

## Notes
<notes or omit section>

---
Part of <requirement_issue>
```

### Example

```
render_template("issue-user-story", {
  user_story: "As a Manager, I want to export reports as PDF so that I can share them with stakeholders",
  acceptance_criteria: ["Export button visible on report page", "PDF downloads within 5 seconds", "File includes report title and date"],
  notes: "Depends on #42",
  requirement_issue: "#38"
})
```

---

## `issue-requirement`

**Used by**: `/po create-requirement`
**Reference**: `.claude/templates/issue-requirement.md`

### Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `summary` | string | yes | 2-3 sentences: what + why |
| `goals` | list of strings | yes | 2-6 items, user-centric, no tech details |
| `out_of_scope` | string | yes | "Not specified" or list of exclusions |

### Output Structure

```
## Summary
<summary>

## Goals
- <goal 1>
- <goal 2>

## Out of Scope
<out_of_scope>
```

---

## `issue-bug-report`

**Used by**: `/po create-bug`
**Reference**: `.claude/templates/issue-bug-report.md`

### Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `description` | string | yes | 1-2 sentences, user impact, no tech details |
| `steps` | list of strings | yes | 2-15 numbered steps |
| `expected` | string | yes | 1-2 sentences, what SHOULD happen |
| `actual` | string | yes | 1-3 sentences, what DOES happen |
| `severity` | string | yes | critical \| high \| medium \| low |

### Output Structure

```
## Bug Report

### Description
<description>

### Steps to Reproduce
1. <step 1>
2. <step 2>

### Expected Behaviour
<expected>

### Actual Behaviour
<actual>

### Severity
<severity>
```

---

## `issue-tdd`

**Used by**: `/tl create-feature-solution`
**Reference**: `.claude/templates/issue-tdd.md`

### Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `sprint` | string | yes | Sprint number, e.g. "Sprint 5" |
| `requirement_issue` | string | yes | GitHub issue number |
| `problem_statement` | string | yes | 2-3 sentences: gap/pain, why now |
| `goals` | list of strings | yes | 2-6 items, user-centric |
| `non_goals` | list of strings | yes | What is not addressed |
| `high_level_diagram` | string | yes | Mermaid diagram showing services, DBs, caches |
| `happy_path` | string | yes | Mermaid sequence: user → services → storage → response |
| `unhappy_path` | string | yes | Mermaid sequence: failure scenario + system response |
| `tech_stack` | string | yes | "No new technologies" or list new tech with purpose |
| `components_design` | string | yes | Mermaid diagram: internal component structure |
| `data_models` | string | yes | "No new data models" or ERD/JSON schema |
| `api_spec` | string | yes | Table: Method, Route, Auth, Request, Response, Status Codes |
| `event_schemas` | string | yes | "N/A" or Topic, schema, producer, consumer |
| `alternatives` | string | yes | Table: Decision, Chosen, Alternative, Why Rejected |
| `security` | string | yes | Auth, authz, encryption coverage |
| `scalability` | string | yes | Throughput/latency targets, scaling approach |
| `failure_modes` | string | yes | Table: Scenario, Impact, Mitigation (min 2) |
| `migration` | string | yes | "N/A" or cutover + rollback plan |
| `monitoring` | string | yes | Key metrics, alert thresholds |
| `arch_decisions` | string | yes | Layer responsibilities, naming, file org, cross-cutting |
| `implementation_priority` | string | yes | Table: Priority, Stories (story-removed = P1) |
| `status` | string | no | Draft (default), Approved, Deprecated |

### Output Structure

See `.claude/templates/issue-tdd.md` for full markdown structure.

---

## `issue-design-instructions`

**Used by**: `/design create-design`
**Reference**: `.claude/templates/issue-design-instructions.md`

### Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `requirement_issue` | string | yes | e.g. "#38" |
| `overview` | string | yes | Sprint UI goal, affected pages, reference pages |
| `layout` | string | yes | Page structure + ASCII wireframes |
| `components` | string | yes | Table: Element, Component, Variant, Size, Notes |
| `design_tokens` | string | yes | Table: Usage, Token, Notes (no raw values) |
| `ui_states` | string | yes | Table: Surface, State, Implementation |
| `responsive` | string | yes | Mobile, tablet, desktop breakpoints |
| `accessibility` | string | yes | ARIA, keyboard nav, focus, contrast |
| `consistency_notes` | string | no | "NONE" or cross-surface deviations |

### Output Structure

See `.claude/templates/issue-design-instructions.md` for full markdown structure.

---

## `pr-story`

**Used by**: `/dev` (standard mode, change mode)
**Reference**: `.claude/templates/pr-story.md`

### Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `summary` | string | yes | 1-2 sentences: what + why built |
| `changes` | list of strings | yes | Format: "`path/to/file` — <what changed>" |
| `test_command` | string | yes | From project.md (e.g. `cd ../notism-api && dotnet test`) |
| `lint_command` | string | yes | From project.md (e.g. `cd ../notism-web && bun run lint`) |
| `manual_verification` | string | yes | At least 1 manual step |
| `acceptance_criteria` | list of strings | yes | Copy ACs from issue verbatim, all checked |
| `closes` | string | yes | Issue number, e.g. "#47" |

### Output Structure

```
## Summary
<summary>

## Changes
- `path/to/file` — <what changed>

## Test plan
- [ ] <test_command> passes
- [ ] <lint_command> passes
- [ ] <manual_verification>

## Acceptance criteria
- [x] <AC 1>
- [x] <AC 2>

Closes <closes>
```

---

## `pr-release`

**Used by**: `/po close-sprint`
**Reference**: `.claude/templates/pr-release.md`

### Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `sprint` | string | yes | Sprint number |
| `stories` | list of dicts | yes | Each: {issue: "#N", title: "..."} sorted by issue asc |
| `migrations` | string | yes | "No database migrations" or migration warning + files |
| `checklist` | list of strings | no | Default: 4 fixed items |

### Output Structure

```
## Sprint N — Release PR

Merges all Sprint N stories into main.

## Stories
- Closes #<N> — <title>

## Migration notes
<migrations>

## Checklist
- [ ] All story PRs merged into sprint branch
- [ ] Migration scripts reviewed (if any)
- [ ] Lint and tests pass on sprint branch
- [ ] QA sign-off
```

---

## `comment-sprint-summary`

**Used by**: `/po close-sprint`
**Reference**: `.claude/templates/comment-sprint-summary.md`

### Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `sprint` | string | yes | Sprint number |
| `closed_date` | string | yes | YYYY-MM-DD format |
| `stories` | list of dicts | yes | Each: {issue: "#N", title: "..."} |
| `release_prs` | list of dicts | yes | Each: {codebase: "backend\|frontend", pr: "#N"} |
| `migrations` | string | yes | Migration warning or "None" |

### Output Structure

See `.claude/templates/comment-sprint-summary.md` for full structure.

---

## `comment-dev-investigation`

**Used by**: `/dev` (bug mode — posted after root cause investigation, before implementation)
**Reference**: `.claude/templates/comment-dev-investigation.md`

### Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `complexity` | string | yes | S \| M \| L |
| `root_cause` | string | yes | Plain language — WHY the bug occurs, no file paths or technical terms |
| `scope` | string | yes | Plain language — which product area is affected, no file paths or layer names |
| `fix_approach` | string | yes | Opens with [side] tag + actionable bullets |
| `key_decisions` | list of strings | yes | Min 1: "Decision: rationale" |
| `risk` | string | yes | Pattern: "Low — ..." or "Medium — migration required: ..." |

### Output Structure

```
## Dev Investigation

**Complexity**: <complexity>

### Root Cause
[<frontend|backend|devops>] <root_cause>

### Scope
<scope>

### Fix Approach
[<frontend|backend|devops|frontend + backend>] <fix_approach>

### Key Decisions
- <key_decision 1>

### Risk
<risk>
```

---

## `acceptance-criteria`

**Used by**: Embedded in issue-user-story and issue-bug-report
**Reference**: `.claude/templates/acceptance-criteria.md`

### Fields

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `criteria` | list of strings | yes | 2-8 items, observable, testable, 10-150 chars |
| `notes` | string | no | Edge cases, dependencies |

### Output Structure

```
## Acceptance Criteria
- [ ] <AC 1>
- [ ] <AC 2>

## Notes
<notes>
```

---

## How Commands Use This Skill

Instead of loading `.claude/templates/pr-story.md` at startup, a command should:

1. Call `render_template("pr-story", fields)` to generate the artifact
2. Post the rendered markdown to GitHub via the appropriate MCP tool

Example — `/dev` command generates PR description:

```
render_template("pr-story", {
  summary: "Implemented user profile page with avatar upload",
  changes: [
    "`src/pages/Profile.tsx` — Added profile page component",
    "`src/store/userSlice.ts` — Extended user state with avatar field"
  ],
  test_command: "cd ../notism-api && dotnet test",
  lint_command: "cd ../notism-web && bun run lint",
  manual_verification: "Navigate to /profile and upload an avatar",
  acceptance_criteria: ["Avatar visible after upload", "Upload fails gracefully on network error"],
  closes: "#47"
})
```
