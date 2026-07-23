# ADR-004: athenahealth pilot first; EHR-agnostic core

- **Status:** Accepted (contractual in SOW #3)
- **Decisions:** #1, #2
- **Date:** 2026-06 (SOW #3); reinforced in Mesmerize Q&A
- **Sources:** SOW #3 Phase 1, Mesmerize Responses (EHR Constraints)

## Context

Mesmerize needs a near-term pilot while avoiding lock-in that forces core rewrites for Epic or Oracle Health (Cerner).

## Decision

1. **athenahealth is the first target EHR** for the pilot. Epic and Oracle/Cerner are **future roadmap** integrations (not MVP builds).
2. The main clinician-facing app is a **SMART on FHIR app launched from inside Athena** (see [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md)).
3. Design **EHR-agnostic** data models, Platform APIs, and auth abstractions so Epic/Cerner are **modular additions**.
4. Phase 1 delivers an **EHR-Agnostic Core Architecture Blueprint** and an **Epic & Oracle Cerner Integration Roadmap** (analysis, not full build).

## Consequences

- Do not hardcode athena-only assumptions into core domain models.
- Isolate vendor-specific FHIR quirks at the SMART app mapping edge.
- Marketplace/registration work starts with athena; other EHRs follow the roadmap.
