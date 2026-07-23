# CI templates (Ladder A — platform)

**Status:** Reference pack only — **not** wired as GitHub Actions in the `mesmerize` docs repo.

**Purpose:** Copy these stubs into a future Content Evidence **platform** monorepo under `.github/` when that repo exists. Patterns are **Proposed** for Ladder A, sourced from **Confirmed** touchscreen-ux `.github` practices (see [`ADOPTION.md`](./ADOPTION.md)).

## Dual-ladder warning

- **Ladder A (platform AWS):** GitHub Actions → ECR → ECS + Terraform. Use this pack.
- **Ladder B (device/PWA):** Netlify web preview, TTV filesync, whitelabel, content-link and contrast audits — **do not** copy those workflows here as platform requirements ([ADR-016](../adr/016-git-branching-and-delivery-ladders.md)).

## Contents

| File | Copy to (platform repo) |
|------|-------------------------|
| [`workflows/ci.yml`](./workflows/ci.yml) | `.github/workflows/ci.yml` |
| [`PULL_REQUEST_TEMPLATE.md`](./PULL_REQUEST_TEMPLATE.md) | `.github/PULL_REQUEST_TEMPLATE.md` |
| [`CODEOWNERS`](./CODEOWNERS) | `.github/CODEOWNERS` |
| [`ADOPTION.md`](./ADOPTION.md) | Keep in docs or ops; do not need to ship in app repo |

## Before first use in a platform repo

1. Replace every `# TODO:` command with the real package-manager / monorepo commands.
2. Pin Node (or runtime) major per stack ADR — touchscreen-ux uses Node 22; Ladder A pin is **Unknown** until decided.
3. Replace `CODEOWNERS` placeholders with real GitHub handles/teams.
4. Do **not** enable lint `continue-on-error` unless tracked debt tickets exist.

## Spec

[`docs/superpowers/specs/2026-07-23-ci-templates-adoption-from-touchscreen-ux-design.md`](../superpowers/specs/2026-07-23-ci-templates-adoption-from-touchscreen-ux-design.md)
