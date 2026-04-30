---
name: common-rules
description: >
  Apply when writing, modifying, or designing code solutions. Governs how code
  changes are made and how solutions are shaped — from low-level edits to
  high-level design decisions.
tools: Read, Grep, Glob, Bash
---

# Common Rules

## Check References Before Removing

Before removing any symbol, file, or config key:

1. Search the entire codebase for usages (name, import path, symbol)
2. If active callers exist — **do not remove**; report what still uses it
3. Only remove if zero references found, or all callers are removed in the same change

## Simplicity Over Complexity

Prefer the simpler solution unless complexity is justified by long-term maintainability.

- **No premature abstractions** — don't introduce base classes, interfaces, helpers, or layers for a single use case; wait for the second or third caller
- **No speculative generality** — don't add parameters, flags, or extension points for hypothetical future needs; add them when needed
- **Inline before extracting** — if a helper is used once and the call site is already clear, keep it inline
- **Flat before nested** — avoid deep nesting of components, modules, or logic when a flat structure is readable
- **Three-strikes rule** — only extract a shared abstraction after the same pattern appears in three or more places

When reviewing a change: if the added complexity doesn't solve a current, concrete problem — simplify it.
