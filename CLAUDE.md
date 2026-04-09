# Project Bootstrap

At the start of every conversation, before taking any other action:

1. Read `.claude/project.md` — extract and hold in memory: tracker adapter path, repo, codebase paths, tech stack details, architecture doc locations, all label names, git branch patterns, and test/lint commands.
2. Read the tracker adapter file at the path specified in `project.md` — all issue tracker operations throughout the conversation must use the operations it defines.
3. When any branch operation is needed (create, checkout, or push a branch), read `.claude/skills/git-workflow.md` — it is the single source of truth for branch naming patterns, git operations, and setup strategy.

No hardcoded repo slugs, paths, or label strings anywhere.
