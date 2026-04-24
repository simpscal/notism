---
name: common-rules
description: >
  Universal coding guardrails — apply these rules on every code modification task:
  refactoring, removing code, renaming, restructuring, deleting files, moving functions,
  or any change that could break existing callers. Auto-invoked on any task involving
  deletion, removal, renaming, or restructuring of code. Trigger phrases: "remove",
  "delete", "clean up", "refactor", "rename", "restructure", "simplify", "unused".
tools: Read, Grep, Glob, Bash
---

# Common Rules

## Identity

Universal guardrails that apply to every code modification task. These rules exist to prevent breaking changes and unintended side effects. Consult before making any structural change to code.

---

## Rules

### Check References Before Removing

Before removing any function, variable, class, method, type, constant, or file — search for all references first.

**Steps:**
1. Search the entire codebase for usages (by name, import path, or symbol)
2. If any active callers exist, **do not remove** — report what still uses it instead
3. Only remove if zero references found, or all remaining references are themselves being removed in the same change

**Applies to**: functions, methods, variables, constants, classes, interfaces, types, components, modules, files, exports, config keys.
