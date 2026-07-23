# CI Templates + Adoption Matrix from touchscreen-ux Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a non-runnable Ladder A CI template pack under `docs/ci-templates/` (adoption matrix + core-gate stubs) and wire ADR-016, SAD ch.17, and the touchscreen-ux devops extract to it.

**Architecture:** Docs-only pack (Approach 1). Core gate only (lint/typecheck/test/build + PR template + CODEOWNERS). Tool-agnostic `TODO` commands. Explicit do-not-adopt for Ladder B workflows. No live `.github/` in this repo.

**Tech Stack:** Markdown + GitHub Actions YAML skeletons (not executed here).

**Spec:** `docs/superpowers/specs/2026-07-23-ci-templates-adoption-from-touchscreen-ux-design.md`

## Global Constraints

- Templates live only under `docs/ci-templates/` — do **not** create runnable `.github/workflows/` in `mesmerize`.
- Core gate only — do **not** template whitelabel, content-links, contrast-audit, or eringest workflows as Ladder A.
- Never claim Netlify / TTV / axe / committed `.env`/`VITE_*` as Ladder A requirements.
- Evidence: Confirmed = touchscreen-ux clone/docs; Proposed = platform adoption; Unknown = Node pin / package manager / live platform inventory.
- Do not vendor `/Users/sasaaleksandrov/myProjects/touchscreen-ux` into this repo.
- Mirror ADR under `output_docs/docs/adr/` when editing `docs/adr/`.
- Commit only if the user explicitly requested commits this session; otherwise skip commit steps.

## File map

| Path | Responsibility |
|------|----------------|
| `docs/ci-templates/README.md` | How to copy into a future platform repo; dual-ladder warning |
| `docs/ci-templates/ADOPTION.md` | Practice → stance matrix |
| `docs/ci-templates/workflows/ci.yml` | Tool-agnostic core gate skeleton |
| `docs/ci-templates/PULL_REQUEST_TEMPLATE.md` | Platform-oriented PR skeleton |
| `docs/ci-templates/CODEOWNERS` | Placeholder path owners |
| `kb/customer-reference/touchscreen-ux-devops-extract.md` | Add inspected `.github` inventory |
| `docs/adr/016-git-branching-and-delivery-ladders.md` (+ `output_docs` mirror) | Point at template pack |
| `output_docs/sad/chapters/17-ci-cd.md` | CI checks / Proposed / Unknown wording |

---

### Task 1: Template pack README + ADOPTION matrix

**Files:**
- Create: `docs/ci-templates/README.md`
- Create: `docs/ci-templates/ADOPTION.md`

**Interfaces:**
- Produces: Pack root docs that Tasks 2–3 and doc-wiring tasks link to

- [ ] **Step 1: Create `docs/ci-templates/README.md`** with exactly this content:

```markdown
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
```

- [ ] **Step 2: Create `docs/ci-templates/ADOPTION.md`** with exactly this content:

```markdown
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
```

- [ ] **Step 3: Verify files exist**

```bash
test -f docs/ci-templates/README.md && test -f docs/ci-templates/ADOPTION.md && echo OK
rg -n "Do not adopt|Proposed|Ladder A" docs/ci-templates/ADOPTION.md | head -20
```

Expected: `OK`; matrix rows include both Proposed and Do not adopt.

- [ ] **Step 4: Commit (only if requested)** `docs(ci): add Ladder A adoption matrix and template README`

---

### Task 2: Core gate `ci.yml` skeleton

**Files:**
- Create: `docs/ci-templates/workflows/ci.yml`

**Interfaces:**
- Consumes: Stance from Task 1 (`ADOPTION.md` Proposed rows)
- Produces: Copy-target workflow for platform repos

- [ ] **Step 1: Create directory and write `docs/ci-templates/workflows/ci.yml`:**

```yaml
# REFERENCE ONLY — not executed in the mesmerize docs repo.
# Copy to a platform monorepo as: .github/workflows/ci.yml
# Source patterns: touchscreen-ux .github/workflows/ci.yml (Confirmed there; Proposed here).
# Spec: docs/superpowers/specs/2026-07-23-ci-templates-adoption-from-touchscreen-ux-design.md
#
# Do NOT add: Netlify, TTV, whitelabel, content-links, contrast/axe, eringest, placeholder-scan.

name: CI

on:
  push:
    branches: [main, staging]
  pull_request:
    branches: [main, staging]

jobs:
  lint:
    runs-on: ubuntu-latest
    # Optional: continue-on-error: true  # only while tracked lint debt exists
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          # touchscreen-ux uses Node 22; Ladder A pin is Unknown until stack ADR — set explicitly when adopting
          node-version: '22'
          # cache: 'npm'  # TODO: enable when package manager is fixed (npm|pnpm|yarn)
      - name: Install
        run: |
          # TODO: lockfile install (e.g. npm ci / pnpm install --frozen-lockfile)
          echo "TODO: install dependencies"
          exit 1
      - name: Lint
        run: |
          # TODO: package lint script
          echo "TODO: lint"
          exit 1

  typecheck:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
      - name: Install
        run: |
          # TODO: lockfile install
          echo "TODO: install dependencies"
          exit 1
      - name: Typecheck
        run: |
          # TODO: e.g. tsc -b / nest build --typecheck
          echo "TODO: typecheck"
          exit 1

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
      - name: Install
        run: |
          # TODO: lockfile install
          echo "TODO: install dependencies"
          exit 1
      - name: Test
        run: |
          # TODO: unit/integration test command
          echo "TODO: test"
          exit 1

  build:
    needs: [typecheck, test]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '22'
      - name: Install
        run: |
          # TODO: lockfile install
          echo "TODO: install dependencies"
          exit 1
      - name: Inject build config from secrets/vars
        env:
          # TODO: map platform secrets/vars (not committed client .env / VITE_*)
          EXAMPLE_API_URL: ${{ vars.EXAMPLE_API_URL }}
        run: |
          # TODO: write env file or export for build; prefer cloud secret store for runtime
          echo "TODO: configure build env from GHA secrets/vars or skip if not needed for compile"
      - name: Build
        run: |
          # TODO: production build (and later: docker build / push ECR — deploy strategy Unknown)
          echo "TODO: build"
          exit 1
```

- [ ] **Step 2: Verify skeleton**

```bash
test -f docs/ci-templates/workflows/ci.yml
rg -n "TODO:|needs: \[typecheck, test\]|REFERENCE ONLY|whitelabel|Netlify" docs/ci-templates/workflows/ci.yml
```

Expected: `REFERENCE ONLY` present; `needs: [typecheck, test]` present; multiple `TODO:`; **no** `whitelabel` or `Netlify` job names (header may mention them in Do NOT add comment — that is OK).

- [ ] **Step 3: Commit (only if requested)** `docs(ci): add tool-agnostic Ladder A ci.yml skeleton`

---

### Task 3: PR template + CODEOWNERS skeletons

**Files:**
- Create: `docs/ci-templates/PULL_REQUEST_TEMPLATE.md`
- Create: `docs/ci-templates/CODEOWNERS`

- [ ] **Step 1: Write `docs/ci-templates/PULL_REQUEST_TEMPLATE.md`:**

```markdown
<!-- Title: conventional prefix — feat: / fix: / chore: / docs: / refactor: (content: only if this repo holds content JSON) -->

## What & why

<!-- One or two lines. Link the issue: Closes #N -->

## How to verify

<!-- What should the reviewer run or check? -->

## Checklist

- [ ] Base branch is **`staging`** (never `main`) — Proposed for platform repos (ADR-016)
- [ ] If this repo holds content JSON: this PR is **either** content **or** code — not both (ADR-016)
- [ ] Ran locally: lint · typecheck · test · build (commands per repo README)
- [ ] No secrets committed; build/runtime config uses approved secret store / GHA secrets
```

- [ ] **Step 2: Write `docs/ci-templates/CODEOWNERS`:**

```
# REFERENCE ONLY — copy to platform repo as .github/CODEOWNERS
# Replace placeholders with real GitHub users/teams that have write access.
# Last matching pattern wins.

# Default
* @REPLACE_DEFAULT_OWNER

# Example path routing (uncomment and edit when monorepo layout is known)
# /apps/ @REPLACE_APP_OWNERS
# /infra/ @REPLACE_INFRA_OWNERS
# /docs/ @REPLACE_DOCS_OWNERS
```

- [ ] **Step 3: Verify pack complete**

```bash
find docs/ci-templates -type f | sort
```

Expected paths:
```
docs/ci-templates/ADOPTION.md
docs/ci-templates/CODEOWNERS
docs/ci-templates/PULL_REQUEST_TEMPLATE.md
docs/ci-templates/README.md
docs/ci-templates/workflows/ci.yml
```

- [ ] **Step 4: Commit (only if requested)** `docs(ci): add PR template and CODEOWNERS skeletons`

---

### Task 4: Update devops extract with inspected `.github`

**Files:**
- Modify: `kb/customer-reference/touchscreen-ux-devops-extract.md`

- [ ] **Step 1: After the existing CI table row / “Git / branching / CI / deployment” section, append a new subsection** (keep existing Confirmed table intact). Insert before `## Dual delivery ladders`:

```markdown
## Inspected `.github` (local clone)

**Provenance:** Workflows and templates were inspected from a local clone of `MesmerizeTeam/touchscreen-ux` (`.github/`). That clone is **not** vendored into this repo. Docs under `kb/customer-reference/touchscreen-ux/` remain the citable Downloads copies for CONTRIBUTING/DEPLOYMENT.

| Path | Role |
|------|------|
| `workflows/ci.yml` | Parallel lint (continue-on-error while debt), `tsc -b`, vitest, placeholder-scan (warn), build; Node 22; npm cache; secrets/vars → `.env` for build |
| `workflows/check-content-links.yml` | Path filter `src/data/**`; Node script link check |
| `workflows/contrast-audit.yml` | Playwright + axe; warn-only; artifact upload; path filters + `workflow_dispatch` |
| `workflows/generate-whitelabel.yml` | On `whitelabel.json` change; concurrency; bot commit `[skip ci]` |
| `workflows/check-ingest-endpoint.yml` | PR/push + daily cron; curl OPTIONS to eringest |
| `CODEOWNERS` | Default + path owners for `src/data/`, `public/images/`, `whitelabel.json` |
| `PULL_REQUEST_TEMPLATE.md` | Conventional title; staging base; content≠code; local gates |
| `ISSUE_TEMPLATE/` | Bug report (env matrix); content request |

**Ladder A adoption:** Portable core-gate patterns and do-not-adopt list → [`docs/ci-templates/`](../../docs/ci-templates/).
```

- [ ] **Step 2: Verify**

```bash
rg -n "Inspected \`\.github\`|docs/ci-templates" kb/customer-reference/touchscreen-ux-devops-extract.md
```

Expected: both matches.

- [ ] **Step 3: Commit (only if requested)** `docs(kb): record touchscreen-ux .github inventory in extract`

---

### Task 5: Wire ADR-016 (+ mirror)

**Files:**
- Modify: `docs/adr/016-git-branching-and-delivery-ladders.md`
- Modify: `output_docs/docs/adr/016-git-branching-and-delivery-ladders.md` (keep identical)

- [ ] **Step 1: Add decision item 5** after item 4 in the Decision list:

```markdown
5. **CI gate patterns (Proposed for platform):** Core GitHub Actions gate shape (parallel lint · typecheck · test · build), PR template, and CODEOWNERS patterns are documented as copy-ready stubs in [`docs/ci-templates/`](../ci-templates/). Sourced from Confirmed touchscreen-ux `.github` practices. Do **not** treat Ladder B–only workflows (whitelabel regen, content-link checks, contrast/axe, eringest probe, Netlify) as Ladder A requirements. Live NestJS workflow inventory in a platform monorepo remains **Unknown** until that repo adopts the stubs.
```

- [ ] **Step 2: Add to Related:**

```markdown
- [`docs/ci-templates/`](../ci-templates/) — Ladder A CI template pack + adoption matrix  
- [SAD Chapter 17 — CI/CD](../../output_docs/sad/chapters/17-ci-cd.md)
```

- [ ] **Step 3: Copy the same edits to `output_docs/docs/adr/016-git-branching-and-delivery-ladders.md`** (or `cp` after editing canonical `docs/adr/` if that is the source of truth for mirrors).

- [ ] **Step 4: Verify**

```bash
rg -n "ci-templates|CI gate patterns" docs/adr/016-git-branching-and-delivery-ladders.md output_docs/docs/adr/016-git-branching-and-delivery-ladders.md
```

Expected: matches in both files.

- [ ] **Step 5: Commit (only if requested)** `docs(adr): point ADR-016 at Ladder A CI template pack`

---

### Task 6: Update SAD Chapter 17 CI checks

**Files:**
- Modify: `output_docs/sad/chapters/17-ci-cd.md`

- [ ] **Step 1: Replace the Proposed callout under CI checks** with:

```markdown
<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> Platform monorepo CI adopts the core gate shape (parallel lint · typecheck · test · build; PR template; CODEOWNERS) documented in <a href="../../../docs/ci-templates/">docs/ci-templates/</a> (adoption matrix + tool-agnostic stubs sourced from touchscreen-ux Confirmed <code>.github</code>). Exact <em>live</em> NestJS workflow inventory is not yet frozen in a platform repo.
</p>
```

- [ ] **Step 2: Add Evidence bullet:**

```markdown
- [`docs/ci-templates/`](../../../docs/ci-templates/) — Ladder A CI template pack + adoption matrix (Proposed)
```

- [ ] **Step 3: Soften Unknown / open question 3** so they do not contradict the template pack:

In the Unknown callout, change the third clause to:

`exact live platform GitHub Actions inventory in a platform monorepo (Proposed gate shape documented in docs/ci-templates/)`

Change open question 3 to:

`3. When the platform monorepo exists, which package-manager commands and Node pin replace the TODOs in docs/ci-templates/workflows/ci.yml?`

- [ ] **Step 4: Verify**

```bash
rg -n "ci-templates|Proposed gate|TODO" output_docs/sad/chapters/17-ci-cd.md
# Ensure Ladder A still does not claim Netlify
rg -n "Ladder A" -A2 output_docs/sad/chapters/17-ci-cd.md | rg -i "netlify|ttv" && echo FAIL || echo OK_no_conflation
```

Expected: `ci-templates` linked; `OK_no_conflation`.

- [ ] **Step 5: Commit (only if requested)** `docs(sad): link ch.17 to CI template pack`

---

### Task 7: Pack consistency check

**Files:** (read-only verify; fix only if a prior task missed something)

- [ ] **Step 1: Run full verification**

```bash
find docs/ci-templates -type f | sort
rg -n "docs/ci-templates" \
  docs/adr/016-git-branching-and-delivery-ladders.md \
  output_docs/docs/adr/016-git-branching-and-delivery-ladders.md \
  output_docs/sad/chapters/17-ci-cd.md \
  kb/customer-reference/touchscreen-ux-devops-extract.md
# Must NOT exist:
test ! -d .github/workflows && echo "no_live_gha_ok"
# Must not adopt Ladder B as Ladder A templates:
ls docs/ci-templates/workflows/
```

Expected: five pack files; all four docs reference `ci-templates`; `no_live_gha_ok`; only `ci.yml` under `docs/ci-templates/workflows/`.

- [ ] **Step 2: Spec coverage self-check** — confirm each Success criterion in the design spec is met (pack exists; ADOPTION lists adopt vs do-not; ADR/ch.17/extract wired; no Ladder B as A; commits skipped unless requested).

- [ ] **Step 3: Commit (only if requested)** — single rollup only if user asked and prior task commits were skipped.

---

## Spec coverage (plan self-review)

| Spec requirement | Task |
|------------------|------|
| `docs/ci-templates/README.md` | 1 |
| `ADOPTION.md` matrix | 1 |
| `workflows/ci.yml` tool-agnostic | 2 |
| PR template + CODEOWNERS | 3 |
| Extract `.github` inventory | 4 |
| ADR-016 + mirror | 5 |
| SAD ch.17 update | 6 |
| No live `.github` / no Ladder B templates | 2, 7 |
| No commit unless requested | All tasks |
