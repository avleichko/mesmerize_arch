# CI templates (Ladder A — platform)

**Status:** Reference pack only — **not** wired as GitHub Actions in the `mesmerize` docs repo.

**Purpose:** Copy these stubs into the Content Evidence **platform** monorepo under `.github/` (customer home: `mesmerize-monorepo`). Patterns are **Proposed** for Ladder A. API runtime is **Python / FastAPI** ([ADR-017](../adr/017-python-platform-backend.md)).

## Dual-ladder warning

- **Ladder A (platform AWS):** GitHub Actions → ECR → ECS + Terraform. **Python** API images. Use this pack.
- **Ladder B (device/PWA):** Netlify web preview, TTV filesync, whitelabel, content-link and contrast audits — **do not** copy those workflows here as platform requirements ([ADR-016](../adr/016-git-branching-and-delivery-ladders.md)).

## Contents

| File | Copy to (platform repo) |
|------|-------------------------|
| [`workflows/ci.yml`](./workflows/ci.yml) | `.github/workflows/ci.yml` |
| [`PULL_REQUEST_TEMPLATE.md`](./PULL_REQUEST_TEMPLATE.md) | `.github/PULL_REQUEST_TEMPLATE.md` (customer scaffold already has a PHI-aware template — merge carefully) |
| [`CODEOWNERS`](./CODEOWNERS) | `.github/CODEOWNERS` |
| [`ADOPTION.md`](./ADOPTION.md) | Keep in docs or ops; do not need to ship in app repo |

## Before first use in a platform repo

1. Replace every `# TODO:` command with real **uv/Poetry** and **pnpm** commands.
2. Pin **Python** major (recommend 3.12+) — open as **Q-15** until decided; Node 20+ for frontends (customer `.nvmrc` = 20.11.0).
3. Replace `CODEOWNERS` placeholders with real GitHub handles/teams.
4. Do **not** enable lint `continue-on-error` unless tracked debt tickets exist.
5. Do **not** resurrect NestJS CI jobs as the Platform API path.

## Spec

[`docs/superpowers/specs/2026-07-23-ci-templates-adoption-from-touchscreen-ux-design.md`](../superpowers/specs/2026-07-23-ci-templates-adoption-from-touchscreen-ux-design.md)  
Customer analysis: [`docs/architecture/customer-monorepo-analysis.md`](../architecture/customer-monorepo-analysis.md)
