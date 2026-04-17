# Commit and Push

Once all subagents complete, commit inside each codebase path using the changed files each subagent reported:

```
cd <codebase-path>
git add <changed files reported by subagent>
git commit -m "feat(#<ISSUE_NUMBER>): <imperative-tense description>"
git push origin <story-branch>
```

## Rules

- Multi-skill: run independently in each codebase path after its respective subagent finishes
- Only stage files relevant to this story — do not stage unrelated changes
- If the change includes irreversible operations (reported by devops subagent), note them in the commit message body:

```
feat(#<ISSUE_NUMBER>): <description>

Irreversible: <what cannot be rolled back and why it is safe>
```
