# SECURITY

> **Sources:** Architecture (Security Architecture, PHI tables), Strategy Overview (PHI Boundary), Implementation Context, Mesmerize Responses Q&A, Jul 14 meeting notes.  
> **Not legal advice.** Confirm BAAs and policies with Mesmerize compliance owner (**open in kb**).

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
| SMART app | EHR authenticates provider; OAuth2 SMART launch; Mesmerize session token for Platform API |
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
