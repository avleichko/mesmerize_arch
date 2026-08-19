# Architecture Decision Records (ADR)

## Mandatory for agents

**Before any architecture, auth, FHIR, device, content-matching, billing, writeback, or infra/CI change:**

1. Search and read relevant files under [`kb/`](../../kb/).
2. Search and read the second knowledge base [`customer-kb/`](../../customer-kb/) (pointer: [`docs/customer-kb/README.md`](../customer-kb/README.md)) — settled customer infra is **`INFRASTRUCTURE.md` `D-xx` only**; `docs/prebuild-proposal/` is not Confirmed ([ADR-018](018-customer-decision-repo-second-kb.md)).
3. Read this folder — start with the **Confirmed decision register** below, then the linked ADR.
4. Do **not** contradict a Confirmed decision without a superseding ADR + explicit human approval. If this register conflicts with customer `D-xx`, stop and ask.

See also [`AGENTS.md`](../../AGENTS.md) and [`docs/ai/ENGINEERING_RULES.md`](../ai/ENGINEERING_RULES.md).

## Confirmed decision register

| # | Decision | Status | ADR |
|---|----------|--------|-----|
| 1 | **athenahealth is the first target EHR** for the pilot. Epic and Oracle/Cerner are future roadmap integrations. | Confirmed | [ADR-004](004-athena-pilot-ehr-agnostic-core.md) |
| 2 | The main clinician-facing app is a **SMART on FHIR app launched from inside Athena**. | Confirmed | [ADR-004](004-athena-pilot-ehr-agnostic-core.md), [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md) |
| 3 | Clinician workflow uses **3-legged OAuth / Authorization Code Grant**, not 2-legged. **Reason:** provider launches from an active Athena patient chart/encounter → needs authenticated provider + patient/encounter context; Q&A confirms EHR launch only, Athena/EHR SSO, no separate Mesmerize login for SMART app. | Confirmed | [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md) |
| 4 | SMART launch type is **EHR launch only** for MVP. Standalone launch is not required. | Confirmed | [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md) |
| 5 | MVP FHIR scopes: `launch/encounter`, `Patient.read`, `Condition.read`, `Encounter.read`, `DocumentReference.write`; **Proposed** additive reads for exam-room imaging display (`DiagnosticReport.read`, `DocumentReference.read`, `Media.read`, `Observation.read`). No `ImagingStudy` / DICOMweb / WADO in v1. | Confirmed (additive reads Confirmed-as-intent; Proposed in SAD until athena ratification) | [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md), [ADR-019](019-exam-room-imaging-display-and-evidence.md) |
| 6 | **Patient/encounter context and FHIR token stay in the browser**. They must not be sent to Mesmerize backend. | Confirmed | [ADR-002](002-zero-phi-on-mesmerize-servers.md) |
| 7 | Mesmerize backend receives only **ICD-10 condition codes + device group ID + opaque session ID**. | Confirmed | [ADR-002](002-zero-phi-on-mesmerize-servers.md) |
| 8 | Backend follows **zero-PHI-on-Mesmerize-servers**. No patient identifiers stored. | Confirmed | [ADR-002](002-zero-phi-on-mesmerize-servers.md) |
| 9 | Content recommendation uses **ICD-10 → content metadata mapping**. CPT/HCPCS are not recommendation keys. | Confirmed | [ADR-006](006-icd10-content-match-cpt-billing-output.md) |
| 10 | CPT/HCPCS/HCC logic belongs on the **billing evidence output** side, not content matching. | Confirmed | [ADR-006](006-icd10-content-match-cpt-billing-output.md) |
| 11 | Current PWA is **extended**, not rebuilt from scratch. New work adds SMART-driven push, pairing, and telemetry. | Confirmed | [ADR-007](007-extend-pwa-server-mediated-devices.md) |
| 12 | Device communication goes through **Mesmerize backend Device Command API**, not direct SMART app → device. | Confirmed | [ADR-007](007-extend-pwa-server-mediated-devices.md) |
| 13 | Real-time push / device sync uses **Socket.io / WebSockets**. | Confirmed | [ADR-007](007-extend-pwa-server-mediated-devices.md) |
| 14 | Devices are identified via **Esper UUID + serial + M-number/location alias**. | Confirmed | [ADR-007](007-extend-pwa-server-mediated-devices.md) |
| 15 | Room/device targeting uses **device selection/pairing** for pilot (exact room/provider mapping does not exist today). | Confirmed / pilot approach | [ADR-007](007-extend-pwa-server-mediated-devices.md) |
| 16 | Engagement telemetry is **de-identified session telemetry**: content ID, ICD-10, device ID, timestamps, duration, interactions. | Confirmed | [ADR-008](008-engagement-telemetry-billing-hitl-writeback.md) |
| 17 | Billing engine produces **suggestions/evidence**, not claims. Claim submission is out of scope. | Confirmed | [ADR-003](003-documentreference-engagement-writeback.md), [ADR-008](008-engagement-telemetry-billing-hitl-writeback.md) |
| 18 | **Physician review/approval** is required before writeback / official documentation use. | Confirmed | [ADR-003](003-documentreference-engagement-writeback.md), [ADR-008](008-engagement-telemetry-billing-hitl-writeback.md) |
| 19 | EHR writeback is **configurable / disable-able per customer**. | Confirmed | [ADR-003](003-documentreference-engagement-writeback.md), [ADR-008](008-engagement-telemetry-billing-hitl-writeback.md) |
| 20 | Exam-room imaging **display** is in scope for athena pilot delivery: **Tier 1** web-native artifact push + **Tier 2** window/tab-scoped WebRTC mirror. No Mesmerize DICOM viewer; no server-side imaging payloads. | Confirmed | [ADR-019](019-exam-room-imaging-display-and-evidence.md) |

### Technology stack (Confirmed)

| # | Area | Decision | ADR |
|---|------|----------|-----|
| S1 | Frontend | React 19, TypeScript, Vite, Tailwind | [ADR-010](010-technology-stack.md) |
| S2 | SMART library | `fhirclient.js` | [ADR-010](010-technology-stack.md) |
| S3 | Backend | **Python / FastAPI** (was NestJS/TS) | [ADR-010](010-technology-stack.md), [ADR-017](017-python-platform-backend.md) |
| S4 | Database | PostgreSQL 16 | [ADR-010](010-technology-stack.md) |
| S5 | ORM | **SQLAlchemy 2 + Alembic** (was Prisma) | [ADR-010](010-technology-stack.md), [ADR-017](017-python-platform-backend.md) |
| S6 | Cache / realtime support | Redis 7 | [ADR-010](010-technology-stack.md) |
| S7 | Realtime communication | Socket.io (python-socketio on server) | [ADR-010](010-technology-stack.md), [ADR-007](007-extend-pwa-server-mediated-devices.md), [ADR-017](017-python-platform-backend.md) |
| S8 | Repo layout | **Multi-repo:** one GitHub repo per deployable service (customer D-07); pnpm in TS repos; uv/Poetry in Python API repo | [ADR-010](010-technology-stack.md), [ADR-017](017-python-platform-backend.md) |
| S9 | Auth | EHR OAuth for SMART app; Auth0 + RBAC for admin/Command Center | [ADR-010](010-technology-stack.md), [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md) |
| S10 | Device management | Esper MDM + existing TelemetryTV/PWA fleet | [ADR-010](010-technology-stack.md), [ADR-007](007-extend-pwa-server-mediated-devices.md) |
| S11 | Content | Sanity CMS + BioDigital + MJH / Pharmacy Times + current PWA JSON content | [ADR-010](010-technology-stack.md) |
| S12 | Infrastructure | Mesmerize-owned AWS | [ADR-010](010-technology-stack.md) |
| S13 | Infra components | ECS/Fargate, RDS PostgreSQL, ElastiCache/Redis, S3, CloudFront | [ADR-010](010-technology-stack.md) |
| S14 | IaC / CI/CD | Terraform + GitHub Actions | [ADR-010](010-technology-stack.md) |
| S15 | Observability | Mesmerize-approved monitoring; Datadog in reference architecture | [ADR-010](010-technology-stack.md) |

### Do not build (Confirmed)

| # | Decision | Reason | ADR |
|---|----------|--------|-----|
| DNB-1 | No Redox dependency | SMART on FHIR path selected | [ADR-011](011-do-not-build.md) |
| DNB-2 | No Deepgram | No audio capture/transcription | [ADR-011](011-do-not-build.md) |
| DNB-3 | No Claude SOAP note generation | No ambient clinical note generation | [ADR-011](011-do-not-build.md) |
| DNB-4 | No transcript storage | Audio/transcription removed | [ADR-011](011-do-not-build.md) |
| DNB-5 | No clinical note storage | Mesmerize should not become ambient scribe | [ADR-011](011-do-not-build.md) |
| DNB-6 | No patient CRUD / longitudinal patient record | Zero-PHI backend principle | [ADR-011](011-do-not-build.md) |
| DNB-7 | No clearinghouse / EDI claim submission | PM system handles claims | [ADR-011](011-do-not-build.md) |
| DNB-8 | No server-side EHR token handling | FHIR token stays browser-side | [ADR-011](011-do-not-build.md) |
| DNB-9 | No Mesmerize DICOM viewer and no server-side DICOM or imaging payloads | PHI/FDA; imaging **display** is in scope | [ADR-011](011-do-not-build.md), [ADR-019](019-exam-room-imaging-display-and-evidence.md) |

### Multitenancy (Confirmed)

| # | Decision | ADR |
|---|----------|-----|
| MT-1 | **Tenant** = Organization (`tenantId` = `organizationId`) | [ADR-013](013-multitenancy-silo-and-bridge.md) |
| MT-2 | **Clinic/site** = sub-scope inside tenant (`clinicId` / `deviceGroupId`) | [ADR-013](013-multitenancy-silo-and-bridge.md) |
| MT-3 | Mode **Silo**: isolated DB per Organization + org-isolated S3 | [ADR-013](013-multitenancy-silo-and-bridge.md) |
| MT-4 | Mode **Bridge**: shared DB + `tenantId` column + isolated S3 folders `{tenantId}/{clinicId}/…` | [ADR-013](013-multitenancy-silo-and-bridge.md) |
| MT-5 | Pilot / SOW #3 **default** = Bridge; Silo available per org | [ADR-013](013-multitenancy-silo-and-bridge.md) |

### Messaging (Confirmed)

| # | Decision | ADR |
|---|----------|-----|
| MSG-1 | Edge clients use **REST** (+ Socket.io for devices) | [ADR-014](014-sqs-messaging-patterns.md) |
| MSG-2 | Internal: **REST or SQS** per decision matrix | [ADR-014](014-sqs-messaging-patterns.md) |
| MSG-3 | SQS sync-style = **Request/Reply** + **Correlation Identifier**; per-target `{service}.replies`; per-op timeout | [ADR-014](014-sqs-messaging-patterns.md) |
| MSG-4 | SQS async = **Fire-and-forget** | [ADR-014](014-sqs-messaging-patterns.md) |
| MSG-5 | Failures: **Content Enricher** then **DLQ** | [ADR-014](014-sqs-messaging-patterns.md) |

### Delivery / branching

| # | Decision | Status | ADR |
|---|----------|--------|-----|
| DEL-1 | Dual delivery: **Ladder A** platform (GHA → ECR → ECS + Terraform) vs **Ladder B** device/PWA (Netlify ≠ device; TTV filesync; Esper) | Confirmed (A direction / B touchscreen-ux) | [ADR-016](016-git-branching-and-delivery-ladders.md), [ADR-015](015-aws-deployment-reference.md) |
| DEL-2 | Org Git ladder `feature → staging → main`; PRs to `staging`; content-vs-code split | Confirmed touchscreen-ux; **Proposed** for platform repos | [ADR-016](016-git-branching-and-delivery-ladders.md) |
| DEL-3 | Do **not** claim Netlify or TTV filesync for Python/ECS platform services | Confirmed | [ADR-016](016-git-branching-and-delivery-ladders.md), [ADR-017](017-python-platform-backend.md) |

Related product strategy: [ADR-001](001-content-evidence-not-ambient-scribe.md).

## Where this lands in the SAD

Pack map: [`README.md`](../../README.md). Infra provision checklist (GitHub / ECS / RDS / SQS / VPC ×3 env): [SAD Chapter 21](../../output_docs/sad/chapters/21-infra-provision-checklist.md). Questions **Q-01…Q-17**: [Chapter 18](../../output_docs/sad/chapters/18-assumptions-and-open-questions.md). ASRs: [`docs/ai/NFR.md`](../ai/NFR.md) (imaging **INT-05** / **PERF-02**).

| ADR | SAD chapters (primary) |
|-----|------------------------|
| 001–008, 011 | 01–02, 07, 10 |
| 010, **017** (Python + S8 multi-repo) | 08, 13, 17, **21** |
| 013 | 11 |
| 014 | 12 |
| 015–016 | 13, 17, 21 |
| **018** | Always-check `customer-kb/`; Ch.21 cites `D-xx` and does not create them |
| **019** | 19–20; ripple 07–10, 14 |

## ADR index

| ADR | Title |
|-----|-------|
| [001](001-content-evidence-not-ambient-scribe.md) | Content Evidence Platform (not ambient scribe) |
| [002](002-zero-phi-on-mesmerize-servers.md) | Zero PHI on Mesmerize servers / browser-held FHIR token |
| [003](003-documentreference-engagement-writeback.md) | Engagement DocumentReference writeback |
| [004](004-athena-pilot-ehr-agnostic-core.md) | athenahealth pilot first; EHR-agnostic core |
| [005](005-smart-oauth-ehr-launch-mvp-scopes.md) | 3-legged OAuth, EHR launch only, MVP scopes |
| [006](006-icd10-content-match-cpt-billing-output.md) | ICD-10 content match; CPT/HCPCS/HCC on billing output |
| [007](007-extend-pwa-server-mediated-devices.md) | Extend PWA; Device Command API; Socket.io; Esper IDs; pairing |
| [008](008-engagement-telemetry-billing-hitl-writeback.md) | De-identified telemetry; suggestions; HITL; disable-able writeback |
| [009](009-dicom-imaging-out-of-sow-scope.md) | DICOM / imaging mirror out of SOW scope (**superseded** by [019](019-exam-room-imaging-display-and-evidence.md)) |
| [010](010-technology-stack.md) | Technology stack (React / Python FastAPI / AWS / …; S3–S5/S8 via ADR-017) |
| [011](011-do-not-build.md) | Explicit “do not build” decisions |
| [012](012-c4-persons-vs-stakeholders.md) | C4 Persons (runtime) vs SAD stakeholders |
| [013](013-multitenancy-silo-and-bridge.md) | Dual-mode multitenancy (Silo DB vs Bridge + S3) |
| [014](014-sqs-messaging-patterns.md) | SQS Request/Reply, correlation, enricher, DLQ, fire-and-forget |
| [015](015-aws-deployment-reference.md) | AWS reference deployment topology |
| [016](016-git-branching-and-delivery-ladders.md) | Git branching and dual delivery ladders |
| [017](017-python-platform-backend.md) | Platform backend Python / FastAPI; **S8 per-service GitHub repos** (D-07) |
| [018](018-customer-decision-repo-second-kb.md) | Customer decision repo as second knowledge base (like `kb/`) |
| [019](019-exam-room-imaging-display-and-evidence.md) | Exam-room imaging display and imaging evidence (supersedes ADR-009) |
