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
  /dev <skill>  →  Dev implements one story, opens PR to sprint branch
        ↓  ← HUMAN GATE: review PR
  /qa <pr>      →  QA tests, reviews, approves or rejects
        ↓  ← HUMAN GATE: merge PR
       Done
```

Each phase ends with a **human gate** — you review the output before running the next command.

---

## Commands

| Command | Agent | Input | Output |
|---------|-------|-------|--------|
| `/ba <issue-number>` | Maya (BA) | requirement issue # | user story issues + sprint milestone |
| `/tl <milestone-id>` | Alex (Technical Lead) | milestone # | TDD issue + annotated stories |
| `/dev [issue-number]` | Dev persona (auto-selected from ticket labels) | optional issue # | implementation + PR to sprint branch |
| `/qa <pr-number>` | Quinn (QA) | PR # | formal review + approval/rejection |

Skills: `frontend` · `backend` · `fullstack` · `devops`

---

## Structure

```
.claude/
  project.md        ← project config: repo, tech stack, labels, branch patterns
  commands/         ← slash commands (workflow orchestration + persona)
    ba.md
    tl.md
    dev.md
    qa.md
  skills/           ← role methodology (tech-stack-agnostic, invoked by commands)
    ba.md
    technical-lead.md
    dev.md
    qa.md
  README.md
```

**`project.md`** is the only file that changes between projects. It defines the repo, codebases, tech stack, labels, branch patterns, architecture doc paths, and test/lint commands.

**Commands** handle: issue tracker operations, labels, sprint management, PR creation, human gates.

**Skills** handle: the core intellectual work — analysis, design, implementation, review. No project-specific references.

---

## Setup for a New Project

1. Copy the `.claude/` directory to your project
2. Edit `.claude/project.md` with your project's values:
   - Issue tracker type and repo
   - Codebase paths and tech stack
   - Architecture doc locations
   - Label names
   - Git branch patterns and test/lint commands
3. Start with `/ba <issue-number>`

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

**Human gate**: Review the PR diff.

### 5. Run QA
```
/qa 15
```
Quinn reads the PR, audits the code, runs the test suite, and submits a formal review.

**If rejected**: fix the issues and re-run `/qa 15`.

**Human gate**: Once QA approves, merge the PR into the sprint feature branch.

---

## Label Reference

| Label | Meaning |
|-------|---------|
| `requirement` | PO-created requirement |
| `user-story` | BA-created story |
| `sprint-ready` | Awaiting TL |
| `tl-reviewed` | TL complete — awaiting dev |
| `technical-design` | TDD issue |
| `in-progress` | Dev is implementing |
| `qa-approved` | Ready to merge |
| `qa-rejected` | Needs rework |
| `skill:frontend` | Frontend story |
| `skill:backend` | Backend story |
| `skill:fullstack` | Full-stack story |
| `skill:devops` | Infrastructure story |

> Label names are configurable in `project.md`.
