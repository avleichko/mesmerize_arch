# ENGINEERING_RULES

> **Sources:** Architecture v2.0, Implementation Context, Mesmerize Responses (Technical Constraints), SOW #3, Jul 14 functional/non-functional notes.  
> **Mark open items** rather than inventing standards.

## Mandatory: check kb + ADR before changes

**Always** do this before implementing or proposing architecture/product behavior:

1. Search/analyze relevant materials under [`kb/`](../../kb/).
2. Read [`docs/adr/README.md`](../adr/README.md) — confirmed decisions **#1–#20** are binding.
3. Open the linked ADR(s) for the area you are touching (auth, PHI, devices, content match, billing, writeback, imaging).
4. If a Confirmed decision conflicts with a request, **stop** and escalate — do not silently override.

Do not invent requirements beyond `kb/` + accepted ADRs.

## Templates (mandatory when present)

Canonical folder: [`templates/`](../../templates/) — see [`templates/README.md`](../../templates/README.md).

1. Before creating a Solution Architecture Definition or other formal architecture document, **list `templates/`**.
2. If a matching template exists, **copy and fill it** (preserve section structure). Current SAD template: `templates/Solution_Architecture_Definition_template.docx`.
3. Do **not** overwrite template files; write outputs to `output_docs/` (or the task-specified path).
4. If no template matches, proceed with `docs/ai/*` + ADRs and note that no template was found.
5. Template structure does not authorize inventing product requirements — content still comes from `kb/` + ADRs.

## Non-functional requirements (binding ASRs)

Full catalog: [`docs/ai/NFR.md`](NFR.md) and [`output_docs/nfr/NFR_CATALOG.md`](../../output_docs/nfr/NFR_CATALOG.md).

**Architecturally significant (must not conflict):** zero-PHI servers; browser-held FHIR token; no ambient notes path; tenant isolation; exponential backoff retries; durable engagement proof; WCAG 2.1 AA; white-label; ambulatory-only; engagement vs diagnostic log split; diagnostic retention ≤ 90 days; SMART 3-legged EHR launch; server-mediated devices; tenant-isolated S3; separate audit telemetry; HIPAA-aligned AWS / OWASP+pen-test path.

Do **not** invent numeric availability/latency SLOs — none are fixed in kb (see Open items in NFR catalog).


## Stack (reference architecture — binding via [ADR-010](../adr/010-technology-stack.md))

| Layer | Choice |
|-------|--------|
| Frontend | React 19, TypeScript, Vite, Tailwind |
| SMART library | `fhirclient.js` |
| Backend | NestJS / TypeScript |
| Database | PostgreSQL 16 |
| ORM | Prisma |
| Cache / realtime support | Redis 7 |
| Realtime | Socket.io |
| Monorepo | Turborepo + npm workspaces |
| Auth | EHR OAuth (SMART app); Auth0 + RBAC (admin / Command Center) |
| Device management | Esper MDM + TelemetryTV / existing PWA fleet |
| Content | Sanity CMS + BioDigital + MJH / Pharmacy Times + current PWA JSON |
| Cloud | Mesmerize-owned AWS: ECS/Fargate, RDS PostgreSQL, ElastiCache/Redis, S3, CloudFront |
| IaC / CI/CD | Terraform + GitHub Actions |
| Observability | Mesmerize-approved monitoring; Datadog in reference architecture |

## Monorepo conventions

- Prefer packages in `packages/*` for shared types, billing rules, FHIR formatting, UI.
- `apps/smart-app` owns browser-side FHIR I/O only.
- `apps/api` owns session/content/device/billing APIs — **no EHR HTTP clients**.
- Do not reintroduce `packages/ai-services` or server-side FHIR EHR adapters (`fhir-client` Epic/Cerner/Athena adapters were replaced by `fhir-engagement`).

## Schema and API rules

- Prisma/DB: Organization, User, Device, Session, ContentItem, ContentEngagement, BillingSuggestion — **no** Patient, Medication, Allergy, Coverage, Transcript, ClinicalNote tables.
- **Multitenancy ([ADR-013](../adr/013-multitenancy-silo-and-bridge.md)):** `tenantId` = `organizationId`; `clinicId`/`deviceGroupId` are sub-scopes. Support **Silo** (DB per org) and **Bridge** (shared DB + `tenantId` column). Pilot default = Bridge. S3 paths always `{tenantId}/{clinicId}/…` (or org-dedicated bucket in Silo).
- Session create payload from SMART app: condition codes + device group context — **never** patient ID; always associate with `tenantId` (+ clinic/device group).
- Bridge mode: every tenant-owned query **must** filter by `tenantId` (fail closed).
- Silo mode: resolve DB connection from org config; never reuse another org’s connection string.
- Content model fields (Q&A): `id`, `source` (mesmerize|biodigital|mjh), `title`, `type`, `icd10Code`, specialty, format, device, media refs, locale.
- Content matching: curated metadata ICD-10 mapping first; **no ML recommender** under SOW unless metadata path fails and scope is explicitly reopened.
- UUID-based content / engagement tracking (meeting alignment) to avoid PHI on device.

## Messaging rules (SQS)

See [ADR-014](../adr/014-sqs-messaging-patterns.md).

- Edge: REST (+ Socket.io for devices). Do not put SMART iframe hot-path on SQS request/reply by default.
- Internal wait-for-result: SQS **Request/Reply** to `{service}.requests`, reply on `{service}.replies`, match **`correlationId`**, set **`replyTo`**, **per-operation timeout**.
- Async facts: **Fire-and-forget** to event/command queues.
- On repeated failure: **Content Enricher** (error context, no PHI) → **DLQ**.
- All messages: `tenantId` required; no patient identifiers / EHR tokens.

- All command traffic **server-mediated** (session-based), not peer SMART↔device for application commands — **NFR-INT-02**.
- Socket.io for push + heartbeats; exponential backoff retries for transaction failures — **NFR-REL-01**.
- Extend existing PWA; production repo is **read-only** for partner edits — work on copy/extension.
- White-labeling (customer branding/CSS) is a **hard requirement** — **NFR-UX-02**.
- Product setting: **ambulatory care only** (not inpatient/surgical) — **NFR-UX-04**.

## Frontend rules

- SMART app must work in **EHR iframe** (narrow sidebar ~400–800px cited in Implementation Context); no pop-up-dependent flows — **NFR-PERF-01**.
- Responsive for provider desktop/tablet; exam-room device is a separate fixed kiosk surface — do not merge responsive requirements — **NFR-UX-03**.
- Accessibility target for clinical UI: **WCAG 2.1 AA** (SOW Phase 2) — **NFR-UX-01**.
- Brand tokens: Tailwind preset; Implementation Context cites Urbanist/Inter and Navy/Purple/Magenta/Orange from POC — follow existing design system when present; do not invent a new brand.

## Billing / writeback rules

- Engine input = engagement telemetry only.
- Site-by-site configurable rules (SOW).
- Physician-only approve before writeback; writeback disable-able per customer.
- Export/audit: structured CSV/JSON + separate audit telemetry log (not only EHR).
- HCPCS Level II / J-codes: **thin today** — treat extensions as explicit work with billing consultant, not silent MVP scope.

## Environments and tooling

- Dev / Staging / Prod.
- Staging: PHI-free; athenahealth sandbox.
- Prod: gated to single pilot practice (Phase 4 per Q&A).
- Work on Mesmerize-approved infra (GitHub org, Jira MESV2, Confluence MES* spaces) for production-bound work.

## Process rules for agents

1. **Always check `kb/` and `docs/adr/` first** (see mandatory section above).
2. **Always check NFRs/ASRs** ([`NFR.md`](NFR.md) / `output_docs/nfr/`) before infra, security, logging, or API boundary changes.
3. **Always check `templates/`** before formal architecture / SAD documents; use matching templates when present.
4. Read `AGENTS.md` invariants before coding.
5. Prefer smallest diff; no drive-by refactors.
6. Do not “complete” ambient/audio/DICOM features under SOW #3 ([ADR-009](../adr/009-dicom-imaging-out-of-sow-scope.md)).
7. When kb says `[PROPOSED]` or Unknown, surface it in PR/notes.
8. Update or add an ADR when changing a hard boundary; update the decision register if a Confirmed decision changes; update NFR catalog if an ASR changes.
9. Sync meaningful doc changes to `output_docs/` when exporting for stakeholders.

## Explicit don’ts

Binding deny-list: [`docs/adr/011-do-not-build.md`](../adr/011-do-not-build.md) (DNB-1–DNB-9).

- Don’t add Redox, Deepgram, Claude/SOAP note generation, transcript or clinical-note storage.
- Don’t add patient CRUD / longitudinal patient records on Mesmerize servers.
- Don’t build clearinghouse / EDI claim submission.
- Don’t handle EHR FHIR tokens server-side; don’t send patient/encounter identifiers to the Platform API.
- Don’t implement DICOM push / imaging mirror under current SOW.
- Don’t edit live production PWA in place when the rule is extend-via-copy.
