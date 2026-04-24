# Load Design Instructions

## Step 1 — Determine if Design or Story Number

Fetch the issue to check its labels. If it has the `design` label, it is a design issue — fetch it directly.

If it does not have the `design` label, it is a story issue — use its milestone to find the associated design instructions:

```
fetch_issue(<issue_number>)
```

Then:
```
list_issues(<story.milestone>, labels: "design")
```

If found, use that design issue number. If not found, output: "No Design Instructions found for this issue."

## Step 2 — Fetch Design

```
fetch_issue(<design_issue_number>)
```

## Step 3 — Display

Output the full issue body as-is. Include the issue title and number as a header.

```
## Design Instructions #<issue_number>: <title>

<body>
```
