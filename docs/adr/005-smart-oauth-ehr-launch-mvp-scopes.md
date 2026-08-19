# ADR-005: 3-legged OAuth, EHR launch only, MVP FHIR scopes

- **Status:** Accepted
- **Decisions:** #2, #3, #4, #5
- **Sources:** Mesmerize Responses Q&A (UC1), Architecture SMART registration, SOW #3; amended 2026-08-19 by [ADR-019](019-exam-room-imaging-display-and-evidence.md)

## Context

The provider launches Mesmerize from an **active Athena patient chart/encounter**. The app therefore needs:

- Authenticated **provider** context
- **Patient / encounter** launch context from the EHR

**2-legged** OAuth (client credentials) cannot supply that launch context for the clinician SMART workflow.

## Decision

1. Clinician-facing surface is a **SMART on FHIR app launched from inside Athena** (pilot).
2. Use **3-legged OAuth / Authorization Code Grant** (SMART authorization code flow), **not** 2-legged, for clinician workflow.
3. MVP launch type is **EHR launch only**. Standalone launch is **not** required.
4. Authentication for the SMART app is **Athena / EHR SSO** — **no separate Mesmerize login** for the SMART app (Auth0 is for Command Center / admin only; see [ADR-010](010-technology-stack.md)).
5. MVP FHIR scopes:
   - `launch/encounter`
   - `patient/Patient.read` (Patient.read) — browser-only; still not sent to Platform ([ADR-002](002-zero-phi-on-mesmerize-servers.md))
   - `patient/Condition.read` (Condition.read)
   - `patient/Encounter.read` (Encounter.read)
   - `patient/DocumentReference.write` (DocumentReference.write)
   - **Proposed** additive reads for exam-room imaging display (tag **Proposed** in SAD until athena sandbox ratification; **Confirmed-as-intent** in this ADR / [ADR-019](019-exam-room-imaging-display-and-evidence.md)):
     - `patient/DiagnosticReport.read`
     - `patient/DocumentReference.read`
     - `patient/Media.read`
     - `patient/Observation.read` (labs/reports)
6. Do **not** add `ImagingStudy` / DICOMweb / WADO to v1 ([ADR-019](019-exam-room-imaging-display-and-evidence.md)).

## Reason (decision #3 — 3-legged / Authorization Code Grant)

Confirmed in answered Q&A:

- Flow is **EHR launch only** for MVP
- Uses **Athena / EHR SSO**
- Does **not** require a separate Mesmerize login for the SMART app
- Provider starts from an active chart/encounter, so the app must receive authenticated provider + patient/encounter context via the SMART authorization code (3-legged) launch

## Consequences

- SMART app must implement launch + callback endpoints and iframe-friendly hosting.
- No standalone SMART entry path in MVP backlog.
- Do not introduce Mesmerize username/password (or Auth0) for the clinician SMART iframe.
- Scope creep on FHIR permissions is rejected by default, except the **Proposed** additive **read** scopes in decision 5 (imaging display). No imaging **write** beyond `DocumentReference.write`. No `ImagingStudy` / DICOMweb / WADO in v1.
- FHIR access token remains browser-side ([ADR-002](002-zero-phi-on-mesmerize-servers.md)).
- Sequence diagrams: `output_diagrams/11-smart-3legged-oauth-athena.puml` (summary), `output_diagrams/12-smart-3legged-oauth-athena-detailed.puml` (high-fidelity).
