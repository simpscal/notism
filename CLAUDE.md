# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Bootstrap

At the start of every conversation, before taking any other action:

1. Read `.claude/project.md` — hold in memory: tracker adapter path, repo, codebase paths, tech stack, label names, branch patterns, test/lint commands.
2. Read the tracker adapter at the path from step 1 — all issue tracker operations must use the operations it defines.

Never hardcode repo slugs, label names, paths, or branch patterns.
