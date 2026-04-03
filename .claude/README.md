# AI Development Workflow

An AI-powered development workflow using Claude Code slash commands. The issue tracker and all project-specific values are defined in `project.md` — making the workflow reusable across projects.

---

## How It Works

```
PO writes requirement issue
        ↓
  /ba <issue>   →  BA brainstorms with PO, creates user stories + sprint milestone
        ↓  ← HUMAN GATE: review stories
  /tl <ms>      →  TL reads architecture, writes TDD, annotates stories
        ↓  ← HUMAN GATE: review TDD and annotations
  /design <ms>  →  Designer analyzes design system, creates design instructions (for frontend stories)
        ↓  ← HUMAN GATE: review design instructions
  /dev [issue-number]  →  Dev implements one story, opens PR to sprint branch
        ↓  ← HUMAN GATE: review PR and merge
       Done
```

Each phase ends with a **human gate** — you review the output before running the next command.

---

## Commands

| Command | Agent | Input | Output |
|---------|-------|-------|--------|
| `/ba <issue-number>` | Maya (BA) | requirement issue # | user story issues + sprint milestone |
| `/tl <milestone-id>` | Alex (Technical Lead) | milestone # | TDD issue + annotated stories |
| `/design <milestone-id>` | Nhi (Designer) | milestone # | design instruction comments on frontend stories |
| `/dev [issue-number]` | Dev persona (auto-selected from ticket labels) | optional issue # | implementation + PR to sprint branch |

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

### 3. Run Technical Lead
```
/tl 3
```
Alex reads the architecture docs, designs the solution, writes a TDD issue, and annotates every story with implementation guidance.

**Human gate**: Review the TDD issue and story annotations on the issue tracker.

### 3.5. Run Designer (if frontend stories exist)
```
/design 3
```
Nhi analyzes the design system (components, tokens, layouts) and posts structured design instructions on each frontend/fullstack story. These instructions guide developers to use consistent components, design tokens, and patterns.

**Human gate**: Review the design instructions on each story. (If no frontend stories, skip to Step 4.)

### 4. Run Dev(s)
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
| `sprint-ready` | Awaiting TL |
| `tl-reviewed` | TL complete — awaiting design |
| `technical-design` | TDD issue |
| `design-reviewed` | Design instructions complete — awaiting dev |
| `in-progress` | Dev is implementing |
| `skill:frontend` | Frontend story |
| `skill:backend` | Backend story |
| `skill:fullstack` | Full-stack story |
| `skill:devops` | Infrastructure story |

> Label names are configurable in `project.md`.
