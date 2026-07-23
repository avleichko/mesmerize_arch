# ADR-014: SQS messaging patterns (REST edge + EIP internal)

- **Status:** Accepted
- **Date:** 2026-07-23
- **Decisions:** Edge REST; internal REST or SQS by matrix; SQS RR with per-service reply queues; correlation id; content enricher; DLQ; fire-and-forget
- **Sources:** Messaging brainstorming; C4 containers; NFR-REL-01/02; ADR-013 (tenantId on messages)

## Context

Microservices need clear sync vs async semantics. Edge clients (SMART app, devices) require low-latency request/response. Internal workers need durable async processing with operable failure handling.

## Decision

1. **Edge (SMART / devices / Command Center → platform):** **REST** (and Socket.io for device realtime).  
2. **Internal service-to-service:** **REST or SQS**, chosen per [decision matrix](#decision-matrix).  
3. **SQS “synchronous” style:** **Request/Reply** using:
   - request queue: `{service}.requests`
   - reply queue: `{service}.replies` (per **target** service)
   - **Correlation Identifier** (`correlationId`) + `replyTo`
   - **Timeouts configurable per operation**
4. **SQS asynchronous style:** **Fire-and-forget** to `{service}.events` (or command queues that do not wait).  
5. **Failures:** **Content Enricher** adds error context to the message; after max receives → **Dead Letter Queue** `{queue}.dlq`.  
6. All messages carry **`tenantId`** (and `clinicId` when relevant) — [ADR-013](013-multitenancy-silo-and-bridge.md). Never EHR tokens or patient identifiers — [ADR-002](002-zero-phi-on-mesmerize-servers.md).

### Decision matrix

| Need | Transport / pattern |
|------|---------------------|
| Interactive edge answer (session, recommend, device list) | REST |
| Caller service needs result from another service | SQS Request/Reply + correlationId |
| Emit fact / side effect (engagement, audit, session.ended) | SQS Fire-and-forget |
| Poison / repeated failure | Enrich → DLQ |

### Envelope (minimum)

`messageId`, `correlationId`, `replyTo`, `tenantId`, `clinicId?`, `messageType`, `timestamp`, `payload`, `error?`

## Consequences

- Diagrams: `output_diagrams/13-sqs-messaging-overview.puml`, `14-sqs-request-reply-correlation.puml`, `15-sqs-fire-and-forget.puml`, `16-sqs-enricher-dlq.puml`
- Agents must not use SQS request/reply for SMART iframe hot path when REST to the owning service is sufficient.
- NFR-REL-01 (backoff) applies to consumers; DLQ is the terminal path after retries.
