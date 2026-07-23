# ADR-011: Explicit “do not build” decisions

- **Status:** Accepted
- **Decisions:** DNB-1–DNB-9 (see table)
- **Sources:** Strategy Overview / Risks (pivot away from Redox & ambient), Architecture “What Is NOT In This Architecture”, Implementation Context removals, SOW #3 out-of-scope, ADRs 001–003, 009

## Context

Older plans and stubs (Redox, ambient audio, clinical notes, patient CRUD, clearinghouse) can reappear as “helpful” agent suggestions. Agents need an explicit deny-list.

## Decision — do not build

| # | Decision | Reason |
|---|----------|--------|
| DNB-1 | **No Redox dependency** | SMART on FHIR path selected ([ADR-001](001-content-evidence-not-ambient-scribe.md), [ADR-004](004-athena-pilot-ehr-agnostic-core.md)) |
| DNB-2 | **No Deepgram** | No audio capture / transcription ([ADR-001](001-content-evidence-not-ambient-scribe.md)) |
| DNB-3 | **No Claude SOAP note generation** | No ambient clinical note generation ([ADR-001](001-content-evidence-not-ambient-scribe.md)) |
| DNB-4 | **No transcript storage** | Audio / transcription removed from architecture |
| DNB-5 | **No clinical note storage** | Mesmerize must not become an ambient scribe; engagement evidence ≠ clinical notes ([ADR-003](003-documentreference-engagement-writeback.md)) |
| DNB-6 | **No patient CRUD / longitudinal patient record** | Zero-PHI backend principle ([ADR-002](002-zero-phi-on-mesmerize-servers.md)) |
| DNB-7 | **No clearinghouse / EDI claim submission** | Practice management (PM) system handles claims ([ADR-008](008-engagement-telemetry-billing-hitl-writeback.md)) |
| DNB-8 | **No server-side EHR token handling** | FHIR token stays browser-side ([ADR-002](002-zero-phi-on-mesmerize-servers.md)) |
| DNB-9 | **No DICOM push in current scope** | Explicitly out of scope in SOW #3 ([ADR-009](009-dicom-imaging-out-of-sow-scope.md)) |

## Also remove / do not reintroduce (implementation stubs)

If found in skeletons or older docs, delete or leave unused — do not complete:

- `packages/ai-services` (Deepgram / Claude clients)
- Server-side EHR adapter packages (`packages/fhir-client` Epic/Cerner/Athena adapters)
- Prisma models: Patient, Medication, Allergy, Coverage, Transcript, ClinicalNote
- Redox configuration
- Recording consent modules (no recording occurs)

## Consequences

- PRs that add any DNB item require a **superseding ADR + human approval** (and SOW change where applicable).
- Billing may **suggest** codes with evidence; it must not submit claims.
- Writeback remains browser-side DocumentReference of engagement/service-delivery evidence — not SOAP/clinical note generation or storage on Mesmerize servers.
