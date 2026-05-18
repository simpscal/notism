
Extract `issue_number` (the token after `amend`).

---

## Step 1 — Fetch Refactor Issue

Read issue `#issue_number` in full — title, body, labels.

**Guard**: must have `refactoring` label. If absent → stop:
> ⛔ Issue #N is not a refactoring task (label `refactoring` missing).

Hold as **$REFACTOR**. Extract from body:
- **Problem Statement**
- **Motivation**
- **Scope** (bullet list)
- **Technical Approach** (numbered steps)
- **Affected Codebases**
- **Definition of Done** (checklist)

---

## Step 2 — Load Architecture Constraints

Read each in-scope codebase's `CLAUDE.md` (paths from the Codebases table).

Hold the architecture facts in memory — layer structure, naming conventions, build/test commands, patterns in use.

---

## Step 3 — Reconstruct the Mental Model

Work through all loaded material silently. Produce no output in this step. Build the following understanding before proceeding:

**From $REFACTOR:**
- What is the specific pain point driving the refactor?
- Which files, modules, or layers are in scope?
- What is the sequence of steps in the current Technical Approach?
- What does "done" look like — which DoD items are objective vs subjective?
- What was explicitly excluded or constrained?

**From CLAUDE.md files:**
- What architectural constraints apply to each affected codebase?
- What patterns must the refactor preserve?

Complete when: you can state the refactor goal, name every file or module in scope, summarise every step of the approach, and flag what would break if scope shifts — without re-reading.

When complete, activate using this format:

> Technical Lead active — refactor #issue_number. Full knowledgebase loaded: [list what was loaded]. Ready to discuss changes or alternatives.

Do not proceed to Step 4 until activation is complete.

---

## Step 4 — Open Amendment Dialog

Ask a single `AskUserQuestion`:

> What changed, and why? Describe the problem with the current refactor plan and the direction you want to go — or share options you'd like to evaluate.

Hold the response as **$CHANGE_INPUT**. Do not proceed until answered.

Use $CHANGE_INPUT to engage in discussion — answer trade-off questions, surface constraints from the mental model, flag risks from loaded material. Continue iterating until the final direction is confirmed.

---

## Step 5 — Re-explore (if scope expands)

If the confirmed change adds a codebase not previously listed in **Affected Codebases**, or expands scope into modules not yet mapped:

Spawn one `Explore` subagent per newly-in-scope area **in parallel** with a targeted brief (file paths, classes/components, current pattern, what needs changing and why). Use the same briefs as `create-refactor` Step 2.

Skip this step if the change stays within the existing Scope.

---

## Step 6 — Revise Plan and Gate on Approval

Use the current refactor as baseline. Output the **full revised plan**, not a diff.

For each section, decide whether the confirmed change affects it — keep unchanged sections exactly, rewrite only affected parts.

| Field | When to revise |
|-------|----------------|
| Problem Statement | Pain point reframed or sharpened |
| Motivation | What the refactor unlocks has shifted |
| Scope | Files/modules added or removed |
| Technical Approach | Steps reordered, replaced, or added |
| Affected Codebases | Codebase added or dropped |
| Definition of Done | New objective criterion or one no longer applies |

Present a **Change Summary** before the revised body:

```
## Refactor Amendment — Issue #<N>: <title>

**Scope changes**: <added: X · removed: Y · unchanged>
**Approach changes**: <step N replaced · step N+1 added · …>
**DoD changes**: <added · removed · unchanged>
**Codebases added/removed**: <list or "none">
```

Then post the full revised issue body.

Ask via `AskUserQuestion`: *"Confirm this amendment, or specify adjustments before I update the issue."*

Do NOT call any mutating operation until the user confirms.

---

## Step 7 — Update Issue

After approval:

1. Update the body of issue `#issue_number` with the revised plan (render the `issue-refactoring` template).

2. Report:
   ```
   Refactor #<N> amended. Scope: <delta>. Approach: <delta>. DoD: <delta>.
   ```
