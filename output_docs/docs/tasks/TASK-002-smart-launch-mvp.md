# TASK-002: SMART launch MVP

## Goal

SMART app launches from EHR (athena sandbox path), obtains patient/encounter context in browser, reads Conditions (ICD-10), creates a **de-identified** Mesmerize session.

## Kb sources

- Architecture SMART registration + scopes
- Implementation Context fhirclient.js + sandbox table
- Mesmerize Q&A UC1–UC2

## MVP scopes

`launch/encounter patient/Patient.read patient/Condition.read patient/Encounter.read patient/DocumentReference.write`

Do **not** add imaging scopes for SOW #3 MVP.

## Invariants

- FHIR token never sent to Mesmerize API
- Session API receives ICD-10 (+ device group), never patient ID

## Done when

- [ ] Launch handshake works in target sandbox
- [ ] Conditions drive UI recommendations input
- [ ] Network/payload review shows no patient identifiers to Platform API
- [ ] Tests/checklist in `docs/ai/TESTING.md` satisfied
