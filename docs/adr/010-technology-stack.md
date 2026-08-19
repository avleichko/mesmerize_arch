# ADR-010: Technology stack (platform reference architecture)

- **Status:** Accepted (reference architecture; CTO ratification noted as ongoing in kb where applicable). **Partial supersession:** **S3** and **S5** updated by [ADR-017](017-python-platform-backend.md) (2026-08-06) — Platform backend is **Python / FastAPI**; ORM is **SQLAlchemy 2 + Alembic**. NestJS / Prisma rows below are **historical**.
- **Decisions:** Stack register #S1–#S15 (see table; S3/S5/S8 per ADR-017)
- **Sources:** Architecture v2.0 monorepo/infra, Implementation Context, Mesmerize Responses Q&A (Technical Constraints), cost/observability notes citing Datadog; ADR-017

## Context

Delivery needs a single, agent-visible stack so Newfire and Mesmerize implementers do not diverge across SMART app, Platform API, devices, and AWS environments.

## Decision

| # | Area | Decision |
|---|------|----------|
| S1 | Frontend | **React 19**, **TypeScript**, **Vite**, **Tailwind** |
| S2 | SMART library | **`fhirclient.js`** (`fhirclient` npm) |
| S3 | Backend | **Python** / **FastAPI** ([ADR-017](017-python-platform-backend.md); was NestJS / TypeScript) |
| S4 | Database | **PostgreSQL 16** |
| S5 | ORM | **SQLAlchemy 2** + **Alembic** ([ADR-017](017-python-platform-backend.md); was Prisma) |
| S6 | Cache / realtime support | **Redis 7** |
| S7 | Realtime communication | **Socket.io** (Python server: **python-socketio** — ADR-017) |
| S8 | Repo layout | **Multi-repo (per service)** per customer **D-07** / [ADR-017](017-python-platform-backend.md); **pnpm** inside each TS service repo; **uv** or **Poetry** inside the Python API repo. Not a single polyglot git monorepo. |
| S9 | Auth | **EHR OAuth (SMART)** for clinician SMART app; **Auth0 + RBAC** for admin / Command Center |
| S10 | Device management | **Esper MDM** + existing **TelemetryTV / PWA** fleet (integrate; do not build a new MDM) |
| S11 | Content | **Sanity CMS** + **BioDigital** + **MJH / Pharmacy Times** + current **PWA JSON** content |
| S12 | Infrastructure | **Mesmerize-owned AWS** |
| S13 | Infra components | **ECS/Fargate**, **RDS PostgreSQL**, **ElastiCache/Redis**, **S3**, **CloudFront** |
| S14 | IaC / CI/CD | **Terraform** + **GitHub Actions** |
| S15 | Observability | **Mesmerize-approved monitoring**; **Datadog** appears in the reference architecture (confirm final vendor/config with Mesmerize) |

### Clarifications

- SMART clinician auth remains **3-legged EHR OAuth** ([ADR-005](005-smart-oauth-ehr-launch-mvp-scopes.md)); Auth0 is **not** the SMART app login for MVP clinicians.
- RBAC for Command Center timing may still be phased (kb Q&A); the **Auth0 + RBAC** direction is confirmed even if full RBAC lands after initial surfaces.
- Device realtime uses Socket.io per [ADR-007](007-extend-pwa-server-mediated-devices.md); Redis supports cache/session/realtime infrastructure needs alongside Postgres.
- Observability: prefer Mesmerize-approved tooling; treat Datadog as the documented reference unless Mesmerize specifies otherwise. Jul 14 notes also describe Kinesis/S3 diagnostic logging patterns — those are complementary logging architecture, not a replacement for this stack choice.

## Consequences

- Agents default to this stack (with S3/S5/S8 as amended by ADR-017); alternative frameworks require a superseding ADR + human approval.
- Local Docker Compose should align on PostgreSQL 16 + Redis 7.
- New MDM, non-AWS prod hosts, or replacing FastAPI/Python, SQLAlchemy, or React without ADR are rejected by default. Reintroducing NestJS/Prisma as the Platform API target requires superseding ADR-017.
- Content integrations must account for **both** Sanity/BioDigital/MJH **and** existing PWA JSON (extend, don’t ignore fleet content — [ADR-007](007-extend-pwa-server-mediated-devices.md)).
