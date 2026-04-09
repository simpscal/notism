# AI Development Workflow

An AI-powered development workflow using Claude Code slash commands. The issue tracker and all project-specific values are defined in `project.md` — making the workflow reusable across projects.

---

## How It Works

```
PO writes requirement issue
        ↓
  /ba <issue>   →  BA brainstorms with PO, creates user stories + sprint milestone
        ↓  ← HUMAN GATE: review stories
  /design <ms>  →  Designer analyzes design system, creates design instructions (for frontend stories)
        ↓  ← HUMAN GATE: review design instructions
  /tl <ms>      →  TL reads architecture + design instructions, writes TDD, annotates stories
        ↓  ← HUMAN GATE: review TDD and annotations
  /dev [issue-number]  →  Dev implements one story, opens PR to sprint branch
        ↓  ← HUMAN GATE: review PR and merge
       Done
```

Each phase ends with a **human gate** — you review the output before running the next command.

---

## Commands

| Command | Agent | Input | Output |
|---------|-------|-------|--------|
| `/bug-report <description>` | Bug Reporter | bug description | bug issue with `bug` label |
| `/ba <issue-number>` | Maya (BA) | requirement issue # or bug issue # | user story issues + sprint milestone (for requirements) — or ACs added to bug ticket |
| `/design <milestone-id>` | Nhi (Designer) | milestone # | design instruction comments on frontend stories |
| `/tl <milestone-id or bug-issue-number>` | Alex (Technical Lead) | milestone # or bug issue # | TDD issue + annotated stories (for sprints) — or technical annotation on bug ticket |
| `/dev [issue-number]` | Dev persona (auto-selected from ticket labels) | optional issue # | implementation + PR to sprint branch (stories) or main (bugs) |

Skills: `frontend` · `backend` · `fullstack` · `devops`

---

## Structure

```
.claude/
  project.md        ← project config: repo, tech stack, labels, branch patterns, tracker adapter
  commands/         ← self-contained slash commands (orchestration + methodology)
    ba.md
    tl.md
    design.md
    dev.md
  trackers/         ← tracker adapters (swap to change issue tracker)
    github.md
  README.md
```

**`project.md`** is the primary config: repo, codebases, tech stack, labels, branch patterns, architecture doc paths, test/lint commands, and the active tracker adapter path.

**Commands** are self-contained: each file includes both the role methodology and calls to tracker operations by name. No separate skill files.

**Trackers** define how abstract workflow operations (`fetch_issue`, `create_pr`, etc.) map to a specific issue tracker. Swap `trackers/github.md` for `trackers/jira.md` and update `project.md` — zero changes to command files.

---

## Setup for a New Project

1. Copy the `.claude/` directory to your project
2. Edit `.claude/project.md` with your project's values:
   - Issue tracker type, repo, and tracker adapter path
   - Codebase paths and tech stack
   - Architecture doc locations
   - Label names
   - Git branch patterns and test/lint commands
3. To use a different issue tracker (e.g., Jira): create `.claude/trackers/jira.md` using the same operation interface as `github.md`, then update the tracker adapter path in `project.md`
4. Start with `/ba <issue-number>`

---

## Full Workflow

### 1. Create a requirement
Open an issue on your project repo, add the `requirement` label, describe what you want built. Note the issue number.

### 2. Run BA
```
/ba 42
```
Maya brainstorms with you to eliminate ambiguity, then creates 3–8 user stories in a new sprint milestone.

**Human gate**: Review the stories. Edit or close any that don't fit. Get the milestone ID from the URL (`.../milestone/3`).

### 3. Run Designer (if frontend stories exist)
```
/design 3
```
Nhi analyzes the design system (components, tokens, layouts) and posts structured design instructions on each frontend/fullstack story. These instructions guide developers to use consistent components, design tokens, and patterns.

**Human gate**: Review the design instructions on each story. (If no frontend stories, skip to Step 4.)

### 4. Run Technical Lead
```
/tl 3
```
Alex reads the architecture docs and any design instructions posted in Step 3, designs the solution, writes a TDD issue, and annotates every story with implementation guidance.

**Human gate**: Review the TDD issue and story annotations on the issue tracker.

### 5. Run Dev(s)
Auto-pick an unassigned ticket:
```
/dev
```

Or target a specific issue:
```
/dev 45
```

The persona (frontend/backend/fullstack/devops) is determined automatically from the ticket's `skill:` labels. A ticket with multiple skill labels activates multiple personas. Run multiple in parallel for independent stories.

**Human gate**: Review the PR diff. When approved, merge into the sprint feature branch.

---

## Label Reference

| Label | Meaning |
|-------|---------|
| `requirement` | PO-created requirement |
| `user-story` | BA-created story |
| `bug` | Reporter-created bug issue |
| `sprint-ready` | Awaiting design |
| `tl-reviewed` | TL complete — awaiting dev |
| `technical-design` | TDD issue |
| `design-reviewed` | Design instructions complete — awaiting dev |
| `in-progress` | Dev is implementing |
| `skill:frontend` | Frontend story or bug |
| `skill:backend` | Backend story or bug |
| `skill:fullstack` | Full-stack story |
| `skill:devops` | Infrastructure story |

> Label names are configurable in `project.md`.

---

## Bug Workflow

A separate pipeline for fixing production bugs — runs independently of the sprint cycle. Bug PRs always target `main`.

```
/bug-report <description>
        ↓ ← HUMAN GATE: review bug summary
  /ba <N>   →  BA reads architecture, adds ACs to the bug ticket
        ↓ ← HUMAN GATE: review acceptance criteria
  /tl <N>   →  TL reads architecture + ACs, annotates bug ticket with skill/scope/decisions
        ↓ ← HUMAN GATE: review technical annotation
  /dev <N>  →  Dev implements fix on fix/issue-N branch, opens PR to main
        ↓ ← HUMAN GATE: review PR and merge
       Done
```

`/ba`, `/tl`, and `/dev` detect the `bug` label automatically and switch to Bug Mode — no separate commands needed.
