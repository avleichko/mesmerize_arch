# GLOSSARY

Terms as used in Mesmerize Content Evidence materials. Prefer these meanings in code and docs.

| Term | Meaning |
|------|---------|
| **Content Evidence Platform** | Current product architecture (v2): education delivery + engagement evidence + billing suggestions; not ambient scribing |
| **Control plan** | Older Redox-based plan with end-to-end PHI pipeline — superseded for this initiative |
| **SMART v1 plan** | Earlier SMART plan that included ambient audio / Deepgram / Claude notes — superseded |
| **SMART on FHIR app** | Provider-facing web app launched from EHR iframe via SMART/OAuth2 |
| **fhirclient.js** | Open-source SMART client library (`fhirclient` npm) used in browser |
| **Platform API** | NestJS backend for sessions, content, devices, billing evidence — no EHR calls |
| **Session ID** | Opaque Mesmerize UUID for an encounter-scoped work session — **not** patient ID |
| **Device group** | Clinic/site grouping of devices used for targeting |
| **M-number** | Operator device alias prefix used with serial/location in fleet ops |
| **tenantId** | Equals **organizationId** — multitenancy boundary ([ADR-013](../adr/013-multitenancy-silo-and-bridge.md)) |
| **Silo mode** | Isolated database per Organization |
| **Bridge mode** | Shared database with `tenantId` column + isolated S3 folders |
| **Esper** | MDM used to provision/manage clinic devices and device tokens |
| **TelemetryTV** | Existing ops/telemetry tooling mirrored with device registry |
| **PWA / touchscreen-ux** | Live patient-facing exam-room kiosk app repo |
| **Command Center** | Staff/admin device/web surface (Auth0) |
| **Bridge App** | Patient education companion (post-visit); secure link + timeout |
| **Sanity CMS** | Content management for new recommendation corpus |
| **BioDigital** | 3D anatomy models (iframe / API IDs) |
| **MJH / Pharmacy Times** | Article / medication education content sources |
| **ICD-10** | Diagnosis codes; **sole** content match key for recommendations |
| **CPT / HCPCS** | Procedure/service codes; **outputs** of billing evidence engine |
| **Billing evidence** | Structured, engagement-backed code suggestions + proof — not claim submission |
| **DocumentReference writeback** | FHIR resource written to EHR for education/service-delivery documentation |
| **Engagement event** | Content start/duration/completion (+ interactions) tied to session/device/ICD-10 |
| **VAST** | Video Ad Serving Template — baseline for video ad telemetry (meeting alignment) |
| **Human-in-the-loop** | Physician must review/approve before writeback |
| **Zero-PHI-on-servers** | Design goal: no patient identifiers stored or processed on Mesmerize backend |
| **Patient Imaging Mirror** | WebRTC imaging display concept — **out of SOW #3** delivery |
| **EHR-agnostic core** | Decoupled models/APIs/auth so Epic/Cerner can be modular later |
| **SOW #3** | Newfire Statement of Work governing current delivery scope |
| **Phase 1–4** | SOW execution phases (design → build → harden → pilot) |
| **Safe Harbor** | HIPAA de-identification framing used in kb for ICD-10-without-identifiers |
| **BAA** | Business Associate Agreement |
| **RBAC** | Role-based access control (Command Center; timing per Q&A) |
| **POC ecosystem** | Demo multi-device journey used as reference behavior |
| **mesmerize-platform** | Target Turborepo monorepo for the new platform |

## Acronyms

| Acronym | Expansion |
|---------|-----------|
| EHR | Electronic Health Record |
| FHIR | Fast Healthcare Interoperability Resources |
| SMART | Substitutable Medical Applications, Reusable Technologies |
| PHI | Protected Health Information |
| CCM / PCM / TCM | Chronic / Principal / Transitional Care Management |
| ACP | Advance Care Planning |
| AWV | Annual Wellness Visit |
| BHI | Behavioral Health Integration |
| HCC | Hierarchical Condition Category |
| MDM | Medical Decision Making (E/M) |
| PM | Practice Management (system) |
| MDM (device) | Mobile Device Management (Esper) — disambiguate from E/M MDM by context |
