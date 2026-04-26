---
name: artifacts
description: Generates formatted GitHub issues, PRs, and comments. Auto-invoked on any `render_template()` call — never reference `.claude/skills/artifacts/` template files directly.
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

Before calling `render_template()`, Read the corresponding reference file to get the field spec.

---

## Template Index

| Template | `render_template()` name | Reference file |
|---------|--------------------------|----------------|
| Issue: User Story | `issue-user-story` | `references/issue-user-story.md` |
| Issue: Requirement | `issue-requirement` | `references/issue-requirement.md` |
| Issue: Bug Report | `issue-bug-report` | `references/issue-bug-report.md` |
| Issue: TDD | `issue-tdd` | `references/issue-tdd.md` |
| Issue: Design Instructions | `issue-design-instructions` | `references/issue-design-instructions.md` |
| Acceptance Criteria | `acceptance-criteria` | `references/acceptance-criteria.md` |
| PR: Story | `pr-story` | `references/pr-story.md` |
| PR: Revert | `pr-revert` | `references/pr-revert.md` |
| PR: Release | `pr-release` | `references/pr-release.md` |
| Comment: Sprint Summary | `comment-sprint-summary` | `references/comment-sprint-summary.md` |
| Comment: Dev Investigation | `comment-dev-investigation` | `references/comment-dev-investigation.md` |
| Comment: Bug Summary | `comment-bug-summary` | `references/comment-bug-summary.md` |
