# ADR-001: Content Evidence Platform (not ambient scribe)

- **Status:** Accepted (strategy docs dated March 11, 2026; SOW #3 execution)
- **Date:** 2026-03-11
- **Sources:** `kb/Documentation/Content Evidence Platform — Strategy Overview.docx`, Risks and Tradeoffs, SOW #3

## Context

Mesmerize evaluated (1) Redox-centric end-to-end PHI/claims pipelines, (2) SMART + ambient audio transcription + LLM clinical notes, and (3) content delivery with engagement-backed billing evidence.

Ambient documentation markets are crowded (EHR-native and well-funded scribes). Mesmerize’s durable assets are content, devices, and engagement→billing evidence.

## Decision

Build the **Content Evidence Platform**: SMART app + device platform + engagement telemetry + billing suggestions. **Do not** capture audio, transcribe, or generate clinical notes in this program.

## Consequences

- Smaller PHI footprint, fewer BAAs, smaller team, faster path to pilot.
- Complements ambient AI tools instead of competing with them.
- Billing evidence grounded in device engagement, not transcripts.
- Ambient documentation remains a possible later additive phase only if market demand and a new decision reopen it (Implementation Context migration path).
