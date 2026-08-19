# Mesmerize architecture pack

Working architecture for the **Content Evidence Platform**: ADRs, Solution Architecture Definition (SAD), NFRs, and diagrams.

This is the **canonical** pack (`avleichko/mesmerize_arch`). A snapshot is copied to [`MJHLS/mesmerize-monorepo`](https://github.com/MJHLS/mesmerize-monorepo) under `architecture/` (branch `docs/architecture-working-pack`). That copy does **not** replace customer [`INFRASTRUCTURE.md`](docs/customer-kb/README.md) `D-xx`.

If an ADR here and a customer `D-xx` **conflict**, stop and ask — do not merge them silently ([ADR-018](docs/adr/018-customer-decision-repo-second-kb.md)).

## How to use these docs

### Pick your job

| You want to… | Start here |
|--------------|------------|
| Learn the product in one pass | [SAD Ch.01](output_docs/sad/chapters/01-purpose.md) → [02](output_docs/sad/chapters/02-scope.md) → [07](output_docs/sad/chapters/07-functional-architecture.md) |
| Confirm a **binding decision** | [ADR register](docs/adr/README.md) |
| Check **do-not-build** / PHI | [AGENTS.md](AGENTS.md) + [ADR-011](docs/adr/011-do-not-build.md) + [ADR-002](docs/adr/002-zero-phi-on-mesmerize-servers.md) |
| Design or review a change | ADR register → [`docs/ai/NFR.md`](docs/ai/NFR.md) (ASR rows) → SAD chapter |
| Exam-room **imaging** | [ADR-019](docs/adr/019-exam-room-imaging-display-and-evidence.md) → [Ch.19](output_docs/sad/chapters/19-imaging-mirror-evidence-addendum.md) → [Ch.20](output_docs/sad/chapters/20-exam-room-imaging-mirror.md) · NFR **INT-05**, **PERF-02** |
| Open questions | [SAD Ch.18](output_docs/sad/chapters/18-assumptions-and-open-questions.md) (**Q-01…Q-17**) |
| Infra provision checklist (Dev / Staging / Prod) | [SAD Ch.21](output_docs/sad/chapters/21-infra-provision-checklist.md) — does **not** create `D-xx` |
| Settled customer infra | [`customer-kb/INFRASTRUCTURE.md`](docs/customer-kb/README.md) `D-01`–`D-07` only |
| Export / handoff | [`output_docs/`](output_docs/README.md) |

### Read order (before changing architecture)

1. This README (map + what is *not* Confirmed).
2. [`AGENTS.md`](AGENTS.md) — mission, invariants, in/out of scope.
3. [`docs/adr/README.md`](docs/adr/README.md) — #1–#20, stack **S1–S15** (S8 = per-service repos), DNB, tenancy, delivery.
4. Customer `INFRASTRUCTURE.md` `D-xx` ([pointer](docs/customer-kb/README.md)).
5. The SAD chapter or `docs/ai/*` file for the area you are touching.

`kb/` is local evidence (often gitignored). Do not invent requirements to fill gaps.

### Status words

| Status | Meaning |
|--------|---------|
| **Confirmed** | ADR, signed `D-xx`, or explicit kb/Q&A |
| **Inferred** | Strongly implied; not an explicit decision |
| **Proposed** | Recommended; not decided (FHIR imaging **read** strings until **Q-16**; GitHub slugs until **Q-17**) |
| **Unknown** | Must be answered; [Chapter 18](output_docs/sad/chapters/18-assumptions-and-open-questions.md) |

### Canonical vs export

| Canonical | Export |
|-----------|--------|
| [`docs/adr/`](docs/adr/) | [`output_docs/docs/adr/`](output_docs/docs/adr/) |
| [`docs/ai/`](docs/ai/) | [`output_docs/docs/ai/`](output_docs/docs/ai/) · NFR also [`output_docs/nfr/`](output_docs/nfr/) |
| [`output_diagrams/`](output_diagrams/) | [`output_docs/output_diagrams/`](output_docs/output_diagrams/) |
| SAD | [`output_docs/sad/`](output_docs/sad/README.md) only (21 chapters) |

---

## Map: SAD ↔ ADR ↔ NFR ↔ diagrams

Use this table so new chapters and ADRs stay wired. Ch.21 adds **no** diagram catalog IDs.

| SAD | Primary ADRs / `D-xx` | NFR / ASR | Diagrams |
|-----|----------------------|-----------|----------|
| [01](output_docs/sad/chapters/01-purpose.md) Purpose | 001, 011, 019 | — | — |
| [02](output_docs/sad/chapters/02-scope.md) Scope | 001, 011, 015, 016, **017 S8**, 019 · D-07 | — | — |
| [03](output_docs/sad/chapters/03-related-documents.md) Related documents | Register 001–019 | Catalog pointer | — |
| [04](output_docs/sad/chapters/04-definitions-and-acronyms.md) / [15](output_docs/sad/chapters/15-key-terms-and-abbreviations.md) Terms | — | — | — |
| [05](output_docs/sad/chapters/05-business-context.md) Business | 001, 012 | — | 07 |
| [06](output_docs/sad/chapters/06-solution-scope.md) Solution scope | 001, 011, 019 | — | 01, 17 |
| [07](output_docs/sad/chapters/07-functional-architecture.md) Functional | 002–008, 019 | INT-01, BUS-01/02 | 03, 05, 11–12 |
| [08](output_docs/sad/chapters/08-system-architecture.md) System | 010, **017**, 019 | INT-02, INT-05 | 06, 06a–h, **04** (logical modules), 23 |
| [09](output_docs/sad/chapters/09-data-architecture.md) Data | 002, 008, 013 | SEC-01, DATA-* | 02 |
| [10](output_docs/sad/chapters/10-security-and-privacy.md) Security | 002, 005, 011, 019 | SEC-*, INT-05 | 02, 05, 11–12 |
| [11](output_docs/sad/chapters/11-multitenancy.md) Multitenancy | 013 · D-04 **Ask** | SEC-07, DATA-02 | 08–10 |
| [12](output_docs/sad/chapters/12-messaging-and-integration.md) Messaging | 014 | INT-04, REL-01/02 | 13–16 |
| [13](output_docs/sad/chapters/13-deployment-and-infrastructure.md) Deployment | 015 · D-01 accounts Confirmed; Region **Q-07 Ask** | OPS-05/06 | 17–18, 21–22 |
| [14](output_docs/sad/chapters/14-nfr-and-quality-attributes.md) NFR | 002, 007, 013, 014, 016, **019** | Full ASR list; **INT-05**, **PERF-02** | — |
| [16](output_docs/sad/chapters/16-revision-history.md) Revisions | — | — | — |
| [17](output_docs/sad/chapters/17-ci-cd.md) CI/CD | 016, **017**, D-06 | OPS-05/06 | **19–20** (ladders, not imaging) |
| [18](output_docs/sad/chapters/18-assumptions-and-open-questions.md) Assumptions | — | **Q-01…Q-17**, A-01…A-10 | — |
| [19](output_docs/sad/chapters/19-imaging-mirror-evidence-addendum.md) Imaging evidence | **019**, 002, 003, 008 | INT-05 | **23** |
| [20](output_docs/sad/chapters/20-exam-room-imaging-mirror.md) Imaging display | **019**, 007 | INT-05, PERF-02 | **24–25** |
| [21](output_docs/sad/chapters/21-infra-provision-checklist.md) Infra provision checklist | **017** S8, 010, 013–016, 018 · **D-01–D-07** | No new NFR; cites Q-07/09/13/03/14/**17** | **None** |

**Q-16** = additive FHIR **read** strings (Ch.19–20). **Q-17** = GitHub org + service repo slugs (Ch.21).

Trackers: [SAD README](output_docs/sad/README.md) · [PROGRESS](output_docs/sad/PROGRESS.md) · [COVERAGE](output_docs/sad/COVERAGE.md) · [NFR catalog](output_docs/nfr/NFR_CATALOG.md) · [ASR checklist](output_docs/nfr/ASR_CHECKLIST.md)

---

## Table of contents

### SAD (21 chapters)

See [output_docs/sad/README.md](output_docs/sad/README.md).

### ADRs (001–019)

Full register: [docs/adr/README.md](docs/adr/README.md). **S8** = per-service GitHub repos (D-07 / ADR-017). **ADR-009** is superseded by **019**.

### Agent docs (`docs/ai/`)

| File | Purpose |
|------|---------|
| [PROJECT_CONTEXT.md](docs/ai/PROJECT_CONTEXT.md) | Business purpose, success metric |
| [ARCHITECTURE.md](docs/ai/ARCHITECTURE.md) | Components, logical modules vs service repos |
| [CURRENT_STATE.md](docs/ai/CURRENT_STATE.md) | What exists vs to-be-built |
| [ENGINEERING_RULES.md](docs/ai/ENGINEERING_RULES.md) | Stack, conventions |
| [SECURITY.md](docs/ai/SECURITY.md) | PHI boundary, auth, BAAs |
| [TESTING.md](docs/ai/TESTING.md) | Validation before “done” |
| [GLOSSARY.md](docs/ai/GLOSSARY.md) | Shared vocabulary |
| [NFR.md](docs/ai/NFR.md) | NFRs; **ASR** rows binding |

### Diagrams

Catalog **01–25**: [`output_diagrams/README.md`](output_diagrams/README.md). **19–20** = CI/CD ladders. **23–25** = imaging. Diagram **04** is **logical** app/package boundaries (physical git = service repos).

### Other

| Path | What it is |
|------|------------|
| [`AGENTS.md`](AGENTS.md) | Invariants for humans and coding agents |
| [`templates/`](templates/README.md) | SAD Word template — copy out; do not overwrite |
| [`docs/customer-kb/`](docs/customer-kb/README.md) | How to resolve the second KB |
| [`docs/ci-templates/`](docs/ci-templates/README.md) | Example CI for **service** repos |
| [`docs/architecture/deployment/`](docs/architecture/deployment/aws-production-deployment.md) | AWS production narrative |
| [`docs/superpowers/`](docs/superpowers/specs/2026-08-19-dev-kickoff-infra-request-and-multirepo-design.md) | Specs / plans (working notes) |
