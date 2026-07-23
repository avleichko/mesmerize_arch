# ADR-003: Engagement DocumentReference writeback (not clinical notes)

- **Status:** Accepted
- **Decisions:** #17, #18, #19 (see also [ADR-008](008-engagement-telemetry-billing-hitl-writeback.md))
- **Date:** 2026-03-11
- **Sources:** Architecture §4 FHIR Engagement Log, Implementation Context, SOW #3 writeback scope, Mesmerize Q&A UC9–UC10

## Context

Writing AI-generated clinical notes to EHRs is high complexity (templates, sign-off, liability) and conflicts with the Content Evidence positioning.

## Decision

- Write structured **education / service-delivery engagement evidence** as FHIR **DocumentReference** from the **browser** using the EHR token.
- Category framing in architecture: patient education / instructions (LOINC **69730-0** cited).
- Physician **human-in-the-loop** review/approve before writeback; feature disable-able per customer.
- Mesmerize does **not** submit claims (EDI); PM systems remain responsible for claim generation.

## Consequences

- `packages/fhir-engagement` formats DocumentReference; no heavy clinical-note output package.
- Billing engine suggests codes with evidence; approval is clinical/user workflow, not automatic posting.
- Acceptance depends on EHR/customer configuration in pilot.
