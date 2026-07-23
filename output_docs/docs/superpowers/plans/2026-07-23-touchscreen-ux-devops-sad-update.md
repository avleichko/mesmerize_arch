# Touchscreen-ux DevOps → SAD/ADR Update Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ingest touchscreen-ux CI/CD/Git evidence into `kb/`, add ADR-016 (dual delivery ladders), and update SAD + agent/NFR docs so platform vs device delivery is explicit and tagged Confirmed/Proposed/Unknown.

**Architecture:** Evidence extract cites Downloads sources; ADR-016 is the decision spine; Ladder A (AWS/GHA/ECS/Terraform) stays ADR-010/015; Ladder B (staging→main, Netlify preview ≠ device, manual TTV filesync, Esper) is Confirmed for PWA; branching conventions are Proposed for Content Evidence platform repos.

**Tech Stack:** Markdown docs; existing SAD HTML callouts; ADR register.

**Spec:** `docs/superpowers/specs/2026-07-23-touchscreen-ux-devops-sad-update-design.md`

## Global Constraints

- Always distinguish **touchscreen-ux (device PWA)** vs **Content Evidence platform (AWS)**.
- Never claim Netlify or TTV filesync deploys NestJS/ECS.
- Do not invent Region, RTO/RPO, or platform rolling/blue-green/canary.
- Do not copy committed-`.env` / VITE key policy into platform Secrets Manager model (note as PWA-specific in SECURITY only).
- Evidence tags: Confirmed / Proposed / Inferred / Unknown per spec.
- Branch ladder Confirmed for touchscreen-ux: `feature → staging → main`; PRs target `staging`; never start from `main`.
- Commit only if the user explicitly requested commits this session; otherwise skip commit steps.
- Sync mirrors under `output_docs/` for any file that already has an export copy.

### Source paths (read-only inputs)

- `/Users/sasaaleksandrov/Downloads/AGENTS.md`
- `/Users/sasaaleksandrov/Downloads/CONTRIBUTING.md`
- `/Users/sasaaleksandrov/Downloads/DEPLOYMENT.md`
- `/Users/sasaaleksandrov/Downloads/README.md`

---

### Task 1: Evidence pack in kb/

**Files:**
- Create: `kb/customer-reference/touchscreen-ux-devops-extract.md`
- Create: `kb/customer-reference/touchscreen-ux/AGENTS.md` (copy)
- Create: `kb/customer-reference/touchscreen-ux/CONTRIBUTING.md` (copy)
- Create: `kb/customer-reference/touchscreen-ux/DEPLOYMENT.md` (copy)
- Create: `kb/customer-reference/touchscreen-ux/README.md` (copy)
- Create: `kb/customer-reference/README.md` (one-paragraph index)

**Interfaces:**
- Produces: citable extract table + provenance copies for ADR-016 and SAD

- [ ] **Step 1: Create directories and copy provenance files**

```bash
mkdir -p kb/customer-reference/touchscreen-ux
cp /Users/sasaaleksandrov/Downloads/AGENTS.md kb/customer-reference/touchscreen-ux/
cp /Users/sasaaleksandrov/Downloads/CONTRIBUTING.md kb/customer-reference/touchscreen-ux/
cp /Users/sasaaleksandrov/Downloads/DEPLOYMENT.md kb/customer-reference/touchscreen-ux/
cp /Users/sasaaleksandrov/Downloads/README.md kb/customer-reference/touchscreen-ux/
```

- [ ] **Step 2: Write `kb/customer-reference/README.md`**

State: these files are customer reference from Mesmerize touchscreen-ux; use the extract for architecture work; do not treat JSON/COLORS authoring as Content Evidence platform requirements.

- [ ] **Step 3: Write `kb/customer-reference/touchscreen-ux-devops-extract.md`**

Must include:
1. Purpose + date + source file list  
2. Table of Git/branching/CI/deployment facts (match spec extract table)  
3. Explicit **Out of extract** (JSON templates, COLORS, whitelabel authoring)  
4. Dual-ladder one-liner (platform vs device)  
5. Links to the four copied files under `kb/customer-reference/touchscreen-ux/`

- [ ] **Step 4: Verify**

```bash
test -f kb/customer-reference/touchscreen-ux-devops-extract.md
test -f kb/customer-reference/touchscreen-ux/DEPLOYMENT.md
rg -n "staging|TTV filesync|content/\*|Netlify" kb/customer-reference/touchscreen-ux-devops-extract.md
```

Expected: files exist; key terms present.

- [ ] **Step 5: Commit (only if user requested)**

```bash
git add kb/customer-reference
git commit -m "$(cat <<'EOF'
docs: add touchscreen-ux DevOps evidence extract

EOF
)"
```

---

### Task 2: ADR-016 + register + ADR-015 cross-link

**Files:**
- Create: `docs/adr/016-git-branching-and-delivery-ladders.md`
- Modify: `docs/adr/README.md`
- Modify: `docs/adr/015-aws-deployment-reference.md`
- Mirror under `output_docs/docs/adr/`

**Interfaces:**
- Consumes: extract from Task 1
- Produces: binding decision text for later tasks

- [ ] **Step 1: Write ADR-016** following existing ADR style (`docs/adr/015-*.md`): Status Accepted, Date 2026-07-23, Sources (extract + CONTRIBUTING/DEPLOYMENT), Context, Decision (4 points from spec), Consequences, Related (ADR-007, 010, 015).

Include Confirmed vs Proposed explicitly in Decision bullets.

- [ ] **Step 2: Update `docs/adr/README.md`** — add row for 016 in the register table; update any “decisions #1–#15” counts if present.

- [ ] **Step 3: Patch ADR-015** — add consequence/related note: platform topology unchanged; device delivery and org branching in ADR-016; do not show Netlify/TTV as ECS path.

- [ ] **Step 4: Mirror**

```bash
cp docs/adr/016-git-branching-and-delivery-ladders.md output_docs/docs/adr/
cp docs/adr/README.md output_docs/docs/adr/
cp docs/adr/015-aws-deployment-reference.md output_docs/docs/adr/
```

- [ ] **Step 5: Verify**

```bash
rg -n "Ladder A|Ladder B|Proposed|Confirmed|TTV|Netlify" docs/adr/016-git-branching-and-delivery-ladders.md
rg -n "016" docs/adr/README.md
```

- [ ] **Step 6: Commit (only if requested)** `docs(adr): add ADR-016 git branching and delivery ladders`

---

### Task 3: Agent docs (ENGINEERING_RULES, NFR, ARCHITECTURE, SECURITY, AGENTS)

**Files:**
- Modify: `docs/ai/ENGINEERING_RULES.md`
- Modify: `docs/ai/NFR.md`
- Modify: `docs/ai/ARCHITECTURE.md`
- Modify: `docs/ai/SECURITY.md`
- Modify: `AGENTS.md`
- Mirror under `output_docs/`

- [ ] **Step 1: ENGINEERING_RULES** — add subsection **Git & delivery**:
  - Branch prefixes + PRs to `staging` (**Proposed** for platform; **Confirmed** touchscreen-ux)
  - Content vs code separate PRs where content JSON exists
  - Dual ladders A/B one paragraph + link ADR-016

- [ ] **Step 2: NFR.md** — update/add OPS rows:
  - Device: manual TTV filesync; Netlify ≠ device; staging canary / main prod (**Confirmed** for PWA)
  - Platform: GitHub Actions + Terraform (**Confirmed** ADR-010); deploy strategy Unknown
  - Link ADR-016

- [ ] **Step 3: ARCHITECTURE.md** — add **Delivery & branching** under cloud/infra: dual ladders + ADR-016 + extract link. Do not replace ECS topology.

- [ ] **Step 4: SECURITY.md** — short note: touchscreen committed `.env` / VITE_* is **PWA client-bundle** policy; platform uses Secrets Manager Proposed / no PHI secrets invention. Link DEPLOYMENT extract.

- [ ] **Step 5: AGENTS.md** — in read-order or rules: point to ADR-016 and `kb/customer-reference/touchscreen-ux-devops-extract.md` for git/delivery; do not paste full CONTRIBUTING.

- [ ] **Step 6: Mirror changed files to `output_docs/`**

- [ ] **Step 7: Verify**

```bash
rg -n "ADR-016|Ladder A|Ladder B|TTV filesync" docs/ai/ENGINEERING_RULES.md docs/ai/NFR.md docs/ai/ARCHITECTURE.md docs/ai/SECURITY.md AGENTS.md
```

- [ ] **Step 8: Commit (only if requested)** `docs: wire ADR-016 into agent NFR and engineering rules`

---

### Task 4: SAD chapters 13, 02, 08, 14, 03

**Files:**
- Modify: `output_docs/sad/chapters/13-deployment-and-infrastructure.md`
- Modify: `output_docs/sad/chapters/02-scope.md`
- Modify: `output_docs/sad/chapters/08-system-architecture.md`
- Modify: `output_docs/sad/chapters/14-nfr-and-quality-attributes.md`
- Modify: `output_docs/sad/chapters/03-related-documents.md`

Use existing HTML callout snippets from `output_docs/sad/_snippets/callouts.md`.

- [ ] **Step 1: Chapter 13** — add dual-ladder section:
  - Ladder A: GHA → ECR → ECS + Terraform (Confirmed direction)
  - Ladder B: feature→staging→main; Netlify web-only; manual TTV filesync; Esper tags (Confirmed for PWA)
  - Proposed: platform repos adopt same branch/PR conventions
  - Keep Unknown: Region, RTO/RPO, Multi-AZ flags, platform deploy strategy
  - Narrow prior “CI/CD pack from AM” Unknown if ADR-016 now covers branching; leave observability vendor Unknown
  - Evidence links: ADR-016, extract

- [ ] **Step 2: Chapter 02** — align Dev/Staging/Prod narrative with release ladder note (PWA Confirmed; platform Proposed/Unknown for identical promotion).

- [ ] **Step 3: Chapter 08** — one short pointer: extend PWA / device runtime uses Ladder B (ADR-007 + ADR-016).

- [ ] **Step 4: Chapter 14** — update OPS ASR bullets to cite ADR-016 / device vs platform.

- [ ] **Step 5: Chapter 03** — add ADR-016 + extract to related documents tables.

- [ ] **Step 6: Verify images still resolve + key strings**

```bash
python3 - <<'PY'
from pathlib import Path
import re
for name in ['13-deployment-and-infrastructure','02-scope','08-system-architecture','14-nfr-and-quality-attributes','03-related-documents']:
 p=Path(f'output_docs/sad/chapters/{name}.md')
 t=p.read_text(); b=p.parent
 broken=[m for m in re.findall(r'!\[[^\]]*\]\(([^)]+)\)', t) if not (b/m).resolve().exists()]
 print(name, 'broken', broken or 'none', 'ADR-016', 'ADR-016' in t or '016' in t)
PY
rg -n "Ladder A|Ladder B|TTV filesync|Netlify" output_docs/sad/chapters/13-deployment-and-infrastructure.md
```

- [ ] **Step 7: Commit (only if requested)** `docs(sad): document dual delivery ladders from ADR-016`

---

### Task 5: Rescore PROGRESS + COVERAGE + README pointer

**Files:**
- Modify: `output_docs/sad/PROGRESS.md`
- Modify: `output_docs/sad/COVERAGE.md`
- Modify: `output_docs/sad/README.md` (optional one-line “see ADR-016”)
- Modify: `output_docs/sad/chapters/*` maturity lines only if PROGRESS bands change
- Optionally: `output_docs/sad/WORD_TEMPLATE_CROSSWALK.md` — no change unless new chapter (none)

- [ ] **Step 1: Update COVERAGE** for chapters 02, 03, 08, 13, 14 — mark new evidence items; adjust white spots (close “no CI/CD branching evidence”; keep Region/RTO/observability).

- [ ] **Step 2: Recompute PROGRESS** — apply Unknown-cap rule (band ≤75 if any Unknown remains). Overall % may rise slightly if CI Unknowns closed.

- [ ] **Step 3: Sync maturity headers** in affected chapters to PROGRESS.

- [ ] **Step 4: Verify**

```bash
rg -n "ADR-016|Unknown:" output_docs/sad/COVERAGE.md output_docs/sad/PROGRESS.md | head -40
rg -n "AKIA" output_docs/sad/ || echo "no AKIA"
```

- [ ] **Step 5: Commit (only if requested)** `docs(sad): rescore coverage after DevOps evidence ingest`

---

### Task 6: Final consistency sweep

**Files:** any leftovers from Tasks 1–5; `docs/ai/CURRENT_STATE.md` only if it mentions CI/CD vaguely (optional one line)

- [ ] **Step 1: Grep for contradictions**

```bash
rg -n "Netlify|filesync|squash|branch from main" docs/adr docs/ai output_docs/sad AGENTS.md kb/customer-reference/touchscreen-ux-devops-extract.md
```

Fix any sentence that claims Netlify deploys ECS or that platform CI is Unknown while ADR-016 exists.

- [ ] **Step 2: Confirm mirrors** — `output_docs/docs/adr/016-*.md` and updated ai docs exist.

- [ ] **Step 3: Write short handoff note** in report (if using SDD) listing: extract path, ADR-016, remaining Unknowns.

- [ ] **Step 4: Commit (only if requested)** `docs: finalize touchscreen-ux DevOps documentation ingest`

---

## Spec coverage self-check

| Spec requirement | Task |
|------------------|------|
| Evidence extract + provenance copies | 1 |
| ADR-016 + register + ADR-015 link | 2 |
| ENGINEERING_RULES / NFR / ARCHITECTURE / SECURITY / AGENTS | 3 |
| SAD 13/02/08/14/03 | 4 |
| PROGRESS/COVERAGE rescore | 5 |
| No Netlify→ECS; no invented RTO; dual ladders | 1–6 |
| output_docs mirrors | 2–3 |

## Placeholder scan

Plan uses “Unknown” only as documentation outcomes (deploy strategy, Region), not as unimplemented plan steps.
