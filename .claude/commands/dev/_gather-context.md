# Gather Story Context

Fetch all context needed for dispatch in a single batch:

1. **Issue body + comments** — the ticket already fetched in Step 1 (hold it)

2. **TDD** — `list_issues(milestone_id, labels: [technical-design label from project config])` to find it, then `fetch_issue(tdd_number)` to read full content. Extract:
   - Problem statement
   - Proposed solution
   - Architecture key decisions
   - Components design
   - API specification
   - Data models
   - Risks
   - Implementation priority

3. **Design Instructions** (frontend only) — `list_issues(milestone_id, labels: [design-reviewed])` to find the design instructions issue. `fetch_issue` it in full — the document covers the entire sprint's UI design.
