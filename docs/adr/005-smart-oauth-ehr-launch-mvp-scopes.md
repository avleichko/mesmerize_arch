# ADR-005: 3-legged OAuth, EHR launch only, MVP FHIR scopes

- **Status:** Accepted
- **Decisions:** #2, #3, #4, #5
- **Sources:** Mesmerize Responses Q&A (UC1), Architecture SMART registration, SOW #3

## Context

The clinician app must run inside the EHR with authenticated provider identity and patient/encounter context. Client-credentials (2-legged) OAuth cannot supply that launch context for the MVP clinician workflow.

## Decision

1. Clinician-facing surface is a **SMART on FHIR app launched from inside Athena** (pilot).
2. Use **3-legged OAuth / Authorization Code Grant** (SMART authorization code flow), not 2-legged, for clinician workflow.
3. MVP launch type is **EHR launch only**. Standalone launch is **not** required.
4. MVP FHIR scopes are minimal:
   - `launch/encounter`
   - `patient/Patient.read` (Patient.read)
   - `patient/Condition.read` (Condition.read)
   - `patient/Encounter.read` (Encounter.read)
   - `patient/DocumentReference.write` (DocumentReference.write)
5. Do **not** add imaging or other clinical scopes to MVP unless a superseding ADR says so (see [ADR-009](009-dicom-imaging-out-of-sow-scope.md)).

## Consequences

- SMART app must implement launch + callback endpoints and iframe-friendly hosting.
- No standalone SMART entry path in MVP backlog.
- Scope creep on FHIR permissions is rejected by default.
