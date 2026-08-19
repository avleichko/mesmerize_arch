# Dev Kickoff Infra Request (Ch.21) + ADR-017 Multi-Repo Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add SAD Chapter 21 (sequenced Now/Staging/Prod infra asks from Newfire to Mesmerize) and rewrite ADR-017 in place so repo strategy matches customer D-07 (per-service GitHub repos), then ripple live monorepo wording and push.

**Architecture:** Ch.21 is a tickable register (same callouts as Ch.18), not a `D-xx` source. ADR-017 keeps Python/FastAPI + SQLAlchemy; S8 becomes multi-repo. Conflicts (Region, D-04, D-05, IaC tool, shared accounts) stay **Ask**. No new diagram IDs.

**Tech Stack:** Markdown SAD + ADRs only. No Terraform/OIDC implementation.

## Global Constraints

- Cite `INFRASTRUCTURE.md` D-01–D-07; do not invent CIDR, RTO, SLOs, observability vendor, or Confirmed GitHub slugs.
- Never store AWS credentials in GitHub (D-06).
- No new ADR-020; do not `git rm` ADRs.
- No new PlantUML catalog IDs; Ch.21 tables-only.
- Ladder B = stub appendix only; do not describe Ladder A as Netlify/TTV.
- Starter repos **Proposed**: clinician SMART app, platform API (Python/FastAPI), infra/Terraform — exact slugs **Q-17**.
- Terraform as *the* IaC remains **Proposed** in this pack until customer `D-xx` (register lists IaC tool **open**).
- Push: architecture `main` + refresh `architecture/` on `docs/architecture-working-pack`.

---

## File map

| Path | Responsibility |
|------|----------------|
| `docs/adr/017-python-platform-backend.md` | S8 multi-repo; keep Python; fix imaging OOS leftover → ADR-019 |
| `docs/adr/010-technology-stack.md` | S8 row text |
| `docs/adr/README.md` | S8 register |
| `docs/adr/018-customer-decision-repo-second-kb.md` | Drop D-07 vs 017 from known tensions (resolved) |
| `docs/architecture/customer-monorepo-analysis.md` | Repo layout row: aligned to D-07 |
| `AGENTS.md`, `docs/ai/{ENGINEERING_RULES,ARCHITECTURE,CURRENT_STATE}.md` | No live “platform is one monorepo” |
| SAD Ch.02, 08, 17 | Logical modules vs physical service repos |
| `output_docs/sad/chapters/21-infra-provision-checklist.md` | New chapter |
| Ch.18, SAD README, COVERAGE, PROGRESS, Ch.03, Ch.16 | Q-17 + 21 chapters |
| `output_docs/docs/adr/` | Mirror ADR files |

---

### Task 1: Rewrite ADR-017, ADR-010 S8, ADR README, ADR-018 tension, mirrors

**Files:**
- Modify: `docs/adr/017-python-platform-backend.md`
- Modify: `docs/adr/010-technology-stack.md` (S8 row)
- Modify: `docs/adr/README.md` (S8)
- Modify: `docs/adr/018-customer-decision-repo-second-kb.md` (consequences: D-07 vs 017 **resolved**)
- Mirror: `cp` those files to `output_docs/docs/adr/`

**Interfaces:**
- Produces: Binding S8 = per-service repos (D-07)
- Consumes: Spec ADR-017 rewrite section

- [ ] **Step 1: Rewrite ADR-017 header** — Change “clarifies S8 monorepo as polyglot” to “amends S8 to **per-service GitHub repos** (customer D-07)”. Date: add “repo strategy aligned 2026-08-19”. Keep supersedes S3/S5.

- [ ] **Step 2: Replace S8 table row** with:

| **S8** | Repo layout | Turborepo + npm/pnpm workspaces (one repo) | **Multi-repo:** each deployable service in its **own GitHub repository** with its own OIDC pipeline ([customer `INFRASTRUCTURE.md` **D-07**](../../customer-kb/INFRASTRUCTURE.md); D-06). TypeScript services use **pnpm** (Turborepo optional **inside that repo**); Python API uses **uv** or **Poetry** **in the API repo**. Do not require a single polyglot monorepo or NestJS in the API tree. |

- [ ] **Step 3: Context/clarifications** — Customer `mesmerize-monorepo` is **docs + infra description**, not the platform code home. Logical names (`smart-app`, `platform-api`, shared packages) are **modules**, not “clone one Turborepo.” Clarification 4: imaging **display** in-scope ADR-019; still no Mesmerize DICOM viewer (remove “packages/webrtc out of SOW”). Clarification 5: Platform may also receive imaging artifact kind/opaque id (ADR-019), still no PHI. Open: Python version / uv vs Poetry (Q-15); **exact repo slugs (Q-17)**.

- [ ] **Step 4: ADR-010 S8** — `| S8 | Repo layout | **Multi-repo (per service)** per D-07 / ADR-017; pnpm in TS repos; uv/Poetry in Python API repo |`

- [ ] **Step 5: ADR README S8** — Area **Repo layout**; Decision **Multi-repo: one GitHub repo per deployable service (D-07)**; ADR 010+017.

- [ ] **Step 6: ADR-018** — Remove “D-07 multi-repo vs ADR-017 polyglot monorepo” from known tensions. Note repo strategy now follows D-07 via ADR-017.

- [ ] **Step 7: Verify** `rg -n "polyglot monorepo|clarifies \*\*S8\*\* monorepo as polyglot" docs/adr/017-python-platform-backend.md docs/adr/010-technology-stack.md docs/adr/README.md` — no live one-repo claim.

- [ ] **Step 8: Mirror** `cp -f docs/adr/010-technology-stack.md docs/adr/017-python-platform-backend.md docs/adr/018-customer-decision-repo-second-kb.md docs/adr/README.md output_docs/docs/adr/`

- [ ] **Step 9: Commit** `docs(adr): align ADR-017 S8 with D-07 service repos`

---

### Task 2: Ripple agent docs + SAD 02/08/17 + analysis

**Files:**
- Modify: `AGENTS.md` (working rule: match stack and **service-repo** layout)
- Modify: `docs/ai/ENGINEERING_RULES.md`, `ARCHITECTURE.md`, `CURRENT_STATE.md` (search `monorepo` / `Turborepo` / `polyglot`)
- Modify: `docs/architecture/customer-monorepo-analysis.md` repo-layout row: **Aligned** D-07 = ADR-017 (no longer Escalate)
- Modify: `output_docs/sad/chapters/02-scope.md`, `08-system-architecture.md`, `17-ci-cd.md` — “logical packages; physical = service repos”
- Mirror analysis under `output_docs/docs/architecture/` if that copy exists

**Interfaces:**
- Consumes: Task 1 S8 wording
- Produces: No live “platform is one monorepo” in agent/SAD paths listed

- [ ] **Step 1:** `rg -n "polyglot monorepo|pnpm/Turborepo|one git repo" AGENTS.md docs/ai docs/architecture output_docs/sad/chapters/02-scope.md output_docs/sad/chapters/08-system-architecture.md output_docs/sad/chapters/17-ci-cd.md`

- [ ] **Step 2:** Replace live claims. Keep “logical” `apps/smart-app` language with a one-line Confirmed: physical git = **per-service repos (D-07 / ADR-017)**. Ch.08 stack callout: drop “polyglot monorepo (pnpm…uv)”. Ch.17: frontend CI “if that service repo includes Node”.

- [ ] **Step 3: Verify** same `rg` — leftover only historical Context (customer used to have a NestJS scaffold).

- [ ] **Step 4: Commit** `docs: ripple service-repo layout through agent docs and SAD`

---

### Task 3: SAD Chapter 21

**Files:**
- Create: `output_docs/sad/chapters/21-infra-provision-checklist.md`

**Interfaces:**
- Consumes: Spec Gate 1–3, conflict table, Ladder B stub
- Produces: Q-17 citation (row added in Task 4)

- [ ] **Step 1: Create chapter** with field table (Chapter ID `21-infra-provision-checklist`, Mesmerize extension, 2026-08-19, Review-ready). Purpose: Newfire → Mesmerize infra; does not create `D-xx`. How to use: Need | Settled | Ask. HTML callouts same as Ch.18.

- [ ] **Step 2: Three register tables** covering every bullet in the spec Gate 1, 2, 3. Include account IDs `301478651732` / `063293864447` as **Confirmed (D-01)** not invented. SSO: message Mackenzie Clark / groups as published in customer README (cite `customer-kb/README.md`). D-06: no AWS keys in GitHub.

- [ ] **Step 3: Conflicts subsection** — exact five-row table from the spec.

- [ ] **Step 4: Ladder B appendix** — stub table only.

- [ ] **Step 5: Evidence + white spots + open questions** — Q-07, Q-09, Q-13, Q-03/Q-14, **Q-17**. No new diagram.

- [ ] **Step 6: Verify** `test -f output_docs/sad/chapters/21-infra-provision-checklist.md` and chapter contains `D-06`, `Q-17`, `Ladder B`.

- [ ] **Step 7: Commit** `docs(sad): add Chapter 21 development kickoff infra request`

---

### Task 4: Ch.18 Q-17 + pack index

**Files:**
- Modify: `output_docs/sad/chapters/18-assumptions-and-open-questions.md` (Q-17 + traceability)
- Modify: `output_docs/sad/chapters/03-related-documents.md` (Ch.21, ADR-017 multi-repo)
- Modify: `output_docs/sad/chapters/16-revision-history.md` (2026-08-19 Ch.21 / ADR-017 S8)
- Modify: `output_docs/sad/README.md` (21 chapters; mention Ch.21)
- Modify: `output_docs/sad/COVERAGE.md` (section 21)
- Modify: `output_docs/sad/PROGRESS.md` (21st chapter; recount)

**Q-17 row (exact):**

| Q-17 | Ratify exact GitHub **org + service repo slugs** for the Proposed starter set (clinician SMART app, platform API Python/FastAPI, infra/Terraform)? Until answered, names are **Proposed** in Chapter 21. | First service-repo create / OIDC trust | Eng lead + GitHub org owner | [21](21-infra-provision-checklist.md), D-07 |

- [ ] **Step 1:** Add Q-17 + theme “Service repos / OIDC”.

- [ ] **Step 2:** Index Ch.21 everywhere Ch.19–20 are indexed. PROGRESS: add Ch.21 at 75 Review-ready (Unknowns in chapter). Recount overall % honestly.

- [ ] **Step 3: Commit** `docs(sad): index Chapter 21 and add Q-17`

---

### Task 5: Verify + push architecture main + monorepo `architecture/`

**Files:** none new

- [ ] **Step 1:** `rg -n "polyglot monorepo|pnpm/Turborepo \(TS\)" docs/adr AGENTS.md docs/ai output_docs/sad` — no live one-repo platform claim (ADR-017 historical Context OK if labeled historical).

- [ ] **Step 2:** `rg "Q-17" output_docs/sad/chapters/18-assumptions-and-open-questions.md output_docs/sad/chapters/21-infra-provision-checklist.md`

- [ ] **Step 3:** `git push origin main` (this architecture repo).

- [ ] **Step 4:** Refresh `/Users/sasaaleksandrov/myProjects/newfire/mesmerize-monorepo/architecture/` from `git archive HEAD` of this repo; **keep** nested `architecture/README.md`; commit + `git push origin docs/architecture-working-pack`. Do not modify root `INFRASTRUCTURE.md`.

---

## Spec coverage (self-review)

| Spec item | Task |
|-----------|------|
| Ch.21 three gates + conflicts + Ladder B stub | 3 |
| Q-17 | 4 |
| SAD index 21 chapters | 4 |
| ADR-017 in-place multi-repo; keep Python | 1 |
| ADR-010 S8; README S8 | 1 |
| Ripple AGENTS/ai/SAD 02/08/17 | 2 |
| ADR-018 drop D-07 vs 017 tension | 1 |
| No new diagrams | 3 |
| Push main + monorepo architecture/ | 5 |
