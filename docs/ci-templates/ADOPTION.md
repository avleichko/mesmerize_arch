# Adoption matrix — touchscreen-ux `.github` → Ladder A

**Inspected:** local clone `.github` (external path; not vendored into `mesmerize`).  
**Band:** Core gate only. Hardening (path filters, cron probes, artifacts, codegen `[skip ci]`) = Later / out of band.

| Practice | Source | Confirmed (touchscreen-ux) | Ladder A stance | Notes |
|----------|--------|----------------------------|-----------------|-------|
| Parallel jobs: lint, typecheck, test, build | `workflows/ci.yml` | Yes | **Proposed** | Build `needs` typecheck+test |
| `actions/checkout@v4` + `setup-node@v4` + cache | `workflows/ci.yml` | Yes | **Proposed** | Cache key TBD with package manager |
| Lockfile install (`npm ci`) | `workflows/ci.yml` | Yes | **Proposed** | Command is TODO until stack fixed |
| Lint may `continue-on-error` while debt tracked | `workflows/ci.yml` | Yes | **Proposed pattern** | Not a permanent free pass |
| Secrets/vars → build env (not committed client secrets) | `workflows/ci.yml` | Yes (VITE via secrets→`.env`) | **Proposed** | Platform: GHA secrets / Secrets Manager — **not** PWA committed `.env` |
| Triggers on `staging` (+ `main`) push/PR | `workflows/ci.yml` | Yes | **Proposed** | Matches ADR-016 branching proposal |
| PR template: conventional title, what/why, verify, staging base | `PULL_REQUEST_TEMPLATE.md` | Yes | **Proposed** | Drop PWA-only checklist rows |
| Content≠code on separate PRs | `PULL_REQUEST_TEMPLATE.md` | Yes | **Proposed when repo holds content JSON** | Else omit (ADR-016) |
| CODEOWNERS path routing | `CODEOWNERS` | Yes | **Proposed** | Placeholder owners in this pack |
| Placeholder asset warn scan | `workflows/ci.yml` job `placeholder-scan` | Yes | **Do not adopt** | Content JSON / PWA |
| Content link checker (path filter) | `check-content-links.yml` | Yes | **Do not adopt** | Ladder B / content |
| Contrast audit (Playwright + axe, warn-only, artifacts) | `contrast-audit.yml` | Yes | **Do not adopt** | PWA a11y |
| Whitelabel regen + bot commit `[skip ci]` | `generate-whitelabel.yml` | Yes | **Do not adopt** | PWA authoring |
| Daily/PR curl health to eringest | `check-ingest-endpoint.yml` | Yes | **Do not adopt** | PWA analytics endpoint |
| Issue templates (bug env matrix, content request) | `ISSUE_TEMPLATE/*` | Yes | **Later** | Out of core band |
| Concurrency cancel-in-progress | `generate-whitelabel.yml` | Yes | **Later** | Hardening band |
| Dependabot | — | No | — | Not present upstream |
| In-repo deploy to Netlify/ECS | — | No (Netlify external) | Ladder A deploy = separate Unknown | Do not invent strategy here |

## Adjacent tools (informational)

Observed in touchscreen-ux package ecosystem (not required as Ladder A pins): ESLint 9 flat, typescript-eslint, Prettier, Vitest, Playwright, `@axe-core/playwright`.
