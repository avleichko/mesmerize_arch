# ADR-019: Exam-room imaging display and imaging evidence (supersedes ADR-009)

- **Status:** Accepted
- **Date:** 2026-08-19
- **Decision:** #20
- **Supersedes:** [ADR-009](009-dicom-imaging-out-of-sow-scope.md) (SOW #3 imaging-out-of-scope live rule)
- **Amends:** [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md) (additive Tier 1 **read** scopes; still no `ImagingStudy`); [ADR-011](011-do-not-build.md) **DNB-9**
- **Sources:** Architecture working session / imaging-in-scope design 2026-08-19; [ADR-002](002-zero-phi-on-mesmerize-servers.md), [ADR-003](003-documentreference-engagement-writeback.md), [ADR-007](007-extend-pwa-server-mediated-devices.md), [ADR-008](008-engagement-telemetry-billing-hitl-writeback.md); `customer-kb/INFRASTRUCTURE.md` (device transport **open** — not a `D-xx`)

## Context

ADR-009 treated DICOM push, Patient Imaging Mirror, and screen mirroring as out of SOW #3 delivery. Exam-room imaging **display** plus de-identified imaging **evidence** are now in scope for the athenahealth pilot. The PHI, FDA, and token-boundary constraints do not change: Mesmerize servers still must not hold patient identifiers or imaging bytes, and the SMART app still must not talk to devices directly.

Customer `INFRASTRUCTURE.md` lists **device transport** as explicitly re-opened (no product name settled). WebRTC signaling in this ADR is **this pack’s decision**, not a Mesmerize-signed `D-xx`. Do not claim Socket.io or WebRTC as customer-register settled infra.

## Decision

1. **Tier 1 — web-native artifact push.** The SMART app (EHR FHIR token in the browser) reads web-native US Core artifacts: DiagnosticReport `presentedForm`, DocumentReference files, Media, and Observation/lab reports as PDF/HTML/JPEG/PNG/structured. Platform receives opaque session + device group + artifact **kind / opaque id** — not Patient ID, not payload. The Device Command API instructs the exam-room PWA to display. The device does not use a **server-held** EHR token.

2. **Tier 2 — window/tab-scoped WebRTC mirror.** The provider shares **only** the EHR/PACS viewer window or tab. WebRTC **media is P2P** (clinician browser ↔ device). Platform does **signaling only**. Full-desktop share is forbidden.

3. **Evidence.** Record a de-identified Platform event conceptually named `imaging_session` (implementation name TBD; concept Confirmed). It is not Patient-linked. Fields: timestamps, device id, session id, tier (`1` | `2`), artifact type or `mirror` flag. Physician HITL approve, then browser `DocumentReference.write` (existing write scope; [ADR-003](003-documentreference-engagement-writeback.md), [ADR-008](008-engagement-telemetry-billing-hitl-writeback.md)).

4. **Forbidden.** Mesmerize DICOM parser/viewer; ImagingStudy / WADO pipeline; storing imaging bytes in RDS or S3; logging PHI; SMART talking to devices on a data channel (commands and WebRTC signaling go through Platform only).

**v1 FHIR reads (list also in ADR-005):** keep existing scopes including `patient/Patient.read` (browser-only; still not sent to Platform) and `patient/DocumentReference.write`. Additive reads are **Confirmed-as-intent** here; tag **Proposed** in SAD until athena sandbox ratification: `patient/DiagnosticReport.read`, `patient/DocumentReference.read`, `patient/Media.read`, `patient/Observation.read` (labs/reports). Do **not** add `ImagingStudy`, DICOMweb, or WADO to v1.

## Consequences

- Register **#20** is imaging in-scope (Tier 1 + Tier 2) with no Mesmerize DICOM viewer. ADR-009 is retained as the historical SOW-exclusion record.
- DNB-9 forbids a Mesmerize DICOM viewer and server-side DICOM or imaging payloads; it no longer forbids exam-room **display**.
- Agents must reject ImagingStudy/WADO ingest, Mesmerize DICOM viewers (including Cornerstone/OHIF as a Mesmerize component), and any design that places pixels or DICOM on Platform storage or logs.
- Signaling for Tier 2 is in scope for this architecture pack; it remains **open** on the customer infra register until a `D-xx` exists.
- Four-EHR write-back adapters beyond athena DocumentReference remain roadmap — not this ADR.
