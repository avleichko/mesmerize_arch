# Development kickoff infra request (SAD Ch.21) + ADR-017 multi-repo — design

- **Date:** 2026-08-19
- **Status:** Draft for user review (brainstorming gate)
- **Sources:** `customer-kb/INFRASTRUCTURE.md` D-01–D-07; customer README (SSO / accounts); ADR-010, ADR-013, ADR-015, ADR-016, ADR-017, ADR-018; SAD Ch.17–18; user choices: sequenced gates **C**, Ladder B stub **C**, git **D-07 service repos (A)**, ADR-017 **rewrite in place (B)**, starter repos **Proposed set (A)**, deliverable **SAD Ch.21 (B)**, structure **Approach 1 / user A**

## Goal

Give Mesmerize infrastructure stakeholders a **SAD Chapter 21** they can tick: technical needs from the Newfire **dev team** so **Ladder A** development can start — GitHub service repos, AWS environments, CI/CD (OIDC, not static keys), identity, monitoring — in **three gates** (now → first staging deploy → production). Align this pack’s **repo strategy** with customer **D-07** by rewriting **ADR-017 in place** (keep Python/FastAPI + SQLAlchemy) and rippling live “polyglot monorepo” wording. Push after implementation.

## Non-goals

- Implementing Terraform, OIDC, or AWS resources
- Closing `D-xx` conflicts (Region, tenancy, blue-green, shared accounts, **IaC tool**) — **cite and Ask**
- Inventing CIDR, RTO/RPO, numeric SLOs, observability vendor, or Confirmed GitHub repo slugs
- New diagram catalog IDs (Ch.21 is tables-only)
- Filling the Word SAD template
- Full Ladder B (device/PWA) — **stub appendix only**
- New ADR-020; do not `git rm` ADRs
- Storing AWS credentials in GitHub (forbidden — D-06)

## Decisions (locked)

| ID | Choice |
|----|--------|
| Shape | Sequenced **Now / Staging / Prod** registers (Approach 1) |
| Ladders | **Ladder A** fully specified; **Ladder B** stub appendix |
| Repos | Customer **D-07** per-service repos; not a platform monorepo |
| Starter repos | **Proposed:** clinician SMART app, platform API (Python/FastAPI), infra/Terraform — names Ask until README index |
| Deliverable | SAD **Chapter 21** (same field table / callouts as Ch.18) |
| ADR-017 | **Rewrite in place:** multi-repo; keep Python/FastAPI + SQLAlchemy 2 + Alembic |
| Diagrams | None new |
| Push | Architecture `main` + copy into `architecture/` on `docs/architecture-working-pack` |

## SAD Chapter 21

**File:** `output_docs/sad/chapters/21-infra-provision-checklist.md`

**Field table:** Chapter ID `21-infra-provision-checklist`; SAD mapping Mesmerize extension; Last updated 2026-08-19; Maturity Review-ready.

**Audience:** Mesmerize infra / GitHub / IAM Identity Center owners. **From:** Newfire delivery. Does **not** create `D-xx` rows.

**How to use:** Each register row = Need | Already settled (`D-xx` / ADR) | Ask (who / what). Callouts: Confirmed only from `D-xx` or Accepted ADRs; Proposed starter names; Unknown for open vendor/Region/CIDR/SLO.

### Gate 1 — Now (unblock coding)

- GitHub org membership for named Newfire engineers
- Write access to `MJHLS/mesmerize-monorepo` (docs; no pipelines — D-06/D-07)
- Create **Proposed** empty service repos: SMART app, platform API, infra/Terraform — **Ask exact slugs**; then index in customer README
- IAM Identity Center only (D-02): request via Mackenzie Clark / groups in customer README; no IAM users; no long-lived keys
- Confirm published SSO start URL

### Gate 2 — Before first staging deploy

- Per-repo GitHub OIDC → AWS deploy role; trust pinned to repo + deploying branch/environment (D-06)
- GitHub Environment `staging`
- Target account: shared staging `301478651732` (D-01) **or** new per-service account — **Ask** (register: fate of shared accounts open)
- Region: customer **D-01 `us-east-2`** vs this pack **Q-07** — **Ask**, do not pick
- Who provisions VPC / ECS / ALB / ECR / RDS Postgres (D-03) / Redis (ADR-015): Mesmerize vs Newfire in infra repo — **Ask**
- IaC tool: customer register **open** vs ADR-010 Terraform — **Ask**
- Observability: **Q-09** Unknown; Ask CloudWatch-only interim vs wait
- Never AWS access keys in GitHub

### Gate 3 — Before production

- GitHub Environment `production` + required reviewers (D-06)
- Prod account `063293864447` (D-01)
- D-05 **blue-green** vs SAD **A-03 rolling** — **Ask**
- Who promotes Staging → Prod (**Q-13**)
- BAA / HIPAA logging pack (**Q-03**, **Q-09**, **Q-14**)
- D-05 consequence: expand/contract migrations (same DB during traffic shift)

### Conflicts subsection (required)

| Tension | Customer | This pack | Ch.21 action |
|---------|----------|-----------|--------------|
| Region | D-01 `us-east-2` | Q-07 | Ask |
| Tenancy compute | D-04 one container/tenant | ADR-013 Bridge | Ask |
| Prod deploy | D-05 blue-green | A-03 rolling | Ask |
| IaC | Open | ADR-010 Terraform | Ask |
| Shared accounts | Open | — | Ask |

### Appendix — Ladder B stub

Short table: later need `touchscreen-ux` / extend-PWA access, Netlify ≠ device, TTV filesync, Esper. No fake owners. Do not describe Ladder A as Netlify/TTV.

### Ch.18

Add **Q-17**: ratify exact GitHub **service repo slugs** (and org) for the Proposed starter set. Point Ch.21 at Q-16 unchanged (imaging). Do not invent more Q-rows for items already Q-07/Q-09/Q-13.

### Ripple SAD index

`output_docs/sad/README.md`, `COVERAGE.md`, `PROGRESS.md` (21 chapters). Ch.03 related documents: Ch.21 + rewritten 017.

## ADR-017 rewrite (in place)

Keep: Python/FastAPI; SQLAlchemy 2 + Alembic; python-socketio; no NestJS/Prisma as target.

Replace: polyglot monorepo / pnpm+Turborepo+uv as **one repo**. New decision: **per-service GitHub repositories** per D-07; OIDC per repo (D-06); index in customer README. Logical names (`smart-app`, `platform-api`, packages) may remain as **module** language, not “clone one monorepo.”

**ADR-010 S8:** multi-repo (per service). Stack S3–S5 still 017.

**Ripple:** `docs/adr/README.md` S8; `AGENTS.md`; `docs/ai/{ENGINEERING_RULES,ARCHITECTURE,CURRENT_STATE}.md`; SAD Ch.02, 08, 17 (captions: logical layout vs physical service repos); `docs/architecture/customer-monorepo-analysis.md` if it still implies a NestJS/pnpm **code** monorepo as the build target.

**Do not** rewrite 002/003/019 imaging/PHI except stray “the monorepo” phrases. Do not delete ADRs.

## Evidence tagging

- D-01–D-07 rows in Ch.21 = **Confirmed** as customer-signed (not this pack inventing them)
- Starter repo **names** = **Proposed** until Q-17
- Terraform as *the* IaC = **Proposed** in this pack until customer `D-xx` or Ask resolves
- Observability vendor = **Unknown**

## Implementation order (for later plan)

1. Rewrite ADR-017 + ADR-010 S8 + ADR README  
2. Ripple AGENTS.md + docs/ai + SAD 02/08/17 + analysis note  
3. Write Ch.21 + Ch.18 Q-17 + pack index  
4. Mirror `output_docs/docs/adr/`  
5. Commit + push architecture `main`; copy into monorepo `architecture/` branch and push  

## Spec self-review

- No TBD except exact GitHub slugs (explicitly Proposed / Q-17)
- No silent pick on D-04/D-05/Q-07/IaC
- D-07 and ADR-017 rewrite agree
- Ch.21 has no new diagram IDs
- PHI: no credentials, no patient data in the chapter
