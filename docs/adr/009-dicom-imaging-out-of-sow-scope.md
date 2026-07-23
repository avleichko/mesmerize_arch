# ADR-009: DICOM / imaging mirror / screen mirroring out of SOW scope

- **Status:** Accepted
- **Decision:** #20
- **Sources:** SOW #3 out-of-scope list, Mesmerize Responses Q&A (imaging scopes note), Jul 14 “needs further discussion” on imaging

## Context

Architecture materials describe a Patient Imaging Mirror (WebRTC) as a future-capable design. SOW #3 explicitly excludes DICOM push to the PWA and related mirroring for current delivery.

## Decision

**DICOM push / imaging mirror / screen mirroring is out of current SOW scope.** Keep only future-ready architectural awareness (do not implement imaging scopes, DICOM pipelines, or mirroring UX in SOW #3 delivery).

## Consequences

- MVP FHIR scopes stay minimal ([ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md)) — no ImagingStudy/DiagnosticReport read for delivery work.
- Agents must reject imaging-mirror implementation tasks unless SOW/ADR is explicitly superseded.
- Signaling-only stubs may exist only if an approved task says so; default is **do not build**.
