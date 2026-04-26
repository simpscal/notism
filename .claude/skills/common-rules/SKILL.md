---
name: common-rules
description: >
  Universal coding guardrails — apply on every code modification: refactoring, removing,
  renaming, restructuring, deleting, moving, or simplifying code.
tools: Read, Grep, Glob, Bash
---

# Common Rules

## Check References Before Removing

Before removing any symbol, file, or config key:

1. Search the entire codebase for usages (name, import path, symbol)
2. If active callers exist — **do not remove**; report what still uses it
3. Only remove if zero references found, or all callers are removed in the same change
