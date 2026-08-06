# ADR-017: Platform backend language — Python (supersedes NestJS / TypeScript)

- **Status:** Accepted (stakeholder direction 2026-08-06; supersedes ADR-010 **S3** and **S5** for Platform API)
- **Date:** 2026-08-06
- **Supersedes:** [ADR-010](010-technology-stack.md) rows **S3** (NestJS / TypeScript) and **S5** (Prisma); clarifies **S8** monorepo as polyglot
- **Does not supersede:** ADR-010 **S1–S2**, **S4**, **S6–S7**, **S9–S15**; ADR-007 Socket.io protocol; ADR-014 messaging; ADR-015/016 delivery ladders
- **Sources:** Stakeholder instruction (architecture working session 2026-08-06); customer-provided scaffold analysis [`docs/architecture/customer-monorepo-analysis.md`](../architecture/customer-monorepo-analysis.md) (`~/myProjects/newfire/mesmerize-monorepo`)

## Context

ADR-010 selected **NestJS / TypeScript** + **Prisma** for the Platform API. The customer-provided monorepo scaffold (`mesmerize-monorepo`) still mirrors that NestJS/pnpm/Turborepo shape.

Stakeholders directed that the **platform backend language is Python**. Frontends (SMART app, device UIs) remain TypeScript/React per ADR-010 S1–S2 and the customer scaffold. Continuing to document NestJS as Confirmed would mislead delivery and CI.

## Decision

| # | Area | Prior (ADR-010) | New decision |
|---|------|-----------------|--------------|
| **S3** | Backend | NestJS / TypeScript | **Python** platform services. Reference framework: **FastAPI** (async HTTP, OpenAPI). Logical service boundaries unchanged (session, content, device-realtime, engagement, billing-evidence, org-identity, audit-telemetry). |
| **S5** | ORM / migrations | Prisma | **SQLAlchemy 2** + **Alembic** (PostgreSQL 16 unchanged — S4). |
| **S7** | Realtime | Socket.io | **Unchanged protocol** (ADR-007). Server implementation: **python-socketio** (or equivalent) compatible with existing Socket.io device clients. |
| **S8** | Monorepo | Turborepo + npm/pnpm workspaces | **Polyglot:** TypeScript apps/packages via **pnpm** (+ Turborepo optional for frontends); Python API via **uv** or **Poetry** workspace. Do not require NestJS inside the Python API tree. |

### Clarifications

1. **Language Confirmed = Python** for Platform API / NestJS-replacement services.
2. **FastAPI** is the **reference framework** for this ADR (NestJS analogue). A different Python web framework requires a superseding ADR.
3. Customer scaffold `apps/api` described as NestJS is **legacy relative to this ADR** — re-scaffold or replace with Python; do not treat NestJS stubs as the build target.
4. **`packages/webrtc` / Patient Imaging Mirror** in the customer monorepo remains **out of SOW** ([ADR-009](009-dicom-imaging-out-of-sow-scope.md), DNB-9) — do not build.
5. PHI / FHIR-token invariants unchanged ([ADR-002](002-zero-phi-on-mesmerize-servers.md)): Python services still receive only ICD-10 + device group + opaque session ID; no server-side EHR token handling.
6. Ladder A CI becomes **Python-first gates** (lint/typecheck/test/build image) for API, plus separate Node gates for frontends when present ([ADR-016](016-git-branching-and-delivery-ladders.md); `docs/ci-templates/`).

## Consequences

- Update agent docs, SAD Chapters 08 / 13 / 17, ENGINEERING_RULES, and CI stubs to Python/FastAPI + SQLAlchemy/Alembic.
- NestJS / Prisma mentions in older customer strategy docs under the monorepo are **historical**; architecture repo ADRs win for Newfire delivery.
- ECS/Fargate container images for API are **Python base images** (not Node) for Ladder A.
- Staffing briefs that require NestJS seniors must be revised for Python/FastAPI.
- Open: exact Python version pin (recommend 3.12+), uv vs Poetry, and whether frontends stay in the same git repo — record under Chapter 18 if not decided in ops.
