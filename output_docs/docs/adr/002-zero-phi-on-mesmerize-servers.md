# ADR-002: Zero PHI on Mesmerize servers / browser-held FHIR token

- **Status:** Accepted
- **Decisions:** #6, #7, #8
- **Date:** 2026-03-11 (reinforced in Mesmerize Q&A 2026-07-06)
- **Sources:** Architecture v2.0, Strategy Overview PHI analysis, Mesmerize Responses to Newfire Questions

## Context

Earlier plans stored or processed substantial PHI (patient records, transcripts, notes). That increased BAA count, liability, and engineering scope.

## Decision

1. EHR FHIR access token and patient-identifying resources remain in the **SMART app browser** only.
2. Mesmerize backend receives **ICD-10 codes + device group ID + opaque session ID** (plus de-identified engagement/billing artifacts) — **not** patient identifiers.
3. Imaging (if ever enabled) must not place image payloads on Mesmerize servers (architecture: WebRTC P2P); SOW #3 still excludes DICOM push.

## Consequences

- Platform API never calls EHR FHIR APIs.
- Schema excludes patient/clinical-note/transcript tables.
- Compliance narrative simplifies; AWS BAA may be unnecessary if de-identification holds — **confirm with compliance owner**.
- Agents must reject designs that “just send Patient.id to the API for convenience.”
