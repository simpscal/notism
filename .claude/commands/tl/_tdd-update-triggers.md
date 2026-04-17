# TDD Section Update Triggers

Evaluate every section of the TDD template against the revised design. Sections not affected must be preserved exactly. Sections that change must be fully rewritten — do not summarise or abbreviate.

| TDD Section | Update trigger |
|-------------|----------------|
| Executive Summary — Problem Statement / Goals / Non-Goals | Scope added or removed |
| High-Level Diagram | Any service, database, cache, or integration added or removed |
| Integration Flows (happy + unhappy paths) | Request or response flow changed |
| Technology Stack | New library or infrastructure introduced |
| Components Design | Any component added, removed, or restructured |
| Data Models | Any entity added, removed, or field changed |
| API Specification | Any endpoint added, removed, or its contract changed |
| Event Schemas | Any event added, removed, or its structure changed |
| Alternatives Considered | Any decision revisited |
| Security | Auth or encryption requirements changed |
| Scalability & Performance | Load characteristics changed |
| Failure Modes | Any new external dependency or failure scenario |
| Migration Plan | Data model or cutover strategy changed |
| Architecture Key Decisions | Naming, layering, or cross-cutting patterns changed |
| Implementation Priority | Any story added, removed, or implementation order reconsidered |
