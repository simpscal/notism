---
name: project-config
description: >
  Auto-invoked once at the start of every conversation. Loads project configuration
  from `config.md` and holds it for the session: codebase paths, GitHub
  labels, and migration detection rules. Must run before any other work begins.
tools: Read
---

Read `config.md` and hold for the session:
- **Codebases** — name, path, tech summary (exact paths used by agents)
- **Labels** — purpose-to-string mapping (exact strings used in GitHub API calls)
- **Migration Detection** — path pattern for EF Core migration files

Retain exact values — do not summarise. Do not re-read if already loaded this session.
