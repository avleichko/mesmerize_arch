# C4 Container-Focus Diagrams (06a–06h) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans. **Tasks 1–8 may run in parallel**; Task 9 runs after PNGs exist.

**Goal:** Eight C4 container-focus PlantUML diagrams (`06a`–`06h`) plus Chapter 08 subsections (purpose, relations table, figure, prose), catalog README, and COVERAGE update.

**Architecture:** Each diagram isolates one NestJS service from `06-c4-containers` with all Confirmed neighbors plus tagged `[Inferred]` edges from ADRs/ARCHITECTURE. Ch.08 embeds Figures 8-3…8-10 after the full-container interaction summary.

**Tech Stack:** PlantUML C4 (`C4_Container.puml`), OpenJDK + `.tools/plantuml.jar`, Markdown SAD.

**Spec:** `docs/superpowers/specs/2026-07-23-c4-container-focus-diagrams-design.md`

## Global Constraints

- Catalog IDs `06a`…`06h` only (do not renumber parent `06`).
- PlantUML C4 source + rendered PNG; mirror under `output_docs/output_diagrams/`.
- Confirmed = edges on `06`; Inferred = tag `[Inferred]` and cite in ch.08 table.
- No invented REST route catalogs, SLOs, Region; no EHR token on Mesmerize APIs; no Netlify/TTV for NestJS.
- ads-service marked optional in prose.
- Commit only if the user explicitly requested commits.

## Render command (all diagram tasks)

```bash
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
java -jar .tools/plantuml.jar -tpng -o "$(pwd)/output_diagrams" output_diagrams/<stem>.puml
# Requires network for C4-PlantUML include; use unrestricted sandbox if needed
cp -f output_diagrams/<stem>.{puml,png} output_docs/output_diagrams/
# Verify PNG is not an error page (typically > 20KB)
```

---

### Task 1: `06a` session-service

**Files:** Create `output_diagrams/06a-c4-focus-session-service.{puml,png}` + mirror

- [ ] PlantUML with subject + Gateway, Postgres, SQS; Inferred SMART→Gateway
- [ ] Render + mirror + size check

### Task 2: `06b` content-service

**Files:** `06b-c4-focus-content-service.{puml,png}`

- [ ] Neighbors: Gateway, Postgres, S3, SQS, Sanity, BioDigital, MJH; Inferred SMART recommend
- [ ] Render + mirror

### Task 3: `06c` device-realtime-service

**Files:** `06c-c4-focus-device-realtime-service.{puml,png}`

- [ ] Neighbors: Gateway, Device PWA Socket.io, Postgres, Redis, SQS, Esper; Inferred SMART commands (ADR-007)
- [ ] Render + mirror

### Task 4: `06d` engagement-service

**Files:** `06d-c4-focus-engagement-service.{puml,png}`

- [ ] Neighbors: Gateway, SQS consume, Postgres; Inferred timeline reads (ADR-008)
- [ ] Render + mirror

### Task 5: `06e` billing-evidence-service

**Files:** `06e-c4-focus-billing-evidence-service.{puml,png}`

- [ ] Neighbors: Gateway, SQS, Postgres; Inferred SMART approve + browser→EHR writeback note (ADR-003)
- [ ] Render + mirror

### Task 6: `06f` org-identity-service

**Files:** `06f-c4-focus-org-identity-service.{puml,png}`

- [ ] Neighbors: Gateway, Postgres, Auth0; Inferred Command Center path
- [ ] Render + mirror

### Task 7: `06g` audit-telemetry-service

**Files:** `06g-c4-focus-audit-telemetry-service.{puml,png}`

- [ ] Neighbors: SQS consume; Inferred S3 diagnostic path; no Gateway on `06`
- [ ] Render + mirror

### Task 8: `06h` ads-service

**Files:** `06h-c4-focus-ads-service.{puml,png}`

- [ ] Neighbors: Gateway, Postgres, S3; optional-path note
- [ ] Render + mirror

---

### Task 9: Chapter 08 + catalog + COVERAGE

**Files:**
- Modify: `output_docs/sad/chapters/08-system-architecture.md`
- Modify: `output_diagrams/README.md` (+ `output_docs/output_diagrams/README.md` mirror)
- Modify: `output_docs/sad/COVERAGE.md` (ch.08 required diagrams include `06a`–`06h`)

- [ ] Insert `### Container focus diagrams` with eight subsections (purpose, relations table, figure 8-3…8-10, ownership prose)
- [ ] Evidence links to `06a`–`06h`
- [ ] README catalog rows
- [ ] Verify:

```bash
ls output_diagrams/06[a-h]-*.png | wc -l   # 8
rg -n "Container focus|06a-c4-focus" output_docs/sad/chapters/08-system-architecture.md
```

- [ ] Commit only if requested

## Spec coverage

| Spec item | Task |
|-----------|------|
| Eight focus diagrams | 1–8 |
| Ch.08 subsections + prose | 9 |
| Catalog + COVERAGE | 9 |
| Inferred tagged / cited | 1–9 |
| Parallel diagrams | 1–8 parallelizable |
