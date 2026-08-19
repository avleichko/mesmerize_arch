# 21. Development Kickoff — Infrastructure Request

| Field | Value |
|-------|-------|
| Chapter ID | `21-development-kickoff-infrastructure-request` |
| SAD mapping | Mesmerize extension (kickoff register) |
| Last updated | 2026-08-19 |
| Maturity | Review-ready |

## Purpose of this chapter

Give Mesmerize **infrastructure / GitHub / IAM Identity Center** owners a tickable register of what the Newfire **dev team** needs so **Ladder A** (platform AWS) development can start: GitHub service repos, AWS environments, CI/CD (OIDC, not static keys), identity, and monitoring.

**From:** Newfire delivery. **To:** Mesmerize infra stakeholders.

This chapter **does not** create customer `INFRASTRUCTURE.md` `D-xx` rows. Settled customer infra remains only those signed rows. Conflicts with this pack stay **Ask** — do not pick silently.

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Repo strategy is <strong>multi-repo</strong> (customer <strong>D-07</strong>; <a href="../../../docs/adr/017-python-platform-backend.md">ADR-017</a> S8). CI/CD for every <em>service</em> repo is GitHub Actions with <strong>OIDC role assumption only</strong> — never AWS credentials in GitHub (<strong>D-06</strong>). The docs repo <code>MJHLS/mesmerize-monorepo</code> has <strong>no pipelines</strong> and deploys nothing.
</p>

## How to use

Each register row is **Need | Already settled (`D-xx` / ADR) | Ask (who / what)**.

- **Confirmed** callouts = customer `D-xx` or Accepted ADRs in this pack.
- **Proposed** = starter repo *names* until **Q-17**; Terraform as *the* IaC until customer `D-xx`.
- **Unknown** = open vendor / Region / CIDR / SLO / account-fate items — do not invent.

No new diagram IDs. Runtime AWS topology remains [Chapter 13](13-deployment-and-infrastructure.md); dual ladders [Chapter 17](17-ci-cd.md).

## Gate 1 — Now (unblock coding)

| Need | Already settled | Ask |
|------|-----------------|-----|
| GitHub org membership for named Newfire engineers | Org exists: **MJHLS** (customer README; D-07) | Named engineers + org owner grant membership (org admin) |
| Write access to `MJHLS/mesmerize-monorepo` | Docs + `INFRASTRUCTURE.md` only; **no pipelines** (D-06, D-07) | Write (or equivalent) for Newfire docs contributors; follow customer `CONTRIBUTING.md` (PR + 1 approval on `main`) |
| Create **Proposed** empty service repos: clinician SMART app, platform API (Python/FastAPI), infra/Terraform | Multi-repo required (D-07); README service-repo table is empty as of 2026-08-11 | **Exact org + slugs (Q-17)**; then index rows in customer README |
| Human AWS access: **IAM Identity Center only** | **D-02**: no IAM users, no long-lived keys. Request by messaging **Mackenzie Clark in Teams**; groups in customer README | Confirm each Newfire engineer’s group (`newfire-developers` vs `readonly-observers`) |
| Confirm published SSO start URL | Customer README: `https://d-9a675d9353.awsapps.com/start` | Confirm URL still current; CLI = `aws configure sso` (region per D-01 until Q-07 closes) |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> IAM Identity Center groups published in customer README: <code>newfire-developers</code> (PowerUser on staging, ReadOnly on production); <code>readonly-observers</code> (ReadOnly on staging and production). Access-key usage is treated as an incident (customer README; D-02).
</p>

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> Starter service set for first coding: (1) clinician SMART app (React/TS), (2) platform API (Python/FastAPI), (3) infra/Terraform. Names are <strong>not</strong> Confirmed GitHub slugs until <strong>Q-17</strong>.
</p>

## Gate 2 — Before first staging deploy

| Need | Already settled | Ask |
|------|-----------------|-----|
| Per-repo GitHub OIDC → AWS deploy role; trust pinned to **that repo** + deploying branch/environment | **D-06** | Who creates the IAM OIDC provider + deploy role in the target account (Mesmerize vs Newfire in infra repo)? |
| GitHub Environment **`staging`** on each deploying service repo | D-06 (environment-pinned trust) | Org admin: create Environments; who may deploy to `staging` |
| Target AWS account for first staging deploy | Shared staging **`301478651732`** exists (**D-01**). Register: fate of shared accounts under multi-repo is **open** | Reuse shared staging **or** new per-service account — **Ask** (do not pick) |
| AWS Region | Customer **D-01 `us-east-2`**. This pack **Q-07** still Unknown | **Ask** — do not silently pick D-01 vs Q-07 |
| Who provisions VPC / ECS / ALB / ECR / RDS Postgres / Redis | Engine **Postgres on RDS** (**D-03**). Runtime shape ADR-015 (ECS/Fargate, ElastiCache/Redis, S3, CloudFront) | Mesmerize vs Newfire in the infra repo — **Ask** |
| IaC tool | Customer register **open**. This pack ADR-010 **S14 Terraform** (Proposed until customer `D-xx`) | **Ask** — Terraform vs other; this chapter does not close `D-xx` |
| Observability for staging | **Q-09** Unknown; S15 Datadog is reference only | CloudWatch-only interim vs wait for vendor — **Ask** |
| Never store AWS access keys in GitHub | **D-06** | Confirm GitHub org secret policy; treat keys as incident |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Shared staging account ID <code>301478651732</code> and shared production <code>063293864447</code> are customer-signed (<strong>D-01</strong>), not invented here. Additional per-service accounts “as appropriate” is also D-01 — whether first staging uses the shared account remains <strong>Ask</strong>.
</p>

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> Until Mesmerize signs an IaC <code>D-xx</code>, Newfire plans Terraform in a dedicated infra repo (ADR-010 S14). That is this pack’s default, not a customer-register close.
</p>

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> Observability vendor and PHI-safe log split (<strong>Q-09</strong>); CIDR / VPC layout; numeric SLOs. Do not invent them to unblock Gate 2.
</p>

## Gate 3 — Before production

| Need | Already settled | Ask |
|------|-----------------|-----|
| GitHub Environment **`production`** + required reviewers | **D-06** | Named reviewers; org admin creates Environment protection rules |
| Production AWS account | Shared prod **`063293864447`** (**D-01**) | Same shared-vs-per-service Ask as Gate 2, for prod |
| Production deploy strategy | Customer **D-05 blue-green** (ECS-native; no CodeDeploy). This pack **A-03 rolling** for Phase 1 | **Ask** — do not pick D-05 vs A-03 |
| Who promotes Staging → Prod | **Q-13** open | Ops / eng lead + gates |
| BAA / HIPAA logging pack | **Q-03**, **Q-09**, **Q-14** | Compliance / AM timeline |
| Schema migrations during traffic shift | **D-05** consequence: blue and green share the **same database** — expand/contract (backward-compatible) migrations | Confirm this is a standing code-review rule in each **service** repo |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> If Mesmerize holds D-05, production traffic shift uses ECS-native blue/green against one database; expand/contract migrations are mandatory (customer <code>INFRASTRUCTURE.md</code> D-05). Staging remains rolling under that same row.
</p>

## Conflicts (do not auto-close)

| Tension | Customer | This pack | Ch.21 action |
|---------|----------|-----------|--------------|
| Region | D-01 `us-east-2` | Q-07 | **Ask** |
| Tenancy compute | D-04 one container/tenant | ADR-013 Bridge (shared DB default) | **Ask** |
| Prod deploy | D-05 blue-green | A-03 rolling | **Ask** |
| IaC | Open on customer register | ADR-010 Terraform | **Ask** |
| Shared accounts | Open (reuse vs retire under multi-repo) | — | **Ask** |

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> The five rows above are not resolved by this chapter. Cite both sources; wait for Mesmerize (customer <code>D-xx</code> and/or SAD Q-row / ADR). Device transport remains <strong>re-opened</strong> on the customer register vs ADR-007 Socket.io — not a kickoff-block for empty repo create, but do not treat Socket.io as a customer <code>D-xx</code>.
</p>

## Appendix — Ladder B stub (device / PWA)

This chapter specifies **Ladder A** only. Ladder B (exam-room PWA / fleet) is **not** a Gate 1–3 blocker for empty platform repos. Later delivery will need:

| Later need | Settled in this pack | Notes |
|------------|----------------------|-------|
| Access to live `touchscreen-ux` / extend-PWA work | ADR-007; ADR-016 Ladder B | Production PWA treated as read-only for Newfire; extend/copy |
| Netlify vs device | ADR-016: Netlify = **web-only** preview | **Not** the device path |
| Device release | Human-triggered TTV filesync; Esper tags | `staging` = QA/canary; `main` = production fleet |
| Owners / credentials for TTV / Esper | Not invented here | Ask when Ladder B work starts |

Do **not** describe Ladder A (ECS / OIDC / Terraform) as Netlify or TTV.

## Evidence

- [`customer-kb/INFRASTRUCTURE.md`](../../../customer-kb/INFRASTRUCTURE.md) — **D-01**–**D-07** (settled customer infra)
- [`customer-kb/README.md`](../../../customer-kb/README.md) — SSO start URL, IAM IC groups, AWS account table, empty service-repo index
- [ADR-017](../../../docs/adr/017-python-platform-backend.md) — Python/FastAPI; S8 per-service repos
- [ADR-010](../../../docs/adr/010-technology-stack.md) — S8 multi-repo; S14 Terraform **Proposed** until customer `D-xx`
- [ADR-013](../../../docs/adr/013-multitenancy-silo-and-bridge.md) — Bridge default (tension with D-04)
- [ADR-015](../../../docs/adr/015-aws-deployment-reference.md) — Ladder A runtime topology
- [ADR-016](../../../docs/adr/016-git-branching-and-delivery-ladders.md) — dual ladders; do not conflate Netlify/TTV with ECS
- [ADR-018](../../../docs/adr/018-customer-decision-repo-second-kb.md) — customer repo as second KB; remaining tensions
- [Chapter 13](13-deployment-and-infrastructure.md) — AWS topology
- [Chapter 17](17-ci-cd.md) — CI/CD ladders
- [Chapter 18](18-assumptions-and-open-questions.md) — Q-07, Q-09, Q-13, Q-03, Q-14, **Q-17**

## White spots

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> Exact GitHub org + service repo slugs (<strong>Q-17</strong>); Region (D-01 vs <strong>Q-07</strong>); shared vs per-service AWS accounts; who provisions VPC/ECS/RDS/Redis; IaC tool; observability vendor (<strong>Q-09</strong>); who promotes Staging → Prod (<strong>Q-13</strong>); BAA / HIPAA logging pack (<strong>Q-03</strong>, <strong>Q-14</strong>); D-04 vs ADR-013; D-05 vs A-03.
</p>

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> Starter repos = SMART app + Python API + infra/Terraform. Terraform as the IaC until a customer <code>D-xx</code> lands.
</p>

## Open questions

Consolidated for Mesmerize decision-making in [Chapter 18 — Assumptions and Open Questions](18-assumptions-and-open-questions.md).

- **Q-17** — Ratify exact GitHub **org + service repo slugs** for the Proposed starter set
- **Q-07** — Primary AWS Region (do not pick over D-01 here)
- **Q-09** — Observability vendor + HIPAA logging pack
- **Q-13** — Who promotes Ladder A Staging → Prod
- **Q-03**, **Q-14** — AWS BAA necessity; HIPAA policy pack date
- **Q-16** — Imaging FHIR read strings (unchanged; not a Gate 1 blocker)
