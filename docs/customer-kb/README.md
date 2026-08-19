# Second knowledge base — customer decision repo

**Always check this source the same way as [`kb/`](../../kb/):** search and analyze before proposing or implementing architecture, infra, CI/CD, tenancy, devices, auth, or product behavior. Do not invent requirements.

This architecture repo does **not** copy the customer tree (it is a separate git repo). Agents resolve it via:

| Resolution | Path |
|------------|------|
| Workspace symlink (preferred) | [`customer-kb/`](../../customer-kb) at repo root |
| Default local clone | `/Users/sasaaleksandrov/myProjects/newfire/mesmerize-monorepo` |
| Override | Environment `MESMERIZE_CUSTOMER_KB` if set |

If the symlink is missing:

```bash
ln -sfn /Users/sasaaleksandrov/myProjects/newfire/mesmerize-monorepo customer-kb
```

Binding practice: [ADR-018](../adr/018-customer-decision-repo-second-kb.md). Cursor: [`.cursor/rules/customer-kb.mdc`](../../.cursor/rules/customer-kb.mdc).

## What to read first (inside the customer repo)

| Order | File | Weight |
|------:|------|--------|
| 1 | `INFRASTRUCTURE.md` | **Settled** Mesmerize-approved infra (`D-xx`). If it is not listed, it is not decided *in this register*. |
| 2 | `README.md` | Layout, AWS accounts/SSO, service-repo index, “this repo has no platform code.” |
| 3 | `CONTRIBUTING.md` | PHI rule; PRs to `main`; issues for stakeholder decisions. |
| 4 | `docs/prebuild-proposal/` | **Not settled architecture.** Goals / historical brainstorm only. Do not cite as Confirmed. |

Snapshot / conflict notes: [`docs/architecture/customer-monorepo-analysis.md`](../architecture/customer-monorepo-analysis.md). SAD **Chapter 21** is the DevOps provision checklist and cites `D-xx`; it **does not** add `INFRASTRUCTURE.md` rows.

## Precedence vs `kb/` and this repo’s ADRs

1. **`kb/`** — original SOW / Q&A / strategy evidence (local, often gitignored).
2. **`customer-kb/`** — live Mesmerize/Newfire decision + infra description repo.
3. **`docs/adr/`** — this architecture pack’s confirmed product/PHI/stack register.

Templates still do not invent requirements. Ground content in `kb/` + `customer-kb/` + `docs/adr/`.

If `INFRASTRUCTURE.md` `D-xx` **conflicts** with an architecture ADR: stop and escalate — do not silently override either source.
