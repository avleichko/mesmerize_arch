# ADR-016: Git branching and dual delivery ladders

- **Status:** Accepted
- **Date:** 2026-07-23
- **Sources:** [`kb/customer-reference/touchscreen-ux-devops-extract.md`](../../kb/customer-reference/touchscreen-ux-devops-extract.md); touchscreen-ux `CONTRIBUTING.md` / `DEPLOYMENT.md` (provenance under `kb/customer-reference/touchscreen-ux/`); ADR-007; ADR-010; ADR-015

## Context

Agents and SAD authors need accurate Git/PR conventions and must not conflate **device/PWA** delivery (Netlify preview, TelemetryTV filesync, Esper fleet) with **Content Evidence platform** AWS delivery (GitHub Actions → ECR → ECS + Terraform). touchscreen-ux documents a confirmed org branching ladder; applying that ladder to platform repos is proposed, not yet proven in this monorepo.

## Decision

1. **Org branching / PR conventions (Proposed for Content Evidence platform repos):** Adopt Mesmerize conventions from touchscreen-ux as the default for platform repositories: `feature → staging → main`; all PRs target `staging`; never start from `main`; prefixes `content/`, `feat/`, `fix/`, `chore/`, `refactor/`, `docs/`; rebase + `--force-with-lease` preferred; merge commits (not squash); Conventional Commit **PR titles**; `staging` protected. **Confirmed** for touchscreen-ux (device PWA) only until platform repos adopt the same ladder.  
2. **Two delivery ladders:**  
   - **Ladder A — Platform (AWS):** GitHub Actions → ECR (inferred) → ECS + Terraform — **Confirmed** direction ([ADR-010](010-technology-stack.md), [ADR-015](015-aws-deployment-reference.md)); deploy strategy (blue/green, canary, etc.) remains **Unknown**.  
   - **Ladder B — Device/PWA:** Netlify branch preview ≠ device path; TelemetryTV (TTV) filesync **human-triggered**; merge to `staging` = QA/canary devices; promote `staging → main` = production fleet; Esper MDM + TTV player — **Confirmed** for touchscreen-ux / extend-PWA ([ADR-007](007-extend-pwa-server-mediated-devices.md)).  
3. **Do not claim Netlify or TTV filesync for NestJS/ECS services.** Ladder A must not be drawn or described as Netlify/TTV.  
4. **Content-vs-code split:** Separate branches and PRs for content JSON (`content/*`) vs code (`feat/` / `fix/` / etc.) where repos hold content — **Confirmed** for touchscreen-ux; platform service PRs use `feat/` / `fix/` / etc. (content prefix only when the repo holds JSON content).  
5. **CI gate patterns (Proposed for platform):** Core GitHub Actions gate shape (parallel lint · typecheck · test · build), PR template, and CODEOWNERS patterns are documented as copy-ready stubs in [`docs/ci-templates/`](../ci-templates/). Sourced from Confirmed touchscreen-ux `.github` practices. Do **not** treat Ladder B–only workflows (whitelabel regen, content-link checks, contrast/axe, eringest probe, Netlify) as Ladder A requirements. Live NestJS workflow inventory in a platform monorepo remains **Unknown** until that repo adopts the stubs.

## Consequences

- Document Confirmed vs Proposed explicitly in SAD, NFR OPS, and agent rules; name the product (“touchscreen-ux (device PWA)” vs “Content Evidence platform (AWS)”).  
- ADR-015 topology stays platform-only; device delivery and org branching live here.  
- Platform deploy strategy, Region, RTO/RPO, and identical `staging`/`main` semantics for platform remain open until a superseding ADR or ops runbook.  
- Do not promote PWA `.env` / `VITE_*`, whitelabel authoring, or COLORS/JSON template detail into platform architecture.

## Related

- [ADR-007](007-extend-pwa-server-mediated-devices.md) — extend PWA; Esper / device path  
- [ADR-010](010-technology-stack.md) — Terraform + GitHub Actions; ECS/Fargate  
- [ADR-015](015-aws-deployment-reference.md) — AWS reference deployment (Ladder A topology)
- [`docs/ci-templates/`](../ci-templates/) — Ladder A CI template pack + adoption matrix  
- [SAD Chapter 17 — CI/CD](../../output_docs/sad/chapters/17-ci-cd.md)
