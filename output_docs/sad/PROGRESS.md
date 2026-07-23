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
| 18 Assumptions & Open Questions | 8/8 | 100% | **75** | Review-ready *(capped; Q-01…Q-14 open)* |

---

## Overall pack

| Metric | Value |
|--------|------:|
| Average of chapter **bands** | **(15×75 + 3×100) / 18 = 79%** |
| Overall maturity band | **75 — Review-ready** |
| Average of checklist raw % (informational) | ~94% *(inflated — architecture chapters can be checklist-complete while Unknowns remain)* |
| Chapters at Stakeholder-ready (100) | 3 / 18 (04, 15, 16) |
| Chapters with open Unknown callouts | 13 / 18 (02, 05–14, 17, 18) |

**Verdict:** Pack is **~79% overall (band 75)** — solid Review-ready working SAD, **not** stakeholder-sign-off complete. Chapter 18 consolidates Must-answer questions (**Q-01…Q-14**) and Proposed assumptions (**A-01…A-10**). Unknown-cap still applies while Q-rows remain open. Do not invent higher maturity.

---

## Hottest white spots (top 10 Unknowns)

Mapped to Chapter 18 IDs (source chapters keep Unknown callouts):

1. **AWS Region / DR Region** — **Q-07** (A-01 Proposed single-Region pilot) — Ch.13  
2. **RTO / RPO** — **Q-06** (A-02 Proposed Multi-AZ) — Ch.13, 14  
3. **AWS BAA necessity** — **Q-03** — Ch.09, 10, 14  
4. **Compliance / PHI approver** and **Billing rules owner** — **Q-01**, **Q-02** — Ch.05, 10  
5. **DocumentReference payload + athena acceptance** — **Q-05** — Ch.07  
6. **Availability / latency SLOs** — **Q-08** — Ch.14  
7. **Observability vendor** + HIPAA policy pack — **Q-09**, **Q-14** (A-10 Proposed) — Ch.10, 14  
8. **Silo provisioning / mode-switch** — **Q-11** (A-08 Proposed) — Ch.11  
9. **Messaging defaults / SMS** — **A-06**, **A-07** (Proposed) — Ch.12  
10. **Deploy strategy / promotion / process split** — **A-03**, **A-04**, **A-05**, **Q-13** — Ch.02, 08, 13, 17  

Also: pilot clinic/device count + RBAC (**Q-10**); engagement log retention (**A-09**, **Q-12**). Full register: [Chapter 18](chapters/18-assumptions-and-open-questions.md).

---

## How to update

1. Edit chapter content / callouts.  
2. Re-check boxes in [`COVERAGE.md`](COVERAGE.md).  
3. Recompute raw %, apply band + Unknown cap, refresh this file.  
4. Keep white-spot lists in sync with `rg -n 'Unknown:' chapters/*.md` and Chapter 18 Q/A IDs.
