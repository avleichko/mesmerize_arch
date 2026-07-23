# TASK-004: Billing evidence + writeback

## Goal

From engagement events, produce billing suggestions with structured evidence; physician review/approve; optional browser-side DocumentReference writeback; exports/audit log support.

## Kb sources

- Architecture Billing Evidence API + data model
- Implementation Context billing engine section
- SOW #3 billing/writeback scope
- Mesmerize Q&A UC8–UC10
- ADR-003

## Invariants

- Engagement-only inputs (no transcripts)
- Human-in-the-loop physician approve
- Writeback disable-able per customer
- Backend does not call EHR
- No claim submission

## Open (do not invent)

- Final rule-set owner and pilot rule pack
- Exact HCPCS coverage beyond documented thin support

## Done when

- [ ] Suggestions include evidence grounded only in captured telemetry
- [ ] Approve gate blocks writeback
- [ ] Disabled writeback path fails closed without leaking data
- [ ] Export and/or audit log path exists as scoped
- [ ] `TESTING.md` checklist complete
