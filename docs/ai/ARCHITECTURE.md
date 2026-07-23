# ARCHITECTURE

> **Sources:** `kb/Documentation/Content Evidence Platform — Architecture.docx`, Implementation Context, Strategy Overview, Mesmerize Responses Q&A.  
> **Diagrams:** `output_diagrams/`.  
> **Formal SAD documents:** use [`templates/Solution_Architecture_Definition_template.docx`](../../templates/Solution_Architecture_Definition_template.docx) when producing stakeholder Solution Architecture Definitions (see [`templates/README.md`](../../templates/README.md)).

## High-level view

Three planes:

1. **Cloud (AWS)** — SMART app hosting, NestJS Platform API, application services, PostgreSQL (engagement only) + Redis, S3 media/ads.
2. **EHR SMART launch** — Epic / Cerner / Athena launch SMART app in iframe (pilot: **athenahealth**).
3. **Clinic edge** — Microtouch exam-room devices, waiting-room TVs, Command Center; Esper MDM.

### Clarifications that affect C4 diagrams

- **C4 Persons** = runtime actors only; project stakeholders go in SAD (see [ADR-012](../adr/012-c4-persons-vs-stakeholders.md)).
- Third-party systems on context/container diagrams: athenahealth (pilot), Auth0, Esper, TelemetryTV, Sanity, BioDigital, MJH/Pharmacy Times, SMS/email provider, AWS services; PM/clearinghouse and ambient AI are external ecosystem — not Mesmerize-built.

See `output_diagrams/01-system-context.mmd` and **C4 context (PlantUML):** `output_diagrams/07-c4-context.puml`.

**Proposed microservice containers (REST + SQS):**  
`output_diagrams/06-c4-containers.mmd` (Mermaid C4) and `output_diagrams/06-c4-containers.puml` (PlantUML C4). Building blocks: gateway, session, content, device-realtime, engagement, billing-evidence, org-identity, audit-telemetry, ads (optional), plus Postgres/Redis/S3/SQS.

## Architectural principles

1. **Token never leaves the browser** — EHR FHIR token stays in SMART app browser context.
2. **No patient identifiers on Mesmerize servers** — only ICD-10 codes + device group ID + opaque session ID to backend.
3. **No audio path** — deliberate absence (not deferred scaffolding).
4. **Server-mediated device control** — SMART app → Platform API → Socket.io → device (no direct device-to-device app traffic for commands).
5. **EHR-agnostic core** — pilot optimized for athena; data models/APIs/auth designed for modular Epic/Cerner later (SOW Phase 1 blueprint).

PHI boundary detail: `output_diagrams/02-phi-boundary.mmd` and [`SECURITY.md`](SECURITY.md).

## Components

### SMART on FHIR app (`apps/smart-app`)

Lightweight React app in EHR iframe:

- SMART launch + `fhirclient.js` OAuth2
- Reads (browser): Patient (display name), Condition (ICD-10), Encounter
- Recommends content; browse/search; device select/pair; push confirmation
- Shows engagement + billing evidence; physician approve
- Writes DocumentReference via EHR token at session end (when enabled)

**MVP FHIR scopes (Q&A):**  
`launch/encounter patient/Patient.read patient/Condition.read patient/Encounter.read patient/DocumentReference.write`

Architecture doc also lists imaging read scopes for **Patient Imaging Mirror** — **out of scope under SOW #3**; do not treat as MVP.

Registered client (architecture): `mesmerize-content-evidence`, `private_key_jwt`, authorization_code.

### Platform API (`apps/api`, NestJS)

Serves SMART app and devices. **Never** talks to EHR; **never** processes audio/notes.

Documented API groups:

| Group | Examples |
|-------|----------|
| Session | `POST /api/sessions`, get/patch/end |
| Content | list/filter, recommend, engagement log |
| Device command | command, list, heartbeat, status |
| Billing evidence | get, approve, export, dashboard |

Application services (architecture diagram): Session, Content, Billing Evidence Engine, Device Command, Ad Delivery, Engagement Tracking.

### Device platform (`apps/web` + existing PWA)

- Waiting Room, Exam Room, Command Center, Bridge App views
- Live fleet today: React/Vite PWA on Android/Esper (`touchscreen-ux`)
- Device auth: Esper-provisioned **device token**
- Commands: `show_content`, `show_biodigital`, `start_playlist`, `clear_display` (as documented)
- Pairing: clinic/device group query → provider select (or auto if one) → Socket.io room `session:{id}:device:{deviceId}`

Fleet scale (Q&A): ~4,400 exam-room/touchscreen devices (~3,480 active); Esper UUID + serial + M-number alias; room/provider mapping is a known gap for pilot targeting.

### Billing evidence engine (`packages/billing-engine`)

**Input:** content engagement events only (no transcript).  
**Output:** CPT suggestions + structured evidence (time thresholds, conditions addressed, categories such as counseling/CCM/ACP/etc. per strategy docs).  
**Does not:** primary E/M MDM determination, claim generation, PA, coverage checks.

### FHIR engagement package (`packages/fhir-engagement`)

Formats engagement / service-delivery summary as FHIR **DocumentReference** (architecture cites LOINC 69730-0 Instructions category). Replaces heavier clinical-note writeback designs.

### Content sources

| Source | Type | Integration |
|--------|------|-------------|
| Mesmerize library | Videos | Sanity → Content API / S3 |
| BioDigital | 3D models | OAuth2 + iframe / IDs |
| MJH / Pharmacy Times | Articles | Sanity sync |

### Data stored on Mesmerize (de-identified)

Session (Mesmerize UUID, clinicId, deviceGroupId, ICD-10 conditions[], times, status) → ContentEngagement[] → BillingSuggestion[].

**Not stored:** patient identifiers, coverage, meds/allergies, FHIR resources, audio, transcripts, clinical notes, imaging payloads.

### Patient Imaging Mirror (architecture Tier 1 / WebRTC)

Documented as WebRTC P2P imaging display with signaling-only on Mesmerize servers. **SOW #3 explicitly excludes DICOM push / screen mirroring** — treat as future foundation, not current delivery scope. Tech meeting notes also mark imaging strategy as needing further discussion.

## Monorepo structure (target)

```
mesmerize-platform/
  apps/
    api/          # NestJS
    web/          # Device views
    smart-app/    # SMART on FHIR
  packages/
    shared/           # Types, Zod, constants, Socket.io events
    ui/
    billing-engine/
    fhir-engagement/  # not server-side EHR adapters
    config/
  docs/
  infrastructure/   # docker, terraform, esper
```

**Remove / avoid vs older plans:** `packages/ai-services`, patient CRUD / Redox adapters, transcript & clinical note models.

## Cloud / infra (confirmed direction in Q&A)

Mesmerize-owned AWS: ECS/Fargate, RDS PostgreSQL, ElastiCache/Redis, S3, CloudFront; Terraform; GitHub Actions. Environments: Dev / Staging / Prod (Staging PHI-free vs athena sandbox; Prod gated to pilot).

## Auth model

See `output_diagrams/05-auth-model.mmd` and [`SECURITY.md`](SECURITY.md).

## Encounter happy path

See `output_diagrams/03-encounter-flow.mmd`.

## Waiting room content

Default: specialty playlists from Sanity. Optional: anonymous aggregate condition categories for playlist optimization — still no patient IDs.

## Related ADRs

Full register (decisions #1–#20): [`docs/adr/README.md`](../adr/README.md)

- [ADR-001](../adr/001-content-evidence-not-ambient-scribe.md)
- [ADR-002](../adr/002-zero-phi-on-mesmerize-servers.md) (#6–#8)
- [ADR-003](../adr/003-documentreference-engagement-writeback.md) (#17–#19)
- [ADR-004](../adr/004-athena-pilot-ehr-agnostic-core.md) (#1–#2)
- [ADR-005](../adr/005-smart-oauth-ehr-launch-mvp-scopes.md) (#2–#5)
- [ADR-006](../adr/006-icd10-content-match-cpt-billing-output.md) (#9–#10)
- [ADR-007](../adr/007-extend-pwa-server-mediated-devices.md) (#11–#15)
- [ADR-008](../adr/008-engagement-telemetry-billing-hitl-writeback.md) (#16–#19)
- [ADR-009](../adr/009-dicom-imaging-out-of-sow-scope.md) (#20)
- [ADR-010](../adr/010-technology-stack.md) (S1–S15)
- [ADR-011](../adr/011-do-not-build.md) (DNB-1–DNB-9)
- [ADR-012](../adr/012-c4-persons-vs-stakeholders.md)
