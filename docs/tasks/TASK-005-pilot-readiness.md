# TASK-005: Pilot readiness

## Goal

Prepare for single-org athena pilot: environments, security posture, observability, and E2E path without expanding to multi-system production.

## Kb sources

- SOW Phase 4 themes
- Mesmerize Q&A success metrics + environments
- SECURITY.md / Jul 14 logging decisions
- ADR-004

## Invariants

- Prod gated to pilot org
- Staging PHI-free
- Out of scope: multi–health-system rollout, DICOM push

## Done when

- [ ] E2E path documented and testable against sandbox/pilot config
- [ ] Logging excludes PII/PHI; retention aligned to agreed diagnostic policy
- [ ] Writeback validated or explicitly waived per customer approval
- [ ] No PHI/compliance incident criteria understood by team
- [ ] Open owners/questions listed, not papered over
