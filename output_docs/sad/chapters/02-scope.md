# 02. Scope

| Field | Value |
|-------|-------|
| Chapter ID | `02-scope` |
| SAD mapping | Template §2 Scope |
| Last updated | 2026-08-19 |
| Maturity | Review-ready · 75% |

## Purpose of this chapter

Define the **document and delivery scope** for this SAD pack: what is in vs out under SOW #3, which environments the architecture covers, and how Production is gated to the athenahealth pilot. Solution-feature detail lives in [06-solution-scope.md](06-solution-scope.md).

## Document scope

This pack covers the **architecture** of the Mesmerize Content Evidence Platform for the Newfire SOW #3 athenahealth pilot path: SMART launch, ICD-10 recommendation, device push, engagement, billing evidence (HITL), optional DocumentReference writeback, exam-room imaging **display** (Tier 1 + Tier 2) and de-identified imaging evidence, Bridge multitenancy default, and Mesmerize-owned AWS topology.

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> In-scope delivery themes — SMART on FHIR app; ICD-10-based content recommendation; PWA/device integration; engagement capture; billing evidence + physician approve; site-configurable rules; writeback capability; exam-room imaging <strong>display</strong> (Tier 1 + Tier 2) + HITL imaging evidence; <strong>one athenahealth pilot org</strong> (SOW #3; <a href="../../../docs/adr/019-exam-room-imaging-display-and-evidence.md">ADR-019</a>).
</p>

### In scope (this SAD)

| Area | Included |
|------|----------|
| Product architecture | Content Evidence Platform (not ambient scribe) |
| Pilot EHR | athenahealth first; EHR-agnostic core for later Epic/Cerner |
| Security / PHI boundary | Zero patient IDs on Mesmerize servers; browser-held FHIR token |
| Exam-room imaging display | **Tier 1** web-native artifact push + **Tier 2** window/tab-scoped WebRTC mirror ([ADR-019](../../../docs/adr/019-exam-room-imaging-display-and-evidence.md)) |
| Environments | Dev / Staging / Prod topology (same shape; different notes) |
| NFR / ASRs | Binding ASRs summarized; full catalog linked |
| Explicit non-goals | ADR-011 do-not-build (DNB-9: no Mesmerize DICOM viewer / no server-side imaging payloads); ADR-019 forbidden list |

### Out of scope (this SAD / SOW #3)

| Area | Excluded | Source |
|------|----------|--------|
| Ambient AI path | Audio, Deepgram, Claude SOAP, transcript/note storage | ADR-001; ADR-011 |
| Redox / server EHR APIs | Redox; server-side EHR token handling | ADR-011 DNB-1, DNB-8 |
| Patient CRUD on Mesmerize | Longitudinal patient record | ADR-011 DNB-6 |
| Claims / EDI | Clearinghouse submission | ADR-011 DNB-7 |
| Mesmerize DICOM viewer / WADO / server imaging payloads | Mesmerize DICOM parser/viewer; ImagingStudy / WADO ingest; storing imaging bytes in RDS or S3 | [ADR-019](../../../docs/adr/019-exam-room-imaging-display-and-evidence.md); [ADR-011](../../../docs/adr/011-do-not-build.md) DNB-9 |
| Four-EHR write-back adapters | Epic / Cerner / eCW write-back beyond athena DocumentReference | ADR-019 (roadmap) |
| ML recommender | If metadata insufficient | SOW #3 / PROJECT_CONTEXT |
| Multi–health-system production | Rollout beyond single athena pilot org | SOW #3 |
| Word `.docx` assembly | Official template fill — later export pass | `output_docs/sad/README.md` |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Exam-room imaging <strong>display</strong> (Tier 1 web-native artifact push + Tier 2 window/tab-scoped WebRTC mirror) and de-identified imaging <strong>evidence</strong> are <strong>in scope</strong> for the athenahealth pilot (<a href="../../../docs/adr/019-exam-room-imaging-display-and-evidence.md">ADR-019</a>, decision #20). Still out of scope: a Mesmerize <strong>DICOM viewer</strong>, WADO ingest, <code>ImagingStudy</code> pipeline, and <strong>server-side</strong> DICOM or imaging payloads (<a href="../../../docs/adr/011-do-not-build.md">ADR-011</a> DNB-9). <a href="../../../docs/adr/009-dicom-imaging-out-of-sow-scope.md">ADR-009</a> is <strong>Superseded</strong> (historical SOW-exclusion only).
</p>

## Environments

| Environment | Role | Notes |
|-------------|------|-------|
| **Dev** | Engineering iteration | Same AWS topology shape as Staging/Prod (ADR-015) |
| **Staging** | Integration / sandbox | **PHI-free**; athenahealth **sandbox** |
| **Prod** | Pilot production | **Pilot-gated** — single pilot practice (Phase 4 per Q&A) |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Environments are <strong>Dev / Staging / Prod</strong> on Mesmerize-owned AWS. Staging is PHI-free vs Athena sandbox; <strong>Prod is pilot-gated</strong> (NFR-OPS-05; ENGINEERING_RULES; ADR-015; ARCHITECTURE.md).
</p>

<p style="background:#fff8e1;border-left:4px solid #f9a825;padding:8px 12px;margin:12px 0;">
  <strong>Inferred:</strong> “Pilot-gated Prod” means production topology may exist, but live clinic traffic and PHI-adjacent EHR integration are limited to the approved single athenahealth pilot org until Phase 4 acceptance — not a multi-tenant commercial rollout.
</p>

### Git / service repos (Ladder A)

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Ladder A implementation lives in <strong>per-service GitHub repositories</strong> (customer <code>INFRASTRUCTURE.md</code> <strong>D-07</strong>; <a href="../../../docs/adr/017-python-platform-backend.md">ADR-017</a> S8). The customer repo named <code>mesmerize-monorepo</code> is docs + infra register only — not the platform code home. Logical names such as <code>smart-app</code> / <code>platform-api</code> are modules, not “clone one Turborepo.” Exact org + slugs: <strong>Q-17</strong>. Provision checklist: <a href="21-infra-provision-checklist.md">Chapter 21</a>.
</p>

### Release ladder note

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Device/PWA (Ladder B) release ladder is <code>feature → staging → main</code>: merge to <code>staging</code> = QA/canary devices; promote <code>staging → main</code> = production fleet (ADR-016; touchscreen-ux DevOps extract). Netlify is web-only preview — not the device path.
</p>

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> Platform repos adopt the same branch/PR conventions; identical Staging/Prod promotion semantics for Ladder A remain open.
</p>

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> Whether Content Evidence platform AWS environments use the same <code>staging</code>/<code>main</code> promotion model as Ladder B — do not assume until ops runbook or superseding ADR (ADR-016).
</p>

Deployment detail: [13-deployment-and-infrastructure.md](13-deployment-and-infrastructure.md) · [ADR-015](../../../docs/adr/015-aws-deployment-reference.md) · [ADR-016](../../../docs/adr/016-git-branching-and-delivery-ladders.md) · [`docs/architecture/deployment/aws-production-deployment.md`](../../../docs/architecture/deployment/aws-production-deployment.md).

## Open questions

Consolidated for Mesmerize decision-making in [Chapter 18 — Assumptions and Open Questions](18-assumptions-and-open-questions.md).

- **A-04** — platform `feature → staging → main` (identical Staging/Prod semantics still open until accepted)
- **Q-17** — exact GitHub org + service repo slugs (Chapter 21)

## Evidence

- [ADR-019](../../../docs/adr/019-exam-room-imaging-display-and-evidence.md) — imaging display + evidence in-scope (Tier 1 + Tier 2)
- [ADR-009](../../../docs/adr/009-dicom-imaging-out-of-sow-scope.md) — superseded historical SOW-exclusion
- [ADR-011](../../../docs/adr/011-do-not-build.md) — do-not-build list (DNB-9: no Mesmerize DICOM viewer / no server-side imaging payloads)
- [ADR-015](../../../docs/adr/015-aws-deployment-reference.md) — Dev/Staging/Prod; Prod pilot-gated
- [ADR-016](../../../docs/adr/016-git-branching-and-delivery-ladders.md) — dual ladders; PWA Confirmed / platform Proposed
- [ADR-017](../../../docs/adr/017-python-platform-backend.md) — Python / FastAPI; S8 per-service repos (D-07)
- [Chapter 21](21-infra-provision-checklist.md) — infra provision checklist (Dev / Staging / Prod)
- [`docs/ai/PROJECT_CONTEXT.md`](../../../docs/ai/PROJECT_CONTEXT.md) — in/out goals
- [`docs/ai/ENGINEERING_RULES.md`](../../../docs/ai/ENGINEERING_RULES.md) — environment notes
- [`docs/ai/NFR.md`](../../../docs/ai/NFR.md) — NFR-OPS-05
