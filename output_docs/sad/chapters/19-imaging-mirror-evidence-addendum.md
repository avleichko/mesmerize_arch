# 19. Imaging-Mirror Evidence Addendum

| Field | Value |
|-------|-------|
| Chapter ID | `19-imaging-mirror-evidence-addendum` |
| SAD mapping | Mesmerize extension (appendix) |
| Last updated | 2026-08-19 |
| Maturity | Review-ready |

## Purpose of this chapter

State how **exam-room imaging evidence** is captured and (when approved) written back for the athenahealth pilot — as a Mesmerize extension to this SAD, not as a competing product outline. Display and transport (Tier 1 artifact push, Tier 2 scoped WebRTC) live in [Chapter 20](20-exam-room-imaging-mirror.md). This chapter owns **taxonomy**, **capture vs write-back**, and **traceability**.

Audience: Mesmerize architecture / compliance reviewers and Newfire delivery. Do **not** treat Confluence or the customer prebuild addendum as the SAD spine.

## Narrative

### Provenance (non-canonical)

Earlier imaging-evidence writing lives outside this pack:

- Confluence **MESENG** page *Addendum: Imaging-Mirror Evidence (Content Evidence Platform)* (`MESENG` space)
- Local pointer in the customer decision repo: [`customer-kb/docs/prebuild-proposal/08-IMAGING-MIRROR-EVIDENCE-ADDENDUM.md`](../../../customer-kb/docs/prebuild-proposal/08-IMAGING-MIRROR-EVIDENCE-ADDENDUM.md)

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Those two files are <strong>non-canonical</strong> for this SAD. They are provenance / ticket breadcrumbs only. Binding rules are <a href="../../../docs/adr/019-exam-room-imaging-display-and-evidence.md">ADR-019</a> (decision #20) plus the zero-PHI and HITL writeback ADRs. <code>docs/prebuild-proposal/</code> is not settled customer architecture ([ADR-018](../../../docs/adr/018-customer-decision-repo-second-kb.md)).
</p>

### Taxonomy — two de-identified event classes

Both classes are **session-keyed** and **not Patient-linked**. Neither may carry Patient ID, MRN, name, encounter ID, demographics, pixels, or DICOM on Mesmerize servers ([ADR-002](../../../docs/adr/002-zero-phi-on-mesmerize-servers.md)).

| Class | What it records (logical) | Typical trigger | Write-back (athena v1) |
|-------|---------------------------|-----------------|------------------------|
| **Content engagement** | Content ID, ICD-10 set, device ID, timestamps, duration, interactions + session/clinic linkage | Educational content on the exam-room PWA | HITL → browser `DocumentReference.write` ([ADR-008](../../../docs/adr/008-engagement-telemetry-billing-hitl-writeback.md), [ADR-003](../../../docs/adr/003-documentreference-engagement-writeback.md)) |
| **`imaging_session`** | Timestamps, device id, opaque session id, tier (`1` \| `2`), artifact type **or** `mirror` flag. Implementation event **name** TBD; **concept** Confirmed | Tier 1 web-native display or Tier 2 window/tab mirror | Same HITL → browser `DocumentReference.write` (existing write scope) |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Platform receives opaque session + device group + artifact <strong>kind / opaque id</strong> — not Patient ID, not imaging payload ([ADR-019](../../../docs/adr/019-exam-room-imaging-display-and-evidence.md)).
</p>

### Capture vs write-back

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> <strong>Capture is universal</strong> whenever imaging is shown in the exam room (Tier 1 or Tier 2). The <strong>Platform de-identified store is the system of record</strong>. A missing or failed EHR write-back <strong>never drops</strong> captured evidence. Physician <strong>human-in-the-loop</strong> approve, then browser FHIR <strong>DocumentReference</strong> to athena, is the v1 deposit path (ADR-019; ADR-003; ADR-008).
</p>

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> Write-back <strong>adapters for four EHRs</strong> (athenahealth, Epic, Oracle Health/Cerner, eClinicalWorks) and richer chart types are <strong>roadmap</strong>, not v1. Pilot write-back is athena <code>DocumentReference</code> only.
</p>

### FHIR scopes (read vs write)

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> The <strong>concept</strong> of HITL browser <code>DocumentReference.write</code> for imaging evidence is Confirmed (existing write scope; ADR-003, ADR-008, ADR-019). The EHR FHIR token never leaves the browser; Platform never calls EHR APIs.
</p>

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> Exact additive FHIR <strong>read</strong> scope <em>strings</em> until athena sandbox ratification (<strong>Q-16</strong>): <code>patient/DiagnosticReport.read</code>, <code>patient/DocumentReference.read</code>, <code>patient/Media.read</code>, <code>patient/Observation.read</code> (labs/reports). Intent is Confirmed in ADR-019 / ADR-005; SAD tags the strings Proposed. Do <strong>not</strong> add <code>ImagingStudy</code>, DICOMweb, or WADO in v1.
</p>

### Ticket traceability (MESV2-213–217)

Jira IDs below are **traceability** to the MESENG / prebuild addendum. They are **not** a v1 backlog copied into this pack.

| Ticket | Provenance topic | v1 this pack |
|--------|------------------|--------------|
| **MESV2-213** | Per-EHR FHIR write scopes (`DocumentReference` + `Observation` / `Provenance`) | athena HITL **DocumentReference** only. v1 **does not** implement Observation or Provenance write |
| **MESV2-214** | SMART launch-context fidelity (`Encounter` vs `Patient`) | Traceability. EHR launch remains ADR-005; encounter ID is **not** stored on Platform |
| **MESV2-215** | Device ↔ encounter pairing for exam-room capture | Traceability. Pairing on Platform is opaque session + device group — not encounter ID |
| **MESV2-216** | Legal / compliance review of documentation-support framing | Traceability. Non-diagnostic exam-room display (no Mesmerize DICOM viewer) |
| **MESV2-217** | eCW write-back (FHIR vs HL7 / deep-link) | **Does not** implement eCW HL7 (or any eCW adapter) in v1 |

### Forbidden on Platform (evidence path)

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> <strong>No pixels, DICOM, or imaging bytes</strong> on Mesmerize servers (RDS, S3, or logs). <strong>No Mesmerize DICOM viewer</strong> (including Cornerstone/OHIF as a Mesmerize component). No <code>ImagingStudy</code> / WADO ingest. SMART does not talk to devices on a data channel (ADR-019; ADR-011 DNB-9).
</p>

Device **display** mechanics (commands, signaling) are [Chapter 20](20-exam-room-imaging-mirror.md). This pack’s transport choice is ADR-019 — **not** a customer `INFRASTRUCTURE.md` `D-xx` (device transport remains open on that register).

## Diagram

![Imaging evidence — capture vs HITL writeback](../../output_diagrams/23-imaging-evidence-capture-writeback.png)

*Figure 19-1: Clinician SMART → FHIR reads in the browser / Platform de-identified `imaging_session` → HITL approve → DocumentReference to athena. No pixels on Platform. Evidence tags [C]/[I]/[P] (ADR-019).*

## Evidence

- [ADR-019](../../../docs/adr/019-exam-room-imaging-display-and-evidence.md) — imaging in-scope; `imaging_session` concept; HITL DocumentReference; no pixels / no DICOM viewer
- [ADR-002](../../../docs/adr/002-zero-phi-on-mesmerize-servers.md) — no patient identifiers on Mesmerize servers
- [ADR-003](../../../docs/adr/003-documentreference-engagement-writeback.md) / [ADR-008](../../../docs/adr/008-engagement-telemetry-billing-hitl-writeback.md) — browser DocumentReference; HITL; disable-able writeback
- [ADR-005](../../../docs/adr/005-smart-oauth-ehr-launch-mvp-scopes.md) — additive **read** scopes listed as Proposed-until-ratified
- [ADR-011](../../../docs/adr/011-do-not-build.md) **DNB-9** — no Mesmerize DICOM viewer / no server-side imaging payloads
- Spec: [`docs/superpowers/specs/2026-08-19-imaging-in-scope-sad-chapters-design.md`](../../../docs/superpowers/specs/2026-08-19-imaging-in-scope-sad-chapters-design.md) — Ch.19 pointer rules
- Figure source: `output_diagrams/23-imaging-evidence-capture-writeback` (export mirror under `output_docs/output_diagrams/`)
- Non-canonical provenance only: Confluence MESENG imaging-mirror evidence addendum; `customer-kb/docs/prebuild-proposal/08-IMAGING-MIRROR-EVIDENCE-ADDENDUM.md` (MESV2-213–217 names)

## White spots

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> Exact additive FHIR <strong>read</strong> scope strings (listed above) until <strong>Q-16</strong> sandbox ratification. Four-EHR write-back adapters (including Observation/Provenance and eCW HL7) remain roadmap.
</p>

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> Implementation persistence name for the imaging evidence event (code may differ from conceptual <code>imaging_session</code>). athena sandbox acceptance of the Proposed read-scope list — owned as <strong>Q-16</strong>.
</p>

## Open questions

Consolidated for Mesmerize decision-making in [Chapter 18 — Assumptions and Open Questions](18-assumptions-and-open-questions.md).

- **Q-16** — Ratify additive FHIR **read** scope strings with athena (`patient/DiagnosticReport.read`, `patient/DocumentReference.read`, `patient/Media.read`, `patient/Observation.read`). Until answered, treat those strings as Proposed in this SAD. (The Q-16 register row is added in Chapter 18; this chapter cites the ID for ratification.)
