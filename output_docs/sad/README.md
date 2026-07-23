# Mesmerize SAD Markdown Working Pack

## Purpose

This directory holds the **working Solution Architecture Definition (SAD) pack** for the Mesmerize Content Evidence Platform. Each chapter is a standalone Markdown file, evidence-filled from ADRs, `docs/ai/*`, NFRs, and `kb/`. Diagrams are embedded as images; gaps are marked with colored status callouts (never silent omissions).

This pack lives under `output_docs/sad/` only. It is the authoritative working artifact for architecture review and iteration in this repo.

**Overall pack maturity:** ~**79%** (band **75 — Review-ready**). See [`PROGRESS.md`](PROGRESS.md). Not stakeholder-sign-off complete while open Unknowns remain. Git / dual delivery ladders: [ADR-016](../../docs/adr/016-git-branching-and-delivery-ladders.md); SAD [Chapter 17](chapters/17-ci-cd.md).

## Chapter index

| # | Chapter | File |
|---|---------|------|
| 01 | Purpose | [chapters/01-purpose.md](chapters/01-purpose.md) |
| 02 | Scope | [chapters/02-scope.md](chapters/02-scope.md) |
| 03 | Related Documents | [chapters/03-related-documents.md](chapters/03-related-documents.md) |
| 04 | Definitions and Acronyms | [chapters/04-definitions-and-acronyms.md](chapters/04-definitions-and-acronyms.md) |
| 05 | Business Context | [chapters/05-business-context.md](chapters/05-business-context.md) |
| 06 | Solution Scope | [chapters/06-solution-scope.md](chapters/06-solution-scope.md) |
| 07 | Functional Architecture | [chapters/07-functional-architecture.md](chapters/07-functional-architecture.md) |
| 08 | System Architecture | [chapters/08-system-architecture.md](chapters/08-system-architecture.md) |
| 09 | Data Architecture | [chapters/09-data-architecture.md](chapters/09-data-architecture.md) |
| 10 | Security and Privacy *(extension)* | [chapters/10-security-and-privacy.md](chapters/10-security-and-privacy.md) |
| 11 | Multitenancy *(extension)* | [chapters/11-multitenancy.md](chapters/11-multitenancy.md) |
| 12 | Messaging and Integration *(extension)* | [chapters/12-messaging-and-integration.md](chapters/12-messaging-and-integration.md) |
| 13 | Deployment and Infrastructure *(extension)* | [chapters/13-deployment-and-infrastructure.md](chapters/13-deployment-and-infrastructure.md) |
| 14 | NFR and Quality Attributes *(extension)* | [chapters/14-nfr-and-quality-attributes.md](chapters/14-nfr-and-quality-attributes.md) |
| 15 | Key Terms and Abbreviations | [chapters/15-key-terms-and-abbreviations.md](chapters/15-key-terms-and-abbreviations.md) |
| 16 | Revision History | [chapters/16-revision-history.md](chapters/16-revision-history.md) |
| 17 | CI/CD *(extension)* | [chapters/17-ci-cd.md](chapters/17-ci-cd.md) |

All 17 chapter files are present. Word Heading-1/2 ↔ MD map: [`WORD_TEMPLATE_CROSSWALK.md`](WORD_TEMPLATE_CROSSWALK.md).

## Color legend

Status callouts use HTML so colors render in GitHub and Cursor Markdown preview. Always include the **textual status word** so meaning survives monochrome or print.

| Status | Meaning | Style |
|--------|---------|-------|
| **Confirmed** | ADR, kb, or docs evidence | Green background / border |
| **Inferred** | Strongly implied, not explicitly decided | Amber / orange |
| **Proposed** | Recommended, not yet decided | Blue |
| **Unknown** | Insufficient evidence; white spot | Red |

Copy-paste snippets: [`_snippets/callouts.md`](_snippets/callouts.md)

## Trackers

- **[PROGRESS.md](PROGRESS.md)** — Pack and per-chapter maturity (%). Bands: 0 Outline · 25 Stub · 50 Draft · 75 Review-ready · 100 Stakeholder-ready. Update when chapter content or checklists change.
- **[COVERAGE.md](COVERAGE.md)** — Per-chapter checklist completion and explicit white spots. Incomplete items must appear as colored Unknown/Proposed callouts in chapters, not silent gaps.
- **[WORD_TEMPLATE_CROSSWALK.md](WORD_TEMPLATE_CROSSWALK.md)** — Maps these chapters to `templates/Solution_Architecture_Definition_template.docx` for a future Word export pass.

## Image path convention

From any file under `chapters/`, embed diagrams with:

```markdown
![Caption](../../output_diagrams/<file>.png)
```

This resolves to `output_docs/output_diagrams/` (the export mirror). When adding or regenerating PNGs, update **both** repo-root `output_diagrams/` and `output_docs/output_diagrams/` so embeds do not break.

Use `![…](…)` image syntax — not bare links.

## Out of scope

Filling the official Word `.docx` SAD template is **out of scope** for this Markdown pack. The crosswalk documents how chapters map to the template; Word assembly happens in a later pass.

## Authoring conventions

- Cite ADRs, `docs/ai/*`, NFR, and `kb/`; do not invent requirements, SLOs, RTO, RPO, Region, or secrets.
- C4 Persons = runtime actors only; stakeholders belong in tables (ADR-012).
- Honor ADR-009 (imaging out of SOW) and ADR-011 (do-not-build list).
- Shared callout library: [`_snippets/callouts.md`](_snippets/callouts.md)
