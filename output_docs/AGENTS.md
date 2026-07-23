# AGENTS.md — Mesmerize Content Evidence Platform

Instructions for AI coding agents (Cursor, Codex, Claude Code, Copilot, Gemini CLI, Windsurf, and similar).

## Mission

Help build and evolve Mesmerize’s **Content Evidence Platform**: EHR-launched SMART on FHIR education delivery, clinic device displays, ICD-10-linked engagement telemetry, and billing-evidence suggestions — with **zero patient identifiers on Mesmerize servers**.

## Read first (required context)

**Always check `kb/` and `docs/adr/` before proposing or implementing changes** (especially architecture, auth/FHIR, devices, content matching, billing, writeback, stack/tooling, multitenancy, or anything that might resurrect legacy ambient/Redox paths). Confirmed decisions live in [`docs/adr/README.md`](docs/adr/README.md) (product #1–#20, stack **S1–S15**, do-not-build **DNB-1–DNB-9**, multitenancy **MT-1–MT-5**) — do not contradict them without a superseding ADR and human approval.

| Order | Doc | Purpose |
|------:|-----|---------|
| 0a | [`kb/`](kb/) | Source evidence (Word/PDF/notes). **Analyze before inventing behavior.** |
| 0b | [`docs/adr/README.md`](docs/adr/README.md) | Confirmed decision register (#1–#20) + ADR links |
| 0b′ | [`docs/adr/016-git-branching-and-delivery-ladders.md`](docs/adr/016-git-branching-and-delivery-ladders.md) + [`kb/customer-reference/touchscreen-ux-devops-extract.md`](kb/customer-reference/touchscreen-ux-devops-extract.md) | Git/PR conventions + dual delivery ladders (platform AWS vs device/PWA). Do not paste full CONTRIBUTING. |
| 0c | [`templates/`](templates/) | Formal doc templates (SAD, etc.). **If a matching template exists, use it.** |
| 0d | [`docs/ai/NFR.md`](docs/ai/NFR.md) / [`output_docs/nfr/`](output_docs/nfr/) | Non-functional requirements; **ASR** rows are binding for architecture |
| 1 | [`docs/ai/PROJECT_CONTEXT.md`](docs/ai/PROJECT_CONTEXT.md) | Business purpose, stakeholders, success metrics |
| 2 | [`docs/ai/ARCHITECTURE.md`](docs/ai/ARCHITECTURE.md) | Components, boundaries, data flow |
| 3 | [`docs/ai/CURRENT_STATE.md`](docs/ai/CURRENT_STATE.md) | What exists vs. to-be-built |
| 4 | [`docs/ai/ENGINEERING_RULES.md`](docs/ai/ENGINEERING_RULES.md) | Stack, conventions, do/don’t |
| 5 | [`docs/ai/SECURITY.md`](docs/ai/SECURITY.md) | PHI boundary, auth, BAAs |
| 6 | [`docs/ai/TESTING.md`](docs/ai/TESTING.md) | Validation before “done” |
| 7 | [`docs/ai/GLOSSARY.md`](docs/ai/GLOSSARY.md) | Shared vocabulary |
| — | [`docs/tasks/`](docs/tasks/) | Task-scoped briefs |

Diagrams: [`output_diagrams/`](output_diagrams/). Export copy of docs: [`output_docs/`](output_docs/).

## Templates (mandatory when present)

1. Before creating a **Solution Architecture Definition**, architecture pack, or other formal stakeholder document, check [`templates/`](templates/) (see [`templates/README.md`](templates/README.md)).
2. If a matching template exists, **copy it and fill sections** — do not invent a competing outline.
3. Prefer [`templates/Solution_Architecture_Definition_template.docx`](templates/Solution_Architecture_Definition_template.docx) for SAD work.
4. Never overwrite the template in place; write filled docs to `output_docs/` (or the path the task specifies).
5. Still ground all content in `kb/` + `docs/adr/` — templates define structure, not invented requirements.

## Hard invariants (never violate)

1. **FHIR access token never leaves the browser.** SMART app talks to EHR FHIR with the EHR token; Mesmerize API uses a separate Mesmerize session token.
2. **No patient identifiers on Mesmerize servers.** Backend may receive **ICD-10 codes + device group ID + opaque session ID** only — not Patient ID, MRN, name, encounter ID, demographics.
3. **No ambient AI path.** No audio capture, transcription, LLM note generation, transcript/clinical-note storage, or recording consent flows. See [ADR-011](docs/adr/011-do-not-build.md).
4. **SMART app never talks to devices directly.** Commands go through Platform Device Command API → Socket.io.
5. **Billing is suggest + human-in-the-loop.** Physician review/approve before any EHR writeback; no claim submission (EDI) by Mesmerize.
6. **Writeback is browser-side FHIR DocumentReference** (engagement / service-delivery summary), using the EHR token — backend never calls EHR APIs; **no server-side EHR token handling**.
7. **Prefer extending existing PWA patterns** over rewriting the live fleet app in place. Production `touchscreen-ux` is treated as read-only for Newfire; new work extends/copies.
8. **Honor the do-not-build list** (Redox, Deepgram, Claude SOAP notes, patient CRUD, clearinghouse, DICOM push, etc.) in [ADR-011](docs/adr/011-do-not-build.md).
9. **Multitenancy:** Organization is the tenant; clinic is sub-scope. Support **Silo** (isolated DB) and **Bridge** (`tenantId` column + S3 `{tenantId}/{clinicId}/` folders). Pilot default Bridge. See [ADR-013](docs/adr/013-multitenancy-silo-and-bridge.md).
10. **Honor ASRs** in [`docs/ai/NFR.md`](docs/ai/NFR.md) / [`output_docs/nfr/ASR_CHECKLIST.md`](output_docs/nfr/ASR_CHECKLIST.md) (security, reliability, iframe/a11y, observability, SMART launch, tenancy).

## In scope vs out of scope (SOW #3)

**In scope:** SMART on FHIR app; ICD-10-based content recommendation; PWA/device integration; engagement capture; billing evidence + physician approve; site-configurable rules engine; writeback capability; one athenahealth pilot org.

**Out of scope (do not build unless a new ADR/SOW says otherwise):** ML recommender if metadata insufficient; DICOM / Patient Imaging Mirror push to PWA; multi–health-system production rollout.

## Working rules

- **Always check `kb/` and `docs/adr/` first** before architecture or product-behavior changes. Treat the [confirmed decision register](docs/adr/README.md) as binding.
- **Git / delivery:** For branching, PRs, and deploy paths, follow [ADR-016](docs/adr/016-git-branching-and-delivery-ladders.md) and the [touchscreen-ux DevOps extract](kb/customer-reference/touchscreen-ux-devops-extract.md) — do not conflate Netlify/TTV (device) with ECS (platform).
- **Always check NFRs / ASRs** in [`docs/ai/NFR.md`](docs/ai/NFR.md) (export: [`output_docs/nfr/`](output_docs/nfr/)). Do not introduce designs that conflict with **ASR** marked requirements.
- **Always check `templates/`** before creating formal architecture / SAD / stakeholder docs; use the matching template if one exists.
- **Analyze `kb/` again** when a task touches EHR, PHI, devices, recommendations, billing, or writeback — even if you already read `docs/ai/*`.
- **Do not invent requirements.** If kb marks something `[PROPOSED]`, `Unknown`, or “Needs Further Discussion”, treat it as open — ask or document the assumption.
- **Avoid unnecessary refactoring.** Prefer the smallest change that satisfies the task.
- **Cite sources** in ADRs and significant design notes (`kb/...`, SOW #3, Mesmerize Q&A, decision #).
- **Match existing stack and monorepo layout** documented in Architecture / Engineering Rules.
- **Before declaring work complete**, confirm alignment with relevant ADRs + run the checklist in [`docs/ai/TESTING.md`](docs/ai/TESTING.md).

## Primary success metric (business)

End-to-end athenahealth pilot by **end of Q1 2027**: SMART launch → Condition (ICD-10) read → content recommend → push to exam-room device → engagement capture → billing evidence → DocumentReference writeback — with a real clinician, no PHI/compliance incident.

## When unsure

1. Re-check [`docs/adr/README.md`](docs/adr/README.md) (decisions #1–#20) and the linked ADR.
2. Search `kb/` (Architecture v2.0, Implementation Context, Mesmerize Responses, SOW #3).
3. Prefer the **Content Evidence** plan over older Redox / ambient-scribe plans.
4. If still ambiguous, stop and ask — do not silently expand scope.
