# ADR-012: C4 Persons vs SAD stakeholders

- **Status:** Accepted
- **Date:** 2026-07-23
- **Decision:** Modeling split **C** (brainstorming)

## Context

Solution Architecture Definition and C4 diagrams both need “who is involved,” but mixing project sponsors with runtime users clutters container diagrams and confuses auth boundaries.

## Decision

1. **C4 Person** elements represent **runtime actors only**: Clinician/Physician, Nurse/MA, Admin/Command Center staff, Patient (in clinic), Patient (post-visit / Bridge App).
2. **Stakeholders** (exec sponsors, CTO, Newfire, content owners, compliance/billing owners, pharma reporting consumers) belong in the **SAD “Key Stakeholders”** (and related project docs) — **not** as default C4 Person nodes.
3. A stakeholder is added as a C4 Person only if they also operate a runtime product surface in scope.

## Consequences

- Container/context diagrams stay focused on auth and interaction paths.
- SAD template section “Key Stakeholders” remains the home for governance/ownership.
- Agents must not invent extra end-user personas beyond kb.
