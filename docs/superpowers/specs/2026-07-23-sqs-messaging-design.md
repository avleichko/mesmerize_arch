# SQS messaging patterns design

**Date:** 2026-07-23  
**Status:** Accepted (ADR-014)

## Summary

- Edge: REST (+ Socket.io)
- Internal: REST or SQS by matrix
- Sync-over-SQS: Request/Reply + Correlation Identifier; per-target reply queues; per-op timeouts
- Async: Fire-and-forget
- Errors: Content Enricher → DLQ

## Diagrams

- `output_diagrams/13-sqs-messaging-overview.puml`
- `output_diagrams/14-sqs-request-reply-correlation.puml`
- `output_diagrams/15-sqs-fire-and-forget.puml`
- `output_diagrams/16-sqs-enricher-dlq.puml`
