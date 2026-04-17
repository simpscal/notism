# Validation Checklist

## Story Set Validation

Before finalizing, verify:

- **No hidden dependencies**: Ordering dependencies explicit in Notes
- **No overlapping scope**: No two stories cover the same behaviour
- **Complete coverage**: Set fully satisfies the sprint goal
- **No gold-plating**: Every story traces back to the sprint goal

## AC Testability Checklist

Every AC must pass:

- Is it observable without reading code?
- Does it describe a specific condition and a specific outcome?
- Could a non-engineer verify it in a running system?

Rewrite any AC that fails until it passes.

## Amended Story Validation

After changes, verify:

- **No contradictions**: No existing AC conflicts with added/modified ACs
- **Complete coverage**: Combined AC set fully covers amended scope
- **Consistent with sprint goal**: Change does not introduce out-of-sprint scope
- **Testable**: Every AC passes the testability checklist
