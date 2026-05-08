---
name: github
description: GitHub issue tracker — create, read, update issues; post comments; create/list milestones; manage labels; close issues. Never hardcode repo slugs, label names, or branch patterns.
tools: mcp__github__issue_read, mcp__github__list_issues, mcp__github__issue_write,
  mcp__github__add_issue_comment, mcp__github__update_issue, Bash
---

## Repo Derivation

Derive at runtime — never hardcode:

- **Orchestration repo** (issues, milestones, stories, TDD, design): run `gh repo view --json owner,name --jq '[.owner.login,.name]|join("/")'` from the orchestration repo root.
- **Codebase repos** (PRs, branches): run the same from inside the codebase directory (path from `config.md` Codebases table).

Hold results for the session.

---

## Confirmation Protocol

Before any mutating operation:
1. Summarise all planned mutations in one block
2. Ask once: `"Proceed? (y/n)"` — group related mutations into a single prompt
3. Proceed only if confirmed; stop and report if denied

**No confirmation needed**: read issue, list issues, list milestones — any read-only operation

**Always confirm**: create issue, create milestone, update issue body, update labels, post comment, close issue, update comment

**Example:**
```
## Planned Tracker Actions

1. Create milestone "Sprint 4" with description "User can log in"
2. Create issue "[Story] Log in with email" — labels: user-story, milestone: Sprint 4
3. Create issue "[Story] Log out" — labels: user-story, milestone: Sprint 4
4. Add label sprint-ready to issue #12

Proceed? (y/n)
```

---

## Operations

### Link Reference
**triggers:** reference issue, link to issue, mention issue
**when:** formatting an issue reference inside a body or comment
- Format: `#id` (e.g. `#17`) — use in issue bodies and comments

### Fetch Issue
**triggers:** read issue, get issue, fetch issue, show issue, look up issue
**when:** need the full content of a single issue — title, body, labels, milestone, comments
- **Tool**: `mcp__github__issue_read` → `{ owner, repo, issue_number: id }`
- Returns: title, body, labels, milestone, comments

### List Issues
**triggers:** list issues, find issues, get issues, issues in sprint, issues with label
**when:** need multiple issues filtered by milestone or label
- **Tool**: `mcp__github__list_issues` → `{ owner, repo, milestone: milestone_id, labels, state: "open" }`
- Multiple labels: call once per label, intersect results
- Returns: `[{id, title, labels, assignees}]`

### Create Issue
**triggers:** create issue, new issue, open issue, add issue
**when:** need to create a new GitHub issue
- **Tool**: `mcp__github__issue_write` → `{ owner, repo, title, body, labels, milestone: milestone_id }`
- Returns: new issue number

### Update Issue Body
**triggers:** update issue, edit issue body, rewrite issue body, modify issue content
**when:** need to change the body/content of an existing issue
- **Tool**: `mcp__github__issue_write` → `{ owner, repo, issue_number: issue_id, body }`
- Always read the issue first — modify, then write

### Update Labels
**triggers:** add label, remove label, update labels, change labels, label issue
**when:** need to add or remove labels on an issue
- **Tool**: `mcp__github__issue_write` → `{ owner, repo, issue_number: issue_id, labels: <current + add - remove> }`
- Read the issue first to get current labels
- If `remove` is empty or omitted — skip removal, keep all current labels

### Post Comment
**triggers:** post comment, add comment, comment on issue, leave a comment
**when:** need to add a new comment to an issue
- **Tool**: `mcp__github__add_issue_comment` → `{ owner, repo, issue_number: issue_id, body }`

### Update Comment
**triggers:** update comment, edit comment, modify comment
**when:** need to edit an existing comment by its comment ID
- **CLI**: `gh api repos/{owner}/{repo}/issues/comments/{comment_id} --method PATCH -f body="{body}"`

### Create Milestone
**triggers:** create milestone, new milestone, add milestone, set up sprint milestone
**when:** need to create a new sprint or milestone
- **CLI**: `gh api repos/{owner}/{repo}/milestones --method POST -f title="{title}" -f description="{description}"`
- Returns: milestone id

### List Milestones
**triggers:** list milestones, show milestones, get milestones, what milestones exist
**when:** need the titles of all milestones to find a matching sprint
- **CLI**: `gh api repos/{owner}/{repo}/milestones --jq '.[].title'`
- Returns: list of milestone titles

### List Milestones Detail
**triggers:** list milestones with details, milestone details, milestone counts, milestone IDs
**when:** need milestone numbers and open issue counts, not just titles
- **CLI**: `gh api repos/{owner}/{repo}/milestones --jq '[.[] | {number: .number, title: .title, open_issues: .open_issues}]'`
- Returns: `[{number, title, open_issues}]`

### Resolve Sprint Milestone
**triggers:** resolve sprint milestone, find sprint milestone, locate sprint N milestone ID
**when:** need only the milestone ID for a given sprint number
- List all milestones: `gh api repos/{owner}/{repo}/milestones`
- Find the milestone whose title is `Sprint N`.
- If not found: list available milestone titles and stop — `⛔ No milestone found titled "Sprint N". Available: <titles>`
- Hold GitHub ID as `$MILESTONE_ID` for the session.

### Load Sprint Snapshot
**triggers:** load sprint context, fetch sprint issues, partition sprint issues, sprint snapshot
**when:** need the full set of open sprint issues partitioned by type — standard starting point for most sprint commands
1. -> Resolve Sprint Milestone for Sprint N. Hold `$MILESTONE_ID`.
2. List all **open** issues in the milestone once.
3. Partition in memory and read all present partitions in parallel:
   - **$STORIES** — issues labelled `user-story`. Read each in full (body, ACs, notes).
   - **$REQUIREMENT** — single issue labelled `requirement`. Read in full. May be absent.
   - **$TDD** — single issue labelled `technical-design`. Read in full if present. May be absent.
   - **$DESIGN** — single issue labelled `design`. Read in full if present. May be absent.
4. Hold all partitions for the session.

### List Open Issues
**triggers:** list open issues, find open issues, open bugs, open stories, issues by label
**when:** need all open issues filtered by label regardless of milestone
- **Tool**: `mcp__github__list_issues` → `{ owner, repo, state: "open", labels }`
- Returns: `[{number, title, labels}]`

### Close Issue
**triggers:** close issue, mark issue closed, resolve issue, shut issue
**when:** need to close or resolve a GitHub issue
- **Tool**: `mcp__github__update_issue` → `{ owner, repo, issue_number: issue_id, state: "closed" }`

### Notify Implementation Complete
**triggers:** notify implementation complete, post completion comment, notify revert complete, notify refactor complete
**when:** implementation, refactor, or revert is done and issue needs status update

**Single-skill (refactor):** Post comment on issue `#ISSUE_NUMBER`:
```
## Refactor Complete

- PR: <pr-url>

---
> ⏸ Human gate: Review the PR diff. When approved, merge into `main`.
```

**Multi-skill (refactor, two PRs):** Post comment on issue `#ISSUE_NUMBER`:
```
## Refactor Complete

- Backend: <pr-url>
- Frontend: <pr-url>

---
> ⏸ Human gate: Review both PR diffs. When approved, merge into `main`.
```

**Single-skill (revert):** Post comment on issue `#ISSUE_NUMBER`:
```
## Revert Ready

Story #<ISSUE_NUMBER> was removed from scope. Implementation has been reversed.

- Revert PR: <revert-pr-url>

---
> ⏸ Human gate: Review the revert PR diff. When approved, merge into the sprint branch.
```

**Multi-skill (revert, two PRs):** Post comment on issue `#ISSUE_NUMBER`:
```
## Revert Ready

Story #<ISSUE_NUMBER> was removed from scope. Implementation has been reversed across all codebases.

- Backend revert PR: <revert-pr-url>
- Frontend revert PR: <revert-pr-url>

---
> ⏸ Human gate: Review both revert PR diffs. When approved, merge into the sprint branch.
```

**Single-skill (implementation):** Post comment on issue `#ISSUE_NUMBER`:
```
## Implementation Complete

- PR: <pr-url>

---
> ⏸ Human gate: Review the PR diff. When approved, merge into the staging branch.
```

**Multi-skill (implementation, two PRs):** Post comment on issue `#ISSUE_NUMBER`:
```
## Implementation Complete

- Backend: <pr-url>
- Frontend: <pr-url>

---
> ⏸ Human gate: Review both PR diffs. When approved, merge into the staging branch.
```

**Label updates (implementation):** add `implemented`, remove `in-progress` and `story-updated`
**Label updates (refactor):** add `implemented`, remove `in-progress`
**Label updates (revert):** add `implemented`, remove `in-progress`, `story-updated`, and `story-removed`
