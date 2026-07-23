# Design: Ladder A/B CI/CD diagrams + SAD Chapter 17

**Date:** 2026-07-23  
**Status:** Approved for implementation planning (pending user review of this spec)  
**Approach:** Two PlantUML activity diagrams + delivery-focused chapter 17 (Approach 1)

## Goal

Create two PlantUML delivery-ladder diagrams (Ladder A platform AWS, Ladder B device/PWA), render PNGs for SAD embeds, and add a new Mesmerize extension chapter **17 CI/CD** that owns delivery narrative. Slim CI/CD prose in chapter 13 to a pointer.

## Decisions (brainstorming)

| Topic | Choice |
|-------|--------|
| Chapter placement | **A** — `17-ci-cd.md` (Appendix F); no renumber of 01–16 |
| Diagram format | **B** — PlantUML |
| Chapter depth | **A** — Delivery-focused (not full CONTRIBUTING clone) |
| Packaging | **Approach 1** — Separate diagrams `19` + `20` + thin ch.13 pointer |

## Non-goals

- Inventing platform deploy strategy (rolling/blue-green/canary)
- Claiming Netlify or TTV filesync for NestJS/ECS
- Full workflow YAML inventory or rebase runbooks
- Word `.docx` fill
- Replacing AWS topology diagrams 17/18 (those remain runtime/deploy topology)

## Diagrams

### `output_diagrams/19-ladder-a-platform-cicd.puml` (+ `.png`)

**Title:** Ladder A — Platform (AWS) CI/CD  

**Flow (left → right):**  
Developer / PR → GitHub Actions (lint · test · build) → ECR (Inferred) → Terraform apply → ECS/Fargate service update  

**Annotations:**
- Confirmed: GHA + Terraform + ECS direction (ADR-010, ADR-015, ADR-016)
- Unknown: rolling / blue-green / canary
- Note: Dev / Staging / Prod environments; identical `staging`/`main` git promotion for platform = Proposed/Unknown
- **Must not include:** Netlify, TTV filesync

### `output_diagrams/20-ladder-b-device-cicd.puml` (+ `.png`)

**Title:** Ladder B — Device/PWA delivery  

**Flow:**  
feature branch → PR to `staging` → CI (lint/tsc/test/build + content checks as applicable)  
→ fork: Netlify branch preview (**web only**) | **human** TTV filesync → QA devices  
→ promote `staging`→`main` → **human** TTV filesync → production fleet  
→ Esper tags → brand / allow|hidden  

**Annotations:** Confirmed for touchscreen-ux / ADR-007; clear TTV cache after deploy; version stamp verify  

**Render:** OpenJDK + `.tools/plantuml.jar`; rename if `@startuml` id ≠ basename; sync PNGs to `output_docs/output_diagrams/`.

## Chapter 17

**Create:** `output_docs/sad/chapters/17-ci-cd.md`

| Section | Content |
|---------|---------|
| Meta | Extension; maturity Draft; link PROGRESS |
| Purpose | Dual delivery CI/CD; do not conflate ladders |
| Branching / PRs | Prefixes; PRs→`staging`; content vs code; Confirmed PWA / Proposed platform |
| Ladder A | Embed `19-ladder-a-platform-cicd.png` + caption |
| Ladder B | Embed `20-ladder-b-device-cicd.png` + caption |
| CI checks | Platform direction vs PWA workflow matrix from extract |
| Evidence | ADR-016, 007, 010, 015; touchscreen-ux extract |
| White spots / OQ | Deploy strategy; platform staging/main; (observability pointer only) |

Use existing HTML callout snippets (`_snippets/callouts.md`).

## Related pack updates

| File | Change |
|------|--------|
| `output_docs/sad/chapters/13-deployment-and-infrastructure.md` | Shorten CI/CD; pointer to ch.17; keep topology + diagrams 17/18 |
| `output_docs/sad/chapters/03-related-documents.md` | Link ch.17 + diagrams 19/20 |
| `output_docs/sad/README.md` | Index chapter 17 |
| `output_docs/sad/PROGRESS.md` / `COVERAGE.md` | Add ch.17; rescore |
| `output_docs/sad/WORD_TEMPLATE_CROSSWALK.md` | Appendix F = CI/CD |
| `output_diagrams/README.md` | Catalog 19/20 |
| Optional: `docs/ai/ARCHITECTURE.md` | One-line pointer to SAD ch.17 |

## Evidence rules

- Confirmed / Proposed / Inferred / Unknown per ADR-016 and existing SAD conventions
- Always name product: touchscreen-ux (device PWA) vs Content Evidence platform (AWS)
- Do not invent RTO/RPO/Region

## Success criteria

1. Two separate PlantUML ladders exist as PNG embeds  
2. Chapter 17 is the CI/CD home; ch.13 does not duplicate full ladder narrative  
3. Reviewer cannot confuse Netlify/TTV with ECS  
4. PROGRESS/COVERAGE/crosswalk/README include chapter 17  

## Next step after user approves this spec

Invoke **writing-plans** to produce the implementation plan.
