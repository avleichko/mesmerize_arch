# Design: SAD Chapter 18 — Assumptions and Open Questions

**Date:** 2026-07-23  
**Status:** Draft for user review  
**Audience:** Mesmerize product / ops / compliance (internal)  
**Approach:** Two-track register (Assumptions Proposed + Must-answer questions)  
**Placement:** Chapter 18 · Word Appendix G (after CI/CD Appendix F)

## Problem

Twelve SAD chapters still carry **Unknown** callouts and scattered **Open questions**. That blocks Stakeholder-ready maturity (Unknown-cap at band 75) and forces Mesmerize reviewers to hunt across the pack. We need one Mesmerize-facing register that:

1. States **Proposed** engineering assumptions we can build against, and  
2. Lists **Must-answer** questions that only Mesmerize can close (compliance, PHI, RTO, owners, writeback, etc.).

## Goals

1. Create `output_docs/sad/chapters/18-assumptions-and-open-questions.md` with stable IDs (`A-xx`, `Q-xx`).  
2. Wire Appendix G + README + ch.03; point other chapters’ Open questions sections at Ch.18 IDs (keep Unknown callouts in source chapters).  
3. Update PROGRESS/COVERAGE for 18 chapters; Unknown-cap still applies while any **Q-** remains open.  
4. Keep evidence honest: assumptions = **Proposed** only; never invent Confirmed owners, RTO/RPO numbers, Region, or “BAA not required.”

## Non-goals

- Closing Unknowns in source chapters this pass (pointers + register only).  
- Newfire-facing SOW language as the primary voice.  
- Inventing numeric SLOs, Region codes, or named individuals as Confirmed.  
- Claiming Stakeholder-ready while Q-rows remain open.

## Decisions (brainstorming)

| # | Choice |
|---|--------|
| Audience | **A** — Mesmerize product/ops/compliance |
| Assumption aggressiveness | **B** — Balanced (engineering defaults Proposed; compliance/PHI Must-answer) |
| Placement | **A** — Chapter 18 Appendix G; other chapters’ Open questions become short pointers |
| Structure | **Approach 1** — Two-track register + traceability |

## Chapter structure

1. Shared SAD header (Chapter ID `18-assumptions-and-open-questions`, Mesmerize extension / Appendix G, maturity Review-ready capped while Qs open).  
2. **Purpose** — how Mesmerize uses the chapter (accept/reject assumption; answer question; supersede via ADR).  
3. **Assumptions register** — table A-01…A-10 with columns: ID | Assumption | Rationale | Invalidate if | Source chapter(s) | Status (Proposed).  
4. **Open questions register** — table Q-01…Q-14 with columns: ID | Question | Blocks | Suggested owner role | Source chapter(s) | Status (Open).  
5. **Traceability** — compact map Unknown theme → IDs.  
6. **How to close** — answer → update source Unknown → ADR if needed → rescore PROGRESS.  
7. Evidence / White spots (Unknown = all open Q-rows; Proposed = assumption set).

Use existing HTML callout snippets for Proposed / Unknown.

## Assumptions register (exact content for implementation)

| ID | Assumption | Rationale (US healthcare / SA) | Invalidate if | Sources |
|----|------------|--------------------------------|---------------|---------|
| A-01 | Pilot: **one primary AWS Region** (no multi-Region active-active in Phase 1) | Typical first SMART/athena pilot; DR secondary until RTO exists | Multi-Region required from day one | 13, 14 |
| A-02 | **RDS + Redis Multi-AZ on** for Staging/Prod | Standard HA without inventing RTO | Cost/ops veto for pilot | 13 |
| A-03 | Ladder A Phase 1 deploy strategy = **rolling** | Simplest ECS default | Canary/blue-green mandated | 13, 17 |
| A-04 | Platform repos use **`feature → staging → main`** | Matches ADR-016 Proposed | Different promotion model | 02, 17 |
| A-05 | NestJS services = **separate ECS services** by cutover | Blast-radius / boundary clarity | Long-lived co-locate for cost | 08 |
| A-06 | Queues `{env}-{service}-{purpose}`; RR timeout default **30s** until measured | Unblocks messaging build | Different standard | 12 |
| A-07 | SMS = **one US-capable provider** (Twilio-class) chosen at build | Common clinic messaging pattern | Other vendor already contracted | 12 |
| A-08 | Silo: **dedicated DB + secrets namespace**; shared S3 + prefix until scale | ADR-013 spirit | Dedicated buckets day one | 11 |
| A-09 | Engagement/business logs retained **≥ 1 year** Prod pending confirmation | Conservative floor; not multi-year claim | Signed retention differs | 14 |
| A-10 | **One** observability vendor; PHI-safe log split (no PHI on Mesmerize servers) | Zero-PHI posture; vendor name open | Dual-tool mandate | 10, 14 |

## Open questions register (exact content for implementation)

| ID | Question | Blocks | Suggested owner role | Sources |
|----|----------|--------|----------------------|---------|
| Q-01 | Who is **Compliance / PHI approver**? | Security sign-off | Compliance lead | 05, 10 |
| Q-02 | Who owns **billing / engagement rules**? | Product acceptance | Product / MM | 05 |
| Q-03 | Is an **AWS BAA** required given de-identified engagement schema? | Legal / account | Compliance + legal | 09, 10, 14 |
| Q-04 | Ratify **data-classification matrix** (what may touch Mesmerize servers)? | Data + security | Compliance + architecture | 09, 10 |
| Q-05 | Confirm **DocumentReference** writeback field catalog + athena pilot acceptance | Writeback | Clinical informatics / EHR config | 07 |
| Q-06 | **RTO / RPO** for Staging vs Prod? | DR / Multi-AZ spend | Ops + compliance | 13, 14 |
| Q-07 | Primary **AWS Region** (+ DR Region if any)? | All infra | Ops / cloud owner | 13 |
| Q-08 | Formal **availability / latency SLO** for device↔cloud (or explicitly “none for pilot”)? | NFR-REL | Product + ops | 14 |
| Q-09 | Final **observability vendor** + HIPAA logging policy pack timeline? | Ops + SEC | Ops / AM | 10, 14 |
| Q-10 | Exact **pilot clinic + device count** and Command Center **RBAC depth** for Phase 1? | Scope / acceptance | Product / SOW owner | 06 |
| Q-11 | **Silo provisioning** runbook owner + post-go-live Bridge↔Silo switch policy? | Multitenancy ops | Platform ops | 11 |
| Q-12 | Engagement log **retention years** if beyond A-09? | Storage / compliance | Brandon / MM / compliance | 14 |
| Q-13 | Who promotes Ladder A **Staging → Prod** and with what gates? | Delivery | Ops / eng lead | 17 |
| Q-14 | HIPAA **policy pack** delivery date from Mesmerize (AM)? | Security appendix | AM / compliance | 10 |

Owner roles are **roles**, not named people (except where kb already uses initials as open references — still Open until confirmed).

## Doc wiring

| File | Change |
|------|--------|
| `output_docs/sad/chapters/18-assumptions-and-open-questions.md` | Create |
| `WORD_TEMPLATE_CROSSWALK.md` | Appendix G row; export order after 17 |
| `README.md` | Chapter 18 row; overall % after rescore |
| `chapters/03-related-documents.md` | Link to ch.18 |
| Chapters with `## Open questions` (02, 05–14, 17 as applicable) | Replace long lists with pointers to `Q-xx` / `A-xx` |
| `PROGRESS.md` / `COVERAGE.md` | Add ch.18; recompute for 18 chapters; hottest white spots cite IDs |
| Optional | One line in ARCHITECTURE pointing to ch.18 for open decisions |

## Guardrails

- Assumptions = **Proposed** only; never Confirmed without Mesmerize acceptance recorded.  
- Do not invent Region codes, RTO/RPO numbers, or “BAA not required.”  
- Do not invent stakeholder names as Confirmed owners.  
- Accepting an assumption does **not** auto-clear the source Unknown until Mesmerize marks it accepted and the source chapter is updated.  
- Commit only if the user explicitly requests.

## Success criteria

- [ ] Chapter 18 exists with A-01…A-10 and Q-01…Q-14 as specified.  
- [ ] Crosswalk / README / ch.03 updated; Appendix G.  
- [ ] Open questions sections point to Ch.18 IDs; Unknown callouts remain in source chapters.  
- [ ] PROGRESS/COVERAGE include ch.18; Unknown-cap while Qs open.  
- [ ] No Confirmed claims for Region/RTO/BAA/owners invented in this work.

## Implementation note

After this spec is approved, create an implementation plan via `writing-plans`.
