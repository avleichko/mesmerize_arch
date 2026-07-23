# CURRENT_STATE

> **Sources:** Implementation Context §1, Mesmerize Responses Q&A, SOW #3 phasing, Sprint Plan (architecture repo), Jul 14 notes.  
> **As of kb corpus (~July 2026 discovery).** Re-verify against live repos before large refactors.

## Snapshot

| Area | State |
|------|--------|
| Product strategy | **Content Evidence Platform v2** adopted (not Redox control plan; not ambient-scribe SMART v1) |
| Delivery contract | **SOW #3** with Newfire — Sprint 0 / Phase 1 discovery & foundations through Phase 4 pilot |
| Pilot EHR | **athenahealth** first; Epic/Cerner roadmap analysis in Phase 1 |
| Live devices | ~**4,400** exam-room/touchscreen devices (~3,480 active) on Esper + TelemetryTV |
| Live PWA | `MesmerizeTeam/touchscreen-ux` — specialty/slug content, **no ICD-10 tags** |
| New platform monorepo | Initialized (`mesmerize-platform/`): Turborepo, NestJS skeleton, React 19/Vite placeholders, Prisma v1, Docker Compose, package stubs |
| POC reference | `poc-ecosystem/` feature-complete demo (multi-device Socket.io, BioDigital, ICD-10 mapping demo, billing logic demo) |
| ICD-10 content tagging | **Low/partial** for new corpus; **0** on current PWA topics — Phase 1 mapping deliverable |
| Imaging mirror / DICOM | Documented in architecture; **out of SOW #3**; needs further discussion per Jul 14 |
| Admin error-correction UI | Deferred |
| Compliance owner / billing rules owner | **Open** in Q&A |

## What exists today (carry forward)

From **POC** (Implementation Context): multi-device journey demo, Socket.io sync, BioDigital embeds, ICD-10→content mapping engine (demo), billing logic samples, shared TS types, brand tokens.

From **mesmerize-platform**: monorepo, NestJS modules + health, Prisma + seed, React placeholder pages, Tailwind brand preset, stubs including billing-engine / ui / (legacy) ai-services & fhir-client to be removed or replaced.

From **operations**: Esper MDM, TelemetryTV, proof-of-play telemetry, condition-targeted **ad** campaigns (useful head start, not the same as clinical ICD-10 content tags), athena Marketplace Developer Console account (sandbox details to confirm).

## What must change vs older skeletons

| Asset | Action |
|-------|--------|
| `packages/ai-services` | Remove |
| `packages/fhir-client` EHR adapters | Replace with `packages/fhir-engagement` |
| Patient / med / allergy / coverage / transcript / note Prisma models | Remove |
| Redox config | Remove |
| Session APIs | Ensure no patient identifiers |
| `apps/smart-app` | Add |
| ICD-10 metadata on content | Build (Phase 1) |
| Device room mapping | Close gap for pilot targeting |
| Socket.io push + pairing on extended PWA | Net-new vs live slug PWA |

## SOW #3 phase status (programmatic)

| Phase | Focus | Acceptance themes (summary) |
|-------|--------|-----------------------------|
| 1 | Requirements, UX research, architecture blueprint, CI/CD, app shell | Wireframes, journey map, EHR-agnostic blueprint, Epic/Cerner roadmap, SDLC, CI/CD, Phase 2 plan |
| 2 | Core build + demo | Hi-fi UX, SMART + content + device push + engagement + billing evidence + writeback capability, usage data, basic admin dashboard |
| 3 | Hardening / analytics | Recommendation tuning rounds, observability, security/pen test, richer analytics as scoped |
| 4 | Pilot | Single healthcare org on athena production path; validated writeback subject to customer approval |

Exact calendar: SOW text is authoritative; architecture Sprint Plan also targets Tier-1 ship windows — **reconcile dates with current project plan** rather than inventing a new schedule here.

## Environments (proposed/confirmed mix)

- Dev / Staging / Prod (Q&A).
- Staging ↔ athena sandbox; Prod ↔ single pilot (Phase 4).
- Jul 14: establish Athena sandbox; align new AWS account for storage (action items in notes).

## Known risks affecting implementation

- Content metadata incompleteness blocking recommendation quality.
- Device↔room mapping incomplete.
- Writeback depends on customer/EHR configuration.
- Imaging scope confusion (architecture vs SOW) — keep out of delivery until ADR/SOW update.
- Open ownership for billing rule definition and compliance sign-off.

## What agents should assume

- Prefer **Content Evidence** docs over any ambient/Redox materials in `kb/`.
- Treat production PWA as **extend, don’t overwrite in place**.
- Treat Patient Imaging Mirror as **non-goals for SOW #3 coding tasks**.
- Re-check live GitHub repos for drift; this file describes kb-reported state, not a live `git status`.
