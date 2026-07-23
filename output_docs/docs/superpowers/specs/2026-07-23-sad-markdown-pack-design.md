# Design: Mesmerize SAD Markdown Working Pack

**Date:** 2026-07-23  
**Status:** Approved for implementation planning (pending user review of this spec)  
**Approach:** Dual tracker + HTML color callouts (Approach 1)

## Goal

Produce a **working Solution Architecture Definition (SAD) pack in Markdown** under `output_docs/sad/`, with:

- **One standalone MD file per chapter**
- **Diagrams embedded as images** (not bare links)
- **Evidence-filled** content from existing ADRs, `docs/ai/*`, NFRs, and `output_diagrams/`
- **Progress + coverage trackers** so white spots are visible (hybrid % + checklists)
- **Colored callouts** for Confirmed / Inferred / Proposed / Unknown
- Freedom to diverge from the Word template now; later map via a crosswalk into `templates/Solution_Architecture_Definition_template.docx`

## Non-goals

- Filling the Word `.docx` in this pass (crosswalk only)
- Inventing SLOs, RTO, RPO, Region, account IDs, or other unconfirmed numbers
- Duplicating diagram binary sources inside `sad/` (reference `output_diagrams/`)
- Treating stakeholders as C4 Persons (ADR-012)

## Decisions (from brainstorming)

| Topic | Choice |
|-------|--------|
| Pack vs Word template | **C** — freer Markdown pack; Word later via crosswalk |
| Completeness model | **C Hybrid** — maturity band/% + per-chapter checklist |
| Chapter set | **B** — template spine + Mesmerize extensions |
| Location | **B** — `output_docs/sad/` only |
| First pass depth | **B** — evidence-filled draft |
| Diagrams | **Embed as images** in chapter MD |
| White spots | Colored HTML callouts + listed in `COVERAGE.md` |
| Tracker structure | Dual: `PROGRESS.md` + `COVERAGE.md` |

## Pack layout

```
output_docs/sad/
  README.md
  PROGRESS.md
  COVERAGE.md
  WORD_TEMPLATE_CROSSWALK.md
  chapters/
    01-purpose.md
    02-scope.md
    03-related-documents.md
    04-definitions-and-acronyms.md
    05-business-context.md
    06-solution-scope.md
    07-functional-architecture.md
    08-system-architecture.md
    09-data-architecture.md
    10-security-and-privacy.md          # extension
    11-multitenancy.md                  # extension
    12-messaging-and-integration.md     # extension
    13-deployment-and-infrastructure.md # extension
    14-nfr-and-quality-attributes.md    # extension
    15-key-terms-and-abbreviations.md
    16-revision-history.md
```

## Color legend

| Status | Meaning | Callout style |
|--------|---------|---------------|
| Confirmed | ADR / kb / docs evidence | Green background / border |
| Inferred | Strongly implied | Amber / orange |
| Proposed | Recommended, not decided | Blue |
| Unknown / TBD / white spot | Insufficient evidence | Red / magenta |

Use HTML `<p style="...">` (or equivalent) so colors show in GitHub/Cursor Markdown preview. Always include the **textual status word** so meaning survives monochrome/print.

## Progress model (`PROGRESS.md`)

- Maturity bands: **0 Outline · 25 Stub · 50 Draft · 75 Review-ready · 100 Stakeholder-ready**
- Per-chapter % derived from `COVERAGE.md` checklist completion (hybrid)
- Overall pack % = average of chapter scores
- Update whenever chapter content or checklist changes

## Coverage model (`COVERAGE.md`)

Shared checklist items (adapt per chapter where N/A):

1. Purpose stated  
2. Actors / components covered  
3. Required diagrams **embedded as images**  
4. Interfaces / interactions described  
5. Data ownership noted (where relevant)  
6. Security / PHI notes (where relevant)  
7. Evidence links (ADRs / docs)  
8. Open questions listed or explicitly “none”  
9. White spots only appear as colored Unknown/Proposed — no silent gaps  

Plus chapter-specific required items. Incomplete items = explicit white spots.

## Diagram → chapter map

| Chapter | Embedded diagrams |
|---------|-------------------|
| 05 Business Context | `07-c4-context` (+ stakeholder **tables**, not C4 Persons) |
| 06 Solution Scope | `01-system-context`; `17-aws-deployment-reference` |
| 07 Functional Architecture | `03-encounter-flow`; optionally `05-auth-model` |
| 08 System Architecture | `06-c4-containers` (render PNG if missing); `04-monorepo-boundaries` |
| 09 Data Architecture | `02-phi-boundary` |
| 10 Security & Privacy | `02-phi-boundary`; `05-auth-model`; `11` + `12` SMART OAuth |
| 11 Multitenancy | `08`, `09`, `10` |
| 12 Messaging & Integration | `13`–`16` |
| 13 Deployment & Infrastructure | `18` (primary); `17` (stakeholder companion) |
| 01–04, 14–16 | Generally no large architecture images; NFR uses ASR tables |

**Image paths:** from `output_docs/sad/chapters/` use `../../output_diagrams/<file>.png` (resolves to `output_docs/output_diagrams/`, the export mirror). When adding or regenerating diagrams, update **both** repo-root `output_diagrams/` and `output_docs/output_diagrams/` so embeds do not break.

**Mermaid-only sources:** render PNG once into both diagram folders so every chapter embeds a real image; if render is blocked, temporary Mermaid fence + Unknown callout until PNG exists.

**Chapters 04 vs 15:** keep both. `04` = SAD template “Definitions and Acronyms” (short project glossary for the SAD). `15` = fuller key terms aligned with `docs/ai/GLOSSARY.md`. Cross-link; do not duplicate long definitions in both.

## Chapter skeleton

1. Title + meta (id, template mapping or “extension”, date, maturity %)  
2. Purpose of this chapter  
3. Narrative (evidence-filled)  
4. Diagrams (embedded images + captions)  
5. Tables as needed  
6. Evidence list  
7. White spots (colored callouts only)  
8. Open questions  

## Writing rules

- Cite ADRs / `docs/ai` / NFR / kb; do not invent requirements  
- Honor ADR-011 do-not-build and ADR-009 out-of-scope  
- C4 Persons = runtime only (ADR-012)  
- No secrets, account IDs, private URLs  
- Unknown Region / RTO / RPO / Multi-AZ flags stay Unknown  

## First writing pass order

13 → 10 → 11 → 12 → 08 → 09 → 07 → 06 → 05 → 14 → 01–04 → 15–16 → finalize `PROGRESS.md` + `COVERAGE.md` + `README.md` + `WORD_TEMPLATE_CROSSWALK.md`.

## Word template crosswalk (summary)

| Word template section | MD chapter(s) |
|----------------------|---------------|
| Purpose of document | 01 |
| Scope | 02 |
| Related Documents | 03 |
| Definitions and Acronyms | 04 (+ 15 may merge later) |
| Business Context | 05 |
| Solution Scope | 06 |
| Functional Architecture | 07 |
| System Architecture | 08 |
| Data Architecture | 09 |
| Key terms and abbreviations | 15 |
| Revision History | 16 |
| *(no Word home — appendices or folded later)* | 10, 11, 12, 13, 14 |

## Success criteria

A reviewer can:

- Open any chapter and understand that slice without reading the whole pack  
- See embedded diagrams (images) in context  
- Open `PROGRESS.md` and know pack + chapter completeness %  
- Open `COVERAGE.md` and list remaining white spots  
- Distinguish Confirmed vs Unknown by color **and** text  
- Later map chapters into the Word SAD via the crosswalk  

## Out of scope for implementation plan follow-up

- Automated generation of PROGRESS from YAML (Approach 3)  
- Full Word `.docx` assembly  

## Next step after user approves this spec

Invoke **writing-plans** to produce an implementation plan for creating the SAD pack files.
