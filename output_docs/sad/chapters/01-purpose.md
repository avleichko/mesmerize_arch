# 01. Purpose of Document

| Field | Value |
|-------|-------|
| Chapter ID | `01-purpose` |
| SAD mapping | Template §1 Purpose of document |
| Last updated | 2026-07-23 |
| Maturity | Review-ready · 75% |

## Purpose of this chapter

State **who** this Solution Architecture Definition (SAD) pack is for, **why** it exists, and how it relates to the official Word template — without inventing product requirements.

## Audience

| Audience | How they use this pack |
|----------|------------------------|
| Mesmerize technical owners / architecture reviewers | Confirm boundaries, ADRs, and ASRs before build or pilot gate |
| Newfire delivery (SOW #3) | Shared working architecture for SMART, Platform, devices, billing evidence, writeback |
| Stakeholders (sponsors, compliance, content/PWA owners) | Governance context in later chapters; not C4 runtime Persons ([ADR-012](../../../docs/adr/012-c4-persons-vs-stakeholders.md)) |
| AI coding agents | Evidence-backed spine aligned with `AGENTS.md`, `kb/`, and `docs/adr/` |

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> This pack describes the <strong>Content Evidence Platform</strong> — EHR-launched SMART on FHIR education delivery, clinic devices, ICD-10-linked engagement, and billing-evidence suggestions with <strong>zero patient identifiers on Mesmerize servers</strong> (<code>docs/ai/PROJECT_CONTEXT.md</code>; ADR-001).
</p>

## Why this pack exists

1. **Single working artifact** for architecture review and iteration under `output_docs/sad/` — Markdown chapters with status callouts and diagram embeds.
2. **Traceability** from SOW #3 / Mesmerize Q&A / `kb/` through confirmed ADRs (#1–#20, stack, DNB, multitenancy, messaging) into stakeholder-readable sections.
3. **Template fidelity** — section spine matches [`templates/Solution_Architecture_Definition_template.docx`](../../../templates/Solution_Architecture_Definition_template.docx) so a later Word export does not invent a competing outline ([`templates/README.md`](../../../templates/README.md)).
4. **Guardrails** — call out Confirmed / Inferred / Proposed / Unknown; honor do-not-build and imaging-out-of-SOW decisions so agents do not silently expand scope.

<p style="background:#e8f5e9;border-left:4px solid #2e7d32;padding:8px 12px;margin:12px 0;">
  <strong>Confirmed:</strong> Authoritative working pack lives under <code>output_docs/sad/</code> only. Filling the official Word <code>.docx</code> is <strong>out of scope</strong> for this Markdown pack; Word assembly is a later pass (<code>output_docs/sad/README.md</code>).
</p>

## Relationship to the Word template

| Template section | This pack |
|------------------|-----------|
| §1 Purpose | This chapter |
| §2 Scope | [02-scope.md](02-scope.md) |
| §3 Related Documents | [03-related-documents.md](03-related-documents.md) |
| §4 Definitions and Acronyms | [04-definitions-and-acronyms.md](04-definitions-and-acronyms.md) |
| §5–§11 (+ Mesmerize extensions) | Chapters 05–16 (see [pack README](../README.md)) |

- **Copy structure, do not overwrite** the template in `templates/`.
- **Crosswalk** (when present): [`WORD_TEMPLATE_CROSSWALK.md`](../WORD_TEMPLATE_CROSSWALK.md) maps chapters → Word sections for export.
- Content is filled from `kb/` + `docs/adr/` + `docs/ai/*` + NFR — not invented.

<p style="background:#fff8e1;border-left:4px solid #f9a825;padding:8px 12px;margin:12px 0;">
  <strong>Inferred:</strong> Chapters 10–14 (Security, Multitenancy, Messaging, Deployment, NFR) are Mesmerize extensions beyond the minimal Word spine; they remain part of the working pack and map into Word annexes or expanded sections during export.
</p>

## Evidence

- [`templates/README.md`](../../../templates/README.md) — SAD required sections; copy/fill rules
- [`output_docs/sad/README.md`](../README.md) — pack purpose, chapter index, Word out of scope
- [`docs/ai/PROJECT_CONTEXT.md`](../../../docs/ai/PROJECT_CONTEXT.md) — product positioning and success metric
- [`docs/adr/README.md`](../../../docs/adr/README.md) — confirmed decision register
