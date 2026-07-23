# 14. NFR & Quality Attributes

| Field | Value |
|-------|-------|
| Chapter ID | `14-nfr-and-quality-attributes` |
| SAD mapping | Mesmerize extension |
| Last updated | 2026-07-23 |
| Maturity | Review-ready · 75% |

## Purpose of this chapter

Summarize Architecturally Significant Requirements (ASRs) that bind the Content Evidence Platform architecture. Full definitions live in the NFR catalog — this chapter does not invent numeric availability, latency, or recovery targets.

**Full catalog:** [`../../nfr/NFR_CATALOG.md`](../../nfr/NFR_CATALOG.md) · **ASR checklist:** [`../../nfr/ASR_CHECKLIST.md`](../../nfr/ASR_CHECKLIST.md) · **Agent mirror:** [`../../../docs/ai/NFR.md`](../../../docs/ai/NFR.md)

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> ASR-marked NFRs shape structure, boundaries, and technology choices. Agents and design reviews treat them as binding (NFR.md / ASR_CHECKLIST.md). Do not invent numeric SLOs absent from kb.
</p>

## Narrative

### Security & privacy (ASR)

| ASR | Statement |
|-----|-----------|
| NFR-SEC-01 | Zero patient identifiers on Mesmerize servers |
| NFR-SEC-02 | EHR FHIR access token stays in browser |
| NFR-SEC-03 | No ambient audio / transcripts / clinical notes |
| NFR-SEC-04 | HIPAA-aligned AWS / BAA posture |
| NFR-SEC-05 | OWASP hardening + pen-test (SOW Phase 3) |
| NFR-SEC-07 | No cross-tenant access (Organization = tenant) |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Backend may store ICD-10 + device/clinic/session + engagement only; Platform API uses a separate Mesmerize session token (ADR-002, ADR-005, ADR-011, ADR-013).
</p>

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> Whether an AWS BAA is required if Mesmerize stores only de-identified data — Confirmed as open under NFR-SEC-04; compliance owner decides.
</p>

### Reliability & durability (ASR)

| ASR | Statement |
|-----|-----------|
| NFR-REL-01 | Exponential backoff retries for failed transactions |
| NFR-REL-02 | Durable engagement / proof-of-play delivery |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Retry with exponential backoff (configurable); store proof and retry until acknowledged within product retry policy (qualitative — no numeric retry budget in kb).
</p>

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> Formal availability / latency SLOs for device↔cloud (NFR-REL-04). No numeric target in kb — do not invent uptime percentages or latency budgets.
</p>

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> Recovery time / recovery point objectives are not defined in NFR sources. Do not invent numeric recovery targets.
</p>

### Scalability (ASR)

| ASR | Statement |
|-----|-----------|
| NFR-SCAL-01 | Fleet / screen-volume scale readiness |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Architecture must remain viable at fleet scale — <strong>~4,400</strong> devices today; <strong>1,000+</strong> screens proof for Jul 2027 planning. Prefer async SQS for non-interactive work (NFR-SCAL-01; Q&amp;A / STRATEGY).
</p>

### Usability & accessibility (ASR)

| ASR | Statement |
|-----|-----------|
| NFR-UX-01 | WCAG 2.1 AA for clinical UI (SOW Phase 2) |
| NFR-UX-02 | White-label branding without breaking iframe / CSP security |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Clinical SMART UI meets WCAG 2.1 AA; white-labeling is a hard requirement that must not weaken iframe embedding or CSP (Jul 14; ENGINEERING_RULES).
</p>

### Observability & operations (ASR)

| ASR | Statement |
|-----|-----------|
| NFR-OPS-01 | Separate engagement telemetry from diagnostic logs |
| NFR-OPS-02 | Diagnostic log retention ≤ 90 days |
| NFR-OPS-05 / 06 | Dev / Staging / Prod; GitHub Actions + Terraform on Mesmerize AWS (platform) |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Engagement vs diagnostic log paths are separate. Diagnostic retention is <strong>≤ 90 days</strong> then tiering/expiry (NFR-OPS-02; SECURITY.md). Device/PWA delivery follows <strong>Ladder B</strong> (Netlify web-only; manual TTV filesync; Esper); platform AWS follows <strong>Ladder A</strong> (GHA → ECR → ECS + Terraform) — do not conflate ([ADR-016](../../../docs/adr/016-git-branching-and-delivery-ladders.md)).
</p>

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> Platform repos adopt the same org branch/PR conventions as touchscreen-ux; NFR-OPS-05/06 environment narrative remains AWS topology (ADR-015) plus dual-ladder ops posture (ADR-016).
</p>

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> Engagement / business log retention (multi-year figures discussed but not confirmed) — open with Brandon / MM per NFR catalog. Observability vendor (Datadog vs approved alternative) still open.
</p>

### Interoperability (ASR)

| ASR | Statement |
|-----|-----------|
| NFR-INT-01 | SMART 3-legged EHR launch (Athena pilot) |
| NFR-INT-02 | Server-mediated device commands (REST + Socket.io) |
| NFR-INT-04 | SQS patterns per ADR-014 (RR/correlation, fire-and-forget, enricher+DLQ; edge REST) |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Authorization Code Grant EHR launch; SMART app never talks to devices directly; internal SQS as ADR-014; interactive edge remains REST (ADR-005, ADR-007, ADR-014).
</p>

### Data integrity & isolation (ASR)

| ASR | Statement |
|-----|-----------|
| NFR-DATA-01 | UUID-based engagement integrity (start / duration / completion) |
| NFR-DATA-02 | Tenant-isolated S3 paths |
| NFR-DATA-03 | Separate audit telemetry |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> UUID content/engagement tracking; S3 layout <code>{tenantId}/{clinicId}/…</code> (Bridge) or org-isolated root (Silo); audit telemetry distinct from EHR writeback (ADR-008, ADR-013).
</p>

### Related non-ASR quality attributes (summary)

Non-ASR NFRs still constrain delivery but do not by themselves force structural choices. Highlights from the catalog:

| ID | Quality attribute | Note |
|----|-------------------|------|
| NFR-PERF-01 | Performance / UX | SMART usable in EHR iframe (~400–800px sidebar); no pop-up-dependent primary flows |
| NFR-PERF-02 | Performance | Imaging/mirroring latency — **out of SOW** (ADR-009) |
| NFR-SCAL-02 | Scalability | Dual Bridge/Silo tenancy without rewriting domain APIs |
| NFR-BUS-01 / 02 | Business | Suggest-only billing; physician HITL before writeback |
| NFR-OPS-05 / 06 | Operability | Dev / Staging / Prod; Ladder A (GHA + Terraform / ECS) vs Ladder B (PWA/TTV) per ADR-016 |

## Traceability

| Artifact | Role |
|----------|------|
| [`docs/ai/NFR.md`](../../../docs/ai/NFR.md) | Canonical agent NFR + ASR list |
| [`output_docs/nfr/NFR_CATALOG.md`](../../nfr/NFR_CATALOG.md) | Export catalog (full table) |
| [`output_docs/nfr/ASR_CHECKLIST.md`](../../nfr/ASR_CHECKLIST.md) | Design-review checklist |
| ADR-002, 005, 007, 008, 011, 013, 014, 016 | Decisions backing ASR statements (016 = dual delivery ladders / OPS) |
| SOW #3 Phase 2 / 3 | WCAG 2.1 AA; OWASP + pen-test |

## Open items / decisions needed

Consolidated for Mesmerize decision-making in [Chapter 18 — Assumptions and Open Questions](18-assumptions-and-open-questions.md).

| Topic | Ch.18 IDs |
|-------|-----------|
| Availability / latency SLO (or none for pilot) | **Q-08** |
| RTO / RPO | **Q-06** |
| Engagement / business log retention | **A-09**, **Q-12** |
| AWS BAA necessity | **Q-03** |
| Observability vendor + HIPAA pack | **A-10**, **Q-09**, **Q-14** |
| Region class (pilot) | **A-01**, **Q-07** |

## Sources

- `docs/ai/NFR.md`
- `output_docs/nfr/NFR_CATALOG.md`
- `output_docs/nfr/ASR_CHECKLIST.md`
- `output_docs/sad/_snippets/callouts.md`
- Linked ADRs cited in catalog Traceability column
