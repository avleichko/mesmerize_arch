# SECURITY

> **Sources:** Architecture (Security Architecture, PHI tables), Strategy Overview (PHI Boundary), Implementation Context, Mesmerize Responses Q&A, Jul 14 meeting notes.  
> **Not legal advice.** Confirm BAAs and policies with Mesmerize compliance owner (**open in kb**).

## NFR alignment

Non-functional and **ASR** requirements: [`NFR.md`](NFR.md) / [`output_docs/nfr/`](../../output_docs/nfr/). Security-related ASRs: NFR-SEC-01…08, NFR-OPS-01…02, NFR-DATA-02/03. Do not weaken PHI boundary, tenant isolation, or log-retention rules without updating the NFR catalog + ADR.

## Multitenancy and data isolation

See [ADR-013](../adr/013-multitenancy-silo-and-bridge.md).

| Mode | Isolation |
|------|-----------|
| Silo | Physical DB per Organization; S3 org bucket or `{tenantId}/` root |
| Bridge (pilot default) | Shared DB; `tenantId` on rows; S3 `{tenantId}/{clinicId}/…` prefixes |

Cross-tenant access is forbidden. Tenant isolation is **orthogonal** to PHI rules: even correctly tenant-scoped data must not contain patient identifiers.

## Core PHI boundary

| Location | May hold patient-identifying / clinical context? | Notes |
|----------|--------------------------------------------------|-------|
| SMART app browser | Yes, **session-only** | FHIR token + Patient/Encounter/Conditions; cleared when session/token ends |
| Mesmerize Platform API / DB | **No patient identifiers** | ICD-10 + session UUID + device/clinic + engagement + billing suggestions |
| Socket.io signaling | No patient content | Opaque signaling metadata (including any future WebRTC signaling) |
| Exam-room device | Ephemeral display only | No patient identity on device; UUID engagement tracking |
| EHR | System of record | Owns clinical chart and SMART access audit trail |

**Safe Harbor framing in kb:** ICD-10 codes **without** patient linkage are treated as non-PHI for Mesmerize server storage. Do not reintroduce linkage keys.

See `output_diagrams/02-phi-boundary.mmd`.

## Authentication and authorization

| Surface | Mechanism |
|---------|-----------|
| SMART app | EHR authenticates provider via **3-legged OAuth / Authorization Code Grant** (SMART EHR launch from Athena chart/encounter); Mesmerize session token for Platform API. **No separate Mesmerize login** for SMART app ([ADR-005](../adr/005-smart-oauth-ehr-launch-mvp-scopes.md)). |
| Command Center | Auth0 login; RBAC (Q&A: RBAC called out as Phase 3 deliverable — do not assume full RBAC exists today) |
| Devices | Device token from Esper provisioning |
| Bridge App | Secure link + one-time code; 30-minute inactivity timeout |

## Data classification (server-side allowed examples)

Allowed on servers (per Q&A): session ID, device ID, clinic/M-number, content ID, ICD-10, timestamps, durations, interaction events, billing suggestions keyed to session.

Not allowed on servers: Patient ID/MRN/name/DOB/address/SSN/contact, insurance, meds/allergies, problem-list history as patient-linked records, FHIR resource dumps, audio, transcripts, clinical notes, imaging payloads.

## Logging and telemetry

- Separate **engagement** telemetry from **diagnostic** logs (meeting alignment).
- Diagnostic logging: Kinesis + S3 table buckets; **exclude PII/PHI**; retention **capped at 90 days** (meeting alignment).
- Video ad telemetry baseline: **VAST** standard (meeting alignment).
- Pharma reporting: aggregated / de-identified only.
- SOW: separate **audit telemetry log** (not only what is written to EHR).
- Failed uploads: heartbeats + email notifications; admin UI for manual correction **deferred** (meeting alignment).

## BAAs (architecture table)

| Vendor | Required? | Reason |
|--------|-----------|--------|
| Auth0 | Yes | Provider authentication |
| SMS/email provider | Yes | Bridge App access codes |
| AWS | Possibly not | If engagement logs stay de-identified |
| Sanity / BioDigital / Esper | Not required | No PHI |
| Deepgram / Anthropic | Eliminated | No audio/notes path |

Total BAAs cited: **2–3** under Content Evidence plan.

## Application security expectations (from SOW / Q&A)

- HIPAA-aligned AWS posture; formal policy handover from Mesmerize still to be confirmed.
- OWASP hardening + pen test called out in SOW Phase 3.
- HTTPS public SMART hosting; CORS for EHR domains; allow iframe embedding (launch/callback endpoints).
- Retry with exponential backoff for failed transactions.
- White-label CSS must not weaken iframe/CSP assumptions without review.

## Device PWA client config vs platform secrets

touchscreen-ux committed `.env` / `VITE_*` is **device PWA client-bundle** policy (build-time public config for the exam-room app) — not Content Evidence platform secrets. Platform secret handling remains **Proposed** via AWS Secrets Manager (or equivalent); do not invent PHI in secrets or promote PWA `.env` posture to NestJS/ECS. See touchscreen-ux [`DEPLOYMENT.md`](../../kb/customer-reference/touchscreen-ux/DEPLOYMENT.md) extract context in [`kb/customer-reference/touchscreen-ux-devops-extract.md`](../../kb/customer-reference/touchscreen-ux-devops-extract.md) and [ADR-016](../adr/016-git-branching-and-delivery-ladders.md).

## Writeback and human control

- Physician approval required before EHR writeback.
- Writeback disable-able per customer (codes and summary independently per Q&A).
- Backend must not proxy EHR FHIR calls with provider tokens.

## Threats this architecture intentionally avoids

- Storing ambient audio / transcripts / AI notes.
- Server-side EHR credential vaults for FHIR.
- Patient-level ad targeting.
- Direct unmediated device channels for clinical context.

## Open security items (do not invent answers)

- Named compliance / PHI decision owner.
- Final data-classification matrix ratification.
- Whether AWS BAA is required for the chosen engagement schema.
- Formal CI/CD, observability, and HIPAA policy pack from Mesmerize (AM).
