# Architecture Decision Records (ADR)

## Mandatory for agents

**Before any architecture, auth, FHIR, device, content-matching, billing, or writeback change:**

1. Search and read relevant files under [`kb/`](../../kb/).
2. Read this folder — start with the **Confirmed decision register** below, then the linked ADR.
3. Do **not** contradict a Confirmed decision without a superseding ADR + explicit human approval.

See also [`AGENTS.md`](../../AGENTS.md) and [`docs/ai/ENGINEERING_RULES.md`](../ai/ENGINEERING_RULES.md).

## Confirmed decision register

| # | Decision | Status | ADR |
|---|----------|--------|-----|
| 1 | **athenahealth is the first target EHR** for the pilot. Epic and Oracle/Cerner are future roadmap integrations. | Confirmed | [ADR-004](004-athena-pilot-ehr-agnostic-core.md) |
| 2 | The main clinician-facing app is a **SMART on FHIR app launched from inside Athena**. | Confirmed | [ADR-004](004-athena-pilot-ehr-agnostic-core.md), [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md) |
| 3 | Clinician workflow uses **3-legged OAuth / Authorization Code Grant**, not 2-legged. **Reason:** provider launches from an active Athena patient chart/encounter → needs authenticated provider + patient/encounter context; Q&A confirms EHR launch only, Athena/EHR SSO, no separate Mesmerize login for SMART app. | Confirmed | [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md) |
| 4 | SMART launch type is **EHR launch only** for MVP. Standalone launch is not required. | Confirmed | [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md) |
| 5 | MVP FHIR scopes are minimal: `launch/encounter`, `Patient.read`, `Condition.read`, `Encounter.read`, `DocumentReference.write`. | Confirmed | [ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md) |
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
| 20 | **DICOM push / imaging mirror / screen mirroring** is out of current SOW scope; future-ready architecture only. | Confirmed | [ADR-009](009-dicom-imaging-out-of-sow-scope.md) |

### Technology stack (Confirmed)

| # | Area | Decision | ADR |
|---|------|----------|-----|
| S1 | Frontend | React 19, TypeScript, Vite, Tailwind | [ADR-010](010-technology-stack.md) |
| S2 | SMART library | `fhirclient.js` | [ADR-010](010-technology-stack.md) |
| S3 | Backend | NestJS / TypeScript | [ADR-010](010-technology-stack.md) |
| S4 | Database | PostgreSQL 16 | [ADR-010](010-technology-stack.md) |
| S5 | ORM | Prisma | [ADR-010](010-technology-stack.md) |
| S6 | Cache / realtime support | Redis 7 | [ADR-010](010-technology-stack.md) |
| S7 | Realtime communication | Socket.io | [ADR-010](010-technology-stack.md), [ADR-007](007-extend-pwa-server-mediated-devices.md) |
| S8 | Monorepo | Turborepo + npm workspaces | [ADR-010](010-technology-stack.md) |
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
| DNB-9 | No DICOM push in current scope | Explicitly out of scope in SOW | [ADR-011](011-do-not-build.md), [ADR-009](009-dicom-imaging-out-of-sow-scope.md) |

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

Related product strategy: [ADR-001](001-content-evidence-not-ambient-scribe.md).

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
| [009](009-dicom-imaging-out-of-sow-scope.md) | DICOM / imaging mirror out of SOW scope |
| [010](010-technology-stack.md) | Technology stack (React/NestJS/AWS/…) |
| [011](011-do-not-build.md) | Explicit “do not build” decisions |
| [012](012-c4-persons-vs-stakeholders.md) | C4 Persons (runtime) vs SAD stakeholders |
| [013](013-multitenancy-silo-and-bridge.md) | Dual-mode multitenancy (Silo DB vs Bridge + S3) |
| [014](014-sqs-messaging-patterns.md) | SQS Request/Reply, correlation, enricher, DLQ, fire-and-forget |
| [015](015-aws-deployment-reference.md) | AWS reference deployment topology |
