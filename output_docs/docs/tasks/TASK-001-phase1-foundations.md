# TASK-001: Phase 1 foundations

## Goal

Establish documentation-aligned foundations for SOW Phase 1: architecture clarity, CI/CD expectations, app shell direction, and ICD-10→content mapping plan — without expanding into out-of-scope features.

## Kb sources

- SOW #3 Phase 1 acceptance criteria
- Implementation Context
- Architecture v2.0
- Mesmerize Responses (Sprint-0 / Phase 1 list)

## Invariants

- EHR-agnostic core; athena pilot later
- No PHI on servers
- No DICOM / ambient AI work

## Deliverables (agent-relevant)

- Keep `docs/ai/*` and ADRs consistent with kb
- Blueprint notes must not invent Epic/Cerner deep integrations beyond roadmap analysis
- ICD-10 mapping approach: curated metadata first (no ML)

## Done when

- [ ] Phase 1 acceptance themes reflected in docs/tasks without new invented requirements
- [ ] Open owners (compliance, billing rules) still marked open
- [ ] `TESTING.md` checklist applied to any code/doc change
