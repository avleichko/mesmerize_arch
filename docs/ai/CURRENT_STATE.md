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
| New platform monorepo | Customer scaffold at `~/myProjects/newfire/mesmerize-monorepo` (pnpm/Turborepo, NestJS-labeled `apps/api` stubs, React/TS device + SMART apps). **Delivery backend language = Python / FastAPI** ([ADR-017](../adr/017-python-platform-backend.md)) — re-scaffold API; see [`customer-monorepo-analysis.md`](../architecture/customer-monorepo-analysis.md) |
| POC reference | `poc-ecosystem/` feature-complete demo (multi-device Socket.io, BioDigital, ICD-10 mapping demo, billing logic demo) |
| ICD-10 content tagging | **Low/partial** for new corpus; **0** on current PWA topics — Phase 1 mapping deliverable |
| Imaging mirror / DICOM | Documented in architecture; **out of SOW #3**; needs further discussion per Jul 14 |
| Admin error-correction UI | Deferred |
| Compliance owner / billing rules owner | **Open** in Q&A |

## What exists today (carry forward)

From **POC** (Implementation Context): multi-device journey demo, Socket.io sync, BioDigital embeds, ICD-10→content mapping engine (demo), billing logic samples, shared TS types, brand tokens.

From **mesmerize-monorepo** (customer): pnpm workspace stubs for api / smart-launcher / exam-room / waiting-room; PR template with PHI gate; strategy docs aligned to Content Evidence. NestJS/Prisma direction in those stubs is **superseded** by ADR-017 (Python). `packages/webrtc` is **out of SOW**.

From **operations**: Esper MDM, TelemetryTV, proof-of-play telemetry, condition-targeted **ad** campaigns (useful head start, not the same as clinical ICD-10 content tags), athena Marketplace Developer Console account (sandbox details to confirm).

## What must change vs older skeletons

| Asset | Action |
|-------|--------|
| NestJS `apps/api` scaffold | Replace with **Python / FastAPI** (ADR-017) |
| Prisma schemas / Nest modules | Replace with **SQLAlchemy 2 + Alembic**; no patient/note/transcript tables |
| `packages/ai-services` | Remove if present |
| `packages/fhir-client` EHR adapters | Replace with browser `fhir-engagement` formatting only |
| `packages/webrtc` / imaging mirror | **Do not build** (ADR-009) |
| Redox config | Remove |
| Session APIs | Ensure no patient identifiers |
| `apps/smart-app` / `smart-launcher` | Keep TS SMART path; wire ICD-10 session create |
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
- Dual delivery ladders (platform GHA→ECS vs device/PWA): [ADR-016](../adr/016-git-branching-and-delivery-ladders.md).

## Known risks affecting implementation

- Content metadata incompleteness blocking recommendation quality.
- Device↔room mapping incomplete.
- Writeback depends on customer/EHR configuration.
- Imaging scope confusion (architecture vs SOW) — keep out of delivery until ADR/SOW update.
- Open ownership for billing rule definition and compliance sign-off.
- Multitenancy dual-mode (Silo vs Bridge) per [ADR-013](../adr/013-multitenancy-silo-and-bridge.md); pilot default Bridge.

## What agents should assume

- Prefer **Content Evidence** docs over any ambient/Redox materials in `kb/`.
- Treat production PWA as **extend, don’t overwrite in place**.
- Treat Patient Imaging Mirror as **non-goals for SOW #3 coding tasks**.
- Enforce tenant isolation: Organization = tenant; clinic = sub-scope; Silo or Bridge per ADR-013.
- Re-check live GitHub repos for drift; this file describes kb-reported state, not a live `git status`.
