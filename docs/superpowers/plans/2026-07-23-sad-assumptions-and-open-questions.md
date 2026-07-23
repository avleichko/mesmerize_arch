# SAD Chapter 18 — Assumptions and Open Questions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add SAD Chapter 18 (Appendix G) as a two-track Mesmerize-facing register of Proposed assumptions (A-01…A-10) and Must-answer open questions (Q-01…Q-14), wire indexes, point other chapters’ Open questions at Ch.18 IDs, and rescore PROGRESS/COVERAGE.

**Architecture:** Consolidate white spots into one register; keep Unknown callouts in source chapters; replace long Open questions lists with ID pointers. Assumptions stay Proposed only; compliance/PHI stay Q-rows.

**Tech Stack:** Markdown SAD + HTML callouts (`_snippets/callouts.md`).

**Spec:** `docs/superpowers/specs/2026-07-23-sad-assumptions-and-open-questions-design.md`

## Global Constraints

- Chapter file: `output_docs/sad/chapters/18-assumptions-and-open-questions.md` only (do not renumber 01–17).
- Word mapping: **Appendix G**; export order after Appendix F (17).
- Audience: Mesmerize product/ops/compliance.
- Assumptions = **Proposed** only — never Confirmed for Region/RTO/BAA/owners invented here.
- Do not invent named people as Confirmed owners; do not invent RTO/RPO/Region numbers as Confirmed; do not claim “BAA not required.”
- Keep source-chapter **Unknown** callouts; only slim **Open questions** to Ch.18 pointers.
- Accepting an assumption does **not** clear source Unknowns until Mesmerize accepts and source chapters are updated (out of scope this plan).
- Commit only if the user explicitly requested commits this session; otherwise skip commit steps.

## File map

| Path | Responsibility |
|------|----------------|
| `output_docs/sad/chapters/18-assumptions-and-open-questions.md` | New chapter (registers + how to close) |
| `output_docs/sad/WORD_TEMPLATE_CROSSWALK.md` | Appendix G + export order |
| `output_docs/sad/README.md` | Chapter table + maturity line |
| `output_docs/sad/chapters/03-related-documents.md` | Link to ch.18 |
| Chapters `07–13`, `17` (and `02`,`05`,`06`,`14` if needed) | Open questions → pointers |
| `output_docs/sad/PROGRESS.md` / `COVERAGE.md` | Ch.18 row + 18-chapter rescore |
| Optional: `docs/ai/ARCHITECTURE.md` (+ mirror) | One-line pointer to ch.18 |

---

### Task 1: Create Chapter 18

**Files:**
- Create: `output_docs/sad/chapters/18-assumptions-and-open-questions.md`
- Read: `output_docs/sad/_snippets/callouts.md`, sibling chapter header style (e.g. `17-ci-cd.md`)

**Interfaces:**
- Produces: Canonical A-01…A-10 and Q-01…Q-14 IDs used by later tasks

- [ ] **Step 1: Write the chapter** with this structure and content (adapt only for typography consistency with siblings):

```markdown
# 18. Assumptions and Open Questions

| Field | Value |
|-------|-------|
| Chapter ID | `18-assumptions-and-open-questions` |
| SAD mapping | Mesmerize extension (Appendix G) |
| Last updated | 2026-07-23 |
| Maturity | Review-ready · 75% |

## Purpose of this chapter

Give Mesmerize product, ops, and compliance a single place to **accept or reject Proposed engineering assumptions** and **answer Must-answer questions** that currently appear as Unknown callouts across the SAD. Source chapters keep their Unknown callouts until Mesmerize closes each item; this chapter owns the decision register.

Audience: **Mesmerize internal** (not Newfire SOW language).

## How to use

1. **Assumptions (A-xx):** Accept → record acceptance (comment / ADR / revision history) → update source chapter Unknown when ready. Reject → replace with a decision and superseding note.
2. **Questions (Q-xx):** Answer with owner + date → update source Unknown → rescore [`PROGRESS.md`](../PROGRESS.md).
3. Do **not** treat Proposed assumptions as Confirmed evidence.

## Assumptions register (Proposed)

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> The following are engineering defaults for Phase 1 / pilot planning. They are <strong>not</strong> Confirmed until Mesmerize accepts them.
</p>

| ID | Assumption | Rationale | Invalidate if | Sources |
|----|------------|-----------|---------------|---------|
| A-01 | Pilot: one primary AWS Region (no multi-Region active-active in Phase 1) | Typical first SMART/athena pilot; DR secondary until RTO exists | Multi-Region required from day one | [13](13-deployment-and-infrastructure.md), [14](14-nfr-and-quality-attributes.md) |
| A-02 | RDS + Redis Multi-AZ on for Staging/Prod | Standard HA without inventing RTO | Cost/ops veto for pilot | [13](13-deployment-and-infrastructure.md) |
| A-03 | Ladder A Phase 1 deploy strategy = rolling | Simplest ECS default | Canary/blue-green mandated | [13](13-deployment-and-infrastructure.md), [17](17-ci-cd.md) |
| A-04 | Platform repos use `feature → staging → main` | Matches ADR-016 Proposed | Different promotion model | [02](02-scope.md), [17](17-ci-cd.md) |
| A-05 | NestJS services = separate ECS services by cutover | Blast-radius / boundary clarity | Long-lived co-locate for cost | [08](08-system-architecture.md) |
| A-06 | Queues `{env}-{service}-{purpose}`; RR timeout default 30s until measured | Unblocks messaging build | Different standard | [12](12-messaging-and-integration.md) |
| A-07 | SMS = one US-capable provider (Twilio-class) chosen at build | Common clinic messaging pattern | Other vendor already contracted | [12](12-messaging-and-integration.md) |
| A-08 | Silo: dedicated DB + secrets namespace; shared S3 + prefix until scale | ADR-013 spirit | Dedicated buckets day one | [11](11-multitenancy.md) |
| A-09 | Engagement/business logs retained ≥ 1 year Prod pending confirmation | Conservative floor; not multi-year claim | Signed retention differs | [14](14-nfr-and-quality-attributes.md) |
| A-10 | One observability vendor; PHI-safe log split (no PHI on Mesmerize servers) | Zero-PHI posture; vendor name open | Dual-tool mandate | [10](10-security-and-privacy.md), [14](14-nfr-and-quality-attributes.md) |

## Open questions register (Must-answer)

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> The following must be answered by Mesmerize before Stakeholder-ready sign-off. Owner column lists <em>roles</em>, not confirmed named individuals.
</p>

| ID | Question | Blocks | Suggested owner role | Sources |
|----|----------|--------|----------------------|---------|
| Q-01 | Who is Compliance / PHI approver? | Security sign-off | Compliance lead | [05](05-business-context.md), [10](10-security-and-privacy.md) |
| Q-02 | Who owns billing / engagement rules? | Product acceptance | Product / MM | [05](05-business-context.md) |
| Q-03 | Is an AWS BAA required given de-identified engagement schema? | Legal / account | Compliance + legal | [09](09-data-architecture.md), [10](10-security-and-privacy.md), [14](14-nfr-and-quality-attributes.md) |
| Q-04 | Ratify data-classification matrix (what may touch Mesmerize servers)? | Data + security | Compliance + architecture | [09](09-data-architecture.md), [10](10-security-and-privacy.md) |
| Q-05 | Confirm DocumentReference writeback field catalog + athena pilot acceptance | Writeback | Clinical informatics / EHR config | [07](07-functional-architecture.md) |
| Q-06 | RTO / RPO for Staging vs Prod? | DR / Multi-AZ spend | Ops + compliance | [13](13-deployment-and-infrastructure.md), [14](14-nfr-and-quality-attributes.md) |
| Q-07 | Primary AWS Region (+ DR Region if any)? | All infra | Ops / cloud owner | [13](13-deployment-and-infrastructure.md) |
| Q-08 | Formal availability / latency SLO for device↔cloud (or explicitly “none for pilot”)? | NFR-REL | Product + ops | [14](14-nfr-and-quality-attributes.md) |
| Q-09 | Final observability vendor + HIPAA logging policy pack timeline? | Ops + SEC | Ops / AM | [10](10-security-and-privacy.md), [14](14-nfr-and-quality-attributes.md) |
| Q-10 | Exact pilot clinic + device count and Command Center RBAC depth for Phase 1? | Scope / acceptance | Product / SOW owner | [06](06-solution-scope.md) |
| Q-11 | Silo provisioning runbook owner + post-go-live Bridge↔Silo switch policy? | Multitenancy ops | Platform ops | [11](11-multitenancy.md) |
| Q-12 | Engagement log retention years if beyond A-09? | Storage / compliance | Brandon / MM / compliance | [14](14-nfr-and-quality-attributes.md) |
| Q-13 | Who promotes Ladder A Staging → Prod and with what gates? | Delivery | Ops / eng lead | [17](17-ci-cd.md) |
| Q-14 | HIPAA policy pack delivery date from Mesmerize (AM)? | Security appendix | AM / compliance | [10](10-security-and-privacy.md) |

## Traceability (theme → IDs)

| Theme | IDs |
|-------|-----|
| Region / DR | A-01, Q-07 |
| RTO / RPO / Multi-AZ | A-02, Q-06 |
| Deploy / branching / promotion | A-03, A-04, Q-13 |
| Process split / ECS | A-05 |
| Messaging / SMS | A-06, A-07 |
| Multitenancy Silo | A-08, Q-11 |
| Logs / observability | A-09, A-10, Q-09, Q-12 |
| Compliance / BAA / classification / owners | Q-01, Q-02, Q-03, Q-04, Q-14 |
| Writeback payload | Q-05 |
| Pilot scope / RBAC | Q-10 |
| Device↔cloud SLO | Q-08 |

## How to close

1. Mesmerize answers a **Q-xx** or accepts/rejects an **A-xx**.  
2. Update the source chapter Unknown (and ADR if needed).  
3. Mark the row Status in this chapter (Accepted / Answered / Superseded) in a follow-up edit.  
4. Rescore [`COVERAGE.md`](../COVERAGE.md) / [`PROGRESS.md`](../PROGRESS.md).

## Evidence

- Source Unknowns across chapters 02, 05–14, 17 (see White spots in those files)
- [ADR-016](../../../docs/adr/016-git-branching-and-delivery-ladders.md) — branching Proposed for platform
- Spec: `docs/superpowers/specs/2026-07-23-sad-assumptions-and-open-questions-design.md`

## White spots

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> All open <strong>Q-01…Q-14</strong> rows above. Assumptions A-01…A-10 remain Proposed until accepted — they do not clear source-chapter Unknowns by themselves.
</p>
```

- [ ] **Step 2: Verify**

```bash
test -f output_docs/sad/chapters/18-assumptions-and-open-questions.md
rg -n '^\\| A-0|^\\| Q-1' output_docs/sad/chapters/18-assumptions-and-open-questions.md | wc -l
# Expect 10 A-rows + 14 Q-rows in tables (plus header lines)
rg -n "BAA not required|Confirmed:.*Region|RTO = " output_docs/sad/chapters/18-assumptions-and-open-questions.md && echo FAIL || echo OK_no_invented_confirmed
```

Expected: file exists; `OK_no_invented_confirmed`.

- [ ] **Step 3: Commit (only if requested)** `docs(sad): add chapter 18 assumptions and open questions`

---

### Task 2: Indexes — crosswalk, README, ch.03

**Files:**
- Modify: `output_docs/sad/WORD_TEMPLATE_CROSSWALK.md`
- Modify: `output_docs/sad/README.md`
- Modify: `output_docs/sad/chapters/03-related-documents.md`

- [ ] **Step 1: Crosswalk** — in Future appendices table add:

`| 18 | Assumptions and Open Questions | chapters/18-assumptions-and-open-questions.md | Appendix G |`

Update export order line to end with `→ Appendix F CI/CD (17) → Appendix G Assumptions (18)`.

- [ ] **Step 2: README** — add row for chapter 18; note Appendix G; keep overall % until Task 4 rescore (or placeholder “see PROGRESS”).

- [ ] **Step 3: ch.03** — add related-doc row linking to Chapter 18 as the pack decision register for Unknowns.

- [ ] **Step 4: Verify**

```bash
rg -n "18-assumptions|Appendix G" output_docs/sad/WORD_TEMPLATE_CROSSWALK.md output_docs/sad/README.md output_docs/sad/chapters/03-related-documents.md
```

- [ ] **Step 5: Commit (only if requested)** `docs(sad): index chapter 18 as Appendix G`

---

### Task 3: Point source Open questions at Ch.18 IDs

**Files:**
- Modify Open questions in: `07`, `08`, `09`, `10`, `11`, `12`, `13`, `17`
- Add or replace short Open questions in: `02`, `05`, `06`, `14` (these have Unknowns but may lack Open questions sections)

**Pointer pattern** (use per chapter; list only IDs that chapter owns):

```markdown
## Open questions

Consolidated for Mesmerize decision-making in [Chapter 18 — Assumptions and Open Questions](18-assumptions-and-open-questions.md).

- See **Q-xx** / **A-xx** (list IDs relevant to this chapter).
```

**ID mapping for each chapter:**

| Chapter | Pointer IDs |
|---------|-------------|
| 02 | A-04 |
| 05 | Q-01, Q-02 |
| 06 | Q-10 |
| 07 | Q-05 |
| 08 | A-05 |
| 09 | Q-03, Q-04 |
| 10 | Q-01, Q-03, Q-04, Q-09, Q-14, A-10 |
| 11 | A-08, Q-11 |
| 12 | A-06, A-07 |
| 13 | A-01, A-02, A-03, Q-06, Q-07 (+ note CI → 17 / Q-13) |
| 14 | A-01, A-09, A-10, Q-03, Q-06, Q-08, Q-09, Q-12 |
| 17 | A-03, A-04, Q-13 (+ optional note: ci-templates TODOs remain engineering follow-up, not Q-register) |

- [ ] **Step 1: Replace** each existing `## Open questions` body with the pointer pattern + that chapter’s IDs. **Do not remove** Unknown callouts elsewhere in the chapter.

- [ ] **Step 2: For 02, 05, 06, 14** — if no Open questions section, add one before Evidence or at end (match sibling order) with the pointer pattern.

- [ ] **Step 3: Verify**

```bash
rg -n "Chapter 18|18-assumptions" output_docs/sad/chapters/{02,05,06,07,08,09,10,11,12,13,14,17}-*.md
# Ensure long numbered open-question lists are gone from 13/17 (sample)
rg -n "^[0-9]+\\. Platform deployment" output_docs/sad/chapters/17-ci-cd.md && echo STALE || echo OK_slim
```

Expected: each listed chapter references Ch.18; `OK_slim`.

- [ ] **Step 4: Commit (only if requested)** `docs(sad): point chapter open questions to ch.18 IDs`

---

### Task 4: PROGRESS + COVERAGE rescore

**Files:**
- Modify: `output_docs/sad/COVERAGE.md`
- Modify: `output_docs/sad/PROGRESS.md`
- Modify: `output_docs/sad/README.md` (overall %)
- Sync maturity header on ch.18 if needed

- [ ] **Step 1: Add COVERAGE section `## 18 — Assumptions and Open Questions`** with shared checklist items (purpose, registers present, IDs A-01…A-10 / Q-01…Q-14, no invented Confirmed Region/RTO/BAA, pointers from other chapters). Score checklist complete but **band 75** (Unknown-cap while Qs open).

- [ ] **Step 2: PROGRESS** — add row for 18; recompute overall for **18 chapters**. Hottest white spots list should cite **Q-xx** IDs. Chapters at 100 remain 04, 15, 16 only unless something else has zero Unknowns.

- [ ] **Step 3: README** overall maturity ≈ recalculated band average; still **not** Stakeholder-ready.

- [ ] **Step 4: Verify**

```bash
rg -n "^\\| 18 |Appendix G|Q-0" output_docs/sad/PROGRESS.md output_docs/sad/COVERAGE.md output_docs/sad/README.md | head -30
```

- [ ] **Step 5: Commit (only if requested)** `docs(sad): rescore pack for chapter 18`

---

### Task 5: Optional ARCHITECTURE pointer + pack check

**Files:**
- Modify (optional but preferred): `docs/ai/ARCHITECTURE.md` and `output_docs/docs/ai/ARCHITECTURE.md`
- Read-only verify pack

- [ ] **Step 1: Add one sentence** near branching/CI or open-decisions: open product/ops/compliance decisions consolidated in SAD Chapter 18.

- [ ] **Step 2: Full verify**

```bash
test -f output_docs/sad/chapters/18-assumptions-and-open-questions.md
rg -n "Appendix G|18-assumptions" output_docs/sad/WORD_TEMPLATE_CROSSWALK.md output_docs/sad/README.md
rg -c "18-assumptions-and-open-questions" output_docs/sad/chapters/*.md
# Must still have Unknown callouts in source chapters:
rg -l "<strong>Unknown:</strong>" output_docs/sad/chapters/{10,13,17}-*.md
```

- [ ] **Step 3: Commit (only if requested)** — skip unless user asked.

---

## Spec coverage (plan self-review)

| Spec requirement | Task |
|------------------|------|
| Create ch.18 with A-01…A-10, Q-01…Q-14 | 1 |
| Appendix G / README / ch.03 | 2 |
| Pointers from other chapters; keep Unknowns | 3 |
| PROGRESS/COVERAGE 18 chapters; Unknown-cap | 4 |
| Optional ARCHITECTURE pointer | 5 |
| No invented Confirmed Region/RTO/BAA | 1, Global Constraints |
| Commit only if requested | All |
