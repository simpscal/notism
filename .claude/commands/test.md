---
name: test
description: QA test case lifecycle — write, sync, amend, pass, block. Applies to feature stories and hotfix bugs.
argument-hint: "<write|sync|amend|pass|block> <issue> [notes]"
tools: Read, AskUserQuestion
---

# /test — QA Test Case Orchestrator

Generate and manage human-verified test cases. Same workflow whether the target is a feature story or a production bug — the mode files fetch the issue and adapt to its labels.

## Step 1 — Parse Arguments and Load Mode

| Stage | Args | Description | Mode file |
|---|---|---|---|
| `write` | `<issue>` | First-time generation of test cases from the issue's ACs. | `test/write.md` |
| `sync` | `<issue>` | Reconcile existing test cases after a requirement change. | `test/sync.md` |
| `amend` | `<issue>` | Revise test cases affected by an AC amendment on this single issue. | `test/amend.md` |
| `pass` | `<issue>` | Mark the issue `qa-passed` after human verification of every case. | `test/pass.md` |
| `block` | `<issue> <notes>` | Mark `qa-blocked` and capture failure notes when one or more cases failed. | `test/block.md` |

**Argument reference:**

- `<issue>` — issue number of the story or bug under test.
- `<notes>` — free-text describing the failures (case numbers, observed vs. expected).

**Load the corresponding mode file and follow its steps.**

If the first word does not match any stage, ask via `AskUserQuestion`.

---

## Constraints

- One stage per invocation.
- Never invent test cases that don't trace to an AC.
- `pass`/`block` are human gates — confirm with the user before applying the label.

### Step Tracking
After completing each numbered step, emit exactly:

> STEP [N] COMPLETE
