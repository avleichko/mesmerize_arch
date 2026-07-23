# SAD Progress Tracker

**Pack:** `output_docs/sad/`  
**Date:** 2026-07-23  
**Source:** Checklist completion in [`COVERAGE.md`](COVERAGE.md)

## Maturity bands

| Band | Label | Meaning |
|-----:|-------|---------|
| 0 | Outline | Structure only |
| 25 | Stub | Placeholders / minimal prose |
| 50 | Draft | Evidence started; major gaps |
| 75 | Review-ready | Checklist strong; open Unknowns still block stakeholder sign-off |
| 100 | Stakeholder-ready | Checklist complete **and** no open Unknown callouts |

**Band rule:** map checklist % to nearest of 0/25/50/75/100. If the chapter still has any **Unknown:** callout, **cap band at 75** (Review-ready max) — do not claim Stakeholder-ready while red white spots remain.

---

## Per-chapter scores

| Chapter | Checklist | Raw % | Band | Label |
|--------:|----------:|------:|-----:|-------|
| 01 Purpose | 5/6 | 83% | **75** | Review-ready |
| 02 Scope | 5/6 | 83% | **75** | Review-ready *(capped; Unknown)* |
| 03 Related Documents | 4/5 | 80% | **75** | Review-ready |
| 04 Definitions | 5/5 | 100% | **100** | Stakeholder-ready |
| 05 Business Context | 7/9 | 78% | **75** | Review-ready |
| 06 Solution Scope | 8/9 | 89% | **75** | Review-ready *(capped; Unknown)* |
| 07 Functional Architecture | 9/9 | 100% | **75** | Review-ready *(capped; Unknown)* |
| 08 System Architecture | 10/10 | 100% | **75** | Review-ready *(capped; Unknown)* |
| 09 Data Architecture | 10/10 | 100% | **75** | Review-ready *(capped; Unknown)* |
| 10 Security & Privacy | 10/10 | 100% | **75** | Review-ready *(capped; Unknown)* |
| 11 Multitenancy | 10/10 | 100% | **75** | Review-ready *(capped; Unknown)* |
| 12 Messaging & Integration | 10/10 | 100% | **75** | Review-ready *(capped; Unknown)* |
| 13 Deployment & Infrastructure | 10/10 | 100% | **75** | Review-ready *(capped; many Unknowns)* |
| 14 NFR & Quality Attributes | 7/7 | 100% | **75** | Review-ready *(capped; Unknown)* |
| 15 Key Terms | 5/5 | 100% | **100** | Stakeholder-ready |
| 16 Revision History | 3/3 | 100% | **100** | Stakeholder-ready |
| 17 CI/CD | 8/8 | 100% | **75** | Review-ready *(capped; Unknown)* |

---

## Overall pack

| Metric | Value |
|--------|------:|
| Average of chapter **bands** | **(14×75 + 3×100) / 17 = 79%** |
| Overall maturity band | **75 — Review-ready** |
| Average of checklist raw % (informational) | ~94% *(inflated — architecture chapters can be checklist-complete while Unknowns remain)* |
| Chapters at Stakeholder-ready (100) | 3 / 17 (04, 15, 16) |
| Chapters with open Unknown callouts | 12 / 17 (02, 05–14, 17) |

**Verdict:** Pack is **~79% overall (band 75)** — solid Review-ready working SAD, **not** stakeholder-sign-off complete. Chapter 17 + ADR-016 evidence dual delivery ladders (diagrams 19/20); Unknown-cap still applies while Region, RTO/RPO, observability, deploy strategy, platform `staging`/`main` semantics, BAA, owners, and writeback payload remain open. Do not invent higher maturity.

---

## Hottest white spots (top 10 Unknowns)

1. **AWS Region / DR Region** (+ account/OU) — Chapter 13  
2. **RTO / RPO** — Chapters 13, 14 *(do not invent)*  
3. **AWS BAA necessity** for de-identified engagement schema — Chapters 09, 10, 14  
4. **Named Compliance / PHI approver** and **Billing rules owner** — Chapters 05, 10  
5. **DocumentReference payload + athenahealth acceptance** — Chapter 07  
6. **Availability / latency SLOs** (device↔cloud) — Chapter 14 *(do not invent)*  
7. **Observability vendor** + HIPAA policy pack — Chapters 10, 13, 14  
8. **Silo provisioning runbook / mode-switch / S3 naming** — Chapter 11  
9. **SQS queue catalog, RR timeouts, SMS vendor** — Chapter 12  
10. **ECS process split timing + Multi-AZ / autoscaling / deploy strategy** (+ platform `staging`/`main` semantics) — Chapters 08, 02, 13, **17**  

Also notable: pilot clinic/device count + Command Center RBAC depth (06); engagement log retention (14); exact platform GHA workflow inventory (17). **Closed via ADR-016 + Ch.17:** org branching / dual delivery ladders (Ladder A vs B; diagrams 19/20) — no longer a CI/CD branching evidence gap.

---

## How to update

1. Edit chapter content / callouts.  
2. Re-check boxes in [`COVERAGE.md`](COVERAGE.md).  
3. Recompute raw %, apply band + Unknown cap, refresh this file.  
4. Keep white-spot lists in sync with `rg -n 'Unknown:' chapters/*.md`.
