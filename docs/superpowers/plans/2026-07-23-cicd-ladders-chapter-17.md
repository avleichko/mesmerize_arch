# CI/CD Ladder Diagrams + SAD Chapter 17 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add PlantUML Ladder A/B CI/CD diagrams (19/20), render PNGs, create SAD chapter 17 CI/CD, slim ch.13 CI/CD to a pointer, and update pack trackers/crosswalk/catalog.

**Architecture:** Two separate PlantUML activity diagrams (never combine Netlify/TTV with ECS). Chapter 17 owns delivery narrative; chapter 13 keeps runtime AWS topology (diagrams 17/18). Evidence from ADR-016 and touchscreen-ux extract.

**Tech Stack:** PlantUML (`.tools/plantuml.jar` + OpenJDK), Markdown SAD + HTML callouts.

**Spec:** `docs/superpowers/specs/2026-07-23-cicd-ladders-chapter-17-design.md`

## Global Constraints

- Chapter file: `output_docs/sad/chapters/17-ci-cd.md` only (do not renumber 01–16).
- Diagrams: `19-ladder-a-platform-cicd` and `20-ladder-b-device-cicd` (`.puml` + `.png`).
- Ladder A must **not** include Netlify or TTV filesync.
- Ladder B must mark Netlify as **web only** and TTV filesync as **human-triggered**.
- Do not invent deploy strategy (rolling/blue-green/canary), Region, or RTO/RPO.
- Confirmed / Proposed / Inferred / Unknown callouts per existing SAD snippets.
- Sync PNGs to both `output_diagrams/` and `output_docs/output_diagrams/`.
- Commit only if the user explicitly requested commits this session; otherwise skip commit steps.

---

### Task 1: PlantUML Ladder A + PNG

**Files:**
- Create: `output_diagrams/19-ladder-a-platform-cicd.puml`
- Create: `output_diagrams/19-ladder-a-platform-cicd.png`
- Copy PNG: `output_docs/output_diagrams/19-ladder-a-platform-cicd.png`
- Copy source: `output_docs/output_diagrams/19-ladder-a-platform-cicd.puml` (optional but preferred for export parity)

- [ ] **Step 1: Write PlantUML activity/flow** with nodes: Developer/PR → GitHub Actions (lint·test·build) → ECR [Inferred] → Terraform → ECS/Fargate. Notes for Confirmed direction and Unknown deploy strategy. No Netlify/TTV.

- [ ] **Step 2: Render**

```bash
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
java -jar .tools/plantuml.jar -tpng -o "$(pwd)/output_diagrams" output_diagrams/19-ladder-a-platform-cicd.puml
# Rename if @startuml id differs from basename
ls output_diagrams/*ladder-a* output_diagrams/19* 2>/dev/null
cp -f output_diagrams/19-ladder-a-platform-cicd.png output_docs/output_diagrams/
cp -f output_diagrams/19-ladder-a-platform-cicd.puml output_docs/output_diagrams/
```

- [ ] **Step 3: Verify PNG is not an error page** (`file` shows reasonable dimensions, e.g. height > 200).

- [ ] **Step 4: Commit (only if requested)** `docs(diagrams): add Ladder A platform CI/CD PlantUML`

---

### Task 2: PlantUML Ladder B + PNG

**Files:**
- Create: `output_diagrams/20-ladder-b-device-cicd.puml`
- Create: `output_diagrams/20-ladder-b-device-cicd.png`
- Mirror under `output_docs/output_diagrams/`

- [ ] **Step 1: Write PlantUML** with feature → PR→staging → CI → fork (Netlify web-only | human TTV → QA) → promote main → human TTV → prod fleet → Esper tags. Confirmed for touchscreen-ux. Note clear cache + version stamp.

- [ ] **Step 2: Render + mirror** (same OpenJDK/jar pattern as Task 1).

- [ ] **Step 3: Verify PNG dimensions OK.**

- [ ] **Step 4: Update `output_diagrams/README.md`** (and mirror) with rows for 19 and 20.

- [ ] **Step 5: Commit (only if requested)** `docs(diagrams): add Ladder B device CI/CD PlantUML`

---

### Task 3: Create chapter 17 CI/CD

**Files:**
- Create: `output_docs/sad/chapters/17-ci-cd.md`
- Read: `output_docs/sad/_snippets/callouts.md`, ADR-016, extract, sibling chapter style (e.g. 13)

- [ ] **Step 1: Write chapter** with shared header (Mesmerize extension), Purpose, Branching/PRs, Ladder A (embed `../../output_diagrams/19-ladder-a-platform-cicd.png`), Ladder B (embed `20-...`), CI checks table, Evidence, White spots, Open questions.

- [ ] **Step 2: Verify embeds**

```bash
python3 - <<'PY'
from pathlib import Path
import re
p=Path('output_docs/sad/chapters/17-ci-cd.md')
t=p.read_text(); b=p.parent
for m in re.findall(r'!\[[^\]]*\]\(([^)]+)\)', t):
 print(('OK' if (b/m).resolve().exists() else 'MISSING'), m)
assert '19-ladder-a' in t and '20-ladder-b' in t
assert 'Netlify' in t and 'ECS' in t
print('done')
PY
```

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add chapter 17 CI/CD`

---

### Task 4: Slim ch.13 + related docs + crosswalk + README

**Files:**
- Modify: `output_docs/sad/chapters/13-deployment-and-infrastructure.md`
- Modify: `output_docs/sad/chapters/03-related-documents.md`
- Modify: `output_docs/sad/WORD_TEMPLATE_CROSSWALK.md`
- Modify: `output_docs/sad/README.md`
- Optional: `docs/ai/ARCHITECTURE.md` one-line pointer

- [ ] **Step 1: Ch.13** — replace long Ladder A/B CI narrative with short summary + link to [17-ci-cd.md](17-ci-cd.md). Keep AWS topology and figures 17/18.

- [ ] **Step 2: Ch.03** — add chapter 17 + diagrams 19/20 to tables.

- [ ] **Step 3: Crosswalk** — Appendix F = CI/CD → `17-ci-cd.md`.

- [ ] **Step 4: README** — add row for chapter 17 in index.

- [ ] **Step 5: Optional ARCHITECTURE pointer** to SAD ch.17.

- [ ] **Step 6: Commit (only if requested)** `docs(sad): point deployment chapter to CI/CD ch17`

---

### Task 5: PROGRESS + COVERAGE rescore

**Files:**
- Modify: `output_docs/sad/PROGRESS.md`
- Modify: `output_docs/sad/COVERAGE.md`
- Sync maturity line in `17-ci-cd.md` (and ch.13 if band changes)

- [ ] **Step 1: Add chapter 17 checklist** to COVERAGE (shared items + required diagrams 19/20 embedded; dual ladders; no Netlify→ECS; Unknown deploy strategy listed).

- [ ] **Step 2: Recompute PROGRESS** including ch.17; apply Unknown-cap (≤75 if Unknowns remain). Update overall average for 17 chapters now (01–17).

- [ ] **Step 3: Verify**

```bash
rg -n "17-ci-cd|19-ladder|20-ladder" output_docs/sad/PROGRESS.md output_docs/sad/COVERAGE.md output_docs/sad/README.md
test -f output_docs/sad/chapters/17-ci-cd.md
```

- [ ] **Step 4: Commit (only if requested)** `docs(sad): rescore progress after CI/CD chapter 17`

---

## Spec coverage

| Spec item | Task |
|-----------|------|
| Diagram 19 Ladder A | 1 |
| Diagram 20 Ladder B | 2 |
| Chapter 17 | 3 |
| Ch.13 slim + pack indexes | 4 |
| PROGRESS/COVERAGE | 5 |

## Placeholder scan

Unknown deploy strategy / platform staging semantics are **content** outcomes, not unfinished plan steps.
