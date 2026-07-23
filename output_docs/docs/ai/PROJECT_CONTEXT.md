# PROJECT_CONTEXT

> **Audience:** AI agents and engineers.  
> **Sources:** `kb/Documentation/Content Evidence Platform — Strategy Overview.docx`, SOW #3, `kb/Files from Mesmerize/Mesmerize Responses to Newfire Questions (1).md`.  
> **Rule:** Do not invent product goals beyond these sources.

## What Mesmerize is building

**Content Evidence Platform (v2):** a clinical education delivery platform with structured billing evidence.

- Providers launch a **SMART on FHIR** app inside the EHR.
- App recommends **condition-specific patient education** (videos, BioDigital 3D, articles).
- Content is **pushed to exam-room / waiting-room devices**.
- Platform captures **timestamped, ICD-10-linked engagement**.
- A **billing rules engine** suggests counseling and related codes with structured evidence.
- Provider **reviews/approves**; optional **FHIR DocumentReference** writeback to the chart.

**One-sentence positioning (kb):** Mesmerize delivers the education content; the EHR’s ambient AI (if any) documents the conversation about it.

## Why this product (strategic shift)

Earlier plans (Redox end-to-end PHI pipeline; SMART + ambient scribe with Deepgram/Claude) were superseded because:

- Ambient documentation is saturated (Epic Art, athenaAmbient, Abridge, Nuance DAX, etc.).
- Mesmerize’s differentiation is **content library + devices + engagement→billing evidence**, not scribing.
- PHI footprint, vendor BAAs, and engineering cost drop dramatically under Content Evidence.

## Business model (unchanged pillars)

- **Advertising-subsidized** delivery to practices (free / low friction).
- Condition-**category** ad targeting — **not** patient-level targeting.
- Content from Mesmerize library, MJH / Pharmacy Times, BioDigital.
- Physical **waiting room** and **exam room** devices (Esper MDM fleet).
- **Bridge App** for post-visit education and recurring-care engagement (CCM/RTM/PCM narrative in strategy docs).

## Key objectives (SOW #3 + Mesmerize Q&A)

1. **EHR-integrated content platform** via SMART on FHIR (provider pushes relevant education).
2. **Foundation for future** advanced features (e.g. imaging to screens / mirroring) — foundation only under SOW #3; DICOM push is **out of scope**.
3. **Pilot by end of Q1 2027** to support **1,000+ screens** proof points for **July 2027** pharma planning.
4. **Minimal PHI footprint** — avoid handling PHI wherever possible.

### Primary success metric

End-to-end flow in an **athenahealth** pilot with a real clinician by **end of Q1 2027**:

SMART launch → FHIR Condition read → ICD-10 recommendation → push to exam-room device → engagement capture → billing evidence → DocumentReference writeback — **no PHI/compliance incident**.

## Users and surfaces

**Modeling rule (confirmed):**  
- **C4 Persons** = runtime actors only (people who use a product surface at runtime).  
- **Stakeholders** = separate SAD / project section (sponsors, delivery, owners) — not C4 Person nodes unless they also operate a runtime surface.

### C4 Persons (runtime actors)

| Actor | Surface | Auth (kb) |
|-------|---------|-----------|
| Clinician / Physician | SMART app in EHR iframe | EHR SSO only |
| Nurse / MA | SMART app in EHR iframe | EHR SSO only |
| Admin / Command Center staff | Command Center | Auth0 + RBAC (RBAC noted as later phase in Q&A) |
| Patient (in clinic) | Exam-room / waiting-room device | No patient login; device token via Esper |
| Patient (post-visit) | Bridge App | Secure link + one-time code; 30-min inactivity timeout |

Physician approval is required before writeback (human-in-the-loop); Nurse/MA may participate in launch/select/push per kb roles.

### Stakeholders (SAD section — not C4 Persons by default)

| Role | Who (as documented) |
|------|---------------------|
| Exec sponsor / decision chain | MM (SVP), KN (Sr. Director); AM (CTO), BB (COO) support |
| Technical owner | Andy Martin (CTO); MM/KN day-to-day |
| Delivery partner | Newfire (SOW #3) |
| Athena relationship | Mesmerize (Marketplace Developer Console) |
| Content ownership | Mesmerize (Sanity + BioDigital + MJH) |
| PWA ownership | Mesmerize (`MesmerizeTeam/touchscreen-ux`, staging branch); Newfire **extends**, does not edit live production in place |
| Compliance / PHI approver | **Open in kb** — confirm |
| Billing rules owner | **Open in kb** — Mesmerize consultant / partner / Newfire implements |
| Pharma / advertisers | Business consumers of aggregated engagement proof — not MVP clinician login roles |

## Two content libraries (do not conflate)

1. **New recommendation corpus:** Sanity + BioDigital + MJH / Pharmacy Times (~10k–15k assets) with `icd10Code`, `specialty`, `format`, `device` metadata. ICD-10 tagging is a **Phase 1 deliverable** (largely to-be-built).
2. **Current exam-room PWA content:** `touchscreen-ux` — ~22 specialty categories / ~150 topics, **slug + specialty only, no ICD-10** today. Live on fleet; new work **extends** it.

## Matching and billing directionality

- **ICD-10 → content** (recommendation): diagnosis drives education.
- **Engagement + ICD-10 → CPT/HCPCS suggestions** (billing evidence): rules engine output.
- Do **not** use CPT as primary content match key (kb rationale: CPT describes service, not what to teach).

## Explicit non-goals (current plan)

- Not an ambient AI scribe competitor.
- Does not capture audio, transcribe, or generate clinical notes.
- Does not store longitudinal patient records on Mesmerize servers.
- Does not submit insurance claims (PM system does).
- SOW #3 does not include DICOM push or ML recommender (if metadata insufficient).

## Related diagrams

- `output_diagrams/01-system-context.mmd`
- `output_diagrams/03-encounter-flow.mmd`
