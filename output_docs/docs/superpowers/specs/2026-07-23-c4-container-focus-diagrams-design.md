# Design: C4 Container-Focus Diagrams (06a–06h) + Chapter 08 Update

**Date:** 2026-07-23  
**Status:** Draft for user review  
**Approach:** One PlantUML C4 container-focus diagram per NestJS service (Approach 1)  
**Parent diagram:** `output_diagrams/06-c4-containers`  
**SAD target:** `output_docs/sad/chapters/08-system-architecture.md`

## Problem

Chapter 08 embeds the full C4 container diagram (`06`) but does not show each NestJS service’s full neighborhood in isolation. Stakeholders and implementers need per-service views of all relations (Confirmed from `06` + Inferred from ADRs/ARCHITECTURE) with short SAD prose.

## Goals

1. Produce eight C4 **container-focus** PlantUML diagrams (`06a`–`06h`), one per NestJS service from `06`.  
2. Each diagram shows **all relations** of that subject (no orphaned Confirmed edges from `06`).  
3. Update Chapter 08 with a **subsection per service**: purpose, relations table, figure, short prose.  
4. Catalog + export mirrors; COVERAGE updated for ch.08 diagrams.  
5. Implementation uses **parallel agents** (one per diagram) after the plan is approved.

## Non-goals

- True C4 **Component** diagrams (modules inside NestJS).  
- Focus diagrams with Gateway / SMART / Device PWA / Postgres / Redis / S3 / SQS as the *subject*.  
- Inventing undeclared REST route catalogs, SLOs, Region, or RTO/RPO.  
- Claiming Confirmed for edges not on `06` or not evidenced in ADR/ARCHITECTURE (those are **Inferred** only).

## Decisions (brainstorming)

| # | Choice |
|---|--------|
| 1 | **B** — C4 container-focus (not module-level Component) |
| 2 | **A** — NestJS services only |
| 3 | **A** — PlantUML C4 (PNG rendered for SAD embeds) |
| 4 | **C** — Catalog IDs `06a`…`06h` |
| 5 | **B** — Edges from `06` + Inferred from ADRs/ARCHITECTURE (tagged) |
| 6 | **B** — Ch.08 subsection per service |
| 7 | **Yes** — parallel agents at implementation |
| Approach | **1** — eight diagrams including optional ads-service |

## Catalog

| ID | File stem | Subject container |
|----|-----------|-------------------|
| 06a | `06a-c4-focus-session-service` | session-service |
| 06b | `06b-c4-focus-content-service` | content-service |
| 06c | `06c-c4-focus-device-realtime-service` | device-realtime-service |
| 06d | `06d-c4-focus-engagement-service` | engagement-service |
| 06e | `06e-c4-focus-billing-evidence-service` | billing-evidence-service |
| 06f | `06f-c4-focus-org-identity-service` | org-identity-service |
| 06g | `06g-c4-focus-audit-telemetry-service` | audit-telemetry-service |
| 06h | `06h-c4-focus-ads-service` | ads-service (optional clinical path) |

Artifacts per ID: `.puml` + `.png` under `output_diagrams/` and mirrored under `output_docs/output_diagrams/`.

## Diagram conventions

- `!include` C4_Container.puml (same pattern as `06-c4-containers.puml`).  
- Title: `Mesmerize — C4 Container Focus — {service-name}`.  
- Draw the subject + every neighbor connected by a Confirmed or Inferred Rel; omit unrelated containers.  
- Rel labels: protocol/bus (REST, Socket.io, SQS, R/W, OIDC, etc.).  
- Tag Inferred relations in the label or a note: `[Inferred]`.  
- Where relevant, note zero-PHI / no EHR token to Mesmerize APIs.  
- `SHOW_LEGEND()` optional if cluttered; prefer a one-line evidence note on the diagram.  
- Render with existing PlantUML jar + OpenJDK path used for other diagrams.

## Relations inventory (baseline)

### Confirmed (from `06-c4-containers.puml`)

| Subject | Relations |
|---------|-----------|
| session-service | ← Gateway REST; → SQS (session.started/ended); → Postgres R/W |
| content-service | ← Gateway REST; → SQS (CMS sync / content.updated); → Postgres; → S3; → Sanity; → BioDigital; → MJH |
| device-realtime-service | ← Gateway REST; ↔ Device PWA Socket.io; → SQS (device.command.*); → Postgres; → Redis; → Esper |
| engagement-service | ← Gateway REST; ← SQS (engagement.recorded); → Postgres |
| billing-evidence-service | ← Gateway REST; ← SQS (session.ended / engagement.completed); → Postgres |
| org-identity-service | ← Gateway REST; → Postgres; → Auth0 |
| audit-telemetry-service | ← SQS (*.audit / diagnostic); (no Gateway Rel on 06) |
| ads-service | ← Gateway REST; → Postgres; → S3 |

### Inferred (must cite source in Ch.08 relations table)

| Subject | Inferred relation | Source hint |
|---------|-------------------|-------------|
| session | SMART creates/uses opaque session via Gateway (ICD-10 + deviceGroup + sessionId only) | ARCHITECTURE, ADR-002, ADR-008 |
| content | SMART recommend via Gateway | ARCHITECTURE |
| device-realtime | SMART push/pair commands via Gateway | ADR-007 |
| engagement | SMART/admin read timelines via Gateway | ADR-008 |
| billing-evidence | Approve in SMART; DocumentReference writeback is **browser→EHR**, not service→EHR | ADR-003, ADR-008 |
| org-identity | Command Center / admin JWT | ADR-010 / ARCHITECTURE |
| audit | Consumes diagnostic events only; no PHI | ADR-002, ADR-014 |
| ads | Optional; not on critical clinical path | ADR-011 / ARCHITECTURE optional ads |

Implementation must not invent additional service-to-service REST meshes beyond SQS patterns in ADR-014 unless already stated in ARCHITECTURE.

## Chapter 08 structure

Keep existing purpose, narrative, Figure 8-1 (full containers), monorepo section.

Add after Figure 8-1 (or after Component Responsibilities, as fits reading order):

```
## Container focus diagrams (NestJS services)

Intro: one paragraph — these are container-focus views derived from diagram 06;
Confirmed vs Inferred.

### session-service
purpose · relations table · ![06a] · figure caption · 1 short ownership paragraph

### content-service
…

### device-realtime-service
…

### engagement-service
…

### billing-evidence-service
…

### org-identity-service
…

### audit-telemetry-service
…

### ads-service
… (optional path called out)
```

Relations table columns: Neighbor | Direction | Mechanism | Evidence (Confirmed / Inferred + cite).

Update Evidence list to include `06a`–`06h`. Update COVERAGE chapter 08 required-diagrams item. Update `output_diagrams/README.md` (+ mirror).

## Parallel implementation note

After writing-plans + user picks Subagent-Driven (or plan mandates parallel):

- Dispatch up to **8 diagram implementers** in parallel (one `06x` each).  
- Then one wiring task for ch.08 + README + COVERAGE.  
- Review gates per plan (batch review OK for mechanical diagram tasks).

## Guardrails

- Do not invent SLOs, Region, route catalogs.  
- Do not put EHR FHIR token on Mesmerize containers.  
- Do not claim Netlify/TTV for NestJS services.  
- ads-service marked optional in SAD prose.  
- Commit only if the user explicitly requests.

## Success criteria

- [ ] Eight `.puml` + `.png` (`06a`–`06h`) exist and mirror under `output_docs/output_diagrams/`.  
- [ ] Each diagram includes all Confirmed neighbors from `06` for that subject.  
- [ ] Inferred edges tagged and cited in ch.08 tables.  
- [ ] Ch.08 has subsection + prose + figure per service.  
- [ ] Catalog README and COVERAGE updated.  
- [ ] Parallel agents used for diagram generation as planned.

## Implementation note

After this spec is approved, create an implementation plan via `writing-plans` that enables parallel diagram tasks.
