# TASK-003: Content recommend, push, engagement

## Goal

Given session ICD-10 set: recommend content, pair/select exam device, push via Device Command API + Socket.io, capture engagement events.

## Kb sources

- Architecture Content/Device APIs
- Mesmerize Q&A UC3–UC7
- Implementation Context content sources + engagement fields
- Jul 14 notes (server-mediated comms, UUID tracking, backoff)

## Invariants

- Server-mediated commands only
- Engagement keyed to session/device/ICD-10 — no patient ID on server
- Extend PWA patterns; don’t rewrite live production in place
- No ML recommender under SOW unless scope reopened

## Done when

- [ ] Recommendations filter by specialty/ICD-10/format/device as available metadata allows
- [ ] Push lands only on paired device
- [ ] Engagement start/duration/completion (+ interactions as scoped) queryable
- [ ] Heartbeat/reconnect/backoff behavior covered by tests or verified manually
- [ ] `TESTING.md` checklist complete
