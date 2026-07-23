# 18. Assumptions and Open Questions

| Field | Value |
|-------|-------|
| Chapter ID | `18-assumptions-and-open-questions` |
| SAD mapping | Mesmerize extension (Appendix G) |
| Last updated | 2026-07-23 |
| Maturity | Review-ready · 75% |

## Purpose of this chapter

Give Mesmerize product, ops, and compliance a single place to **accept or reject Proposed engineering assumptions** and **answer Must-answer questions** that currently appear as Unknown callouts across the SAD. Source chapters keep their Unknown callouts until Mesmerize closes each item; this chapter owns the decision register.

Audience: **Mesmerize internal** (not Newfire SOW language).

## How to use

1. **Assumptions (A-xx):** Accept → record acceptance (comment / ADR / revision history) → update source chapter Unknown when ready. Reject → replace with a decision and superseding note.
2. **Questions (Q-xx):** Answer with owner + date → update source Unknown → rescore [`PROGRESS.md`](../PROGRESS.md).
3. Do **not** treat Proposed assumptions as Confirmed evidence.

## Assumptions register (Proposed)

<p style="background:#e3f2fd;border-left:4px solid #1565c0;padding:8px 12px;margin:12px 0;">
  <strong>Proposed:</strong> The following are engineering defaults for Phase 1 / pilot planning. They are <strong>not</strong> Confirmed until Mesmerize accepts them.
</p>

| ID | Assumption | Rationale | Invalidate if | Sources |
|----|------------|-----------|---------------|---------|
| A-01 | Pilot: one primary AWS Region (no multi-Region active-active in Phase 1) | Typical first SMART/athena pilot; DR secondary until RTO exists | Multi-Region required from day one | [13](13-deployment-and-infrastructure.md), [14](14-nfr-and-quality-attributes.md) |
| A-02 | RDS + Redis Multi-AZ on for Staging/Prod | Standard HA without inventing RTO | Cost/ops veto for pilot | [13](13-deployment-and-infrastructure.md) |
| A-03 | Ladder A Phase 1 deploy strategy = rolling | Simplest ECS default | Canary/blue-green mandated | [13](13-deployment-and-infrastructure.md), [17](17-ci-cd.md) |
| A-04 | Platform repos use `feature → staging → main` | Matches ADR-016 Proposed | Different promotion model | [02](02-scope.md), [17](17-ci-cd.md) |
| A-05 | NestJS services = separate ECS services by cutover | Blast-radius / boundary clarity | Long-lived co-locate for cost | [08](08-system-architecture.md) |
| A-06 | Queues `{env}-{service}-{purpose}`; RR timeout default 30s until measured | Unblocks messaging build | Different standard | [12](12-messaging-and-integration.md) |
| A-07 | SMS = one US-capable provider (Twilio-class) chosen at build | Common clinic messaging pattern | Other vendor already contracted | [12](12-messaging-and-integration.md) |
| A-08 | Silo: dedicated DB + secrets namespace; shared S3 + prefix until scale | ADR-013 spirit | Dedicated buckets day one | [11](11-multitenancy.md) |
| A-09 | Engagement/business logs retained ≥ 1 year Prod pending confirmation | Conservative floor; not multi-year claim | Signed retention differs | [14](14-nfr-and-quality-attributes.md) |
| A-10 | One observability vendor; PHI-safe log split (no PHI on Mesmerize servers) | Zero-PHI posture; vendor name open | Dual-tool mandate | [10](10-security-and-privacy.md), [14](14-nfr-and-quality-attributes.md) |

## Open questions register (Must-answer)

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> The following must be answered by Mesmerize before Stakeholder-ready sign-off. Owner column lists <em>roles</em>, not confirmed named individuals.
</p>

| ID | Question | Blocks | Suggested owner role | Sources |
|----|----------|--------|----------------------|---------|
| Q-01 | Who is Compliance / PHI approver? | Security sign-off | Compliance lead | [05](05-business-context.md), [10](10-security-and-privacy.md) |
| Q-02 | Who owns billing / engagement rules? | Product acceptance | Product / MM | [05](05-business-context.md) |
| Q-03 | Is an AWS BAA required given de-identified engagement schema? | Legal / account | Compliance + legal | [09](09-data-architecture.md), [10](10-security-and-privacy.md), [14](14-nfr-and-quality-attributes.md) |
| Q-04 | Ratify data-classification matrix (what may touch Mesmerize servers)? | Data + security | Compliance + architecture | [09](09-data-architecture.md), [10](10-security-and-privacy.md) |
| Q-05 | Confirm DocumentReference writeback field catalog + athena pilot acceptance | Writeback | Clinical informatics / EHR config | [07](07-functional-architecture.md) |
| Q-06 | RTO / RPO for Staging vs Prod? | DR / Multi-AZ spend | Ops + compliance | [13](13-deployment-and-infrastructure.md), [14](14-nfr-and-quality-attributes.md) |
| Q-07 | Primary AWS Region (+ DR Region if any)? | All infra | Ops / cloud owner | [13](13-deployment-and-infrastructure.md) |
| Q-08 | Formal availability / latency SLO for device↔cloud (or explicitly “none for pilot”)? | NFR-REL | Product + ops | [14](14-nfr-and-quality-attributes.md) |
| Q-09 | Final observability vendor + HIPAA logging policy pack timeline? | Ops + SEC | Ops / AM | [10](10-security-and-privacy.md), [14](14-nfr-and-quality-attributes.md) |
| Q-10 | Exact pilot clinic + device count and Command Center RBAC depth for Phase 1? | Scope / acceptance | Product / SOW owner | [06](06-solution-scope.md) |
| Q-11 | Silo provisioning runbook owner + post-go-live Bridge↔Silo switch policy? | Multitenancy ops | Platform ops | [11](11-multitenancy.md) |
| Q-12 | Engagement log retention years if beyond A-09? | Storage / compliance | Brandon / MM / compliance | [14](14-nfr-and-quality-attributes.md) |
| Q-13 | Who promotes Ladder A Staging → Prod and with what gates? | Delivery | Ops / eng lead | [17](17-ci-cd.md) |
| Q-14 | HIPAA policy pack delivery date from Mesmerize (AM)? | Security appendix | AM / compliance | [10](10-security-and-privacy.md) |

## Traceability (theme → IDs)

| Theme | IDs |
|-------|-----|
| Region / DR | A-01, Q-07 |
| RTO / RPO / Multi-AZ | A-02, Q-06 |
| Deploy / branching / promotion | A-03, A-04, Q-13 |
| Process split / ECS | A-05 |
| Messaging / SMS | A-06, A-07 |
| Multitenancy Silo | A-08, Q-11 |
| Logs / observability | A-09, A-10, Q-09, Q-12 |
| Compliance / BAA / classification / owners | Q-01, Q-02, Q-03, Q-04, Q-14 |
| Writeback payload | Q-05 |
| Pilot scope / RBAC | Q-10 |
| Device↔cloud SLO | Q-08 |

## How to close

1. Mesmerize answers a **Q-xx** or accepts/rejects an **A-xx**.  
2. Update the source chapter Unknown (and ADR if needed).  
3. Mark the row Status in this chapter (Accepted / Answered / Superseded) in a follow-up edit.  
4. Rescore [`COVERAGE.md`](../COVERAGE.md) / [`PROGRESS.md`](../PROGRESS.md).

## Evidence

- Source Unknowns across chapters 02, 05–14, 17 (see White spots in those files)
- [ADR-016](../../../docs/adr/016-git-branching-and-delivery-ladders.md) — branching Proposed for platform
- Spec: `docs/superpowers/specs/2026-07-23-sad-assumptions-and-open-questions-design.md`

## White spots

<p style="background:#fde8e8;border-left:4px solid #c62828;padding:8px 12px;margin:12px 0;">
  <strong>Unknown:</strong> All open <strong>Q-01…Q-14</strong> rows above. Assumptions A-01…A-10 remain Proposed until accepted — they do not clear source-chapter Unknowns by themselves.
</p>
