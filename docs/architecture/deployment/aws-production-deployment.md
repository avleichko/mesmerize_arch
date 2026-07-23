# AWS Production Deployment Architecture

**Environment represented:** Production (pilot-gated)  
**Date:** 2026-07-23  
**Diagram source:** [`aws-production-deployment.puml`](aws-production-deployment.puml)  
**Rendered:** [`aws-production-deployment.png`](aws-production-deployment.png) · [`aws-production-deployment.svg`](aws-production-deployment.svg)  
**Catalog copy:** `output_diagrams/18-aws-production-deployment.{puml,png,svg}`  
**Audience:** Solution architects, developers, DevOps, technical leads, customer architecture reviews  

**Related:** ADR-002, 005, 007, 010, 013, 014, 015 · `docs/ai/NFR.md` · C4 containers `06-*` · SQS diagrams `13–16`

---

## 1. Purpose and scope

### Included

- Mesmerize **Content Evidence Platform** production deployment on **Mesmerize-owned AWS**
- SMART web app hosting, NestJS microservices on **ECS/Fargate**, device realtime (Socket.io), SQS messaging, RDS/Redis/S3, CI/CD
- External systems: athenahealth, Auth0, Esper, Sanity/BioDigital/MJH, SMS/email
- Evidence classification for every major element

### Excluded (intentional)

- Dev/Staging detailed sizing (same topology; Staging = PHI-free / Athena sandbox)
- DICOM / imaging mirror (SOW out of scope — ADR-009)
- Ambient AI / Redox / clearinghouse (ADR-011)
- Per-table schema, SG rule dumps, every IAM policy
- Numeric RTO/RPO/SLOs (not in kb)

### Intended audience

Architects validating cloud fit; engineers implementing services; DevOps implementing Terraform; customer reviews needing honesty about confirmed vs proposed.

---

## 2. Architecture summary

### Ingress

Clinician launches Mesmerize from **athenahealth** (EHR launch). SMART SPA is served via **CloudFront** (S3 origin). API and Socket.io traffic terminate on **ALB** (HTTPS), with a **sticky target group** for `device-realtime-service`. Admin traffic uses **Auth0** then ALB. Devices connect to ALB with Esper-provisioned device tokens.

**Proposed:** Route 53 + WAF in front of CloudFront/ALB (not named as hard requirements in ADR-010; recommended for prod hardening).

### Compute

Logical **ECS Fargate** services (NestJS/TypeScript): session, content, device-realtime, engagement, billing-evidence, org-identity, audit-telemetry, ads (optional). Early pilot may **co-locate** tasks (ADR-015). No Lambda/EKS required by current ADRs.

### Data

- **RDS PostgreSQL 16** — Bridge tenancy default (`tenantId` = organizationId); Silo = additional DB per org (ADR-013)
- **ElastiCache Redis 7** — Socket.io adapter / cache
- **S3** — media at `{tenantId}/{clinicId}/…`; SMART static assets; diagnostic logs ≤90 days

### Messaging

**SQS** per ADR-014: `*.requests` / `*.replies` (request/reply + correlationId), `*.events` (fire-and-forget), `*.dlq` (content enricher → DLQ). Edge interactive path stays **REST**, not SQS RR.

### Security

- Zero patient identifiers on Mesmerize servers; EHR FHIR token **browser-only** (ADR-002/005)
- Auth0 for admin; SMART 3-legged for clinicians
- BAAs: Auth0 + SMS/email; AWS BAA possibly not if de-identified (open)
- **Proposed:** Secrets Manager, KMS CMKs, WAF
- **Inferred:** ACM certificates, IAM task roles, private data subnets

### Observability

Separate engagement vs diagnostic logs (NFR-OPS-01). Diagnostic: Kinesis → S3 ≤90d (Jul 14 / NFR). Monitoring: Mesmerize-approved / **Datadog** as reference (confirm vendor). DLQ alarms expected.

### CI/CD

**GitHub Actions** → build/test → **ECR** (inferred) → ECS deploy; infra via **Terraform**. Deployment strategy (rolling/blue-green/canary): **TBD**.

### Availability / DR

Multi-AZ placement **inferred** for ALB/ECS/data. RDS/Redis Multi-AZ flags **TBD**. Queue buffering + retries + DLQ support recoverability. Cross-Region DR / RTO / RPO: **TBD** (do not invent).

---

## 3. Component deployment mapping

| Application component | Responsibility | Technology | AWS deployment target | Scaling model | Network placement | Evidence status |
|----------------------|----------------|------------|----------------------|---------------|-------------------|-----------------|
| SMART Web App | Clinician UI in EHR iframe | React 19, Vite, fhirclient.js, Tailwind | CloudFront ← S3 static | CDN edge | Global/edge | Confirmed |
| Device PWA / web apps | Exam/waiting/command/bridge | React 19, Vite; extend touchscreen-ux | Client devices (Esper); talks to ALB | Fleet ~4.4k devices | Clinic edge | Confirmed |
| session-service | Opaque sessions, ICD-10 set | NestJS, Prisma | ECS Fargate | TBD (co-locate OK early) | Private app subnets | Confirmed |
| content-service | Catalog, ICD-10 recommend, CMS sync | NestJS | ECS Fargate | TBD | Private app | Confirmed |
| device-realtime-service | Pairing, commands, Socket.io | NestJS, Socket.io, Redis | ECS Fargate + sticky ALB TG | TBD | Private app | Confirmed |
| engagement-service | Engagement persistence, event consume | NestJS | ECS Fargate | TBD | Private app | Confirmed |
| billing-evidence-service | Suggestions, approve, export; SQS RR | NestJS, billing-engine pkg | ECS Fargate | TBD | Private app | Confirmed |
| org-identity-service | Orgs, tenancyMode, Auth0 JWT | NestJS | ECS Fargate | TBD | Private app | Confirmed |
| audit-telemetry-service | Diagnostic/audit ingest | NestJS worker | ECS Fargate | TBD | Private app | Confirmed |
| ads-service | Ads / proof-of-play | NestJS | ECS Fargate | TBD | Private app | Inferred (optional path) |
| Platform data | De-identified domain data | PostgreSQL 16 / Prisma | RDS | Multi-AZ TBD; Silo extra DBs | Private data | Confirmed |
| Cache / realtime bus | Socket.io adapter, cache | Redis 7 | ElastiCache | Multi-AZ TBD | Private data | Confirmed |
| Media / exports | Tenant-isolated objects | — | S3 | — | Regional (not in VPC) | Confirmed |
| Messaging | RR / events / DLQ | SQS | SQS | Buffering | Regional | Confirmed |
| Diagnostic pipeline | Diag logs ≤90d | Kinesis + S3 | Kinesis, S3 | — | Regional | Inferred (Kinesis) / Confirmed (90d S3) |
| Admin auth | Command Center login | Auth0 | External SaaS | — | External | Confirmed |
| CI images | Container artifacts | Docker | ECR | — | Regional | Inferred |
| IaC / CI | Provision + ship | Terraform, GitHub Actions | N/A (control plane) | — | External/AWS | Confirmed |

---

## 4. Communication matrix

| Source | Destination | Interaction | Protocol / mechanism | Sync/async | Authentication | Data sensitivity |
|--------|-------------|-------------|----------------------|------------|----------------|------------------|
| Clinician browser | athenahealth | SMART launch + FHIR R/W | OAuth2 auth code, FHIR R4 HTTPS | Sync | EHR SSO / FHIR Bearer | PHI in browser only |
| Clinician browser | CloudFront / SMART SPA | Load app | HTTPS | Sync | none (static) | No PHI in static assets |
| SMART SPA | ALB → APIs | Session, recommend, push, billing UI | HTTPS REST + Mesmerize JWT | Sync | Mesmerize session token | ICD-10, session, device — **no patient id** |
| Device PWA | ALB → device-realtime | Commands, engagement | HTTPS + WSS Socket.io | Sync | Device token (Esper) | De-identified engagement |
| Admin | Auth0 + ALB | Admin ops | OIDC + HTTPS JWT | Sync | Auth0 | Ops config |
| session-service | billing-evidence | Compute suggestions | SQS request/reply + correlationId | Async wait | IAM | tenantId + engagement facts |
| device/session | engagement-service | engagement.recorded | SQS events | Async FF | IAM | De-identified |
| Any consumer | DLQ | Poison messages | SQS redrive + enricher | Async | IAM | Error context, no PHI |
| content-service | Sanity/BioDigital/MJH | Content sync | HTTPS APIs | Sync | Vendor creds | No PHI |
| org-identity | Auth0 | JWKS | HTTPS | Sync | — | — |
| Services | RDS/Redis/S3 | Persist/cache/objects | TLS / Redis / HTTPS | Sync | IAM task role | De-identified / tenant-scoped |
| Services | Datadog/monitoring | Telemetry | Agent/OTLP | Async ops | API keys | No PHI in diag logs |
| GitHub Actions | ECR / ECS / Terraform | Build & deploy | CI/CD | Deploy | GitHub OIDC/IAM TBD | — |

---

## 5. Evidence and assumptions

| Diagram element | Classification | Evidence | Assumption or uncertainty | Validation needed |
|-----------------|----------------|----------|---------------------------|-------------------|
| Mesmerize-owned AWS | Confirmed | ADR-010 S12; Q&A | Account ID not documented (do not invent) | Account structure / org OU |
| ECS/Fargate + NestJS services | Confirmed | ADR-010, C4 containers, ADR-015 | Exact service count in first pilot | Terraform modules |
| CloudFront + S3 SMART hosting | Confirmed | ADR-010 S13; SMART HTTPS hosting reqs | Exact cache behaviors | CF distribution config |
| ALB + Socket.io sticky | Confirmed | ADR-015, ADR-007 | NLB not used | ALB listener rules |
| RDS PG 16 + Redis 7 | Confirmed | ADR-010 | Engine minor version; Multi-AZ on/off | RDS parameter group |
| SQS RR/events/DLQ | Confirmed | ADR-014 | Exact queue names in AWS | Queue Terraform |
| S3 tenant prefixes | Confirmed | ADR-013 | Bucket count (1 vs many) | Bucket policy |
| Auth0 + SMART 3-legged | Confirmed | ADR-005, ADR-010 | — | Client registration in Athena |
| Esper / TelemetryTV | Confirmed | ADR-007, Q&A | Integration API surface | AM confirmation |
| Diagnostic ≤90d + Kinesis | Confirmed / Inferred | NFR-OPS-02; Jul 14 (Kinesis direction) | Exact Kinesis topology | Ops runbook |
| Datadog | Inferred | ADR-010 S15 “appears in reference” | Final vendor | AM handover |
| Multi-AZ VPC/NAT/private data subnets | Inferred | HA goals; ADR-015 multi-AZ wording | Exact AZ count, CIDR | Network design review |
| ECR | Inferred | ECS images require registry | Could be another registry | Confirm ECR |
| Route 53, WAF, Secrets Manager, KMS | Proposed | Common prod hardening; OWASP/pen-test Phase 3 | Not mandated by ADR-010 list | Security architecture sign-off |
| Region, DR region, RTO, RPO, ASG min/max, deploy strategy | TBD / Unknown | No kb values | — | Mesmerize platform owners |
| AWS BAA | Open | SECURITY.md | May not be required if de-identified | Compliance owner |

---

## 6. Architectural risks and gaps

| Gap | Priority | Notes |
|-----|----------|-------|
| Production **Region / DR** undefined | Critical | Blocks capacity & DR planning |
| **RTO/RPO** undefined | High | Do not invent; needed for customer reviews |
| RDS/Redis **Multi-AZ** not evidenced in IaC (no IaC in this repo yet) | High | “No evidence found in the reviewed project context” for live TF state |
| Autoscaling min/max **TBD** | High | Fleet scale NFR exists qualitatively only |
| **Secrets Manager / KMS** only Proposed | High | Needed before prod secrets sprawl |
| **WAF** only Proposed | Medium | Supports OWASP/pen-test posture |
| Observability vendor not finalized | Medium | Datadog is reference only |
| Engagement log **long retention** unresolved | Medium | Discussed vs diagnostic 90d |
| Early **service co-location** vs isolation | Medium | OK for pilot; revisit for blast radius |
| Deploy strategy (rolling/blue-green) unknown | Medium | Affects ALB target deregistration |
| Direct public DB access | Low (mitigated by design) | Design says private data subnets — validate in TF |

---

## 7. Open questions (material)

1. Which **AWS Region** (and optional DR Region) hosts Production?  
2. Is Production a **dedicated AWS account** vs shared with Staging?  
3. Are RDS and ElastiCache deployed **Multi-AZ**?  
4. What are required **RTO** and **RPO**?  
5. What are ECS **autoscaling** floors/ceilings per service for pilot vs scale?  
6. Confirm **Secrets Manager + KMS + WAF + Route 53** as mandatory prod controls.  
7. Final **observability** stack (Datadog vs Mesmerize-approved alternative)?  
8. **Deployment strategy**: rolling, blue-green, or canary?  
9. Confirm **AWS BAA** required given zero-PHI server design.  
10. Outbound egress allow-list for Sanity/BioDigital/Auth0/SMS/Esper?

---

## Legend (diagram)

| Tag | Meaning |
|-----|---------|
| **[C] Confirmed** | ADR, SOW, Q&A, or kb |
| **[I] Inferred** | Strongly implied by stack/HA practice |
| **[P] Proposed** | Recommended to complete prod posture |
| **[T] TBD** | Insufficient evidence — do not invent numbers |

| Line style (intent) | Meaning |
|---------------------|---------|
| Solid Rel | Synchronous HTTPS/REST/WSS |
| Via SQS nodes | Asynchronous messaging |
| CI/CD Rel | Deployment / provision |
