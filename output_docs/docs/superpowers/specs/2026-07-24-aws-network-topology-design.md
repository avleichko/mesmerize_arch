# Design: AWS Network Topology Diagrams (21–22) + Chapter 13 Update

**Date:** 2026-07-24  
**Status:** Draft for user review  
**Approach:** Dual-diagram network pack (Approach 1)  
**Depth:** Subnet/traffic plane + logical SG tiers with Proposed allow patterns (brainstorming B)  
**SAD target:** `output_docs/sad/chapters/13-deployment-and-infrastructure.md`  
**Related:** ADR-015, ADR-010, ADR-007; existing diagrams 17/18 (unchanged)

## Problem

Chapter 13 covers deployment topology via diagrams 17 (stakeholder) and 18 (production deploy), but lacks a dedicated **network** view for DevOps review: subnet planes, NAT/IGW, VPC endpoints, and a clear **security-group tier** allow story. Exact CIDR/Region remain Unknown — the new diagrams must not invent them as Confirmed.

## Goals

1. Add PlantUML + PNG diagrams **21** (network topology) and **22** (SG tiers).  
2. Extend Chapter 13 with a **Network topology** section: prose, both figures, SG summary table, evidence callouts.  
3. Update catalog README + COVERAGE for ch.13 required diagrams.  
4. Keep evidence tags honest: Confirmed / Inferred / Proposed / Unknown.

## Non-goals

- Inventing CIDR blocks, AZ names, account IDs, or Region as Confirmed.  
- Confirmed line-by-line NACL/SG dumps from live AWS (none in repo).  
- Replacing or rewriting diagrams 17/18.  
- Showing Netlify / TTV / Ladder B on the AWS network plane.  
- Claiming Multi-AZ / VPC endpoints / WAF as Confirmed where ADRs only Infer or Propose.

## Decisions (brainstorming)

| # | Choice |
|---|--------|
| Depth | **B** — subnets/traffic + SG/NACL-tier story (Proposed allows) |
| Catalog | **C** — new **21** + **22** (keep 17/18) |
| Format | **A** — PlantUML + PNG embeds |
| Packaging | **Approach 1** — dual-diagram pack |

## Catalog

| ID | File stem | Purpose |
|----|-----------|---------|
| 21 | `21-aws-network-topology` | VPC / AZ / subnet / edge / endpoints / egress |
| 22 | `22-aws-security-group-tiers` | Logical SG tiers + Proposed allow paths |

Artifacts: `.puml` + `.png` under `output_diagrams/` and mirrored under `output_docs/output_diagrams/`.

## Diagram 21 — Network topology (content)

**Title:** Mesmerize Content Evidence Platform — AWS Network Topology (Ladder A)

**Include:**
- Edge (outside VPC): clients (SMART / devices / admin); Route 53 **[P]**; CloudFront **[C]**; WAF **[P]**  
- VPC **[I]** Multi-AZ assumed; CIDR **[U]**  
  - Public subnets: ALB **[C]**; NAT Gateway **[I]**  
  - Private app subnets: ECS/Fargate NestJS services **[C]** (co-locate OK early **[C]**)  
  - Private data subnets: RDS PostgreSQL 16 **[C]**; ElastiCache Redis 7 **[C]**  
- VPC endpoints **[P/I]**: S3 (gateway), SQS / ECR / Secrets Manager / KMS (interface) — reduce NAT for AWS APIs  
- S3 media bucket shown as regional service (not in VPC) **[C]**  
- Egress via NAT to externals outside VPC: athenahealth, Auth0, Esper, Sanity, BioDigital, MJH, SMS **[C]** placement  

**Evidence legend on diagram:** [C] Confirmed · [I] Inferred · [P] Proposed · [U] Unknown  

**Must not include:** Netlify, TTV, invented CIDR/Region values.

## Diagram 22 — Security group tiers (content)

**Title:** Mesmerize — Logical Security Group Tiers (Proposed allow paths)

Logical tiers (no invented AWS SG IDs):

| Tier | Members | Proposed inbound | Source |
|------|---------|------------------|--------|
| Edge / WAF | CloudFront + WAF path | HTTPS 443 | Internet |
| sg-alb | Application Load Balancer | 443 | CloudFront / clients **[I/P]** |
| sg-ecs | ECS Fargate tasks | App ports via target groups (typically 443/container) | sg-alb only |
| sg-data | RDS, Redis | 5432 (Postgres), 6379 (Redis) | sg-ecs only |
| sg-vpce | Interface VPC endpoints | 443 | sg-ecs |

**Outbound (Proposed):** sg-ecs → VPC endpoints + NAT to approved externals; sg-data **no Internet** **[I]**; deny-by-default between unrelated tiers.

All allow rows are **Proposed** until Terraform/security review confirms. Sticky ALB target group for device-realtime remains a compute/ingress concern (cite ADR-007/015 in prose, not as a new Confirmed SG rule).

## Chapter 13 — Network topology section

Insert after **Ingress** (or immediately before **High availability and DR** if that reads better):

```
## Network topology

Purpose paragraph (DevOps plane; Ladder A only; tags).

![21] ... Figure 13-x caption + 1–2 sentence prose

![22] ... Figure 13-y caption + SG summary table (same as above)

Callouts:
- Inferred: Multi-AZ VPC/NAT/private data placement
- Proposed: WAF, Route 53, VPC endpoints, SG tier matrix
- Unknown: CIDR, Region (pointer to Chapter 18 Q-07)
```

Update Evidence to cite 21/22. Update White spots if needed (CIDR remains Unknown). Update COVERAGE ch.13 required diagrams to include `21` + `22` alongside `18`/`17`. Update `output_diagrams/README.md` (+ mirror).

## Guardrails

- Do not invent Confirmed Region, CIDR, RTO/RPO, or SG rule dumps from live AWS.  
- Do not place Netlify/TTV on Ladder A network diagrams.  
- Zero-PHI / browser-held FHIR token unchanged.  
- Commit only if the user explicitly requests.

## Success criteria

- [ ] `21` and `22` `.puml` + `.png` exist and are mirrored.  
- [ ] Ch.13 has Network topology section with both figures + descriptions + SG table.  
- [ ] Catalog + COVERAGE updated.  
- [ ] Evidence tags correct; no invented Confirmed CIDR/Region.

## Implementation note

After this spec is approved, create an implementation plan via `writing-plans` (PlantUML render with existing `.tools/plantuml.jar` + OpenJDK).
