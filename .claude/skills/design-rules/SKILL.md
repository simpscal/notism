---
name: design-rules
description: >
  Apply when designing or modifying any solution — code, architecture, or
  system design. Governs quality, safety, and simplicity across all design decisions.
tools: Read, Grep, Glob, Bash
---

# Design Rules

## Before Removing Anything

- Search the entire codebase for all usages of the symbol, file, or config key
- If active callers exist, do not remove — report what still depends on it
- Only remove when zero references found, or all dependents are removed in the same change

## Simplicity First

- Prefer the simpler solution unless complexity is justified by a concrete, current need
- Do not introduce abstractions, layers, or extension points for a single use case — wait for the second or third caller
- Do not add parameters or flags for hypothetical future requirements
- Keep helpers inline when called from one place and the call site is already clear
- Favor flat structure over nesting in components, modules, and logic
- Extract a shared abstraction only after the same pattern appears in three or more places
- If the added complexity does not solve a problem that exists today, simplify it
