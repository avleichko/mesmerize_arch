# 15. Key Terms and Abbreviations

| Field | Value |
|-------|-------|
| Chapter ID | `15-key-terms-and-abbreviations` |
| SAD mapping | Template §10 Key terms and abbreviations |
| Last updated | 2026-07-23 |
| Maturity | Stakeholder-ready · 100% |

## Purpose of this chapter

Provide **fuller product/platform term definitions** for Word template §10. Short acronym expansions for front-matter reading stay in [Chapter 04](04-definitions-and-acronyms.md).

**Canonical source:** [`docs/ai/GLOSSARY.md`](../../../docs/ai/GLOSSARY.md) — this chapter is a condensed SAD excerpt; prefer GLOSSARY on conflict.

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Prefer meanings in <code>docs/ai/GLOSSARY.md</code> for code and docs. Chapter 04 = short acronyms; Chapter 15 = condensed key terms (not a competing glossary).
</p>

## Relationship to Chapter 04

| Chapter | Role |
|---------|------|
| [04 Definitions and Acronyms](04-definitions-and-acronyms.md) | Short acronym list for front matter |
| **15 (this chapter)** | Expanded key terms for template §10 |
| [`docs/ai/GLOSSARY.md`](../../../docs/ai/GLOSSARY.md) | Canonical full vocabulary |

## Key terms (condensed)

| Term | Meaning (condensed from GLOSSARY) |
|------|-----------------------------------|
| **Content Evidence Platform** | Current product architecture (v2): education delivery + engagement evidence + billing suggestions — not ambient scribing |
| **SMART on FHIR app** | Provider-facing web app launched from EHR iframe via SMART/OAuth2 |
| **fhirclient.js** | Browser SMART client library (`fhirclient` npm) |
| **Platform API** | NestJS backend for sessions, content, devices, billing evidence — no EHR calls |
| **Session ID** | Opaque Mesmerize UUID for an encounter-scoped work session — **not** patient ID |
| **Device group** | Clinic/site grouping of devices used for targeting |
| **tenantId** | Equals **organizationId** — multitenancy boundary ([ADR-013](../../../docs/adr/013-multitenancy-silo-and-bridge.md)) |
| **Silo mode** | Isolated database per Organization |
| **Bridge mode** | Shared database with `tenantId` column + isolated S3 folders |
| **Esper** | MDM for clinic device provision/manage and device tokens |
| **PWA / touchscreen-ux** | Live patient-facing exam-room kiosk app |
| **Command Center** | Staff/admin device/web surface (Auth0) |
| **Bridge App** | Patient education companion (post-visit); secure link + timeout |
| **Sanity CMS** | Content management for recommendation corpus |
| **ICD-10** | Diagnosis codes; **sole** content match key for recommendations |
| **CPT / HCPCS** | Procedure/service codes; **outputs** of billing evidence engine |
| **Billing evidence** | Engagement-backed code suggestions + proof — not claim submission |
| **DocumentReference writeback** | FHIR resource written to EHR for education/service-delivery documentation |
| **Engagement event** | Content start/duration/completion (+ interactions) tied to session/device/ICD-10 |
| **Human-in-the-loop** | Physician must review/approve before writeback |
| **Zero-PHI-on-servers** | No patient identifiers stored or processed on Mesmerize backend |
| **EHR-agnostic core** | Decoupled models/APIs/auth so Epic/Cerner can be modular later |
| **SOW #3** | Newfire Statement of Work governing current delivery scope |
| **ASR** | Architecturally Significant Requirement — NFR that drives architecture |
| **NFR** | Non-functional requirement (see `output_docs/nfr/`) |
| **mesmerize-platform** | Target Turborepo monorepo for the new platform |

<p style="background:#fff8e1;border-left:4px solid #f9a825;padding:8px 12px;margin:12px 0;">
  <strong>Inferred:</strong> Superseded plans (Control plan, SMART v1), ops aliases (M-number, TelemetryTV), content sources (BioDigital, MJH), and out-of-scope concepts (Patient Imaging Mirror) remain in GLOSSARY only to keep §10 focused on active SAD vocabulary.
</p>

## Abbreviations (supplement to Chapter 04)

Additional expansions used in SAD body copy; see also [Chapter 04](04-definitions-and-acronyms.md).

| Acronym | Expansion |
|---------|-----------|
| CCM / PCM / TCM | Chronic / Principal / Transitional Care Management |
| ACP | Advance Care Planning |
| AWV | Annual Wellness Visit |
| BHI | Behavioral Health Integration |
| HCC | Hierarchical Condition Category |
| PM | Practice Management (system) |
| VAST | Video Ad Serving Template (video ad telemetry baseline) |
| RBAC | Role-based access control (Command Center) |

## Evidence

- [`docs/ai/GLOSSARY.md`](../../../docs/ai/GLOSSARY.md) — canonical terms and acronyms
- [Chapter 04](04-definitions-and-acronyms.md) — short acronym list; template §4
- [`templates/README.md`](../../../templates/README.md) — §10 Key terms and abbreviations
