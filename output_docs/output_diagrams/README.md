# Architecture diagrams

Mermaid sources for AI agents and reviewers. Render in any Mermaid-compatible viewer (GitHub, Mermaid Live, IDE plugins).

| File | Description |
|------|-------------|
| [01-system-context.mmd](01-system-context.mmd) | Cloud / EHR / clinic edge |
| [02-phi-boundary.mmd](02-phi-boundary.mmd) | Token split and PHI boundary |
| [03-encounter-flow.mmd](03-encounter-flow.mmd) | Launch → push → evidence → writeback |
| [04-monorepo-boundaries.mmd](04-monorepo-boundaries.mmd) | Apps/packages boundaries |
| [05-auth-model.mmd](05-auth-model.mmd) | EHR SSO / Auth0 / device / Bridge |
| [06-c4-containers.mmd](06-c4-containers.mmd) | C4 containers (Mermaid) — REST + SQS microservices |
| [06-c4-containers.puml](06-c4-containers.puml) | C4 containers (PlantUML / C4-PlantUML) — same building blocks |
| [07-c4-context.puml](07-c4-context.puml) | C4 system context (PlantUML) — runtime Persons + external systems |
| [08-multitenancy-overview.puml](08-multitenancy-overview.puml) | Multitenancy overview — Silo vs Bridge |
| [09-multitenancy-silo.puml](09-multitenancy-silo.puml) | Mode A: isolated DB per Organization + S3 |
| [10-multitenancy-bridge.puml](10-multitenancy-bridge.puml) | Mode B: shared DB + tenantId + S3 folders (pilot default) |
| [11-smart-3legged-oauth-athena.puml](11-smart-3legged-oauth-athena.puml) | SMART 3-legged OAuth / Authorization Code Grant from Athena |
| [12-smart-3legged-oauth-athena-detailed.puml](12-smart-3legged-oauth-athena-detailed.puml) | **High-fidelity** SMART 3-legged OAuth from Athena (discovery → token → FHIR → session → writeback) |
| [13-sqs-messaging-overview.puml](13-sqs-messaging-overview.puml) | REST edge + SQS patterns overview |
| [14-sqs-request-reply-correlation.puml](14-sqs-request-reply-correlation.puml) | Request/Reply + Correlation Identifier |
| [15-sqs-fire-and-forget.puml](15-sqs-fire-and-forget.puml) | Fire-and-forget async events |
| [16-sqs-enricher-dlq.puml](16-sqs-enricher-dlq.puml) | Content Enricher + Dead Letter Queue |
| [17-aws-deployment-reference.png](17-aws-deployment-reference.png) | AWS icon overview (stakeholders) |
| [17-aws-deployment-reference.svg](17-aws-deployment-reference.svg) | Same diagram (vector) |
| [17-aws-deployment-reference.py](17-aws-deployment-reference.py) | Generator (`diagrams` + Graphviz) |
| [17-aws-deployment-reference-legacy-boxes.puml](17-aws-deployment-reference-legacy-boxes.puml) | Legacy PlantUML boxes (not preferred) |
| [18-aws-production-deployment.png](18-aws-production-deployment.png) | **Production AWS deployment (technical)** — C4 Deployment, evidence-tagged |
| [18-aws-production-deployment.svg](18-aws-production-deployment.svg) | Same diagram (vector) |
| [18-aws-production-deployment.puml](18-aws-production-deployment.puml) | Source (canonical narrative: `docs/architecture/deployment/aws-production-deployment.md`) |

**Render notes:** PlantUML needs C4-PlantUML (includes remote stdlib). Mermaid C4: use [Mermaid Live](https://mermaid.live) or a viewer with C4 support.  
Regenerate `18-*`: `java -jar .tools/plantuml.jar -tpng -tsvg docs/architecture/deployment/aws-production-deployment.puml` (OpenJDK + Graphviz).

Canonical narrative: `docs/ai/ARCHITECTURE.md` and `docs/ai/SECURITY.md`.  
Scratch folder: `diagrams/` (not source of truth).
