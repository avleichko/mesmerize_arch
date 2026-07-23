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

**Render notes:** PlantUML needs C4-PlantUML (includes remote stdlib). Mermaid C4: use [Mermaid Live](https://mermaid.live) or a viewer with C4 support.

Canonical narrative: `docs/ai/ARCHITECTURE.md` and `docs/ai/SECURITY.md`.  
Scratch folder: `diagrams/` (not source of truth).
