# ADR-018: Customer decision repo as second knowledge base (like `kb/`)

- **Status:** Accepted
- **Date:** 2026-08-19
- **Sources:** Stakeholder instruction (architecture working session); live customer repo at `/Users/sasaaleksandrov/myProjects/newfire/mesmerize-monorepo` (`INFRASTRUCTURE.md` last updated 2026-08-11)

## Context

Agents in this architecture repo were required to check [`kb/`](../../kb/) before inventing behavior. Mesmerize now maintains a **separate** documentation repository that records **settled infrastructure decisions** (`INFRASTRUCTURE.md` `D-xx`) and explicitly marks older strategy docs as non-binding. That tree is not inside this git repo. Without a first-class pointer, agents would keep treating an outdated 2026-08-06 NestJS/pnpm scaffold snapshot as “the customer code home.”

## Decision

1. Treat the customer repo as a **second knowledge base with the same mandatory check as `kb/`**.
2. Resolve it via repo-root symlink **`customer-kb/`** (gitignored) or the default absolute path `/Users/sasaaleksandrov/myProjects/newfire/mesmerize-monorepo`.
3. **Inside that repo:** only `INFRASTRUCTURE.md` `D-xx` rows (plus README facts those rows cite) are Mesmerize-settled infra. `docs/prebuild-proposal/` is brainstorm/goals — **not** Confirmed architecture (same weight as kb `[PROPOSED]` / “Needs Further Discussion”).
4. **Precedence on conflict:** do **not** silently merge. Cite both this pack’s ADR and the customer `D-xx`; stop and ask. Product/PHI/do-not-build ADRs in this repo stay binding until a **superseding ADR + human approval**. Customer `D-xx` is authoritative for the infra rows Mesmerize signed there.
5. This customer repo **holds no platform implementation**; per-service code repos are indexed in its README (empty as of 2026-08-11). Do not assume a Turborepo/NestJS monorepo is the build target.

## Consequences

- Agent entrypoints: [`AGENTS.md`](../../AGENTS.md), [`.cursor/rules/customer-kb.mdc`](../../.cursor/rules/customer-kb.mdc), [`docs/customer-kb/README.md`](../customer-kb/README.md).
- Refresh [`docs/architecture/customer-monorepo-analysis.md`](../architecture/customer-monorepo-analysis.md) when the customer register changes.
- Known tensions to escalate (do not auto-close SAD Unknowns without a follow-on ADR): customer **D-01** Region `us-east-2` vs architecture **Q-07**; **D-04** one container per tenant vs ADR-013 Bridge; **D-05** Prod blue/green vs A-03 rolling; **D-07** multi-repo vs ADR-017 polyglot monorepo; device transport **re-opened** vs ADR-007 Socket.io.
