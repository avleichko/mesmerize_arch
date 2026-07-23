# ADR-008: De-identified engagement telemetry; billing suggestions; HITL; disable-able writeback

- **Status:** Accepted
- **Decisions:** #16, #17, #18, #19
- **Sources:** Mesmerize Responses Q&A (UC7–UC10), Architecture data model, SOW #3, [ADR-003](003-documentreference-engagement-writeback.md)

## Context

Engagement must support billing evidence and analytics without placing patient identifiers on Mesmerize servers. Claims and automatic chart posting would expand PHI/compliance scope and conflict with human-in-the-loop requirements.

## Decision

1. Store engagement as **de-identified session telemetry**: content ID, ICD-10, device ID, timestamps, duration, interactions (plus session/clinic linkage as already allowed — **no patient identifiers**).
2. Billing engine produces **suggestions/evidence only** — **not claims**. Claim submission remains out of scope.
3. **Physician review/approval** is required before writeback / official documentation use.
4. EHR writeback is **configurable / disable-able per customer**.

## Consequences

- Telemetry schemas must be reviewable for accidental patient keys.
- No clearinghouse/EDI work under this ADR.
- Writeback feature flags are first-class configuration, not afterthoughts.
- Complements [ADR-003](003-documentreference-engagement-writeback.md) (DocumentReference format and browser-side write).
