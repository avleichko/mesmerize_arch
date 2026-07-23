# TESTING

> **Purpose:** Agents must validate changes before declaring work complete.  
> **Sources:** SOW #3 acceptance themes, Architecture APIs, Mesmerize Q&A use cases, Jul 14 reliability notes.

## Definition of done (agent checklist)

Before claiming a task is complete:

1. **Scope check** — Change matches the task / SOW phase; no out-of-scope DICOM, ML recommender, ambient AI, or multi-org prod rollout.
2. **ADR / kb check** — Relevant [`docs/adr/`](../adr/README.md) decisions and `kb/` sources reviewed; no Confirmed decision violated.
3. **Invariant check** — Re-read `AGENTS.md` hard invariants; confirm no patient identifiers or FHIR tokens reach Mesmerize API/logs.
4. **Boundary check** — SMART FHIR I/O remains browser-side; device commands remain server-mediated.
5. **Tests run** — Lint, typecheck, and relevant unit/integration tests pass in CI-equivalent local commands when a codebase is present.
6. **Docs** — If behavior or architecture changed, update `docs/ai/*` and/or add/adjust an ADR; sync export to `output_docs/` when required by the task. Formal SAD/architecture packs must follow [`templates/`](../../templates/) when a matching template exists.
7. **Open questions** — Any `[PROPOSED]` / Unknown assumptions are listed in the PR/summary — not silently treated as confirmed.

## Test layers (expected)

| Layer | Intent |
|-------|--------|
| Unit | Billing rules (thresholds, categories), ICD-10→content mapping helpers, Zod schemas, DocumentReference builders |
| Integration | Session/content/device/billing API modules with Postgres/Redis test doubles or Compose |
| Contract | Socket.io command payloads; engagement event shapes; export CSV/JSON schemas |
| SMART sandbox | Launch + Condition read against **athenahealth sandbox** (Staging); Epic/Cerner sandboxes for future modular paths |
| Device | Heartbeat, command delivery, reconnect/backoff; pairing to correct device only |
| Security smoke | Confirm request payloads to API exclude patient identifiers; log redaction samples |
| UX / a11y | WCAG 2.1 AA for clinician flows under time pressure (SOW Phase 2) |
| Pilot E2E | Full path with real clinician (Phase 4): launch → recommend → push → engage → evidence → optional writeback |

## Critical acceptance scenarios (from kb use cases)

Agents implementing features should map tests to these:

| ID | Scenario | Pass signal |
|----|----------|-------------|
| UC1 | SMART launch from athena chart | Handshake + patient/encounter context + recommendations without manual re-selection |
| UC2 | FHIR reads | Only ICD-10 codes sent to Mesmerize backend |
| UC3 | Recommend | Ranked relevant items for device given ICD-10 set |
| UC5 | Device targeting | Content lands only on selected/paired device |
| UC6 | Push | Command via API + Socket.io; no direct SMART↔device app channel |
| UC7 | Telemetry | Session-linked start/duration/completion (+ interactions) queryable; no patient ID on server |
| UC8 | Billing engine | Suggestions + structured evidence per configured rules |
| UC9 | Evidence summary | Grounded in telemetry only; editable; gated on physician approve |
| UC10 | Writeback | DocumentReference when enabled; clean disable when not |

## Reliability expectations (Jul 14 alignment)

- Retry with **exponential backoff** on transaction failures.
- Prefer heartbeats + email alerts over a new admin correction UI (deferred).
- Diagnostic log retention **≤ 90 days**; no PII/PHI in diagnostic streams.

## What “green CI” does not prove

- Marketplace / customer FHIR scope approvals.
- Clinical billing compliance of a rule set (needs billing owner).
- Production PHI posture without a review against [`SECURITY.md`](SECURITY.md).

## When there is no application repo yet

This documentation workspace may exist before full `mesmerize-platform` checkout. In that case:

- Still enforce design/doc consistency and ADR updates.
- Do not invent passing test results.
- Validate documentation claims against `kb/` only.
