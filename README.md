# AI Development Workflow

An AI-powered development workflow using Claude Code slash commands. Issue tracker and all project-specific values defined in `project.md` — making the workflow reusable across projects.

---

## Contents

- [Roles](#roles)
- [How It Works](#how-it-works)
  - [Feature Development](#feature-development)
  - [Bug Fixing](#bug-fixing)
  - [Requirements Change](#requirements-change)
  - [Story Change](#story-change)
- [Commands](#commands)
- [Structure](#structure)
- [Label Reference](#label-reference)

---

## Roles

| Role | Who | Responsibilities |
|------|-----|-----------------|
| **Product Owner (PO)** | User | Owns the requirement — creates, updates, prioritises. Closes sprints and bugs. |
| **Business Analyst (BA)** | AI (BA persona) | Turns requirements into user stories with acceptance criteria. Manages scope changes. |
| **Designer** | AI (Designer persona) | Reads the design system, produces sprint-level UI instructions for frontend stories. |
| **Technical Lead (TL)** | AI (TL persona) | Reads architecture, designs system-level solution, writes TDD, annotates bug fixes. |
| **Developer** | AI (backend/frontend/devops) | Implements one story or bug per invocation. TDD: tests first, then code. |
| **Release Manager** | AI (PO persona) | Closes sprints — verifies all PRs merged, closes issues, cleans branches, opens release PRs, flags migrations. |

---

## How It Works

### Feature Development

```mermaid
flowchart TD
    A(["/po create-requirement <description>"]) --> B["Requirement Issue<br/>`requirement`"]
    B --> G1{Gate 1<br/>PO Review}
    G1 -->|Approve| C(["/ba create-stories <issue>"])
    C --> D["User Stories + Sprint Milestone<br/>`sprint-ready`"]
    D --> G2{Gate 2<br/>PO Reviews Stories}
    G2 -->|Approve| E1(["/design create-design <ms>"])
    E1 --> F1["Design Instructions<br/>`design-reviewed`"]
    F1 --> E2(["/tl create-feature-solution <ms>"])
    E2 --> F2["TDD + Annotated Stories<br/>`tl-reviewed`"]
    F2 --> G3{Gate 3<br/>PO Reviews TDD + Design}
    G3 -->|Approve| H(["/dev <issue>"])
    H --> I["PR → sprint branch<br/>`implemented`"]
    I --> G4{Gate 4<br/>PR Review}
    G4 -->|More stories| H
    G4 -->|All merged| J(["/po close-sprint <N>"])
    J --> K["Release PRs → main"]
    K --> G5{Gate 5<br/>Merge Release PRs}
    G5 -->|Done| L([Sprint Shipped])
```

### Bug Fixing

Separate pipeline — runs independently of sprint cycle. Bug PRs always target `main`.

```mermaid
flowchart TD
    A(["/po create-bug [description]"]) --> B["Bug Issue<br/>`bug`"]
    B --> G1{Gate 1<br/>PO Reviews Bug}
    G1 -->|Approve| C(["/ba create-bug <issue>"])
    C --> D["Acceptance Criteria<br/>on bug issue"]
    D --> G2{Gate 2<br/>PO Reviews ACs}
    G2 -->|Approve| E(["/tl create-bug-solution <issue>"])
    E --> F["Technical Annotation<br/>`tl-reviewed`"]
    F --> G3{Gate 3<br/>PO Reviews Annotation}
    G3 -->|Approve| H(["/dev <issue>"])
    H --> I["Fix PR → main<br/>`implemented`"]
    I --> G4{Gate 4<br/>PR Review}
    G4 -->|Merged| J([Bug Fixed])
```

### Requirements Change

Triggered when the PO changes scope mid-sprint. Affects stories, design, and TDD.

```mermaid
flowchart TD
    A(["/po update-requirement <N> <delta>"]) --> B["Requirement updated<br/>`requirement-updated`"]
    B --> C(["/ba update-stories <N>"])
    C --> D["Change Plan<br/>Covered / Updatable / New / Removed"]
    D --> G1{Gate 1<br/>PO Approves Change Plan}
    G1 -->|Approve| E1["Update existing stories"]
    G1 -->|Approve| E2["Create new stories"]
    G1 -->|Approve| E3["Label removed stories<br/>`story-removed`"]
    E1 & E2 & E3 --> F1(["/design create-design <sprint>"])
    F1 --> F2["Design Instructions updated<br/>incremental"]
    F2 --> F3(["/tl create-feature-solution <sprint>"])
    F3 --> F4["TDD updated<br/>incremental"]
```

### Story Change

Triggered when a specific story's acceptance criteria need adjusting — not the overall requirement.

```mermaid
flowchart TD
    A(["/ba change-story <N>"]) --> B["AC Change Plan<br/>Added / Removed / Modified"]
    B --> G1{Gate 1<br/>PO Approves AC Changes}
    G1 -->|Approve| C["Story ACs updated<br/>`story-updated`"]
    C --> D{UI changes?}
    D -->|Yes| E(["/design create-design <sprint>"])
    D -->|No| F{Tech design changes?}
    E --> E2["Design Instructions updated<br/>incremental"]
    E2 --> F
    F -->|Yes| G(["/tl create-feature-solution <sprint>"])
    F -->|No| H(["/dev <N>"])
    G --> G2["TDD updated<br/>incremental"]
    G2 --> H
    H --> I["Refactor PR → sprint branch"]
```

**When to involve Designer and TL:**

| Change type | Designer | TL |
|-------------|----------|----|
| New UI surface or interaction | Yes | Maybe |
| Changed layout, component, or visual state | Yes | Maybe |
| New API endpoint or data model | No | Yes |
| Changed business logic or backend behaviour | No | Yes |
| UI + backend change together | Yes | Yes |
| Copy/label wording only | No | No |

Human judges which roles are needed after reviewing approved AC changes.

---

## Commands

| Command | Role | Input | Output | Example |
|---------|------|-------|--------|---------|
| `/po create-requirement <description>` | Product Owner | raw requirement text | requirement issue with `requirement` label | `/po create-requirement Build a user authentication system with OAuth` |
| `/po update-requirement <issue> <delta>` | Product Owner | issue # + change description | updated requirement issue with `requirement-updated` label | `/po update-requirement 42 Drop OAuth, use magic link instead` |
| `/po create-bug [description]` | Product Owner | bug description (optional) | bug issue with `bug` label (interactively fills missing fields) | `/po create-bug` |
| `/po close-sprint <sprint-number>` | Release Manager | sprint # | sprint issues closed, story branches deleted, release PRs to main, migrations flagged | `/po close-sprint 3` |
| `/po close-bug <issue-number>` | Release Manager | bug # | bug issue closed (`bug-fixed`), fix branch deleted, summary posted | `/po close-bug 42` |
| `/ba create-stories <issue-number>` | BA | requirement issue # | user story issues + sprint milestone (`sprint-ready`) | `/ba create-stories 42` |
| `/ba create-bug <issue-number>` | BA | bug issue # | ACs appended to bug ticket | `/ba create-bug 42` |
| `/ba update-stories <issue-number>` | BA | requirement issue # | updated user stories (add/update/remove) after requirement change | `/ba update-stories 42` |
| `/ba change-story <issue-number>` | BA | story or bug issue # | updated ACs on existing story or bug + `story-updated` label | `/ba change-story 45` |
| `/design create-design <milestone-id>` | Designer | milestone # | sprint-level design instructions issue (`design-reviewed`) — or updates existing if requirement changed | `/design create-design 3` |
| `/tl create-feature-solution <milestone-id>` | Technical Lead | milestone # | TDD issue + feature branches + annotated stories (`tl-reviewed` + `skill:*`) | `/tl create-feature-solution 3` |
| `/tl create-bug-solution <bug-issue>` | Technical Lead | bug issue # | technical annotation comment on bug ticket (`tl-reviewed` + `skill:*`) | `/tl create-bug-solution 42` |
| `/dev [issue-number]` | Developer (auto) | optional issue # | PR to sprint branch (stories) or main (bugs) — auto-routes to implement/refactor/revert based on labels | `/dev` or `/dev 45` |

**Skills:** `frontend` · `backend` · `fullstack` · `devops`

`/dev` auto-selects agent from `skill:` labels. Multi-skill tickets run agents in parallel. TDD: tests first, then code. One ticket per invocation.

---

## Structure

```
.claude/
  project.md            ← primary config: repo, tech stack, labels, branch patterns, tracker adapter
  commands/             ← slash commands (orchestration + methodology)
    po.md
    po/
      create-requirement.md   ← PO creates new requirement
      update-requirement.md   ← PO changes requirement mid-sprint
      create-bug.md          ← PO creates bug report
      close-sprint.md         ← Release Manager closes sprint
      close-bug.md           ← Release Manager closes bug
    ba.md
    ba/
      create-stories.md       ← BA decomposes requirement into stories
      create-bug.md          ← BA writes ACs for bug
      update-stories.md       ← BA re-classifies stories after requirement change
      change-story.md         ← BA changes a single story's ACs
    design.md
    design/
      create-design.md        ← Designer produces UI instructions for sprint
    tl.md
    tl/
      create-feature-solution.md  ← TL writes TDD for sprint
      create-bug-solution.md       ← TL annotates bug fix
      _methodology.md              ← TL's 4-stage design process
    dev.md
    dev/
      implement-story.md      ← Dev implements a story (standard)
      refactor-story.md       ← Dev refactors after AC change
      revert-story.md        ← Dev reverts when story removed from scope
  agents/               ← developer role agents (invoked by /dev)
    backend.md
    frontend.md
    devops.md
  trackers/             ← tracker adapters (swap to change issue tracker)
    github-tracker.md
  skills/               ← git utilities used by commands
    git-strategy/
    git-operations/
  scripts/              ← setup scripts
    create-github-labels.sh
```

**`project.md`** is the primary config: repo, codebases, tech stack, labels, branch patterns, architecture doc paths, test/lint commands, and active tracker adapter path.

**Commands** are self-contained: each file includes the role methodology and calls tracker operations by name.

**Agents** are developer personas invoked by `/dev`. Each follows TDD: understand requirements → write tests → implement code to pass tests.

**Trackers** define how abstract workflow operations (`fetch_issue`, `create_pr`, etc.) map to a specific issue tracker. Swap `trackers/github-tracker.md` for `trackers/jira.md` and update `project.md` — zero changes to command files.

---

## Label Reference

| Label | Meaning |
|-------|---------|
| `requirement` | PO-created requirement |
| `requirement-updated` | Requirement changed mid-sprint |
| `user-story` | BA-created story |
| `bug` | Reporter-created bug issue |
| `bug-fixed` | Bug closed after successful fix |
| `sprint-ready` | Awaiting design/TL |
| `sprint-completed` | Sprint closed |
| `tl-reviewed` | TL complete — awaiting dev |
| `technical-design` | TDD issue |
| `design-reviewed` | Sprint-level design instructions created — awaiting dev |
| `story-added` | New story added mid-sprint |
| `story-updated` | Story ACs changed after initial implementation |
| `story-removed` | Story dropped from scope |
| `in-progress` | Dev is implementing |
| `implemented` | Dev complete — awaiting review |

> Label names are configurable in `project.md`.