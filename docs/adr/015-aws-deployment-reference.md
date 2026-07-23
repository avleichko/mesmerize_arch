# ADR-015: AWS reference deployment topology

- **Status:** Accepted
- **Date:** 2026-07-23
- **Sources:** ADR-010 stack; ADR-013 tenancy; ADR-014 messaging; NFR OPS/SEC/SCAL; deployment brainstorming (generic env diagram, hybrid ECS view)

## Context

Agents and SAD authors need a single deployment picture for Mesmerize-owned AWS that does not invent SLOs or products outside the agreed stack.

## Decision

1. Publish a **generic multi-AZ AWS reference deployment** (same shape for Dev/Staging/Prod; differences in notes).  
2. Show **logical ECS/Fargate services** per C4 container; allow **co-location** on one cluster in early pilot.  
3. Topology essentials:
   - CloudFront + ALB (HTTPS); sticky target group for **device-realtime** Socket.io  
   - Private compute + private data subnets; RDS Postgres 16; ElastiCache Redis 7  
   - SQS requests/replies/events + DLQs  
   - S3 media with `{tenantId}/{clinicId}/…`; diagnostic logging path with ≤90d retention  
   - GitHub Actions → ECR → ECS; Terraform; Mesmerize-approved observability  
4. Externals stay outside VPC: Athena, Auth0, Esper, Sanity/BioDigital/MJH, SMS/email.  
5. **Human-facing icon diagram:** `output_diagrams/17-aws-deployment-reference.png` (and `.svg`), generated from `17-aws-deployment-reference.py` via Python `diagrams` + Graphviz AWS icons.  
6. Legacy box PlantUML kept as `17-aws-deployment-reference-legacy-boxes.puml` (not preferred for stakeholders).  
7. **Production deployment package (evidence-tagged):**  
   - Narrative + matrices: `docs/architecture/deployment/aws-production-deployment.md`  
   - C4 Deployment PlantUML: `docs/architecture/deployment/aws-production-deployment.puml`  
   - Rendered copy: `output_diagrams/18-aws-production-deployment.{puml,png,svg}`  
   - Every element classified Confirmed / Inferred / Proposed / TBD; do not invent Region, RTO, RPO, or autoscaling numbers.

## Consequences

- Do not introduce undocumented AWS products into the reference without an ADR.  
- Silo tenancy = additional RDS instances per org (annotated), not a different VPC pattern by default.  
- Staging remains PHI-free / Athena sandbox; Prod pilot-gated.  
- Prefer the production package (`18-*` + MD) for technical reviews; keep `17-*` for stakeholder icon overview.
