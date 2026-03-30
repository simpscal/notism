# Notism AI Development Workflow

An AI-powered development workflow using Claude Code slash commands and GitHub Issues as the task board.

---

## How It Works

```
PO writes requirement issue
        ↓
  /ba <issue>      →  BA creates user stories + sprint milestone
        ↓  ← HUMAN GATE: review stories
  /architect <ms>  →  Architect designs solution, annotates stories
        ↓  ← HUMAN GATE: review architecture
  /dev <skill>     →  Dev implements story, opens PR
        ↓  ← HUMAN GATE: review PR
  /qa <pr>         →  QA tests, reviews, approves/rejects
        ↓  ← HUMAN GATE: merge PR
       Done
```

Each phase ends with a **human gate** — you review the output before running the next command.

---

## Commands

| Command | Agent | Input | Output |
|---------|-------|-------|--------|
| `/ba <issue-number>` | Maya (BA) | requirement issue # | user story issues + sprint milestone |
| `/architect <milestone-id>` | Alex (Architect) | milestone # | design doc + annotated issues |
| `/dev <skill> [issue-number]` | Linh/Minh/Sam/Hao (Dev) | skill + optional issue # | implementation + PR |
| `/qa <pr-number>` | Quinn (QA) | PR # | review + approval/rejection |

Skills: `frontend` · `backend` · `fullstack` · `devops`

---

## Structure

```
.claude/
  commands/   ← slash commands (workflow orchestration + persona)
    ba.md
    architect.md
    dev.md
    qa.md
  skills/     ← generic role methodology (invoked by commands)
    ba.md
    architect.md
    dev.md
    qa.md
```

**Commands** handle: GitHub operations, labels, sprint management, human gates.
**Skills** handle: the core intellectual work (analysis, design, implementation, review).

---

## Full Workflow

### 1. Create a requirement
Open a GitHub issue on `simpscal/notism`, add label `requirement`, describe what you want built. Note the issue number.

### 2. Run BA
```
/ba 42
```
Maya analyzes the requirement and creates 3–8 user stories in a new sprint milestone.

**Human gate**: Review the stories. Edit or close any that don't fit. Get the milestone ID from the GitHub URL (`.../milestone/3`).

### 3. Run Architect
```
/architect 3
```
Alex reads all stories, explores the codebase, writes the design doc, and annotates every story with implementation guidance.

**Human gate**: Review `notism-api/docs/architecture/sprint-3-design.md` and the issue annotations.

### 4. Run Dev(s)
Auto-pick an unassigned ticket:
```
/dev frontend
/dev backend
```

Or target a specific issue:
```
/dev frontend 45
/dev backend 46
```

Run multiple in parallel for independent stories. Each dev opens a PR when done.

**Human gate**: Review the PR diff.

### 5. Run QA
```
/qa 15
```
Quinn reads the PR, audits the code, runs the test suite, and submits a formal GitHub review.

**If rejected**: fix issues and re-run `/qa 15`.

**Human gate**: Once QA approves, you merge the PR.

---

## Label Reference

| Label | Meaning |
|-------|---------|
| `requirement` | PO-created requirement |
| `user-story` | BA-created story |
| `sprint-ready` | Awaiting architect |
| `architect-reviewed` | Awaiting dev |
| `in-progress` | Dev is implementing |
| `pr-ready` | Awaiting QA |
| `qa-approved` | Ready to merge |
| `qa-rejected` | Needs rework |
| `skill:frontend` | React/TypeScript |
| `skill:backend` | .NET/C# |
| `skill:fullstack` | Both |
| `skill:devops` | Docker/Terraform/infra |
