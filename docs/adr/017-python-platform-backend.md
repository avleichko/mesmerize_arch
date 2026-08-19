# ADR-017: Platform backend language — Python (supersedes NestJS / TypeScript)

- **Status:** Accepted (stakeholder direction 2026-08-06; supersedes ADR-010 **S3** and **S5** for Platform API; **S8** aligned to customer **D-07** multi-repo 2026-08-19)
- **Date:** 2026-08-06 (repo strategy amendment 2026-08-19)
- **Supersedes:** [ADR-010](010-technology-stack.md) rows **S3** (NestJS / TypeScript) and **S5** (Prisma); amends **S8** from one polyglot git repo to **per-service GitHub repositories**
- **Does not supersede:** ADR-010 **S1–S2**, **S4**, **S6–S7**, **S9–S15**; ADR-007 Socket.io protocol; ADR-014 messaging; ADR-015/016 delivery ladders
- **Sources:** Stakeholder instruction (architecture working session 2026-08-06); customer `INFRASTRUCTURE.md` **D-07** (2026-08-11); [`docs/architecture/customer-monorepo-analysis.md`](../architecture/customer-monorepo-analysis.md)

## Context

ADR-010 selected **NestJS / TypeScript** + **Prisma** for the Platform API and a single Turborepo. Stakeholders directed that the **platform backend language is Python**. Customer **D-07** (2026-08-11) settled **multi-repo**: the GitHub repo named `mesmerize-monorepo` holds **docs and infrastructure description only**; each deployable service is its own repository with its own OIDC pipeline.

This ADR previously described a **polyglot monorepo** (pnpm + uv in one git tree). That layout **conflicts with D-07**. Repo strategy now follows D-07. Python/FastAPI and SQLAlchemy are unchanged.

## Decision

| # | Area | Prior (ADR-010) | New decision |
|---|------|-----------------|--------------|
| **S3** | Backend | NestJS / TypeScript | **Python** platform services. Reference framework: **FastAPI** (async HTTP, OpenAPI). Logical service boundaries unchanged (session, content, device-realtime, engagement, billing-evidence, org-identity, audit-telemetry). |
| **S5** | ORM / migrations | Prisma | **SQLAlchemy 2** + **Alembic** (PostgreSQL 16 unchanged — S4). |
| **S7** | Realtime | Socket.io | **Unchanged protocol** (ADR-007). Server implementation: **python-socketio** (or equivalent) compatible with existing Socket.io device clients. |
| **S8** | Repo layout | One Turborepo / npm workspaces tree | **Multi-repo:** each deployable service in its **own GitHub repository**, own AWS account(s) as appropriate, own GitHub Actions **OIDC** deploy role ([D-07](../../customer-kb/INFRASTRUCTURE.md), [D-06](../../customer-kb/INFRASTRUCTURE.md)). TypeScript services: **pnpm** (Turborepo optional **inside that repo**). Python API: **uv** or **Poetry** **in the API repo**. Do not require NestJS in the API tree. Do not require a single polyglot git monorepo. |

### Clarifications

1. **Language Confirmed = Python** for Platform API / NestJS-replacement services.
2. **FastAPI** is the **reference framework** for this ADR. A different Python web framework requires a superseding ADR.
3. Names such as `smart-app`, `platform-api`, and shared libraries are **logical modules**. Physical git = **per-service repos** indexed in the customer README. Exact slugs are **Proposed** until [SAD Q-17](../../output_docs/sad/chapters/18-assumptions-and-open-questions.md).
4. Customer GitHub `mesmerize-monorepo` is **not** the platform code home (docs + `INFRASTRUCTURE.md` only).
5. Exam-room imaging **display** is in scope ([ADR-019](019-exam-room-imaging-display-and-evidence.md)); still **no** Mesmerize DICOM viewer / server imaging payloads (DNB-9).
6. PHI / FHIR-token invariants unchanged ([ADR-002](002-zero-phi-on-mesmerize-servers.md)): no patient identifiers on Mesmerize servers; EHR token stays in the browser. Imaging path may send artifact **kind / opaque id** (not pixels) per ADR-019.
7. Ladder A CI is **per service repo**: Python-first gates for the API repo; Node gates in frontend repos ([ADR-016](016-git-branching-and-delivery-ladders.md); `docs/ci-templates/` as examples, not this docs repo’s pipelines).

## Consequences

- Update agent docs, SAD Chapters 08 / 13 / 17 / **21**, ENGINEERING_RULES, and CI stubs to Python/FastAPI + SQLAlchemy/Alembic **and** multi-repo.
- NestJS / Prisma / one-repo Turborepo in older strategy docs are **historical**.
- ECS/Fargate API images are **Python** base images (not Node) for Ladder A.
- Staffing briefs that require NestJS seniors must be revised for Python/FastAPI.
- Open: exact Python version pin (Q-15); uv vs Poetry; **exact GitHub repo slugs (Q-17)**.
