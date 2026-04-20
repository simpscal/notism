# Load TDD

## Step 1 — Determine if TDD or Story Number

Fetch the issue to check its labels. If it has the `technical-design` label, it is a TDD issue — fetch it directly.

If it does not have the `technical-design` label, it is a story issue — use its milestone to find the associated TDD:

```
fetch_issue(<issue_number>)
```

Then:
```
list_issues(<story.milestone>, labels: "technical-design")
```

If found, use that TDD issue number. If not found, output: "No TDD found for this issue."

## Step 2 — Fetch TDD

```
fetch_issue(<tdd_issue_number>)
```

## Step 3 — Display

Output the full issue body as-is. Include the issue title and number as a header.

```
## TDD #<issue_number>: <title>

<body>
```
