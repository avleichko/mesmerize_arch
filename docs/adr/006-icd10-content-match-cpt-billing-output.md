# ADR-006: ICD-10 content match; CPT/HCPCS/HCC on billing output

- **Status:** Accepted
- **Decisions:** #9, #10
- **Sources:** Mesmerize Responses Q&A (content matching rationale), Implementation Context billing engine

## Context

ICD-10 describes diagnosis (what education to show). CPT/HCPCS describe services performed and are poor keys for choosing education content. Billing recovery needs CPT/HCPCS/HCC on the **output** side from engagement evidence.

## Decision

1. Content recommendation is based on **ICD-10 → content metadata mapping** (plus filters such as specialty/format/device as available).
2. **CPT/HCPCS are not used as recommendation match keys.**
3. **CPT/HCPCS/HCC logic belongs to the billing evidence engine output**, driven by engagement + ICD-10 context — not the content matcher.

## Consequences

- Recommendation services must not require CPT input for MVP matching.
- Billing package owns code suggestion rules; content package owns ICD-10 metadata mapping.
- Optional future CPT as a *secondary re-ranking* signal (kb Phase-3 idea) needs a new ADR before implementation.
