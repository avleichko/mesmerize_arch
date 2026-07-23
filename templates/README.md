# Templates

**Canonical location for document templates.** If this folder contains a template for a deliverable, agents **must** use it (copy/adapt structure and sections). Do **not** invent an alternate outline when a matching template exists here.

## Inventory

| Template | Use for |
|----------|---------|
| [`Solution_Architecture_Definition_template.docx`](Solution_Architecture_Definition_template.docx) | Solution Architecture Definition (SAD) / architecture definition documents |
| [`Solution_Architecture_Definition_Asset_Monitoring_v1.0_draft.docx`](Solution_Architecture_Definition_Asset_Monitoring_v1.0_draft.docx) | Same file as uploaded source (Asset Monitoring draft provenance). Prefer the `*_template.docx` alias when copying for Mesmerize. |

### Solution Architecture Definition — required sections

When producing a SAD (Word or Markdown export), follow this template’s structure:

1. Purpose of document  
2. Scope  
3. Related Documents  
4. Definitions and Acronyms  
5. Business Context (Business Objective, Expected Business Value, Key Stakeholders)  
   - **Key Stakeholders** = governance/ownership (not C4 Persons). See `docs/adr/012-c4-persons-vs-stakeholders.md` and `docs/ai/PROJECT_CONTEXT.md`.  
6. Solution Scope (Solution Description, Solution Architecture Diagram)  
   - Architecture diagrams: **C4 Persons** = runtime actors only (clinician, nurse/MA, admin, patient in clinic, bridge patient).  
7. Functional Architecture  
8. System Architecture (Component Responsibilities, Component Interactions)  
9. Data Architecture (Data Sources, Data Model, Data Flow, Data Ownership)  
10. Key terms and abbreviations  
11. Revision History  

Fill from `kb/` + `docs/adr/` + `docs/ai/*`. Do not invent requirements. Honor ADRs (including do-not-build).

## Agent rules

1. **Before creating** any architecture / solution-definition / formal design document: list `templates/` and select the matching file if one exists.  
2. **Copy the template** (do not overwrite the template file in place). Write outputs under `output_docs/` (or the path the task specifies).  
3. If no matching template exists, use `docs/ai/*` + ADR structure — and note that no template was found.  
4. New templates uploaded by humans go **only** in `templates/`; update this README inventory when adding files.
