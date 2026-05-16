---
name: github-templates
description: Format GitHub issues, PRs, and comments via `render_template()`. Auto-invoke on any `render_template()` call; never read template files directly.
tools: Read, Glob
---

# GitHub Templates

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

Before calling `render_template()`, Read the corresponding reference file to get the field spec.

---

## Template Index

| Template | `render_template()` name | Reference file |
|---------|--------------------------|----------------|
| Issue: User Story | `issue-user-story` | `references/issue-user-story.md` |
| Issue: Requirement | `issue-requirement` | `references/issue-requirement.md` |
| Issue: Bug Report | `issue-bug-report` | `references/issue-bug-report.md` |
| Issue: TDD | `issue-tdd` | `references/issue-tdd.md` |
| Acceptance Criteria | `acceptance-criteria` | `references/acceptance-criteria.md` |
| PR: Story | `pr-story` | `references/pr-story.md` |
| PR: Bug Fix | `pr-bug` | `references/pr-bug.md` |
| PR: Revert | `pr-revert` | `references/pr-revert.md` |
| PR: Release | `pr-release` | `references/pr-release.md` |
| Comment: Sprint Summary | `comment-sprint-summary` | `references/comment-sprint-summary.md` |
| Comment: Dev Investigation | `comment-dev-investigation` | `references/comment-dev-investigation.md` |
| Comment: Bug Summary | `comment-bug-summary` | `references/comment-bug-summary.md` |
| Comment: QA Test Cases | `comment-qa-test-cases` | `references/comment-qa-test-cases.md` |
| Comment: Design Hub | `comment-design-hub` | `references/comment-design-hub.md` |
| Comment: Redesign Hub | `comment-redesign-hub` | `references/comment-redesign-hub.md` |
