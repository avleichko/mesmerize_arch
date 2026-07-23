# ADR-007: Extend PWA; server-mediated devices; Socket.io; Esper IDs; pairing

- **Status:** Accepted
- **Decisions:** #11, #12, #13, #14, #15
- **Sources:** Mesmerize Responses Q&A (UC5–UC6), Architecture Device Command API, Jul 14 server-mediated alignment

## Context

Mesmerize already runs a live exam-room PWA on a large Esper-managed fleet. Exact room/provider device maps do not exist today. Direct SMART↔device channels would bypass server control and complicate security/reliability.

## Decision

1. **Extend** the current PWA (`touchscreen-ux` lineage) — do **not** rebuild from scratch. New work adds SMART-driven push, pairing, and telemetry.
2. Device communication goes through the **Mesmerize backend Device Command API**, not direct SMART app → device application traffic.
3. Real-time push / device sync uses **Socket.io / WebSockets**.
4. Devices are identified by **Esper UUID + serial + M-number/location alias**.
5. For the pilot, room/device targeting uses **provider (or system) device selection/pairing**, because exact room/provider mapping is not available today.

## Consequences

- Production PWA treated as extend/copy — not in-place overwrite by delivery partners.
- Pairing UX and Socket.io rooms are required MVP work.
- Later room↔device registry can reduce manual selection; that is additive, not a rewrite of this ADR.
