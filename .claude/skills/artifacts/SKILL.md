---
name: artifacts
description: Generates formatted GitHub issues, PRs, and comments. Invoked when any command produces a tracker artifact. Commands MUST use `render_template()` — never reference `.claude/templates/` files directly.
tools: Read, Glob
---

# Artifacts

## render_template(name, fields)

Returns a formatted markdown string. Pass the template name and a dict of field values.

```
render_template("pr-story", {
  summary: "Implemented user profile page",
  changes: ["`src/pages/Profile.tsx` — Added profile page"],
  test_command: "bun run test",
  lint_command: "bun run lint",
  manual_verification: "Navigate to /profile and upload an avatar",
  acceptance_criteria: ["Avatar visible after upload"],
  closes: "#47"
})
```

---

## Template Index

| Template | `render_template()` name |
|---------|--------------------------|
| Issue: User Story | `issue-user-story` |
| Issue: Requirement | `issue-requirement` |
| Issue: Bug Report | `issue-bug-report` |
| Issue: TDD | `issue-tdd` |
| Issue: Design Instructions | `issue-design-instructions` |
| Acceptance Criteria | `acceptance-criteria` |
| PR: Story | `pr-story` |
| PR: Revert | `pr-revert` |
| PR: Release | `pr-release` |
| Comment: Sprint Summary | `comment-sprint-summary` |
| Comment: Dev Investigation | `comment-dev-investigation` |
| Comment: Bug Summary | `comment-bug-summary` |

---

## `issue-user-story`

**Used by**: BA — story creation and change modes

| Field | Req | Notes |
|-------|-----|-------|
| `user_story` | yes | `As a <role>, I want <action> so that <benefit>` |
| `acceptance_criteria` | yes | 2-8 items, observable, pass/fail |
| `notes` | no | Edge cases, dependencies |
| `requirement_issue` | yes | Use `link_to(id)` |

---

## `issue-requirement`

**Used by**: PO — requirement creation

| Field | Req | Notes |
|-------|-----|-------|
| `summary` | yes | 2-3 sentences: what + why, business-focused |
| `goals` | yes | 2-6 items, user-centric |
| `out_of_scope` | yes | Exclusions or `Not specified` |

---

## `issue-bug-report`

**Used by**: PO — bug report creation

| Field | Req | Notes |
|-------|-----|-------|
| `description` | yes | 1-2 sentences, user impact |
| `steps` | yes | 2-15 numbered steps, include preconditions |
| `expected` | yes | What should happen |
| `actual` | yes | What does happen; may include error messages |
| `severity` | yes | `critical` \| `high` \| `medium` \| `low` |

---

## `issue-tdd`

**Used by**: Tech Lead — feature design

| Field | Req | Notes |
|-------|-----|-------|
| `requirement_issue` | yes | e.g. `#38` |
| `sprint` | yes | e.g. `Sprint 5` |
| `status` | no | `Draft` (default) \| `Approved` \| `Deprecated` |
| `problem_statement` | yes | 2-3 sentences: gap/pain, why now |
| `goals` | yes | 2-6 user-centric items |
| `non_goals` | yes | Out-of-scope list |
| `high_level_diagram` | yes | Mermaid graph — label new vs existing |
| `happy_path` | yes | Mermaid sequence: user → services → storage → response |
| `unhappy_path` | yes | Mermaid sequence: failure + system response |
| `tech_stack` | yes | New tech only, or `No new technologies — uses existing stack` |
| `components_design` | yes | Mermaid graph: all new/modified components |
| `data_models` | yes | ERD/schema with indexes, or `No new data models — uses existing schema` |
| `api_spec` | yes | Table: Method, Route, Auth, Request, Response, Status Codes |
| `event_schemas` | yes | Table or `N/A` |
| `alternatives` | yes | Table: Decision, Chosen, Alternative, Why Rejected — min 1 |
| `security` | yes | Auth, authz, encryption at rest and in transit |
| `scalability` | yes | Throughput/latency targets, scaling approach |
| `failure_modes` | yes | Table: Scenario, Impact, Mitigation — min 2 rows |
| `migration` | yes | Cutover + rollback, or `N/A — no data migration required` |
| `monitoring` | yes | Key metrics, alert thresholds |
| `arch_decisions` | yes | Layer responsibilities, naming, patterns, file org |
| `implementation_priority` | yes | P1/P2/P3 table — `story-removed` always P1, all stories listed |

---

## `issue-design-instructions`

**Used by**: Designer — design instructions creation

| Field | Req | Notes |
|-------|-----|-------|
| `requirement_issue` | yes | e.g. `#38` |
| `overview` | yes | Sprint UI goal + affected pages (new vs modified) + reference pages |
| `layout` | yes | Page structure + ASCII wireframes; mark new with `← new` |
| `components` | yes | Exact names/variants from design system — no invented components |
| `design_tokens` | yes | Exact token names — no raw values |
| `ui_states` | yes | Cover Loading, Error, Empty, Success per surface |
| `responsive` | yes | Mobile, tablet, desktop — layout, spacing, size changes |
| `accessibility` | yes | ARIA, keyboard nav, focus, WCAG AA contrast |
| `consistency_notes` | no | Cross-surface deviations with WHY, or `NONE` |

---

## `acceptance-criteria`

**Used by**: Embedded in issue-user-story and issue-bug-report

| Field | Req | Notes |
|-------|-----|-------|
| `criteria` | yes | 2-8 items, observable, testable |
| `notes` | no | Edge cases, dependencies |

---

## `pr-story`

**Used by**: Dev — standard and story-change modes

| Field | Req | Notes |
|-------|-----|-------|
| `summary` | yes | 1-2 sentences: what + why |
| `changes` | yes | `` `path` — description `` per file; em dash; relative path |
| `test_command` | yes | From project config |
| `lint_command` | yes | From project config |
| `manual_verification` | yes | At least 1 specific step |
| `acceptance_criteria` | yes | Copied verbatim from issue, all checked `[x]` |
| `closes` | yes | `#N` |

---

## `pr-revert`

**Used by**: Dev — revert mode

| Field | Req | Notes |
|-------|-----|-------|
| `story_number` | yes | `#N` |
| `story_title` | yes | Verbatim — strip `[Story]` prefix |
| `original_pr` | yes | `#N` |
| `merge_commit` | yes | Full SHA from `mergeCommitSha` |
| `test_command` | yes | From project config |
| `lint_command` | yes | From project config |

---

## `pr-release`

**Used by**: PO — sprint close

| Field | Req | Notes |
|-------|-----|-------|
| `sprint` | yes | e.g. `Sprint 5` |
| `stories` | yes | All stories; `Closes #N — <title>`; em dash; sorted by issue number ascending |
| `migrations` | yes | Warning block with file paths, or `No database migrations in this sprint.` |

---

## `comment-sprint-summary`

**Used by**: PO — sprint close

| Field | Req | Notes |
|-------|-----|-------|
| `sprint` | yes | `Sprint N` |
| `closed_date` | yes | `YYYY-MM-DD` |
| `stories` | yes | All milestone stories, sorted ascending, exact titles |
| `release_prs` | yes | Changed codebases only; codebase name from project config |
| `migrations` | yes | Warning phrase or `None` |

---

## `comment-dev-investigation`

**Used by**: Dev — bug mode, posted before implementation

| Field | Req | Notes |
|-------|-----|-------|
| `complexity` | yes | `S` (<4h) \| `M` (4-8h) \| `L` (>8h) |
| `root_cause` | yes | Plain English WHY — no file paths or layer names |
| `scope` | yes | Product area affected — no code locations |
| `fix_approach` | yes | `[side]` tag + imperative bullets, no code |
| `risk` | yes | `Low — ...` \| `Medium — migration required: ...` \| `High — ...` |

---

## `comment-bug-summary`

**Used by**: PO — bug close

| Field | Req | Notes |
|-------|-----|-------|
| `issue` | yes | `#N — <title>` with em dash |
| `closed_date` | yes | `YYYY-MM-DD` |
| `migrations` | yes | Warning phrase or `None` |
