# Customer decision-repo analysis — `mesmerize-monorepo`

- **Analyzed:** 2026-08-19 (replaces 2026-08-06 scaffold snapshot)
- **Path:** `/Users/sasaaleksandrov/myProjects/newfire/mesmerize-monorepo` (workspace symlink: `customer-kb/`)
- **Role:** Second knowledge base — **docs + infrastructure description**, not platform code
- **How agents must use it:** same as `kb/` — [ADR-018](../adr/018-customer-decision-repo-second-kb.md), [`docs/customer-kb/README.md`](../customer-kb/README.md)

The name “monorepo” is **historical**. README (2026-08-11): each service will live in its **own** repository; this repo records decisions and overall infra.

## What to treat as settled (customer register)

Read **`INFRASTRUCTURE.md`** first. Mesmerize-approved rows as of 2026-08-11:

| ID | Decision (summary) |
|----|--------------------|
| D-01 | Dedicated AWS org accounts: staging `301478651732`, production `063293864447`; primary region **us-east-2**; more per-service accounts as needed |
| D-02 | Human access **IAM Identity Center only** (no IAM users / long-lived keys); access via Mackenzie Clark / Teams |
| D-03 | Database: **PostgreSQL on Amazon RDS** (engine committed; hosting service may change) |
| D-04 | Compute: **ECS**, **one container per tenant**; K8s is a later step-up path |
| D-05 | Deploy: **blue-green production**, **rolling staging**; ECS-native (no CodeDeploy); expand/contract migrations |
| D-06 | Every **service** repo: GitHub Actions + **OIDC** to AWS (no static AWS keys in GitHub); Prod gate = `production` environment + reviewer. **This docs repo has no pipelines.** |
| D-07 | **Multi-repo** (supersedes earlier single-repo/path-filter plan) |

**Explicitly open in that register (do not invent):** IaC tool; observability vendor + PHI-safe log split; messaging/eventing; **device transport (re-opened)**; S3 inventory/prefix; log/audit retention; tenant isolation beyond per-tenant container; fate of the two shared accounts under multi-repo.

## What not to treat as Confirmed

| Path | Weight |
|------|--------|
| `docs/prebuild-proposal/` | Goals / historical brainstorm. **Not** settled architecture, stack, or SOW constraints. |
| Older 2026-08-06 pnpm/NestJS/Turborepo tree | **Gone / superseded** by the docs-only + multi-repo model. Do not plan delivery as if those apps still exist here. |

## Alignment / conflicts with this architecture pack

| Theme | Customer `D-xx` / README | This pack | Action |
|-------|--------------------------|-----------|--------|
| Product / PHI / no ambient | Prebuild goals + CONTRIBUTING PHI rule | ADR-001, ADR-002, ADR-011 | Aligned in spirit; still enforce this pack’s PHI invariants |
| Region / accounts | D-01 **us-east-2** + account IDs | SAD **Q-07** Unknown | **Escalate** — do not keep inventing Region as Unknown without closing via ADR |
| Deploy strategy | D-05 Prod **blue-green** | A-03 rolling Phase 1 | **Escalate** — customer signed Prod blue-green |
| Repo layout | D-07 **multi-repo** | ADR-017 polyglot monorepo | **Escalate** — customer signed multi-repo |
| Tenancy compute | D-04 **one container per tenant** | ADR-013 Bridge shared DB default | **Escalate** — different isolation axis (container vs DB) |
| Device transport | Explicitly **re-opened** | ADR-007 Socket.io Confirmed | **Escalate** — do not assume Socket.io is customer-settled |
| Backend language | Not in `D-xx` | ADR-017 Python/FastAPI | Architecture-repo decision until customer `D-xx` or superseding ADR |
| Imaging | Prebuild 08/09 present | ADR-009 / DNB-9 out of SOW | Do not build; prebuild is not a mandate |

## Implications for delivery

1. Always search `customer-kb/` (or the absolute path) **before** inventing infra or CI.
2. File customer-repo GitHub issues for Mesmerize decisions rather than inferring from prebuild docs.
3. Implementation will land in **per-service repos**, not in this architecture repo and not in the customer docs repo.
4. Do not copy Netlify/TTV into platform service pipelines (this pack ADR-016) unless a customer `D-xx` says otherwise — device transport is currently **open** on their register.
