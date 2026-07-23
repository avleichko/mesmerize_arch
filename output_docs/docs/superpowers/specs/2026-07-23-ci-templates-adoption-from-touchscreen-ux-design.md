# Design: CI templates + adoption matrix from touchscreen-ux `.github`

**Date:** 2026-07-23  
**Status:** Draft for user review  
**Approach:** Adoption matrix + template pack (Approach 1)  
**Scope band:** Core gate only; tool-agnostic stubs  
**Related:** ADR-016; SAD Chapter 17; `kb/customer-reference/touchscreen-ux-devops-extract.md`  
**Inspected source:** local clone `/Users/sasaaleksandrov/myProjects/touchscreen-ux/.github` (not vendored into this repo)

## Problem

SAD Chapter 17 and ADR-016 describe Ladder A CI only at direction level (lint · test · build → ECR → ECS). touchscreen-ux has a concrete `.github` inventory we can learn from, but we must not conflate Ladder B (PWA) workflows with platform NestJS/ECS delivery, and this `mesmerize` repo has no runnable app CI today.

## Goals

1. Document which touchscreen-ux CI/DevOps practices are **portable** to Ladder A vs **Ladder B–only**.  
2. Ship a **non-runnable** template pack under `docs/ci-templates/` for copy into a future platform monorepo.  
3. Wire ADR-016 + SAD ch.17 + the devops extract to the pack.  
4. Keep evidence tags honest: Confirmed (ux) vs Proposed (platform adoption).

## Non-goals

- Enabling GitHub Actions in this docs repo.  
- Copying or claiming: Netlify, TTV filesync, whitelabel codegen, content-link checks, Playwright+axe contrast audit, eringest health cron, committed `.env` / `VITE_*` secret posture.  
- Inventing platform deploy strategy, Region, RTO/RPO, or Node/package-manager pins beyond stub comments.  
- Vendoring the touchscreen-ux clone into `mesmerize`.

## Decisions (approved in brainstorming)

| # | Decision |
|---|----------|
| 1 | Deliver **both** docs matrix and concrete template files (user option C). |
| 2 | Templates live under **`docs/ci-templates/`** — not live `.github/` here (user option A). |
| 3 | **Core gate only** — mirror `ci.yml` shape + PR template + CODEOWNERS patterns (user option A). |
| 4 | **Tool-agnostic skeleton** — job graph + principles; commands as `TODO` until stack is fixed (user option C). |
| 5 | Approach **1**: matrix + thin stubs + doc wiring; explicit do-not-adopt list. |

## Source inventory (Confirmed for touchscreen-ux)

### Workflows

| File | Role | Ladder A stance |
|------|------|-----------------|
| `workflows/ci.yml` | Parallel lint / typecheck / test / placeholder-scan / build; Node 22; npm cache; secrets→`.env` for build; lint `continue-on-error` while debt | **Adopt pattern** (core gate; no placeholder-scan; no VITE/.env commit story) |
| `workflows/check-content-links.yml` | Path-filtered content JSON link check | Do not adopt (Ladder B / content repos) |
| `workflows/contrast-audit.yml` | Playwright + axe; warn-only; artifacts; path filters | Do not adopt (PWA a11y) |
| `workflows/generate-whitelabel.yml` | Path filter; concurrency; bot commit + `[skip ci]` | Do not adopt (whitelabel); codegen+skip-ci pattern may be noted as future-only |
| `workflows/check-ingest-endpoint.yml` | curl OPTIONS to eringest; daily cron | Do not adopt as-is (PWA analytics); generic health-probe idea = later hardening, out of core band |

### Repo hygiene

| File | Role | Ladder A stance |
|------|------|-----------------|
| `CODEOWNERS` | Default + path-based review routing | **Adopt pattern** (placeholder owners) |
| `PULL_REQUEST_TEMPLATE.md` | Conventional title; staging base; content≠code; local gates | **Adopt pattern** (drop PWA-only items; content≠code checklist only if the platform repo holds content JSON — per ADR-016) |
| `ISSUE_TEMPLATE/*` | Bug (env matrix) + content request | Out of core band (document only) |

### Adjacent stack (not under `.github`, informs matrix notes)

ESLint 9 flat + typescript-eslint + react plugins; Prettier + Tailwind plugin; Vitest; Playwright + `@axe-core/playwright`. No Dependabot. No in-repo deploy workflow (Netlify external).

## Deliverables

```
docs/ci-templates/
  README.md                 # How to copy into platform .github/; dual-ladder warning
  ADOPTION.md               # Practice matrix (columns below)
  workflows/ci.yml          # Tool-agnostic core gate skeleton
  PULL_REQUEST_TEMPLATE.md  # Platform-oriented PR skeleton
  CODEOWNERS                # Placeholder path owners
```

### `ADOPTION.md` columns

Practice | Source file | Confirmed (touchscreen-ux) | Ladder A stance (Proposed / Do not adopt / Later) | Notes

### `ci.yml` skeleton requirements

- Header comment: not wired in `mesmerize`; copy to platform `.github/workflows/`.  
- Triggers: `push` / `pull_request` to `staging` (and `main` if used).  
- Jobs: `lint`, `typecheck`, `test`, `build` with `build.needs: [typecheck, test]`.  
- Use `actions/checkout@v4` and `actions/setup-node@v4` with cache placeholder.  
- Node major: comment that ux uses 22; Ladder A pin remains **Unknown** until stack ADR.  
- Every install/lint/typecheck/test/build step is a `# TODO:` command line.  
- Optional comment: lint `continue-on-error` only while tracked debt exists.  
- Build config injection via GHA secrets/vars or cloud secret store — **not** committed client `.env`.  
- Do **not** include placeholder-scan, whitelabel, contrast, content-links, or eringest jobs.

### Doc wiring

1. **ADR-016** — add decision or consequences bullet: CI gate patterns (Proposed) live in `docs/ci-templates/`; do not treat PWA-only workflows as Ladder A.  
2. **SAD `17-ci-cd.md`** — update CI checks / Unknowns: exact *live* platform workflow inventory still Unknown; Proposed gate shape documented in template pack sourced from touchscreen-ux Confirmed `.github`.  
3. **`touchscreen-ux-devops-extract.md`** — add “Inspected `.github` (local clone)” listing the five workflows + CODEOWNERS/PR/issue templates; note clone path is external provenance, not committed here.  
4. Mirror ADR/SAD updates per existing `output_docs/` rules if that tree is maintained for those files.

## Guardrails

- Never claim Netlify / TTV / whitelabel / axe as Ladder A requirements.  
- Never invent deploy strategy, Region, or runnable CI in this repo.  
- Do not commit the touchscreen-ux clone into `mesmerize`.  
- Evidence: Confirmed = observed in ux clone/docs; Proposed = platform should adopt; Unknown = not decided (e.g. Node pin, package manager).

## Success criteria

- [ ] `docs/ci-templates/` pack exists and matches this design.  
- [ ] `ADOPTION.md` lists adopt vs do-not-adopt with sources.  
- [ ] ADR-016, ch.17, and devops extract point at the pack / inventory.  
- [ ] No Ladder B workflow copied as a Ladder A requirement.  
- [ ] No commit unless explicitly requested by the user.

## Implementation note

After this spec is approved, create an implementation plan via `writing-plans` (no implementation in the brainstorming phase).
