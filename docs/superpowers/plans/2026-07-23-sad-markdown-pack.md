# Mesmerize SAD Markdown Pack Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create an evidence-filled Markdown SAD pack under `output_docs/sad/` with standalone chapters, embedded diagram images, colored white-spot callouts, and hybrid progress/coverage trackers.

**Architecture:** Working SAD pack lives only under `output_docs/sad/`. Chapters embed PNGs from `output_docs/output_diagrams/` via relative paths. `PROGRESS.md` + `COVERAGE.md` track maturity % and white spots. Word export is deferred; `WORD_TEMPLATE_CROSSWALK.md` maps chapters to the official SAD template later.

**Tech Stack:** Markdown + HTML callouts; PlantUML (`.tools/plantuml.jar` + OpenJDK); Mermaid CLI (`npx @mermaid-js/mermaid-cli`); existing ADRs / `docs/ai/*` / NFR / `docs/architecture/deployment/*`.

**Spec:** `docs/superpowers/specs/2026-07-23-sad-markdown-pack-design.md`

## Global Constraints

- Location: `output_docs/sad/` only (no `docs/sad/`).
- Do not invent SLOs, RTO, RPO, Region, account IDs, or secrets.
- C4 Persons = runtime only; stakeholders in tables (ADR-012).
- Honor ADR-009 (imaging out of SOW) and ADR-011 (do-not-build).
- Status callouts must include textual labels **and** colors (Confirmed / Inferred / Proposed / Unknown).
- Diagrams: embed as images (`![…](…)`), not bare links.
- Image path from chapters: `../../output_diagrams/<file>.png` (must exist under `output_docs/output_diagrams/`).
- Sync new/updated PNGs to **both** `output_diagrams/` and `output_docs/output_diagrams/`.
- Commit only when the user has asked for commits in this session; otherwise skip commit steps and leave a note in the handoff.
- Fill from evidence; mark gaps with Unknown/Proposed callouts — never silent omissions.

### Shared callout snippets (copy verbatim into chapters)

```html
<!-- Confirmed -->
<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> TEXT
</p>

<!-- Inferred -->
<p style="background:#fff8e1;border-left:4px solid #f9a825;padding:8px 12px;margin:12px 0;">
  <strong>Inferred:</strong> TEXT
</p>

<!-- Proposed -->
<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> TEXT
</p>

<!-- Unknown / white spot -->
<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> TEXT
</p>
```

### Shared chapter header template

```markdown
# NN. Title

| Field | Value |
|-------|-------|
| Chapter ID | `NN-slug` |
| SAD mapping | Template section X **or** Mesmerize extension |
| Last updated | 2026-07-23 |
| Maturity | Draft · XX% (see `../PROGRESS.md`) |

## Purpose of this chapter

…

## Narrative

…

## Diagrams

![Caption](../../output_diagrams/FILE.png)

*Figure: what to read from this diagram.*

## Evidence

- ADR-…
- `docs/ai/…`

## White spots

<!-- colored Unknown/Proposed only -->

## Open questions

- … **or** None.
```

---

### Task 1: Scaffold pack + README + shared conventions

**Files:**
- Create: `output_docs/sad/README.md`
- Create: `output_docs/sad/chapters/.gitkeep` (removed once first chapter exists; optional)
- Create: `output_docs/sad/_snippets/callouts.md` (copy-paste library for authors)

**Interfaces:**
- Produces: directory layout; color legend; how to read PROGRESS/COVERAGE; relative image path rule

- [ ] **Step 1: Create directories**

```bash
mkdir -p output_docs/sad/chapters output_docs/sad/_snippets
```

- [ ] **Step 2: Write `output_docs/sad/_snippets/callouts.md`**

Paste the four HTML callout snippets from Global Constraints plus a one-line note: “Always keep the bold status word.”

- [ ] **Step 3: Write `output_docs/sad/README.md`**

Must include:
1. Purpose of the working SAD pack  
2. Chapter index table linking to all 16 planned files (links may 404 until later tasks)  
3. Color legend (Confirmed / Inferred / Proposed / Unknown)  
4. Pointers to `PROGRESS.md`, `COVERAGE.md`, `WORD_TEMPLATE_CROSSWALK.md`  
5. Image path convention  
6. Note: Word `.docx` fill is out of scope for this pack  

- [ ] **Step 4: Verify scaffold**

```bash
test -d output_docs/sad/chapters && test -f output_docs/sad/README.md && test -f output_docs/sad/_snippets/callouts.md && echo OK
```

Expected: `OK`

- [ ] **Step 5: Commit (only if user requested commits)**

```bash
git add output_docs/sad/README.md output_docs/sad/_snippets/callouts.md
git commit -m "$(cat <<'EOF'
docs: scaffold Mesmerize SAD markdown working pack

EOF
)"
```

---

### Task 2: Render diagram PNGs required by SAD chapters

**Files:**
- Create/update PNGs under `output_diagrams/` and mirror to `output_docs/output_diagrams/`
- Required for embeds: `01`–`16` (as applicable), plus existing `17`/`18` already present

**Interfaces:**
- Produces: PNG files named to match sources, e.g. `07-c4-context.png`, `06-c4-containers.png`, `01-system-context.png`

- [ ] **Step 1: Render all PlantUML sources to PNG**

```bash
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
OUT=output_diagrams
JAR=.tools/plantuml.jar
for f in output_diagrams/{06-c4-containers,07-c4-context,08-multitenancy-overview,09-multitenancy-silo,10-multitenancy-bridge,11-smart-3legged-oauth-athena,12-smart-3legged-oauth-athena-detailed,13-sqs-messaging-overview,14-sqs-request-reply-correlation,15-sqs-fire-and-forget,16-sqs-enricher-dlq}.puml; do
  java -jar "$JAR" -tpng -o "$(pwd)/$OUT" "$f"
done
# Rename PlantUML output if it used @startuml diagram name instead of filename
ls -la output_diagrams/*.png | sed -n '1,40p'
```

Expected: PNG present for each listed `.puml` (fix renames if PlantUML used internal diagram names).

- [ ] **Step 2: Render Mermaid `.mmd` to PNG via mermaid-cli**

```bash
npx --yes @mermaid-js/mermaid-cli -i output_diagrams/01-system-context.mmd -o output_diagrams/01-system-context.png
npx --yes @mermaid-js/mermaid-cli -i output_diagrams/02-phi-boundary.mmd -o output_diagrams/02-phi-boundary.png
npx --yes @mermaid-js/mermaid-cli -i output_diagrams/03-encounter-flow.mmd -o output_diagrams/03-encounter-flow.png
npx --yes @mermaid-js/mermaid-cli -i output_diagrams/04-monorepo-boundaries.mmd -o output_diagrams/04-monorepo-boundaries.png
npx --yes @mermaid-js/mermaid-cli -i output_diagrams/05-auth-model.mmd -o output_diagrams/05-auth-model.png
npx --yes @mermaid-js/mermaid-cli -i output_diagrams/06-c4-containers.mmd -o output_diagrams/06-c4-containers.png
```

If `06-c4-containers.png` already exists from PlantUML, keep the clearer render (prefer PlantUML C4 if Mermaid C4 fails).

- [ ] **Step 3: Mirror PNGs into export folder**

```bash
mkdir -p output_docs/output_diagrams
cp -f output_diagrams/*.png output_docs/output_diagrams/
cp -f output_diagrams/*.svg output_docs/output_diagrams/ 2>/dev/null || true
# Verify required embeds resolve
for f in 01-system-context 02-phi-boundary 03-encounter-flow 04-monorepo-boundaries 05-auth-model 06-c4-containers 07-c4-context 08-multitenancy-overview 09-multitenancy-silo 10-multitenancy-bridge 11-smart-3legged-oauth-athena 12-smart-3legged-oauth-athena-detailed 13-sqs-messaging-overview 14-sqs-request-reply-correlation 15-sqs-fire-and-forget 16-sqs-enricher-dlq 17-aws-deployment-reference 18-aws-production-deployment; do
  test -f "output_docs/output_diagrams/${f}.png" || echo "MISSING $f"
done
```

Expected: no `MISSING` lines (or only document failures as Unknown in chapters that need them).

- [ ] **Step 4: Update `output_diagrams/README.md` and mirror** to list new PNGs.

- [ ] **Step 5: Commit (only if user requested commits)**

```bash
git add output_diagrams/*.png output_docs/output_diagrams/*.png output_diagrams/README.md output_docs/output_diagrams/README.md
git commit -m "$(cat <<'EOF'
docs: render architecture diagram PNGs for SAD embeds

EOF
)"
```

---

### Task 3: Chapter 13 — Deployment & Infrastructure

**Files:**
- Create: `output_docs/sad/chapters/13-deployment-and-infrastructure.md`
- Evidence sources: `docs/adr/015-aws-deployment-reference.md`, `docs/adr/010-technology-stack.md`, `docs/architecture/deployment/aws-production-deployment.md`, `docs/ai/ARCHITECTURE.md` (cloud section)

**Interfaces:**
- Consumes: callout snippets; PNGs `18-aws-production-deployment.png`, `17-aws-deployment-reference.png`
- Produces: chapter maturity estimate for later PROGRESS (target after write: Draft ~50–75%)

- [ ] **Step 1: Write the chapter** using the shared header template (Mesmerize extension). Embed both diagrams with captions. Cover ingress, compute, data, SQS, security Proposed controls, CI/CD, HA TBD. Include Unknown callouts for Region, RTO/RPO, Multi-AZ flags, autoscaling bounds.

- [ ] **Step 2: Verify images resolve**

```bash
python3 - <<'PY'
from pathlib import Path
import re
p=Path('output_docs/sad/chapters/13-deployment-and-infrastructure.md')
text=p.read_text()
base=p.parent
for m in re.findall(r'!\[[^\]]*\]\(([^)]+)\)', text):
    target=(base/m).resolve()
    print(('OK' if target.exists() else 'MISSING'), m)
PY
```

Expected: all `OK`

- [ ] **Step 3: Commit (only if user requested commits)** with message `docs(sad): add deployment chapter 13`

---

### Task 4: Chapter 10 — Security & Privacy

**Files:**
- Create: `output_docs/sad/chapters/10-security-and-privacy.md`
- Evidence: ADR-002, 005, 012; `docs/ai/SECURITY.md`; diagrams `02`, `05`, `11`, `12`

- [ ] **Step 1: Write chapter** — zero PHI, browser FHIR token, SMART 3-legged, Auth0 admin, BAAs, audit/diag log split. Embed four diagrams. Unknown: AWS BAA necessity; final observability vendor.

- [ ] **Step 2: Verify image paths resolve** (same Python snippet as Task 3, path changed to chapter 10).

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add security chapter 10`

---

### Task 5: Chapter 11 — Multitenancy

**Files:**
- Create: `output_docs/sad/chapters/11-multitenancy.md`
- Evidence: ADR-013; diagrams `08`, `09`, `10`

- [ ] **Step 1: Write chapter** — Org=tenant; Silo vs Bridge; pilot default Bridge; S3 `{tenantId}/{clinicId}/…`. Embed three diagrams.

- [ ] **Step 2: Verify image paths resolve.**

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add multitenancy chapter 11`

---

### Task 6: Chapter 12 — Messaging & Integration

**Files:**
- Create: `output_docs/sad/chapters/12-messaging-and-integration.md`
- Evidence: ADR-014; diagrams `13`–`16`; externals Athena/Auth0/Esper/CMS/SMS from PROJECT_CONTEXT

- [ ] **Step 1: Write chapter** — REST edge; SQS RR + correlation; fire-and-forget; enricher+DLQ. Embed four SQS diagrams. Note edge interactive path is not SQS RR.

- [ ] **Step 2: Verify image paths resolve.**

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add messaging chapter 12`

---

### Task 7: Chapter 08 — System Architecture

**Files:**
- Create: `output_docs/sad/chapters/08-system-architecture.md`
- Evidence: `docs/ai/ARCHITECTURE.md`; ADR-007, 010; diagrams `06-c4-containers.png`, `04-monorepo-boundaries.png`

- [ ] **Step 1: Write chapter** with subsections **Component Responsibilities** and **Component Interactions** (template Heading-2s). Table of NestJS services → responsibilities → deps. Embed C4 containers + monorepo diagrams.

- [ ] **Step 2: Verify image paths resolve.**

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add system architecture chapter 08`

---

### Task 8: Chapter 09 — Data Architecture

**Files:**
- Create: `output_docs/sad/chapters/09-data-architecture.md`
- Evidence: ADR-002, 006, 013; SECURITY; diagram `02-phi-boundary.png`

- [ ] **Step 1: Write chapter** with subsections Data Sources, Data Model (logical — no invented table schemas), Data Flow, Data Ownership. Embed PHI boundary. State what is **not** stored (patient identifiers on Mesmerize servers).

- [ ] **Step 2: Verify image paths resolve.**

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add data architecture chapter 09`

---

### Task 9: Chapter 07 — Functional Architecture

**Files:**
- Create: `output_docs/sad/chapters/07-functional-architecture.md`
- Evidence: ADR-001, 003, 008; diagrams `03-encounter-flow.png`, `05-auth-model.png`

- [ ] **Step 1: Write chapter** — launch → recommend → push → engage → suggest → approve → DocumentReference writeback. Embed encounter + auth diagrams.

- [ ] **Step 2: Verify image paths resolve.**

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add functional architecture chapter 07`

---

### Task 10: Chapter 06 — Solution Scope

**Files:**
- Create: `output_docs/sad/chapters/06-solution-scope.md`
- Evidence: ADR-001, 004, 009, 011; diagrams `01-system-context.png`, `17-aws-deployment-reference.png`

- [ ] **Step 1: Write chapter** with Solution Description + Solution Architecture Diagram subsections. Explicit in/out of scope lists. Embed system context + stakeholder AWS overview.

- [ ] **Step 2: Verify image paths resolve.**

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add solution scope chapter 06`

---

### Task 11: Chapter 05 — Business Context

**Files:**
- Create: `output_docs/sad/chapters/05-business-context.md`
- Evidence: `docs/ai/PROJECT_CONTEXT.md`; ADR-012; diagram `07-c4-context.png`

- [ ] **Step 1: Write chapter** with Business Objective, Expected Business Value, Key Stakeholders (**table**, not C4 Persons). Embed C4 context for runtime actors only; caption must say stakeholders are in the table.

- [ ] **Step 2: Verify image paths resolve.**

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add business context chapter 05`

---

### Task 12: Chapter 14 — NFR & Quality Attributes

**Files:**
- Create: `output_docs/sad/chapters/14-nfr-and-quality-attributes.md`
- Evidence: `docs/ai/NFR.md`, `output_docs/nfr/NFR_CATALOG.md`, `ASR_CHECKLIST.md`

- [ ] **Step 1: Write chapter** — summarize ASR groups; link to full catalog; **do not invent numeric SLOs**. Unknown callouts where NFR says undefined.

- [ ] **Step 2: Verify** no invented RTO/RPO numbers appear:

```bash
rg -n "RTO|RPO|99\.[0-9]|SLA" output_docs/sad/chapters/14-nfr-and-quality-attributes.md || true
```

Any numeric target must already exist in NFR sources; otherwise mark Unknown.

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add NFR chapter 14`

---

### Task 13: Chapters 01–04 (template spine front matter)

**Files:**
- Create: `output_docs/sad/chapters/01-purpose.md`
- Create: `output_docs/sad/chapters/02-scope.md`
- Create: `output_docs/sad/chapters/03-related-documents.md`
- Create: `output_docs/sad/chapters/04-definitions-and-acronyms.md`

- [ ] **Step 1: Write 01 Purpose** — audience, why this SAD pack exists, relationship to Word template.

- [ ] **Step 2: Write 02 Scope** — in/out; environments Dev/Staging/Prod; pilot-gated Prod; reference ADR-009/011.

- [ ] **Step 3: Write 03 Related Documents** — table linking ADRs 001–015, `docs/ai/*`, NFR, deployment MD, diagram catalog.

- [ ] **Step 4: Write 04 Definitions** — short acronym list for SAD readers; link to chapter 15 / `docs/ai/GLOSSARY.md` for full terms. Do not duplicate long glossary entries.

- [ ] **Step 5: Verify all four files exist and README links work conceptually.**

- [ ] **Step 6: Commit (only if requested)** `docs(sad): add SAD front-matter chapters 01-04`

---

### Task 14: Chapters 15–16 (terms + revision history)

**Files:**
- Create: `output_docs/sad/chapters/15-key-terms-and-abbreviations.md`
- Create: `output_docs/sad/chapters/16-revision-history.md`

- [ ] **Step 1: Write 15** — fuller terms from `docs/ai/GLOSSARY.md` (condense, cite source). Cross-link chapter 04.

- [ ] **Step 2: Write 16** — revision table starting with v0.1 Draft 2026-07-23 “Initial Markdown SAD working pack”.

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add glossary and revision history chapters`

---

### Task 15: PROGRESS.md + COVERAGE.md

**Files:**
- Create: `output_docs/sad/PROGRESS.md`
- Create: `output_docs/sad/COVERAGE.md`

**Interfaces:**
- Consumes: all 16 chapters’ actual content quality
- Produces: honest % scores (not fake 100%)

- [ ] **Step 1: Build `COVERAGE.md`**

For each chapter 01–16, list shared checklist items (from spec) + chapter-specific items. Mark each `[x]` or `[ ]`. List white spots explicitly under each chapter (must match colored Unknown/Proposed callouts in the chapter body).

Chapter-specific minimums:
- 05: stakeholder table present  
- 06: in/out scope lists  
- 07: encounter happy path  
- 08: responsibilities + interactions  
- 09: sources/model/flow/ownership  
- 10: PHI + auth diagrams embedded  
- 11: silo + bridge diagrams embedded  
- 12: all four SQS diagrams embedded  
- 13: both AWS diagrams embedded; TBD Region/RTO called out  
- 14: ASR summary without invented SLOs  

- [ ] **Step 2: Build `PROGRESS.md`**

Compute per-chapter % = (checked items / applicable items) × 100, map to nearest band (0/25/50/75/100). Overall = average of chapter %. Include a short “hottest white spots” list (top 5–10 Unknowns).

- [ ] **Step 3: Sanity check — every red Unknown in chapters appears in COVERAGE**

```bash
rg -n "Unknown:" output_docs/sad/chapters/*.md
rg -n "Unknown|white spot" output_docs/sad/COVERAGE.md
```

- [ ] **Step 4: Commit (only if requested)** `docs(sad): add progress and coverage trackers`

---

### Task 16: Crosswalk + README finalization + pack verification

**Files:**
- Create: `output_docs/sad/WORD_TEMPLATE_CROSSWALK.md`
- Modify: `output_docs/sad/README.md` (fix links; add overall % from PROGRESS)
- Optionally note in `docs/ai/ARCHITECTURE.md` that SAD working pack lives at `output_docs/sad/` (one short paragraph — only if it does not violate “don’t edit unrelated docs”; this is a pointer, allowed)

- [ ] **Step 1: Write crosswalk** mapping Word template Heading-1/2 → MD chapters; list extensions 10–14 as future appendices.

- [ ] **Step 2: Update README chapter index** so every link resolves:

```bash
python3 - <<'PY'
from pathlib import Path
root=Path('output_docs/sad')
missing=[]
for p in (root/'chapters').glob('*.md'):
    pass
expected=[f"{i:02d}" for i in range(1,17)]
have={p.name[:2] for p in (root/'chapters').glob('*.md')}
for e in expected:
    if e not in have: missing.append(e)
print('missing chapters', missing or 'none')
# broken image refs
import re
broken=[]
for p in (root/'chapters').glob('*.md'):
  for m in re.findall(r'!\[[^\]]*\]\(([^)]+)\)', p.read_text()):
    if not (p.parent/m).resolve().exists():
      broken.append(f'{p.name}:{m}')
print('broken images', broken or 'none')
PY
```

Expected: `missing chapters none`, `broken images none`

- [ ] **Step 3: Final evidence hygiene**

```bash
rg -n "AKIA|[0-9]{12}" output_docs/sad/ || echo "no account-looking ids"
```

- [ ] **Step 4: Commit (only if requested)** `docs(sad): finalize crosswalk and pack verification`

---

## Spec coverage self-check

| Spec requirement | Task |
|------------------|------|
| `output_docs/sad/` only | 1 |
| 16 standalone chapters | 3–14 |
| Embedded images | 2 + each chapter task |
| Color callouts | Global + each chapter |
| Dual trackers PROGRESS + COVERAGE | 15 |
| Word crosswalk | 16 |
| Evidence-filled / no invented SLOs | 3–14, esp. 12 |
| Diagram map 05–13 | 3–11 |
| 04 vs 15 split | 13–14 |
| Sync PNGs to both diagram folders | 2 |

## Placeholder scan

Plan avoids TBD implementation steps; Unknowns are **content** outcomes inside chapters, not plan gaps.
