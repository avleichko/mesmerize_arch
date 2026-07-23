# Word template ↔ Markdown SAD crosswalk

Maps [`templates/Solution_Architecture_Definition_template.docx`](../../templates/Solution_Architecture_Definition_template.docx) Heading-1 / Heading-2 structure to Markdown chapters under `output_docs/sad/chapters/`.

**Purpose:** guide a future Word export pass. Filling the `.docx` is **out of scope** for this Markdown pack.

**Sources:** Word template outline; [`templates/README.md`](../../templates/README.md); this pack’s chapter files.

---

## Core template sections → MD chapters

| Word Heading 1 | Word Heading 2 (if any) | MD chapter | MD file |
|----------------|-------------------------|------------|---------|
| Purpose of document | — | 01 Purpose | [`chapters/01-purpose.md`](chapters/01-purpose.md) |
| Scope | — | 02 Scope | [`chapters/02-scope.md`](chapters/02-scope.md) |
| Related Documents | — | 03 Related Documents | [`chapters/03-related-documents.md`](chapters/03-related-documents.md) |
| Definitions and Acronyms | — | 04 Definitions and Acronyms | [`chapters/04-definitions-and-acronyms.md`](chapters/04-definitions-and-acronyms.md) |
| Business Context | Business Objective | 05 Business Context | [`chapters/05-business-context.md`](chapters/05-business-context.md) → `## Business Objective` |
| Business Context | Expected Business Value | 05 | same → `## Expected Business Value` |
| Business Context | Key Stakeholders | 05 | same → `## Key Stakeholders` |
| Solution Scope | Solution Description | 06 Solution Scope | [`chapters/06-solution-scope.md`](chapters/06-solution-scope.md) → `## Solution Description` |
| Solution Scope | Solution Architecture Diagram | 06 | same → `## Solution Architecture Diagram` |
| Functional Architecture | — | 07 Functional Architecture | [`chapters/07-functional-architecture.md`](chapters/07-functional-architecture.md) |
| System Architecture | Component Responsibilities | 08 System Architecture | [`chapters/08-system-architecture.md`](chapters/08-system-architecture.md) → `## Component Responsibilities` |
| System Architecture | Component Interactions | 08 | same → `## Component Interactions` |
| Data Architecture | Data Sources | 09 Data Architecture | [`chapters/09-data-architecture.md`](chapters/09-data-architecture.md) → `## Data Sources` |
| Data Architecture | Data Model | 09 | same → `## Data Model` |
| Data Architecture | Data Flow | 09 | same → `## Data Flow` |
| Data Architecture | Data Ownership | 09 | same → `## Data Ownership` |
| Key terms and abbreviations | — | 15 Key Terms and Abbreviations | [`chapters/15-key-terms-and-abbreviations.md`](chapters/15-key-terms-and-abbreviations.md) |
| Revision History | — | 16 Revision History | [`chapters/16-revision-history.md`](chapters/16-revision-history.md) |

**Numbering note:** Word template sections 1–9 align with MD chapters **01–09**. Word’s final two Heading-1s (“Key terms…”, “Revision History”) map to MD **15** and **16**, not 10–11 — MD **10–14** are Mesmerize extensions (below).

**Chapter 04 vs 15:** Word has both “Definitions and Acronyms” and “Key terms and abbreviations.” This pack keeps a short acronym list in **04** and a fuller glossary in **15** (see chapter narratives). On Word export, avoid duplicating the long glossary under both headings.

---

## Future appendices (MD extensions 10–14, 17–18)

These chapters are **not** Heading-1 sections in the current Word template. Treat them as **appendices** (or new Heading-1 sections) when assembling the stakeholder `.docx`.

| MD # | Title | File | Suggested Word placement |
|-----:|-------|------|--------------------------|
| 10 | Security and Privacy | [`chapters/10-security-and-privacy.md`](chapters/10-security-and-privacy.md) | Appendix A (or new H1 after Data Architecture) |
| 11 | Multitenancy | [`chapters/11-multitenancy.md`](chapters/11-multitenancy.md) | Appendix B |
| 12 | Messaging and Integration | [`chapters/12-messaging-and-integration.md`](chapters/12-messaging-and-integration.md) | Appendix C |
| 13 | Deployment and Infrastructure | [`chapters/13-deployment-and-infrastructure.md`](chapters/13-deployment-and-infrastructure.md) | Appendix D |
| 14 | NFR and Quality Attributes | [`chapters/14-nfr-and-quality-attributes.md`](chapters/14-nfr-and-quality-attributes.md) | Appendix E |
| 17 | CI/CD | [`chapters/17-ci-cd.md`](chapters/17-ci-cd.md) | Appendix F |
| 18 | Assumptions and Open Questions | [`chapters/18-assumptions-and-open-questions.md`](chapters/18-assumptions-and-open-questions.md) | Appendix G |

Export order suggestion: core template 01–09 → appendices 10–14 → Key terms (15) → Revision History (16) → Appendix F CI/CD (17) → Appendix G Assumptions (18).

---

## Pack trackers (not Word sections)

| File | Role |
|------|------|
| [`README.md`](README.md) | Pack index, conventions |
| [`PROGRESS.md`](PROGRESS.md) | Maturity bands / overall % |
| [`COVERAGE.md`](COVERAGE.md) | Checklist + white spots |
| This file | Template ↔ MD map |
