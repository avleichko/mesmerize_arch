# SAD Coverage Checklist

**Pack:** `output_docs/sad/`  
**Date:** 2026-07-23  
**Rule:** Shared items from the SAD design spec; chapter-specific minimums from Task 15. Mark `[x]` / `[ ]`. N/A items omitted from that chapter’s denominator. White spots must match colored **Unknown** / **Proposed** callouts in chapter bodies.

**Shared items (adapt per chapter):**

1. Purpose stated  
2. Actors / components covered  
3. Required diagrams embedded as images  
4. Interfaces / interactions described  
5. Data ownership noted (where relevant)  
6. Security / PHI notes (where relevant)  
7. Evidence links (ADRs / docs)  
8. Open questions listed or explicitly “none”  
9. White spots only as colored Unknown/Proposed — no silent gaps  

---

## 01 — Purpose of Document

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered (audience) | [x] |
| 6 | Security / PHI notes (product boundary) | [x] |
| 7 | Evidence links | [x] |
| 8 | Open questions listed or explicitly “none” | [ ] |
| 9 | White spots only as colored callouts | [x] |

**N/A:** diagrams, interfaces, data ownership (front-matter).

**Score:** 5 / 6 = **83%** → band **75**

**White spots:** none (Inferred only: Chapters 10–14 as Word annexes/extensions).

---

## 02 — Scope

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered (in/out areas) | [x] |
| 6 | Security / PHI notes | [x] |
| 7 | Evidence links (incl. ADR-016 dual ladders) | [x] |
| 8 | Open questions listed or explicitly “none” | [ ] |
| 9 | White spots only as colored callouts | [x] |

**N/A:** diagrams, interfaces, data ownership (document-scope chapter; feature detail in 06).

**Score:** 5 / 6 = **83%** → band **75** (capped while Unknown remains)

**White spots (Unknown):**

- Whether platform AWS Staging/Prod promotion uses identical `staging`/`main` semantics as Ladder B (ADR-016 leaves this open).

**Closed (no longer a white spot):** Device/PWA Ladder B branching (`feature → staging → main`; Netlify ≠ device) — evidenced by ADR-016 + touchscreen-ux extract.

**White spots (Proposed):**

- Platform repos adopt the same org branch/PR conventions (ADR-016).

---

## 03 — Related Documents

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered (ADR / doc catalog 001–016) | [x] |
| 7 | Evidence links (ADR-016 + touchscreen-ux DevOps extract under Deployment) | [x] |
| 8 | Open questions listed or explicitly “none” | [ ] |
| 9 | White spots only as colored callouts | [x] |

**N/A:** architecture diagrams, interfaces, data ownership, PHI narrative (pointers only).

**Score:** 4 / 5 = **80%** → band **75**

**White spots (Proposed):**

- Keep this chapter as the single “table of sources”; deepen narrative in domain chapters rather than duplicating ADR text.

**Closed (no longer a white spot):** Missing CI/CD / branching source pointers — ADR-016 and `kb/customer-reference/touchscreen-ux-devops-extract.md` are catalogued.

---

## 04 — Definitions and Acronyms

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered (acronym list) | [x] |
| 7 | Evidence links | [x] |
| 8 | Open questions listed or explicitly “none” | [x] |
| 9 | White spots only as colored callouts | [x] |

**N/A:** diagrams, interfaces, data ownership, PHI (glossary aid).

**Score:** 5 / 5 = **100%** → band **100** (no open Unknown callouts)

**White spots:** none (Confirmed: Chapter 15 is a condensed curated subset of GLOSSARY, not a full mirror).

---

## 05 — Business Context

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered | [x] |
| 3 | Required diagrams embedded (`07-c4-context`) | [x] |
| 5 | Data ownership noted (content / PWA in stakeholder table) | [x] |
| 6 | Security / PHI notes | [x] |
| 7 | Evidence links (dedicated Evidence section) | [ ] |
| 8 | Open questions listed or explicitly “none” | [ ] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** stakeholder table present | [x] |

**N/A:** interfaces (governance chapter; runtime interactions in 07–08).

**Score:** 7 / 9 = **78%** → band **75**

**White spots (Unknown):**

- Named **Compliance / PHI approver** and **Billing rules owner** remain open in kb — do not invent owners.

---

## 06 — Solution Scope

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered | [x] |
| 3 | Required diagrams embedded (`01-system-context`, `17-aws-deployment-reference`) | [x] |
| 4 | Interfaces / interactions described | [x] |
| 6 | Security / PHI notes | [x] |
| 7 | Evidence links | [x] |
| 8 | Open questions listed or explicitly “none” | [ ] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** in/out scope lists | [x] |

**N/A:** detailed data ownership (Chapter 09).

**Score:** 8 / 9 = **89%** → band **75** (capped while Unknown remains; not Stakeholder-ready)

**White spots (Unknown):**

- Exact pilot clinic/device count and Command Center RBAC depth for Phase 1 vs later.

**White spots (Proposed):**

- Detailed production packaging / region/DR / autoscaling live in Chapter 13 — this chapter is boundary-only for AWS shape.

---

## 07 — Functional Architecture

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered | [x] |
| 3 | Required diagrams embedded (`03-encounter-flow`; `05-auth-model`) | [x] |
| 4 | Interfaces / interactions described | [x] |
| 6 | Security / PHI notes | [x] |
| 7 | Evidence links | [x] |
| 8 | Open questions listed | [x] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** encounter happy path | [x] |

**N/A:** physical data ownership (Chapter 09).

**Score:** 9 / 9 = **100%** → band **75** (capped while Unknown remains)

**White spots (Unknown):**

- Exact DocumentReference payload field catalog and athenahealth acceptance criteria for pilot writeback.

**White spots (Proposed):**

- Command Center RBAC role rollout timing (Auth0 remains IdP for admin).  
- Bridge patient auth and waiting-room playlist optimization as adjacent surfaces; core path is exam-room Content Evidence → DocumentReference.

---

## 08 — System Architecture

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered | [x] |
| 3 | Required diagrams embedded (`06-c4-containers`, `06a`–`06h` focus, `04-monorepo-boundaries`) | [x] |
| 4 | Interfaces / interactions described | [x] |
| 5 | Data ownership noted (component responsibilities) | [x] |
| 6 | Security / PHI notes | [x] |
| 7 | Evidence links (incl. ADR-016 Ladder B for extend-PWA) | [x] |
| 8 | Open questions listed | [x] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** responsibilities + interactions | [x] |

**Score:** 10 / 10 = **100%** → band **75** (capped while Unknown remains)

**White spots (Unknown):**

- Final process-per-service vs co-located NestJS modules for pilot cutover timing; exact public REST route catalog per service beyond architecture API groups.

**Closed (no longer a white spot):** Device/PWA delivery path vs platform ECS — Ladder B vs Ladder A evidenced by ADR-016 (extend-PWA pointer).

**White spots (Proposed):**

- Coarse domain microservices as target runtime shape; early pilot may co-locate (ADR-015).  
- Optional `ads-service` off the core clinical path until prioritized.

---

## 09 — Data Architecture

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered | [x] |
| 3 | Required diagrams embedded (`02-phi-boundary`) | [x] |
| 4 | Interfaces / interactions described (data flow) | [x] |
| 5 | Data ownership noted | [x] |
| 6 | Security / PHI notes | [x] |
| 7 | Evidence links | [x] |
| 8 | Open questions listed | [x] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** sources / model / flow / ownership | [x] |

**Score:** 10 / 10 = **100%** → band **75** (capped while Unknown remains)

**White spots (Unknown):**

- Final ratified physical data-classification matrix; whether an AWS BAA is required given the de-identified engagement schema.

**White spots (Proposed):**

- Future CPT as secondary re-ranking signal needs a new ADR before schema/matcher change (ADR-006).

---

## 10 — Security & Privacy

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered | [x] |
| 3 | Required diagrams embedded (`02-phi-boundary`, `05-auth-model`, `11` + `12` SMART OAuth) | [x] |
| 4 | Interfaces / interactions described | [x] |
| 5 | Data ownership noted (browser vs Platform) | [x] |
| 6 | Security / PHI notes | [x] |
| 7 | Evidence links | [x] |
| 8 | Open questions listed | [x] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** PHI + auth diagrams embedded | [x] |

**Score:** 10 / 10 = **100%** → band **75** (capped while Unknown remains)

**White spots (Unknown):**

- AWS BAA necessity for the chosen engagement schema.  
- Final observability vendor/config; formal HIPAA policy pack from Mesmerize (AM).  
- Named compliance / PHI decision owner; final data-classification matrix ratification.

**White spots (Proposed):**

- OWASP hardening + pen test (SOW Phase 3) and formal HIPAA-aligned AWS policy handover — not yet a signed Mesmerize pack.

---

## 11 — Multitenancy

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered | [x] |
| 3 | Required diagrams embedded (`08` overview, `09` Silo, `10` Bridge) | [x] |
| 4 | Interfaces / interactions described | [x] |
| 5 | Data ownership noted (tenant / clinic / S3) | [x] |
| 6 | Security / PHI notes (orthogonal to zero-PHI) | [x] |
| 7 | Evidence links | [x] |
| 8 | Open questions listed | [x] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** Silo + Bridge diagrams embedded | [x] |

**Score:** 10 / 10 = **100%** → band **75** (capped while Unknown remains)

**White spots (Unknown):**

- Silo provisioning automation (DB + secrets + migrations per org); post-go-live mode-switch policy; exact shared vs dedicated S3 bucket naming for Silo orgs.

**White spots (Proposed):**

- Fail-closed repository guards + org-config lookup as single routing point — implied by ADR-013; not yet a coded pack standard.

---

## 12 — Messaging & Integration

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered | [x] |
| 3 | Required diagrams embedded (all four: `13`–`16` SQS) | [x] |
| 4 | Interfaces / interactions described | [x] |
| 5 | Data ownership noted (envelope `tenantId` / no PHI) | [x] |
| 6 | Security / PHI notes | [x] |
| 7 | Evidence links | [x] |
| 8 | Open questions listed | [x] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** all four SQS diagrams embedded | [x] |

**Score:** 10 / 10 = **100%** → band **75** (capped while Unknown remains)

**White spots (Unknown):**

- Full per-service queue catalog; RR timeout defaults; SMS vendor; exact Auth0/Esper callback and secret layout beyond existing auth/device ADRs.

**White spots (Proposed):**

- Shared consumer library enforcing envelope + tenant fail-closed + backoff/DLQ (ADR-014 consequences; not coded standard yet).

---

## 13 — Deployment & Infrastructure

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered | [x] |
| 3 | Required diagrams embedded (`18` primary, `17` companion) | [x] |
| 4 | Interfaces / interactions described | [x] |
| 5 | Data ownership noted (RDS / Redis / S3) | [x] |
| 6 | Security / PHI notes | [x] |
| 7 | Evidence links (ADR-016 + touchscreen-ux extract; dual ladders) | [x] |
| 8 | Open questions listed | [x] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** both AWS diagrams embedded; TBD Region/RTO called out | [x] |

**Score:** 10 / 10 = **100%** → band **75** (capped; many blocking Unknowns — not Stakeholder-ready)

**White spots (Unknown):**

- Production **AWS Region** (and optional DR Region); AWS account ID / org OU.  
- **RTO** and **RPO** — no kb values.  
- RDS and ElastiCache **Multi-AZ flags**.  
- ECS **autoscaling** min/max.  
- Platform **deployment strategy** (rolling / blue-green / canary).  
- Identical platform `staging`/`main` promotion semantics vs Ladder B.  
- Final **observability** vendor/config (still open; see also Ch 10 / 14).

**Closed (no longer a white spot):** Missing CI/CD **branching** evidence / “CI/CD pack from AM” for org branching — dual delivery ladders (Ladder A GHA→ECR→ECS+TF; Ladder B Netlify web-only + TTV filesync) are Confirmed direction via ADR-016. Do not conflate Netlify/TTV with ECS.

**White spots (Proposed):**

- Route 53, WAF, Secrets Manager, KMS CMKs as mandatory prod controls — awaiting security sign-off.  
- Platform repos adopt touchscreen-ux branch/PR conventions (ADR-016).

---

## 14 — NFR & Quality Attributes

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered (ASR groups) | [x] |
| 6 | Security / PHI notes | [x] |
| 7 | Evidence / Sources links (incl. ADR-016 for NFR-OPS ladders) | [x] |
| 8 | Open questions listed (Open items table) | [x] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** ASR summary without invented SLOs | [x] |

**N/A:** large architecture diagrams; detailed interfaces; data-ownership tables (point to 09/NFR catalog).

**Score:** 7 / 7 = **100%** → band **75** (capped while Unknown remains)

**White spots (Unknown):**

- Whether an AWS BAA is required if Mesmerize stores only de-identified data (NFR-SEC-04).  
- Formal availability / latency SLOs for device↔cloud (NFR-REL-04) — **do not invent**.  
- Recovery time / recovery point objectives — **do not invent**.  
- Engagement / business log retention (multi-year figures discussed but not confirmed).  
- Final **observability** vendor (Datadog vs approved alternative).

**Closed (no longer a white spot):** Device vs platform delivery ladder ambiguity for OPS ASRs — NFR-OPS-05/06 cite ADR-016 (Ladder A vs B).

---

## 15 — Key Terms and Abbreviations

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered (key terms) | [x] |
| 7 | Evidence links | [x] |
| 8 | Open questions listed or explicitly “none” | [x] |
| 9 | White spots only as colored callouts | [x] |

**N/A:** diagrams, interfaces, data ownership, PHI narrative. No Unknown callouts; open questions: none.

**Score:** 5 / 5 = **100%** → band **100**

**White spots:** none (Inferred only: superseded / ops aliases stay in GLOSSARY).

---

## 16 — Revision History

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 7 | Evidence links | [x] |
| 8 | Open questions | N/A (revision log) |
| 9 | White spots only as colored callouts | [x] |

**N/A:** actors, diagrams, interfaces, ownership, PHI, open questions.

**Score:** 3 / 3 = **100%** → band **100**

**White spots:** none (Inferred only: future rows should note chapter/ADR ranges).

---

## 17 — CI/CD

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / components covered (Ladder A platform / Ladder B device-PWA) | [x] |
| 3 | Required diagrams embedded (`19-ladder-a-platform-cicd`, `20-ladder-b-device-cicd`) | [x] |
| 4 | Interfaces / interactions described (branching, CI, release paths) | [x] |
| 7 | Evidence links (ADR-016 + touchscreen-ux extract; dual ladders) | [x] |
| 8 | Open questions listed | [x] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** dual ladders; no Netlify/TTV→ECS; Unknown deploy strategy listed | [x] |

**N/A:** data ownership; Security/PHI narrative (runtime/PHI in Chapters 10 / 13; this chapter is delivery-only).

**Score:** 8 / 8 = **100%** → band **75** (capped while Unknown remains — not Stakeholder-ready)

**White spots (Unknown):**

- Platform **deployment strategy** (rolling / blue-green / canary).  
- Identical platform `staging`/`main` promotion semantics vs Ladder B.  
- Exact platform GitHub Actions workflow inventory for NestJS services.

**Confirmed (not white spots):** Dual delivery ladders — Ladder A GHA→ECR→ECS+TF; Ladder B Netlify web-only + human TTV filesync. Do **not** conflate Netlify/TTV with ECS.

**White spots (Proposed):**

- Platform repos adopt touchscreen-ux branch/PR conventions (ADR-016).

---

## 18 — Assumptions and Open Questions

| # | Item | Status |
|---|------|--------|
| 1 | Purpose stated | [x] |
| 2 | Actors / audience covered (Mesmerize product/ops/compliance) | [x] |
| 7 | Evidence links (source chapters + ADR-016 + design spec) | [x] |
| 8 | Open questions listed (Q-01…Q-14) | [x] |
| 9 | White spots only as colored callouts | [x] |
| * | **Chapter-specific:** Assumptions A-01…A-10 (Proposed only); Must-answer Q register; no invented Confirmed Region/RTO/BAA/owners | [x] |
| * | **Chapter-specific:** Traceability + how-to-close | [x] |
| * | **Chapter-specific:** Other chapters point Open questions at Ch.18 IDs | [x] |

**N/A:** diagrams; data ownership; Security/PHI narrative body (owned by Ch.10 — this chapter is the decision register).

**Score:** 8 / 8 = **100%** → band **75** (capped while Q-01…Q-14 Unknown remains — not Stakeholder-ready)

**White spots (Unknown):** All open **Q-01…Q-14** (see chapter register).

**White spots (Proposed):** Assumptions **A-01…A-10** (engineering defaults; do not clear source Unknowns until Mesmerize accepts).

---

## Sanity cross-check

Every `Unknown:` callout in `chapters/*.md` is listed above under the matching chapter. Proposed callouts are listed as non-blocking white spots where present. Decision IDs live in Chapter 18.

```bash
rg -n "Unknown:" output_docs/sad/chapters/*.md
rg -n "Unknown|white spot" output_docs/sad/COVERAGE.md
```
