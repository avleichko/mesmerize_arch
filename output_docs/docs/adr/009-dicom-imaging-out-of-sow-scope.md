# ADR-009: DICOM / imaging mirror / screen mirroring out of SOW scope

- **Status:** Superseded by [ADR-019](019-exam-room-imaging-display-and-evidence.md)
- **Decision:** #20 (historical; live register row is [ADR-019](019-exam-room-imaging-display-and-evidence.md))
- **Sources:** SOW #3 out-of-scope list, Mesmerize Responses Q&A (imaging scopes note), Jul 14 “needs further discussion” on imaging; superseded 2026-08-19 by ADR-019

## Context (historical)

Architecture materials describe a Patient Imaging Mirror (WebRTC) as a future-capable design. SOW #3 explicitly excludes DICOM push to the PWA and related mirroring for current delivery. The live delivery rule was: **DICOM push / imaging mirror / screen mirroring is out of current SOW scope.** Keep only future-ready architectural awareness (do not implement imaging scopes, DICOM pipelines, or mirroring UX in SOW #3 delivery). That SOW-exclusion no longer governs athena pilot **display** and **evidence**; see [ADR-019](019-exam-room-imaging-display-and-evidence.md).

## Decision

Do **not** implement a Mesmerize DICOM parser/viewer, WADO ingest, ImagingStudy pipeline, or server-side imaging payloads. Exam-room imaging **display** (Tier 1 web-native artifact push + Tier 2 window/tab-scoped WebRTC mirror) and imaging **evidence** rules live in [ADR-019](019-exam-room-imaging-display-and-evidence.md).

## Consequences

- This file is retained as the historical SOW-exclusion record; do **not** delete it.
- Agents follow ADR-019 for in-scope display + HITL evidence, and this Decision (plus rewritten DNB-9) for the remaining DICOM/viewer/payload bans.
- MVP FHIR scopes for imaging **reads** are amended in [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md); still no ImagingStudy / DICOMweb / WADO in v1.
