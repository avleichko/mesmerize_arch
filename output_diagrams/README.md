# Architecture diagrams

Mermaid and PlantUML sources for AI agents, SAD embeds, and reviewers. **Rendered PNGs** (01–22) are checked in for Word/PDF export; regenerate with commands below.

| PNG (SAD embed) | Source | Description |
|-----------------|--------|-------------|
| [01-system-context.png](01-system-context.png) | [01-system-context.mmd](01-system-context.mmd) | Cloud / EHR / clinic edge |
| [02-phi-boundary.png](02-phi-boundary.png) | [02-phi-boundary.mmd](02-phi-boundary.mmd) | Token split and PHI boundary |
| [03-encounter-flow.png](03-encounter-flow.png) | [03-encounter-flow.mmd](03-encounter-flow.mmd) | Launch → push → evidence → writeback |
| [04-monorepo-boundaries.png](04-monorepo-boundaries.png) | [04-monorepo-boundaries.mmd](04-monorepo-boundaries.mmd) | Apps/packages boundaries |
| [05-auth-model.png](05-auth-model.png) | [05-auth-model.mmd](05-auth-model.mmd) | EHR SSO / Auth0 / device / Bridge |
| [06-c4-containers.png](06-c4-containers.png) | [06-c4-containers.puml](06-c4-containers.puml), [06-c4-containers.mmd](06-c4-containers.mmd) | C4 containers — REST + SQS (PNG from PlantUML) |
| [06a-c4-focus-session-service.png](06a-c4-focus-session-service.png) | [06a-c4-focus-session-service.puml](06a-c4-focus-session-service.puml) | C4 container focus — session-service |
| [06b-c4-focus-content-service.png](06b-c4-focus-content-service.png) | [06b-c4-focus-content-service.puml](06b-c4-focus-content-service.puml) | C4 container focus — content-service |
| [06c-c4-focus-device-realtime-service.png](06c-c4-focus-device-realtime-service.png) | [06c-c4-focus-device-realtime-service.puml](06c-c4-focus-device-realtime-service.puml) | C4 container focus — device-realtime-service |
| [06d-c4-focus-engagement-service.png](06d-c4-focus-engagement-service.png) | [06d-c4-focus-engagement-service.puml](06d-c4-focus-engagement-service.puml) | C4 container focus — engagement-service |
| [06e-c4-focus-billing-evidence-service.png](06e-c4-focus-billing-evidence-service.png) | [06e-c4-focus-billing-evidence-service.puml](06e-c4-focus-billing-evidence-service.puml) | C4 container focus — billing-evidence-service |
| [06f-c4-focus-org-identity-service.png](06f-c4-focus-org-identity-service.png) | [06f-c4-focus-org-identity-service.puml](06f-c4-focus-org-identity-service.puml) | C4 container focus — org-identity-service |
| [06g-c4-focus-audit-telemetry-service.png](06g-c4-focus-audit-telemetry-service.png) | [06g-c4-focus-audit-telemetry-service.puml](06g-c4-focus-audit-telemetry-service.puml) | C4 container focus — audit-telemetry-service |
| [06h-c4-focus-ads-service.png](06h-c4-focus-ads-service.png) | [06h-c4-focus-ads-service.puml](06h-c4-focus-ads-service.puml) | C4 container focus — ads-service (optional) |
| [07-c4-context.png](07-c4-context.png) | [07-c4-context.puml](07-c4-context.puml) | C4 system context — Persons + external systems |
| [08-multitenancy-overview.png](08-multitenancy-overview.png) | [08-multitenancy-overview.puml](08-multitenancy-overview.puml) | Multitenancy overview — Silo vs Bridge |
| [09-multitenancy-silo.png](09-multitenancy-silo.png) | [09-multitenancy-silo.puml](09-multitenancy-silo.puml) | Mode A: isolated DB per Organization + S3 |
| [10-multitenancy-bridge.png](10-multitenancy-bridge.png) | [10-multitenancy-bridge.puml](10-multitenancy-bridge.puml) | Mode B: shared DB + tenantId + S3 folders (pilot default) |
| [11-smart-3legged-oauth-athena.png](11-smart-3legged-oauth-athena.png) | [11-smart-3legged-oauth-athena.puml](11-smart-3legged-oauth-athena.puml) | SMART 3-legged OAuth / Authorization Code Grant from Athena |
| [12-smart-3legged-oauth-athena-detailed.png](12-smart-3legged-oauth-athena-detailed.png) | [12-smart-3legged-oauth-athena-detailed.puml](12-smart-3legged-oauth-athena-detailed.puml) | **High-fidelity** SMART 3-legged OAuth from Athena |
| [13-sqs-messaging-overview.png](13-sqs-messaging-overview.png) | [13-sqs-messaging-overview.puml](13-sqs-messaging-overview.puml) | REST edge + SQS patterns overview |
| [14-sqs-request-reply-correlation.png](14-sqs-request-reply-correlation.png) | [14-sqs-request-reply-correlation.puml](14-sqs-request-reply-correlation.puml) | Request/Reply + Correlation Identifier |
| [15-sqs-fire-and-forget.png](15-sqs-fire-and-forget.png) | [15-sqs-fire-and-forget.puml](15-sqs-fire-and-forget.puml) | Fire-and-forget async events |
| [16-sqs-enricher-dlq.png](16-sqs-enricher-dlq.png) | [16-sqs-enricher-dlq.puml](16-sqs-enricher-dlq.puml) | Content Enricher + Dead Letter Queue |
| [17-aws-deployment-reference.png](17-aws-deployment-reference.png) | [17-aws-deployment-reference.py](17-aws-deployment-reference.py) | AWS icon overview (stakeholders) |
| [17-aws-deployment-reference.svg](17-aws-deployment-reference.svg) | — | Same diagram (vector) |
| [18-aws-production-deployment.png](18-aws-production-deployment.png) | [18-aws-production-deployment.puml](18-aws-production-deployment.puml) | **Production AWS deployment (technical)** — C4 Deployment |
| [18-aws-production-deployment.svg](18-aws-production-deployment.svg) | — | Same diagram (vector) |
| [19-ladder-a-platform-cicd.png](19-ladder-a-platform-cicd.png) | [19-ladder-a-platform-cicd.puml](19-ladder-a-platform-cicd.puml) | **Ladder A** — Platform (AWS) CI/CD: GHA → ECR → Terraform → ECS |
| [20-ladder-b-device-cicd.png](20-ladder-b-device-cicd.png) | [20-ladder-b-device-cicd.puml](20-ladder-b-device-cicd.puml) | **Ladder B** — Device/PWA CI/CD: Netlify ≠ device; human TTV; Esper (touchscreen-ux) |
| [21-aws-network-topology.png](21-aws-network-topology.png) | [21-aws-network-topology.puml](21-aws-network-topology.puml) | **AWS network topology (Ladder A)** — VPC / AZ / subnet / edge / endpoints / egress |
| [22-aws-security-group-tiers.png](22-aws-security-group-tiers.png) | [22-aws-security-group-tiers.puml](22-aws-security-group-tiers.puml) | **AWS security group tiers** — Logical SG tiers + Proposed allow paths |

**Regenerate Mermaid PNGs (01–05):**

```bash
npx --yes @mermaid-js/mermaid-cli -i output_diagrams/NN-name.mmd -o output_diagrams/NN-name.png
```

**Regenerate PlantUML PNGs (06, 06a–06h, 07–16, 18–22):** OpenJDK + network for C4 remote includes. PlantUML names output after `@startuml` id — rename to match source basename if needed.

```bash
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
java -jar .tools/plantuml.jar -tpng -o "$(pwd)/output_diagrams" output_diagrams/07-c4-context.puml
# e.g. mv output_diagrams/mesmerize-c4-context.png output_diagrams/07-c4-context.png
```

**Render notes:** PlantUML needs C4-PlantUML (includes remote stdlib). Prefer PlantUML for `06-c4-containers` if Mermaid C4 fails locally.  
Regenerate `17-*`: run [17-aws-deployment-reference.py](17-aws-deployment-reference.py) (`diagrams` + Graphviz).  
Regenerate `18-*`: `java -jar .tools/plantuml.jar -tpng -tsvg output_diagrams/18-aws-production-deployment.puml`

Legacy: [17-aws-deployment-reference-legacy-boxes.puml](17-aws-deployment-reference-legacy-boxes.puml) (boxes, not preferred).

Canonical narrative: `docs/ai/ARCHITECTURE.md` and `docs/ai/SECURITY.md`.  
Deployment narrative: `docs/architecture/deployment/aws-production-deployment.md`.  
Scratch folder: `diagrams/` (not source of truth).

**Export mirror:** copy PNGs (and README) to `output_docs/output_diagrams/` after regeneration.
