# 09. Data Architecture

| Field | Value |
|-------|-------|
| Chapter ID | `09-data-architecture` |
| SAD mapping | Template §9 Data Architecture |
| Last updated | 2026-07-23 |
| Maturity | Review-ready · 75% |

## Purpose of this chapter

Describe where Content Evidence data originates, the **logical** (not physical table) model on Mesmerize servers, how de-identified facts flow end-to-end, and who owns each class of data — without inventing Prisma schemas or column catalogs.

## Narrative

### PHI boundary (what is not stored)

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> <strong>No patient identifiers on Mesmerize servers.</strong> Backend may receive <strong>ICD-10 codes + device group ID + opaque session ID</strong> (plus de-identified engagement / billing artifacts) — not Patient ID, MRN, name, encounter ID, or demographics (ADR-002; SECURITY.md).
</p>

![PHI boundary](../../output_diagrams/02-phi-boundary.png)

*Figure 9-1: PHI boundary — patient-identifying FHIR context stays in the SMART browser; Mesmerize Platform holds only de-identified session / engagement / billing facts (`output_diagrams/02-phi-boundary`).*

**Not stored on Mesmerize servers:** Patient ID / MRN / name / DOB / address / SSN / contact, insurance, meds / allergies, patient-linked problem-list history, FHIR resource dumps, EHR access tokens, audio, transcripts, clinical notes, imaging payloads.

**Allowed server-side examples:** session UUID, device ID, clinic / device group, content ID, ICD-10 codes (without patient linkage), timestamps, durations, interaction events, billing suggestions keyed to session.

## Data Sources

| Source | What it supplies | Where it lives | Evidence |
|--------|------------------|----------------|----------|
| **athenahealth FHIR** (pilot) | Patient display, Condition (ICD-10), Encounter; DocumentReference writeback | SMART **browser** only (EHR token) | Confirmed · ADR-002 |
| **Clinician SMART app** | Opaque session create/update; ICD-10 set + deviceGroup for Platform API | Browser → Platform (Mesmerize session token) | Confirmed |
| **Device PWA** | De-identified engagement events; command ack / presence | Device → engagement / device-realtime | Confirmed |
| **CMS / content vendors** | Catalog metadata, media refs (Sanity, BioDigital, MJH) | content-service → Postgres / S3 refs | Confirmed |
| **Esper MDM** | Device identity / provisioning tokens | device-realtime mirror | Confirmed |
| **Auth0** | Admin / Command Center identity | org-identity JWT validation | Confirmed |
| **Site rules / billing engine** | CPT/HCPCS/HCC **suggestions** from engagement + ICD-10 context | billing-evidence (HITL before writeback) | Confirmed · ADR-006 |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Content recommendation keys on <strong>ICD-10 → content metadata</strong> (plus filters such as specialty / format / device). <strong>CPT/HCPCS are not recommendation match keys</strong>; they appear on billing-evidence <strong>output</strong> only (ADR-006).
</p>

## Data Model

Logical domain entities only — **no invented table schemas**.

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Core chain (ARCHITECTURE.md): <strong>Session</strong> (Mesmerize UUID, clinicId, deviceGroupId, ICD-10 conditions[], times, status) → <strong>ContentEngagement[]</strong> → <strong>BillingSuggestion[]</strong>. Schema excludes patient / clinical-note / transcript tables (ADR-002).
</p>

| Logical entity | Key attributes (logical) | Notes |
|----------------|--------------------------|-------|
| **Organization (tenant)** | `organizationId` = `tenantId`; `tenancyMode` | Isolation root (ADR-013) |
| **Clinic / device group** | `clinicId`, `deviceGroupId` | Sub-scope inside tenant |
| **Session** | Opaque UUID, ICD-10 set, clinic/device group, status, times | No patient/encounter IDs |
| **Content / catalog item** | Content ID, ICD-10 metadata mapping, format / specialty filters | Recommend input |
| **ContentEngagement** | Session-keyed events, content ID, timestamps, durations, interactions | De-identified |
| **BillingSuggestion** | Session-keyed CPT/HCPCS/HCC suggestions + evidence | HITL approve; no claims/EDI |
| **Device** | Device / Esper identity, pairing, presence | No patient identity on device |
| **Audit / diagnostic** | Operational events; no PHI | Separate from engagement; ≤90-day diagnostic retention |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Persistence targets: <strong>PostgreSQL 16</strong> (Bridge <code>tenantId</code> default; Silo = dedicated DB per org), <strong>Redis 7</strong> (presence / Socket.io), <strong>S3</strong> at <code>{tenantId}/{clinicId}/…</code>, <strong>SQS</strong> for internal events (must carry <code>tenantId</code>) (ADR-013; ADR-010).
</p>

<p style="background:#fff8e1;border-left:4px solid #f9a825;padding:8px 12px;margin:12px 0;">
  <strong>Inferred:</strong> Physical Prisma models and indexes follow these logical entities; exact table/column catalogs are implementation artifacts — not specified in ADRs.
</p>

## Data Flow

1. **Launch / read (browser):** SMART launch → EHR FHIR Condition (ICD-10) etc. with EHR token — identifiers never leave the browser.
2. **Session open:** SMART → Platform session API with ICD-10 + deviceGroup + opaque session ID (Mesmerize session token).
3. **Recommend:** content-service matches ICD-10 → content metadata; returns catalog candidates (no CPT as match key).
4. **Push / play:** Device Command API → Socket.io → device; engagement events return de-identified to engagement-service.
5. **Billing evidence:** engagement + ICD-10 context → billing-evidence suggestions (CPT/HCPCS/HCC); physician review/approve.
6. **Writeback (browser):** DocumentReference via EHR token; Platform never calls EHR FHIR APIs.
7. **Tenancy:** Every persisted row / S3 object / SQS message scoped by `tenantId` (and `clinicId` when relevant).

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Edge interactive path is REST (+ Socket.io for devices); internal async facts use SQS; no PHI in queue payloads (ARCHITECTURE.md; ADR-014).
</p>

## Data Ownership

| Data class | System of record / owner | Mesmerize role |
|------------|--------------------------|----------------|
| Patient chart, FHIR resources, SMART audit | **EHR** (athenahealth pilot) | None on servers; browser session only |
| Opaque session, ICD-10 set, status | **session-service** | Platform SoR for de-identified visit context |
| Content catalog / ICD-10 mapping | **content-service** (+ CMS vendors as upstream) | Catalog + recommend |
| Device registry / pairing / commands | **device-realtime-service** (+ Esper identity) | Command mediation |
| Engagement telemetry | **engagement-service** | De-identified timelines |
| CPT/HCPCS/HCC suggestions + evidence | **billing-evidence-service** | Suggest only; human approve |
| Org / users / `tenancyMode` | **org-identity-service** (+ Auth0 for admin identity) | Tenant config |
| Diagnostic / audit ingest | **audit-telemetry-service** | No-PHI operational logs |
| Media / ads objects | **S3** under tenant/clinic prefixes | Object storage |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Multitenancy (Silo vs Bridge) is <strong>orthogonal</strong> to PHI rules: tenant-scoped data still must not contain patient identifiers (ADR-013; SECURITY.md). Detail in Chapter 11.
</p>

## Evidence

- [ADR-002](../../../docs/adr/002-zero-phi-on-mesmerize-servers.md) — zero PHI / browser-held FHIR token
- [ADR-006](../../../docs/adr/006-icd10-content-match-cpt-billing-output.md) — ICD-10 match; CPT on billing output
- [ADR-013](../../../docs/adr/013-multitenancy-silo-and-bridge.md) — Bridge default; Silo; S3 prefixes
- [`docs/ai/SECURITY.md`](../../../docs/ai/SECURITY.md) — classification, allowed / not-allowed server fields
- [`docs/ai/ARCHITECTURE.md`](../../../docs/ai/ARCHITECTURE.md) — Session → Engagement → BillingSuggestion chain
- [`output_diagrams/02-phi-boundary.mmd`](../../../output_diagrams/02-phi-boundary.mmd) / PNG — PHI boundary

## White spots

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> Final ratified physical data-classification matrix and whether an AWS BAA is required given the de-identified engagement schema (SECURITY.md open items).
</p>

<p style="background:#fff8e1;border-left:4px solid #f9a825;padding:8px 12px;margin:12px 0;">
  <strong>Inferred:</strong> Prisma / migration layout maps 1:1 to the logical entities above once services land; not evidenced as a published ERD in this repo.
</p>

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> Optional future CPT as a secondary re-ranking signal for content needs a new ADR before any schema or matcher change (ADR-006 consequence).
</p>

## Open questions

Consolidated for Mesmerize decision-making in [Chapter 18 — Assumptions and Open Questions](18-assumptions-and-open-questions.md).

- **Q-03** — AWS BAA necessity given de-identified engagement schema
- **Q-04** — Ratify data-classification matrix
- Retention beyond defaults: **A-09**, **Q-12**
