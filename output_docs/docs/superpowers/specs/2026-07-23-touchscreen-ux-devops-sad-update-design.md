# Design: Touchscreen-ux DevOps extract → SAD / ADR / NFR update

**Date:** 2026-07-23  
**Status:** Approved for implementation planning (pending user review of this spec)  
**Approach:** Evidence pack + dual delivery model (Approach 1)

## Goal

Analyze Mesmerize customer docs from the **touchscreen-ux** project (`AGENTS.md`, `CONTRIBUTING.md`, `DEPLOYMENT.md`, `README.md`), extract CI/CD, DevOps, Git, and branching practices, record them as citable evidence, and update the Content Evidence Platform documentation set (SAD + ADR/NFR/agent layer) so delivery and branching are accurate and dual-pathed.

## Decisions (brainstorming)

| Topic | Choice |
|-------|--------|
| Scope of application | **B** — Org-wide conventions with Confirmed (touchscreen-ux) vs Proposed (Content Evidence platform) |
| Docs to update | **B** — SAD + agent/ADR/NFR layer (not full CONTRIBUTING port) |
| Decision record | **B** — New **ADR-016** |
| Implementation shape | **Approach 1** — Evidence extract + dual delivery ladders |

## Source material

| File (Downloads) | Role |
|------------------|------|
| `AGENTS.md` | Agent rules; points to CONTRIBUTING for Git; TelemetryTV SDK notes; content schema (mostly out of extract) |
| `CONTRIBUTING.md` | Branch ladder, prefixes, content-vs-code PRs, rebase policy, CI workflows, PR conventions |
| `DEPLOYMENT.md` | Environment ladder, Netlify vs TTV filesync, Esper fleet, CI table, `.env`/VITE policy |
| `README.md` | Stack overview; docs index; brand/device-tag activation |

## Non-goals

- Porting full COLORS / JSON template / whitelabel authoring into this SAD
- Claiming Netlify or TTV filesync for NestJS/ECS platform services
- Inventing platform deploy strategy (rolling/blue-green/canary), Region, RTO/RPO
- Copying committed-`.env` / VITE secret posture into platform Secrets Manager model
- Filling the Word SAD `.docx`

## Evidence extract (in-repo)

**Create:** `kb/customer-reference/touchscreen-ux-devops-extract.md`

Summarize with citations (not a full dump of the four files):

| Topic | Confirmed for touchscreen-ux |
|-------|------------------------------|
| Branch ladder | `feature → staging → main`; all PRs target `staging`; never start from `main` |
| Branch prefixes | `content/`, `feat/`, `fix/`, `chore/`, `refactor/`, `docs/` |
| Hard rule | Content vs code on separate branches and separate PRs |
| Sync | Rebase + `--force-with-lease` preferred; merge also fine for engineers |
| Merge style | Merge commits (not squash); Conventional Commit **PR titles** |
| Protection | `staging` protected (no force-push/delete); `main` downstream-only by convention |
| CI | `ci.yml` (lint, tsc, test, build); content-links; contrast-audit; generate-whitelabel; ingest-check |
| Web preview | Netlify branch previews — web only, not device path |
| Device path | TelemetryTV filesync **manually** triggered; full wipe + alphabetical re-upload; clear TTV cache after deploy |
| Release | Merge to `staging` = QA/canary; promote `staging → main` = production |
| Fleet | Esper MDM + TTV player; brand/visibility via device tags; one build serves all brands |
| Version verify | `__APP_VERSION__` / stamped version logged on boot |

Optional: keep copies of the four source files under `kb/customer-reference/touchscreen-ux/` for provenance (recommended if Downloads may disappear).

## ADR-016

**Create:** `docs/adr/016-git-branching-and-delivery-ladders.md`

**Decision summary:**

1. Adopt Mesmerize org branching/PR conventions from touchscreen-ux as **Proposed** default for Content Evidence platform repositories.  
2. Document **two delivery ladders**:
   - **Ladder A — Platform (AWS):** GitHub Actions → ECR (inferred) → ECS + Terraform — Confirmed direction (ADR-010 / ADR-015); deploy strategy TBD.  
   - **Ladder B — Device/PWA:** Netlify preview ≠ device; TTV filesync human-triggered; `staging` → QA devices; `main` → prod fleet — **Confirmed** for touchscreen-ux / extend-PWA (ADR-007).  
3. Do not claim Netlify or TTV filesync for NestJS/ECS services.  
4. Content-vs-code split applies where repos hold content JSON; platform service PRs use `feat/` / `fix/` / etc.

Register in `docs/adr/README.md`. Cross-link from ADR-015.

## Dual delivery model (canonical narrative)

```
Platform (Content Evidence services)
  PR → GitHub Actions (lint/test/build) → ECR → ECS (Terraform-managed)
  Environments: Dev / Staging / Prod (pilot-gated) — names Confirmed in ADRs;
  whether identical to touchscreen staging→main promotion: Proposed/Unknown until confirmed

Device / PWA (touchscreen-ux extended)
  feature branch → PR to staging → Netlify web preview (review only)
  human TTV filesync → QA devices (from staging)
  promote staging→main → human TTV filesync → production fleet
  Esper tags select brand + allow/hidden content
```

## Files to update

| File | Action |
|------|--------|
| `kb/customer-reference/touchscreen-ux-devops-extract.md` | Create |
| `kb/customer-reference/touchscreen-ux/*` (optional copies) | Create |
| `docs/adr/016-git-branching-and-delivery-ladders.md` | Create |
| `docs/adr/README.md` | Register 016 |
| `docs/adr/015-aws-deployment-reference.md` | Cross-link; platform vs device |
| `docs/ai/ENGINEERING_RULES.md` | Branching + dual ladders |
| `docs/ai/NFR.md` | OPS ASRs for device ladder + platform CI |
| `docs/ai/ARCHITECTURE.md` | Delivery & branching subsection |
| `docs/ai/SECURITY.md` | PWA `.env`/VITE is device-app-specific; not platform secrets model |
| `AGENTS.md` | Pointer to ADR-016 / extract |
| `output_docs/sad/chapters/13-deployment-and-infrastructure.md` | Dual ladders; narrow CI Unknowns |
| `output_docs/sad/chapters/02-scope.md` | Env / release ladder note |
| `output_docs/sad/chapters/08-system-architecture.md` | PWA → ladder B pointer |
| `output_docs/sad/chapters/14-nfr-and-quality-attributes.md` | Reflect OPS evidence |
| `output_docs/sad/chapters/03-related-documents.md` | Link ADR-016 + extract |
| `output_docs/sad/PROGRESS.md`, `COVERAGE.md` | Rescore affected chapters |
| `output_docs/` mirrors of changed docs | Sync |

## Evidence tags (writing rules)

| Tag | Use |
|-----|-----|
| Confirmed | In touchscreen-ux docs **or** existing Mesmerize ADRs (GHA+Terraform+ECS) |
| Proposed | Applying branching/PR conventions to Content Evidence **platform** repos |
| Inferred | Reasonable extension (e.g. same prefix set in a monorepo) |
| Unknown | Platform deploy strategy, Region, RTO/RPO, identical `staging`/`main` semantics for platform |

Always name the product: “touchscreen-ux (device PWA)” vs “Content Evidence platform (AWS).”

## Success criteria

A reviewer can answer:

1. What is Mesmerize’s branch/PR ladder?  
2. What is Confirmed for PWA vs Proposed for platform?  
3. How do web preview, QA devices, and prod devices differ?  
4. How does platform CI/CD differ from device delivery?  
5. Which SAD Unknowns were closed vs still open?

## Out of scope for implementation plan follow-up

- New architecture diagrams beyond caption/note updates (optional: small Mermaid of dual ladders later)  
- Changing Word template structure  

## Next step after user approves this spec

Invoke **writing-plans** to produce an implementation plan for the extract, ADR-016, and doc updates.
