# 21. Infra provision checklist (Dev / Staging / Prod)

| Field | Value |
|-------|-------|
| Chapter ID | `21-infra-provision-checklist` |
| SAD mapping | Mesmerize extension (DevOps create-list) |
| Last updated | 2026-08-19 |
| Maturity | Review-ready |

## Audience

**Mesmerize senior DevOps / platform infra.** This is the list of resources to **create** so Newfire can build and deploy **Ladder A** (platform AWS). It is not an Ask-register and it **does not** add customer `INFRASTRUCTURE.md` `D-xx` rows.

Topology and logical names come from [Chapter 08](08-system-architecture.md) (C4), [Chapter 13](13-deployment-and-infrastructure.md) (VPC / SG / ECS / RDS / Redis / S3), [Chapter 12](12-messaging-and-integration.md) (SQS pattern). Device/PWA (**Ladder B**) is a stub at the end — do not provision Netlify/TTV as this AWS list.

Tick **Dev**, **Staging**, and **Prod** on every row that exists once per environment. `{env}` = `dev` \| `staging` \| `prod`. Resource **names** are **Proposed** until **Q-17** / Terraform review. Logical **service names** are Confirmed in Chapter 08.

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Same AWS <strong>shape</strong> for Dev / Staging / Prod (ADR-015). Staging = PHI-free / athena sandbox. Prod = pilot-gated. Runtime = <strong>Python / FastAPI</strong> on ECS/Fargate (ADR-017). GitHub Actions deploys with <strong>OIDC only</strong> — never AWS keys in GitHub (D-06). Docs repo <code>MJHLS/mesmerize-monorepo</code> has <strong>no pipelines</strong> (D-06 / D-07).
</p>

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> All <code>{env}-mesmerize-*</code> labels below. Terraform as IaC until customer signs an IaC <code>D-xx</code>. Three S3 buckets per env (bucket <em>count</em> is open on ADR-013 / customer register).
</p>

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown / do not invent:</strong> CIDR, AZ count, autoscaling min/max, RTO/RPO, observability vendor, Confirmed GitHub slugs. Region = customer D-01 <code>us-east-2</code> vs this pack <strong>Q-07</strong> — <strong>Ask</strong>, do not pick.
</p>

## Do not auto-close (Ask before creating)

| Tension | Customer `D-xx` | This pack | Action |
|---------|-----------------|-----------|--------|
| Region | D-01 `us-east-2` | Q-07 | **Ask** |
| Tenancy compute | D-04 **one container per tenant** | ADR-013 **Bridge** (shared DB + shared ECS) | **Ask** |
| Prod deploy | D-05 **blue-green** (extra ALB TGs, same RDS) | A-03 **rolling** | **Ask** — if D-05, Prod TG count doubles |
| IaC tool | Open | ADR-010 Terraform | **Ask** |
| Shared accounts | Open (reuse D-01 vs per-service accounts) | — | **Ask** |
| Repo granularity | D-07 **one GitHub repo per deployable service** | ADR-015 **co-locate** first (A-05) | **Ask** — §1 has both inventories |

PHI on everything below: **no** patient identifiers, **no** FHIR tokens, **no** imaging bytes / DICOM (ADR-002, ADR-019).

## Naming (Proposed)

| Kind | Pattern | Example |
|------|---------|---------|
| AWS resource label | `{env}-mesmerize-{purpose}` | `staging-mesmerize-vpc` |
| ECR repository | `mesmerize-{service}` (account-scoped; env via image tag) | `mesmerize-platform-api:staging` |
| SQS (A-06) | `{env}-{service}-{purpose}` | `staging-billing-evidence-requests` |
| SQS DLQ | `{queue}-dlq` | `staging-billing-evidence-requests-dlq` |
| S3 prefix (Confirmed) | `{tenantId}/{clinicId}/…` | inside media bucket |
| CloudWatch logs | `/ecs/{env}/mesmerize-{service}` | `/ecs/staging/mesmerize-api` |
| Secrets | `{env}/mesmerize/{secret}` | `staging/mesmerize/rds` |

---

## 0. What “done” looks like — count per environment

Pilot default (**Proposed**): one co-located API image + a **separate** `device-realtime` ECS service (sticky ALB). Seven C4 logical services still exist even when two ECS services host them.

| Kind | Count / env (first ship) | If D-07 split / D-05 Prod | Notes |
|------|--------------------------|---------------------------|-------|
| VPC | 1 | — | CIDR Unknown |
| Subnet tiers | 3 (public, app, data) × ≥2 AZ Inferred | — | AZ count Unknown |
| Security-group **tiers** | **4**: `sg-alb`, `sg-ecs`, `sg-data`, `sg-vpce` | — | No invented AWS SG IDs |
| IGW | 1 | — | |
| NAT | 1+ (Inferred) | per-AZ optional | |
| VPC endpoints | S3 gateway + SQS/ECR/Secrets/KMS interface | — | Proposed |
| ALB | 1 | — | HTTPS |
| ALB target groups | **2** (REST + sticky realtime) | Prod **4** if D-05 blue-green (blue+green × 2) | |
| CloudFront + SMART origin | 1 | — | |
| ECS cluster | 1 | — | |
| ECS services | **2** (`api` + `device-realtime`) | **7** or **8** if split | or **1** if realtime co-located — sticky TG still required |
| ECR repositories | **1** (same image, two task defs) **or 2** if realtime is a second image | **7** or **8** if split | Inferred registry |
| RDS PostgreSQL 16 | **1** | +1 per Silo org later | D-03; Bridge default |
| ElastiCache Redis 7 | **1** | — | Socket.io adapter |
| S3 buckets | **3** Proposed | or 1 bucket + prefixes — **Ask** | |
| SQS queues + DLQs | **21 + 21** core | **+2** if ads-service | Exact catalog Unknown in Ch.12 |
| GitHub repos | **3** starter (**once**, not ×3) | **+7/+8** if D-07 split | **Q-17** |
| GitHub Environments | 1 per env (`development` Proposed; `staging` / `production` D-06) | — | |
| GitHub OIDC IdP | 1 **per AWS account** | Dev account not in D-01 | |
| OIDC deploy roles | 1 per **repo** per **account** | — | Trust pinned to that repo + Environment |

**Accounts (D-01):** Staging `301478651732`. Prod `063293864447`. **Dev account is not in D-01** — Ask (share staging vs new account).

---

## 1. GitHub repositories (create once; wire into all three envs)

Exact org + slugs = **Q-17**. Org **MJHLS** exists. Do **not** put platform code or pipelines in `mesmerize-monorepo`.

### 1a. Starter set — unblock Newfire (Proposed)

| # | Proposed slug | Contents | Language | Deploy target |
|---|----------------|----------|----------|---------------|
| 1 | `mesmerize-smart-app` | Clinician SMART on FHIR SPA | React 19 / TypeScript / Vite | S3 + CloudFront (not ECS) |
| 2 | `mesmerize-platform-api` | FastAPI; may **co-locate** seven C4 services (A-05) | Python / FastAPI | ECS/Fargate |
| 3 | `mesmerize-infra` | Terraform: VPC, RDS, SQS, IAM OIDC, shared network | IaC | N/A |

| Create empty repo + README index | GitHub Environment + OIDC trust | Dev | Staging | Prod |
|----------------------------------|---------------------------------|:---:|:-------:|:----:|
| `mesmerize-smart-app` | `development` / `staging` / `production` | ☐ | ☐ | ☐ |
| `mesmerize-platform-api` | same | ☐ | ☐ | ☐ |
| `mesmerize-infra` | plan/apply role (if Newfire runs Terraform) | ☐ | ☐ | ☐ |

| Once (not ×3) | Settled | Ask | Done |
|---------------|---------|-----|:----:|
| GitHub org membership for named Newfire engineers | Org MJHLS | Names — org admin | ☐ |
| Write access to `MJHLS/mesmerize-monorepo` | Docs only; **no pipelines** | PR + 1 approval on `main` | ☐ |
| GitHub Environment `staging` | D-06 | — | ☐ |
| GitHub Environment `production` + required reviewers | D-06 | — | ☐ |
| GitHub Environment `development` | Proposed | — | ☐ |

### 1b. Logical C4 services vs extra repos later

These **runtime names are Confirmed** (Chapter 08). They are **not** extra GitHub repos until Mesmerize splits them (D-07 allows it; A-05 allows co-locate first).

| Logical service (Ch.08) | First ship (Proposed) | Later: own GitHub + ECR + ECS |
|-------------------------|----------------------|-------------------------------|
| `session-service` | Inside `mesmerize-platform-api` | `mesmerize-session` |
| `content-service` | Inside `mesmerize-platform-api` | `mesmerize-content` |
| `device-realtime-service` | Own ECS service (sticky TG); image may still be `platform-api` | `mesmerize-device-realtime` |
| `engagement-service` | Inside `mesmerize-platform-api` | `mesmerize-engagement` |
| `billing-evidence-service` | Inside `mesmerize-platform-api` | `mesmerize-billing-evidence` |
| `org-identity-service` | Inside `mesmerize-platform-api` | `mesmerize-org-identity` |
| `audit-telemetry-service` | Worker inside `mesmerize-platform-api` | `mesmerize-audit-telemetry` |
| `ads-service` | **Optional** — off clinical path | `mesmerize-ads` |

| Split repos (only if not co-located) | Dev wiring | Staging | Prod |
|--------------------------------------|:----------:|:-------:|:----:|
| `mesmerize-session` | ☐ | ☐ | ☐ |
| `mesmerize-content` | ☐ | ☐ | ☐ |
| `mesmerize-device-realtime` | ☐ | ☐ | ☐ |
| `mesmerize-engagement` | ☐ | ☐ | ☐ |
| `mesmerize-billing-evidence` | ☐ | ☐ | ☐ |
| `mesmerize-org-identity` | ☐ | ☐ | ☐ |
| `mesmerize-audit-telemetry` | ☐ | ☐ | ☐ |
| `mesmerize-ads` (optional) | ☐ | ☐ | ☐ |

Ladder B (`touchscreen-ux` / extend-PWA) is **not** in this table.

---

## 2. Accounts, IAM Identity Center, OIDC (per AWS account, then per env)

| Create | Settled | Ask / Proposed | Dev | Staging | Prod |
|--------|---------|----------------|:---:|:-------:|:----:|
| AWS account | Staging `301478651732`, Prod `063293864447` (D-01) | Dev account **not** in D-01. Shared vs per-service accounts **Ask** | ☐ | ☐ | ☐ |
| IAM Identity Center (no IAM users / long-lived keys) | D-02; message **Mackenzie Clark** / Teams | Confirm SSO `https://d-9a675d9353.awsapps.com/start`; groups `newfire-developers` / `readonly-observers` | ☐ | ☐ | ☐ |
| GitHub OIDC identity provider in the account | D-06 | Who creates it (Mesmerize vs Newfire in infra repo) — **Ask** | ☐ | ☐ | ☐ |
| OIDC deploy role per service repo; trust = that repo + Environment | D-06 | Role names Proposed `{env}-gha-{repo}` | ☐ | ☐ | ☐ |

---

## 3. Network — VPC, subnets, security-group tiers (×3 env)

Logical SG **tier names** from diagram 22 / Chapter 13. **Do not invent AWS SG IDs.** CIDR **Unknown**. Multi-AZ **Inferred**.

| # | Create | Proposed name | Dev | Staging | Prod |
|---|--------|---------------|:---:|:-------:|:----:|
| 3.1 | VPC | `{env}-mesmerize-vpc` | ☐ | ☐ | ☐ |
| 3.2 | Public subnets (ALB + NAT) | `{env}-mesmerize-public-a` / `-b` | ☐ | ☐ | ☐ |
| 3.3 | Private **app** subnets (ECS) | `{env}-mesmerize-app-a` / `-b` | ☐ | ☐ | ☐ |
| 3.4 | Private **data** subnets (RDS + Redis) | `{env}-mesmerize-data-a` / `-b` | ☐ | ☐ | ☐ |
| 3.5 | Route tables (public / app / data) | `{env}-mesmerize-rt-*` | ☐ | ☐ | ☐ |
| 3.6 | Internet Gateway | `{env}-mesmerize-igw` | ☐ | ☐ | ☐ |
| 3.7 | NAT Gateway(s) | `{env}-mesmerize-nat` (Inferred) | ☐ | ☐ | ☐ |
| 3.8 | **sg-alb** — ALB inbound 443 | `{env}-mesmerize-sg-alb` | ☐ | ☐ | ☐ |
| 3.9 | **sg-ecs** — tasks; inbound from sg-alb only | `{env}-mesmerize-sg-ecs` | ☐ | ☐ | ☐ |
| 3.10 | **sg-data** — Postgres 5432 + Redis 6379 from sg-ecs only; **no Internet egress** Inferred | `{env}-mesmerize-sg-data` | ☐ | ☐ | ☐ |
| 3.11 | **sg-vpce** — interface endpoints 443 from sg-ecs | `{env}-mesmerize-sg-vpce` | ☐ | ☐ | ☐ |
| 3.12 | VPC endpoint — S3 **gateway** | `{env}-mesmerize-vpce-s3` | ☐ | ☐ | ☐ |
| 3.13 | VPC endpoint — SQS interface | `{env}-mesmerize-vpce-sqs` | ☐ | ☐ | ☐ |
| 3.14 | VPC endpoint — ECR (api + dkr) interface | `{env}-mesmerize-vpce-ecr*` | ☐ | ☐ | ☐ |
| 3.15 | VPC endpoint — Secrets Manager interface | `{env}-mesmerize-vpce-secrets` | ☐ | ☐ | ☐ |
| 3.16 | VPC endpoint — KMS interface | `{env}-mesmerize-vpce-kms` | ☐ | ☐ | ☐ |
| 3.17 | Route 53 hosted zone / records | `{env}` SMART + API hostnames (Proposed) | ☐ | ☐ | ☐ |
| 3.18 | ACM certificate(s) | API ALB + CloudFront (Inferred) | ☐ | ☐ | ☐ |
| 3.19 | WAF | `{env}-mesmerize-waf` (Proposed; prod hardening) | ☐ | ☐ | ☐ |

**Proposed allow path:** Internet → CloudFront/WAF :443 → sg-alb :443 → sg-ecs (TG ports) → sg-data :5432 / :6379.

**sg-ecs egress (Proposed):** VPCe + NAT to Auth0, Esper, Sanity, BioDigital, MJH, SMS — **not** to the EHR with a server-held FHIR token.

---

## 4. Ingress — CloudFront, ALB, target groups (×3 env)

| # | Create | Proposed name | Dev | Staging | Prod |
|---|--------|---------------|:---:|:-------:|:----:|
| 4.1 | S3 origin + CloudFront for SMART SPA | `{env}-mesmerize-smart-cf` / origin bucket §6.1 | ☐ | ☐ | ☐ |
| 4.2 | CloudFront origin access (OAC) | on SMART assets bucket | ☐ | ☐ | ☐ |
| 4.3 | Application Load Balancer (HTTPS) | `{env}-mesmerize-alb` | ☐ | ☐ | ☐ |
| 4.4 | ALB listener 443 | — | ☐ | ☐ | ☐ |
| 4.5 | Target group — REST API | `{env}-mesmerize-tg-api` | ☐ | ☐ | ☐ |
| 4.6 | Target group — **sticky** Socket.io (`device-realtime-service`) | `{env}-mesmerize-tg-realtime` | ☐ | ☐ | ☐ |
| 4.7 | Extra TGs for **Prod blue-green** (D-05) | `{env}-mesmerize-tg-api-green`, `-realtime-green` | — | — | ☐ |

D-05: Staging stays **rolling** (one TG pair). Prod blue-green uses ALB target groups + ECS-native strategy — **no CodeDeploy**. Blue and green share the **same RDS**; schema must be expand/contract.

---

## 5. Compute — ECS cluster, containers, ECR (×3 env)

**Confirmed logical containers (7 + optional ads)** — Chapter 08 / ADR-015. Images are **Python** (not NestJS). ECR is **Inferred**. No Lambda / EKS required by current ADRs.

| # | Create | Proposed name | Dev | Staging | Prod |
|---|--------|---------------|:---:|:-------:|:----:|
| 5.1 | ECS cluster | `{env}-mesmerize-platform` | ☐ | ☐ | ☐ |
| 5.2 | ECR repo (co-located first image) | `{account}.dkr.ecr.{region}.amazonaws.com/mesmerize-platform-api` | ☐ | ☐ | ☐ |
| 5.3 | ECS service + task def **API** (session, content, engagement, billing-evidence, org-identity, audit-telemetry) | `{env}-mesmerize-api` | ☐ | ☐ | ☐ |
| 5.4 | ECS service + task def **device-realtime** (sticky TG; Redis; Socket.io + WebRTC **signaling only**) | `{env}-mesmerize-device-realtime` | ☐ | ☐ | ☐ |
| 5.5 | Second ECR repo **only if** realtime is a distinct image | `…/mesmerize-device-realtime` | ☐ | ☐ | ☐ |
| 5.6 | CloudWatch log group — API | `/ecs/{env}/mesmerize-api` | ☐ | ☐ | ☐ |
| 5.7 | CloudWatch log group — realtime | `/ecs/{env}/mesmerize-device-realtime` | ☐ | ☐ | ☐ |
| 5.8 | ECS **task execution** role | `{env}-mesmerize-ecs-execution` | ☐ | ☐ | ☐ |
| 5.9 | ECS **task** role (no static AWS keys; no EHR credentials) | `{env}-mesmerize-ecs-task` | ☐ | ☐ | ☐ |

If Mesmerize **splits** processes (D-07 / not A-05), add one ECR + ECS service + log group per row (still ×3 env):

| Logical container | Proposed ECR / ECS name | Dev | Staging | Prod |
|-------------------|-------------------------|:---:|:-------:|:----:|
| `session-service` | `mesmerize-session` | ☐ | ☐ | ☐ |
| `content-service` | `mesmerize-content` | ☐ | ☐ | ☐ |
| `device-realtime-service` | `mesmerize-device-realtime` | ☐ | ☐ | ☐ |
| `engagement-service` | `mesmerize-engagement` | ☐ | ☐ | ☐ |
| `billing-evidence-service` | `mesmerize-billing-evidence` | ☐ | ☐ | ☐ |
| `org-identity-service` | `mesmerize-org-identity` | ☐ | ☐ | ☐ |
| `audit-telemetry-service` | `mesmerize-audit-telemetry` | ☐ | ☐ | ☐ |
| `ads-service` *(optional)* | `mesmerize-ads` | ☐ | ☐ | ☐ |

Autoscaling min/max: **Unknown** — do not invent. D-04 (one container per tenant) vs Bridge shared compute: **Ask**.

---

## 6. Data stores — RDS, Redis (×3 env)

| # | Create | Proposed identifier | Engine / notes | Dev | Staging | Prod |
|---|--------|---------------------|----------------|:---:|:-------:|:----:|
| 6.1 | RDS PostgreSQL (Bridge: shared DB + `tenantId`) | `{env}-mesmerize-platform` | PostgreSQL **16** (D-03) | ☐ | ☐ | ☐ |
| 6.2 | DB subnet group (private data) | `{env}-mesmerize-db-subnets` | — | ☐ | ☐ | ☐ |
| 6.3 | Attach **sg-data** to RDS | 5432 from sg-ecs only | — | ☐ | ☐ | ☐ |
| 6.4 | Secrets Manager secret — RDS | `{env}/mesmerize/rds` | KMS CMK Proposed | ☐ | ☐ | ☐ |
| 6.5 | ElastiCache Redis | `{env}-mesmerize-redis` | Redis **7** | ☐ | ☐ | ☐ |
| 6.6 | Redis subnet group | `{env}-mesmerize-redis-subnets` | — | ☐ | ☐ | ☐ |
| 6.7 | Attach **sg-data** to Redis | 6379 from sg-ecs only | — | ☐ | ☐ | ☐ |
| 6.8 | Secrets Manager secret — Redis | `{env}/mesmerize/redis` | — | ☐ | ☐ | ☐ |

Multi-AZ flags: **Unknown**. Silo = **extra RDS per Organization** later (ADR-013) — not a first-create row unless a Silo org is signed. **No** imaging bytes / patient IDs in Postgres.

---

## 7. Object storage — S3 buckets (×3 env)

Prefix rule **Confirmed** (ADR-013): `{tenantId}/{clinicId}/…`. Imaging payloads **forbidden** (ADR-019). Diagnostic retention **≤ 90 days** (NFR-OPS-02). Bucket *count* **Ask** — Proposed three buckets per env:

| # | Create | Proposed bucket name | Purpose | Dev | Staging | Prod |
|---|--------|----------------------|---------|:---:|:-------:|:----:|
| 7.1 | SMART SPA static origin | `{env}-mesmerize-smart-assets` | CloudFront origin; block public | ☐ | ☐ | ☐ |
| 7.2 | Education / ads media | `{env}-mesmerize-media` | `{tenantId}/{clinicId}/…` only | ☐ | ☐ | ☐ |
| 7.3 | Diagnostic / audit logs | `{env}-mesmerize-diagnostic-logs` | No PHI; ≤90d | ☐ | ☐ | ☐ |
| 7.4 | Encryption + public-access block on **each** | KMS Proposed | — | ☐ | ☐ | ☐ |

Kinesis → diagnostic S3: **Inferred** (Jul 14) — create only if ops chooses that path (**Q-09**). Do not put imaging or patient data in any bucket.

---

## 8. SQS queues (×3 env)

**Confirmed pattern** (ADR-014): `{service}.requests` / `{service}.replies` / `{service}.events` + `{queue}.dlq`. Envelope must include `tenantId` (and `clinicId` when relevant). **No PHI / no FHIR tokens / no pixels.** Interactive edge stays REST; Socket.io / WebRTC signaling is **not** the SQS hot path.

**Proposed AWS names** (A-06): `{env}-{service}-{purpose}`. Exact catalog is still **Unknown** in Chapter 12 — this is the C4-complete **Proposed** set so queues exist before app code. Unused queues can stay unused.

**Rule:** tick the env when **both** the queue and `{name}-dlq` exist.

### Core (7 C4 services × 3 purposes = 21 queues + 21 DLQs)

| # | Queue (Proposed) | Who (Ch.08) | Dev | Staging | Prod |
|---|------------------|-------------|:---:|:-------:|:----:|
| 8.1 | `{env}-session-events` | session-service → `session.started` / `session.ended` | ☐ | ☐ | ☐ |
| 8.2 | `{env}-session-requests` | session-service RR out | ☐ | ☐ | ☐ |
| 8.3 | `{env}-session-replies` | session-service RR in | ☐ | ☐ | ☐ |
| 8.4 | `{env}-content-events` | content-service CMS / `content.updated` | ☐ | ☐ | ☐ |
| 8.5 | `{env}-content-requests` | content-service RR | ☐ | ☐ | ☐ |
| 8.6 | `{env}-content-replies` | content-service RR | ☐ | ☐ | ☐ |
| 8.7 | `{env}-device-realtime-events` | device commands / presence hooks | ☐ | ☐ | ☐ |
| 8.8 | `{env}-device-realtime-requests` | device-realtime RR | ☐ | ☐ | ☐ |
| 8.9 | `{env}-device-realtime-replies` | device-realtime RR | ☐ | ☐ | ☐ |
| 8.10 | `{env}-engagement-events` | engagement-service | ☐ | ☐ | ☐ |
| 8.11 | `{env}-engagement-requests` | engagement RR | ☐ | ☐ | ☐ |
| 8.12 | `{env}-engagement-replies` | engagement RR | ☐ | ☐ | ☐ |
| 8.13 | `{env}-billing-evidence-requests` | billing-evidence RR **in** (Confirmed need) | ☐ | ☐ | ☐ |
| 8.14 | `{env}-billing-evidence-replies` | billing-evidence RR **out** | ☐ | ☐ | ☐ |
| 8.15 | `{env}-billing-evidence-events` | billing async facts | ☐ | ☐ | ☐ |
| 8.16 | `{env}-org-identity-events` | org / `tenancyMode` | ☐ | ☐ | ☐ |
| 8.17 | `{env}-org-identity-requests` | org-identity RR | ☐ | ☐ | ☐ |
| 8.18 | `{env}-org-identity-replies` | org-identity RR | ☐ | ☐ | ☐ |
| 8.19 | `{env}-audit-telemetry-events` | `*.audit` / diagnostic ingest | ☐ | ☐ | ☐ |
| 8.20 | `{env}-audit-telemetry-requests` | audit RR | ☐ | ☐ | ☐ |
| 8.21 | `{env}-audit-telemetry-replies` | audit RR | ☐ | ☐ | ☐ |

### Optional ads-service (+1 queue + 1 DLQ; add RR later if used)

| # | Queue (Proposed) | Dev | Staging | Prod |
|---|------------------|:---:|:-------:|:----:|
| 8.22 | `{env}-ads-events` | ☐ | ☐ | ☐ |

DLQ alarms: **Proposed**. RR timeout default 30s is **A-06 Proposed** only.

---

## 9. IAM, secrets, observability (×3 env)

| # | Create | Notes | Dev | Staging | Prod |
|---|--------|-------|:---:|:-------:|:----:|
| 9.1 | GitHub OIDC IAM role — `mesmerize-platform-api` | Trust pinned to repo + Environment (D-06) | ☐ | ☐ | ☐ |
| 9.2 | GitHub OIDC IAM role — `mesmerize-smart-app` | Deploy to SMART S3 / CloudFront | ☐ | ☐ | ☐ |
| 9.3 | GitHub OIDC IAM role — `mesmerize-infra` | Plan/apply Terraform (if Newfire runs it) | ☐ | ☐ | ☐ |
| 9.4 | KMS CMK (Proposed) | Secrets + S3 | ☐ | ☐ | ☐ |
| 9.5 | Secrets Manager — Auth0 / Esper / CMS / SMS | `{env}/mesmerize/{name}` | ☐ | ☐ | ☐ |
| 9.6 | Log split: engagement vs diagnostic (NFR-OPS-01) | No PHI in either | ☐ | ☐ | ☐ |
| 9.7 | Observability vendor | **Q-09** Unknown; CloudWatch-only interim — **Ask**. Datadog is ADR-010 S15 *reference*, not signed | ☐ | ☐ | ☐ |

If D-07 split repos exist, add one OIDC deploy role per extra repo (same three env columns).

---

## 10. Do **not** create (this checklist)

| Item | Why |
|------|-----|
| Lambda / EKS | Not required by current ADRs |
| CodeDeploy | D-05 is ECS-native blue-green |
| AWS keys in GitHub | D-06 forbids |
| Patient IDs, MRN, FHIR tokens, imaging/DICOM on RDS/S3/SQS/logs | ADR-002 / ADR-019 / DNB-9 |
| Mesmerize DICOM viewer / WADO ingest | ADR-011 |
| Netlify / TTV as Ladder A | Device path = Ladder B stub |
| Pipelines on `mesmerize-monorepo` | D-06 / D-07 |
| Server-side EHR API credentials | Writeback is browser FHIR |

### Externals (exist outside this VPC — do not provision as AWS)

athenahealth, Auth0, Esper, Sanity, BioDigital, MJH content, SMS/email. ECS may NAT-egress to them; the FHIR access token **never** leaves the clinician browser.

---

## Appendix — Ladder B stub (not this checklist)

| Later need | Notes |
|------------|--------|
| `touchscreen-ux` / extend-PWA access | ADR-007; production PWA read-only for Newfire |
| Netlify | Web preview **only** — not device, not ECS |
| TTV filesync + Esper | Human-triggered; `staging` = QA/canary, `main` = fleet |

---

## Evidence

- [Chapter 08](08-system-architecture.md) — C4 logical services and stores
- [Chapter 12](12-messaging-and-integration.md) — SQS patterns; exact names Unknown
- [Chapter 13](13-deployment-and-infrastructure.md) — VPC / SG tiers / ECS / RDS / Redis / S3
- [Chapter 17](17-ci-cd.md) — OIDC / GHA → ECR → ECS
- [Chapter 18](18-assumptions-and-open-questions.md) — Q-07, Q-09, Q-13, Q-03, Q-14, **Q-17**, A-03, A-05, A-06
- Customer `INFRASTRUCTURE.md` **D-01–D-07**
- ADR-010, 013, 014, 015, 016, 017, 018, 019

## White spots

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> Q-17 slugs; Region (D-01 vs Q-07); Dev AWS account; CIDR / AZ count; RDS/Redis Multi-AZ; ECS autoscaling; exact SQS inventory (Ch.12); bucket count; IaC tool; observability (Q-09); who promotes Staging→Prod (Q-13); D-04 vs ADR-013; D-05 vs A-03.
</p>

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> All <code>{env}-mesmerize-*</code> names; three starter GitHub repos; three S3 buckets per env; full ADR-014 queue set per logical service; co-located API + separate realtime ECS service.
</p>

## Open questions (this chapter)

- **Q-17** — GitHub org + slugs
- **Q-07** — Region
- **Q-09** — Observability
- **Q-13** — Staging → Prod owner
- **Q-03**, **Q-14** — BAA / HIPAA pack
- **A-05** — co-locate vs one ECS service per C4 container
- **A-06** — queue naming (this chapter uses it as Proposed)
