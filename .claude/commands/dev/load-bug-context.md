# Mode: Load Bug Context

**Purpose:** Activate the Developer specialist for Bug #N. Load the full fix knowledgebase — bug report, ACs, investigation results, git state — then operate as Developer for the remainder of the session.

Extract `bug_issue_number` (the token after `load-bug`).

---

## Step 1 — Fetch Issue

Read issue `#bug_issue_number` in full.

If the issue does not have the `bug-production` label, halt:
```
⛔ Issue #<N> is not a bug (labels: <labels>). Use /dev load-bug only for bug issues.
```

Hold as **$BUG**. Extract:
- Bug Report (Description, Steps to Reproduce, Expected Behaviour, Actual Behaviour, Severity)
- Acceptance Criteria section (if present — written by BA via `add-bug-acs`)
- Any existing investigation comment (Root Cause, Scope, Fix Approach, Risk — posted by a previous `fix-bug` run)

---

## Step 2 — Check Git State

List bugfix branches for issue `<N>` — check if bugfix branch exists on the remote.

List open bugfix PRs for issue `<N>` — check for an open PR.

If a PR is found: fetch the list of files changed in that PR.

List all comments on issue `#bug_issue_number` — check for existing investigation comment.

Hold: `$BUG_BRANCH`, `$PR_URL` (or "none"), `$PR_FILES` (list of changed file paths or "none"), `$INVESTIGATION` (comment body or "not posted").

---

## Step 3 — Reconstruct the Mental Model

Work through the loaded material silently. Produce no output in this step. Build the following understanding before proceeding:

**From $BUG:**
- What is the system's intended behaviour in this scenario?
- What is the actual broken behaviour and how does it manifest?
- What user need does the broken behaviour fail to satisfy?
- What does "fixed" look like from the user's observable perspective?

**From the ACs section (if present):**
- What conditions and outcomes must the fix satisfy?
- Are there edge cases specified that need coverage?

**From the investigation comment (if posted):**
- What is the root cause?
- What is the fix approach — which layer(s) does it touch?
- What is the assessed risk and complexity?

**From git state:**
- Has the fix started (branch exists)?
- Is there an open PR?
- Which files have already been modified in the PR (if open)?

Complete when: you can state the root cause, describe the fix approach, name every AC, and assess fix progress — without re-reading any issue.

---

## Step 4 — Activate and Record

Write the context snapshot below to `context/bug-N-dev-context.md` at the repo root (replace N with the actual issue number). Create the directory if it does not exist. Overwrite any existing file for this bug.

This file is a record of the activated state — the actual activation happened in Step 3. Every section is mandatory; write "None" only when genuinely empty.

---

### Bug #N — Developer Context

**Title:** bug title
**Severity:** as stated in bug report
**Status:** open / in-progress / bug-fixed

---

### Bug Report

| Field | Content |
|-------|---------|
| Description | what the bug is |
| Steps to reproduce | numbered steps |
| Expected behaviour | what should happen |
| Actual behaviour | what happens instead |

---

### Acceptance Criteria

| # | Criterion | Covers |
|---|-----------|--------|
| 1 | Given X, when Y, then Z | Main fix / Edge case |

If none: "No ACs yet — run `/ba add-bug-acs N` before implementing."

---

### Investigation

If investigation comment exists:

| Field | Content |
|-------|---------|
| Root cause | plain language: why the bug occurs |
| Scope | product area / user-facing surface affected |
| Fix approach | `[frontend]` / `[backend]` / `[devops]` — what to change |
| Risk | Low / Medium / High — details |
| Complexity | S / M / L |

If not posted: "Investigation not yet posted — run `/dev N` to start from Step 3."

---

### Git State

| Field | Value |
|-------|-------|
| Bugfix branch | `branch-name` or "not created" |
| Base branch | `main` |
| Open PR | URL or "none" |
| PR files changed | comma-separated paths or "none" |

---

**Developer active — Bug #N.**

I have internalized the full fix knowledgebase: bug report, ACs, investigation results, and git state. Context snapshot written to `context/bug-N-dev-context.md` at the repo root.

I am now operating as Developer for Bug #N for the remainder of this session. What do you need?

---

## While Active

Distinguish input type on every follow-up message:

**Task** — input describes work to implement (fix, change, patch — e.g. "fix X", "handle the null case", "patch Y"). Proceed immediately:
1. Derive requirements from the user's input: restate what needs to be fixed + list testable conditions
2. Dispatch via `_dispatch-subagent.md`, passing:
   - Requirements: derived from user input (above)
   - Architecture context: $BUG investigation verbatim (Root Cause, Scope, Fix Approach, Risk) — or bug report if investigation not yet posted
   - Design instructions: absent (bug fix flow)

**Question or discussion** — input asks about root cause, scope, existing behaviour, or decisions. Answer from loaded context. Do not dispatch.
