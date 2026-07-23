# 03. Related Documents

| Field | Value |
|-------|-------|
| Chapter ID | `03-related-documents` |
| SAD mapping | Template §3 Related Documents |
| Last updated | 2026-07-23 |
| Maturity | Review-ready · 75% |

## Purpose of this chapter

Provide a **navigation table** to the ADRs, agent docs, NFRs, deployment notes, and diagram catalog that ground this SAD. Prefer these sources over inventing requirements.

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Confirmed decisions live in the ADR register ([<code>docs/adr/README.md</code>](../../../docs/adr/README.md)). Do not contradict a Confirmed decision without a superseding ADR and human approval.
</p>

## Architecture Decision Records (001–016)

| ADR | Title | Use in SAD |
|-----|-------|------------|
| [001](../../../docs/adr/001-content-evidence-not-ambient-scribe.md) | Content Evidence Platform (not ambient scribe) | Product positioning |
| [002](../../../docs/adr/002-zero-phi-on-mesmerize-servers.md) | Zero PHI on Mesmerize servers / browser-held FHIR token | Security / data boundary |
| [003](../../../docs/adr/003-documentreference-engagement-writeback.md) | Engagement DocumentReference writeback | Writeback / HITL |
| [004](../../../docs/adr/004-athena-pilot-ehr-agnostic-core.md) | athenahealth pilot first; EHR-agnostic core | Pilot / roadmap |
| [005](../../../docs/adr/005-smart-oauth-ehr-launch-mvp-scopes.md) | 3-legged OAuth, EHR launch only, MVP scopes | Auth / SMART |
| [006](../../../docs/adr/006-icd10-content-match-cpt-billing-output.md) | ICD-10 content match; CPT/HCPCS/HCC on billing output | Recommendation / billing |
| [007](../../../docs/adr/007-extend-pwa-server-mediated-devices.md) | Extend PWA; Device Command API; Socket.io | Devices |
| [008](../../../docs/adr/008-engagement-telemetry-billing-hitl-writeback.md) | De-identified telemetry; suggestions; HITL | Engagement / billing |
| [009](../../../docs/adr/009-dicom-imaging-out-of-sow-scope.md) | DICOM / imaging mirror out of SOW scope | Out of scope |
| [010](../../../docs/adr/010-technology-stack.md) | Technology stack | System / deployment |
| [011](../../../docs/adr/011-do-not-build.md) | Explicit do-not-build decisions | Scope guardrails |
| [012](../../../docs/adr/012-c4-persons-vs-stakeholders.md) | C4 Persons vs SAD stakeholders | Business context |
| [013](../../../docs/adr/013-multitenancy-silo-and-bridge.md) | Dual-mode multitenancy (Silo vs Bridge) | Tenancy |
| [014](../../../docs/adr/014-sqs-messaging-patterns.md) | SQS messaging patterns | Messaging |
| [015](../../../docs/adr/015-aws-deployment-reference.md) | AWS reference deployment topology | Deployment (Ladder A) |
| [016](../../../docs/adr/016-git-branching-and-delivery-ladders.md) | Git branching and dual delivery ladders | Deployment / ops; Ladder A vs B |

Register / index: [`docs/adr/README.md`](../../../docs/adr/README.md).

## Agent documentation (`docs/ai/*`)

| Document | Role |
|----------|------|
| [PROJECT_CONTEXT.md](../../../docs/ai/PROJECT_CONTEXT.md) | Business purpose, stakeholders, success metric |
| [ARCHITECTURE.md](../../../docs/ai/ARCHITECTURE.md) | Components, boundaries, data flow |
| [CURRENT_STATE.md](../../../docs/ai/CURRENT_STATE.md) | What exists vs to-be-built |
| [ENGINEERING_RULES.md](../../../docs/ai/ENGINEERING_RULES.md) | Stack, conventions, do/don’t |
| [SECURITY.md](../../../docs/ai/SECURITY.md) | PHI boundary, auth, BAAs |
| [TESTING.md](../../../docs/ai/TESTING.md) | Validation before “done” |
| [GLOSSARY.md](../../../docs/ai/GLOSSARY.md) | Shared vocabulary (canonical terms) |
| [NFR.md](../../../docs/ai/NFR.md) | Non-functional requirements; ASR rows binding |

Also: [`AGENTS.md`](../../../AGENTS.md) (invariants) · [`kb/`](../../../kb/) (source evidence).

## NFR / ASR exports

| Document | Role |
|----------|------|
| [`output_docs/nfr/NFR_CATALOG.md`](../../nfr/NFR_CATALOG.md) | Full NFR catalog |
| [`output_docs/nfr/ASR_CHECKLIST.md`](../../nfr/ASR_CHECKLIST.md) | ASR checklist (binding) |
| [Chapter 14](14-nfr-and-quality-attributes.md) | SAD summary of ASRs |

## Deployment

| Document | Role |
|----------|------|
| [ADR-015](../../../docs/adr/015-aws-deployment-reference.md) | AWS reference topology decision (Ladder A) |
| [ADR-016](../../../docs/adr/016-git-branching-and-delivery-ladders.md) | Dual delivery ladders; branching Confirmed (PWA) / Proposed (platform) |
| [`kb/customer-reference/touchscreen-ux-devops-extract.md`](../../../kb/customer-reference/touchscreen-ux-devops-extract.md) | touchscreen-ux Git / Netlify / TTV / Esper extract (Ladder B) |
| [`docs/architecture/deployment/aws-production-deployment.md`](../../../docs/architecture/deployment/aws-production-deployment.md) | Production deployment MD |
| [Chapter 13](13-deployment-and-infrastructure.md) | SAD deployment topology (AWS) |
| [Chapter 17](17-ci-cd.md) | SAD CI/CD — dual delivery ladders A/B |
| Diagrams `17-*` / `18-*` | Stakeholder overview + technical production deploy |
| Diagrams `19-*` / `20-*` | Ladder A (platform) + Ladder B (device/PWA) CI/CD |

## Diagram catalog

| Catalog | Contents |
|---------|----------|
| [`output_diagrams/README.md`](../../../output_diagrams/README.md) | Source + PNG index (01–20) |
| [`output_docs/output_diagrams/`](../../output_diagrams/) | Export mirror for chapter embeds |

From chapter files, embed diagrams with Markdown image syntax and relative path `../../output_diagrams/<name>.png` (see pack README).

## Pack trackers

| Document | Role |
|----------|------|
| [`../README.md`](../README.md) | Pack purpose and chapter index |
| [`../PROGRESS.md`](../PROGRESS.md) | Maturity bands |
| [`../COVERAGE.md`](../COVERAGE.md) | Checklist / white spots |
| [`../WORD_TEMPLATE_CROSSWALK.md`](../WORD_TEMPLATE_CROSSWALK.md) | Markdown → Word section map (when present) |
| [`../_snippets/callouts.md`](../_snippets/callouts.md) | Status callout HTML |

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> Keep this chapter as the single “table of sources” for reviewers; deepen narrative in domain chapters rather than duplicating ADR text here.
</p>
