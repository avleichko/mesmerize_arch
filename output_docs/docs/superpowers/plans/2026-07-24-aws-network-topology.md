# AWS Network Topology Diagrams (21–22) + Chapter 13 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add PlantUML network topology (21) and SG-tier (22) diagrams with PNGs, and extend SAD Chapter 13 with a Network topology section (prose + figures + SG table).

**Architecture:** Dual-diagram pack; keep 17/18 unchanged. Evidence tags [C]/[I]/[P]/[U]. SG allow paths are Proposed only. Ladder A only (no Netlify/TTV).

**Tech Stack:** PlantUML C4 Deployment (same pattern as `18-aws-production-deployment.puml`), OpenJDK + `.tools/plantuml.jar`.

**Spec:** `docs/superpowers/specs/2026-07-24-aws-network-topology-design.md`

## Global Constraints

- Catalog IDs: `21-aws-network-topology`, `22-aws-security-group-tiers` only.
- Do **not** invent Confirmed CIDR, Region, RTO/RPO, or live SG rule dumps.
- SG matrix rows = **Proposed** until Terraform/security sign-off.
- Do **not** show Netlify or TTV on these diagrams.
- Do **not** modify diagrams 17/18.
- Mirror PNGs/PUMLs under `output_docs/output_diagrams/`.
- Commit only if the user explicitly requested commits this session; otherwise skip commit steps.

## File map

| Path | Responsibility |
|------|----------------|
| `output_diagrams/21-aws-network-topology.{puml,png}` | VPC/subnet/traffic plane |
| `output_diagrams/22-aws-security-group-tiers.{puml,png}` | Logical SG tiers |
| `output_docs/output_diagrams/21-*`, `22-*` | Export mirrors |
| `output_diagrams/README.md` (+ mirror) | Catalog rows |
| `output_docs/sad/chapters/13-deployment-and-infrastructure.md` | Network topology section |
| `output_docs/sad/COVERAGE.md` | Ch.13 required diagrams |

**Render command (all diagram tasks):**

```bash
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
java -jar .tools/plantuml.jar -tpng -o "$(pwd)/output_diagrams" output_diagrams/21-aws-network-topology.puml
java -jar .tools/plantuml.jar -tpng -o "$(pwd)/output_diagrams" output_diagrams/22-aws-security-group-tiers.puml
# Rename outputs to exact stems if @startuml id differs
cp -f output_diagrams/21-aws-network-topology.png output_diagrams/21-aws-network-topology.puml output_docs/output_diagrams/
cp -f output_diagrams/22-aws-security-group-tiers.png output_diagrams/22-aws-security-group-tiers.puml output_docs/output_diagrams/
file output_diagrams/21-aws-network-topology.png output_diagrams/22-aws-security-group-tiers.png
```

---

### Task 1: PlantUML diagram 21 — network topology + PNG

**Files:**
- Create: `output_diagrams/21-aws-network-topology.puml`
- Create: `output_diagrams/21-aws-network-topology.png`
- Mirror under `output_docs/output_diagrams/`

**Interfaces:**
- Produces: Figure asset for Ch.13

- [ ] **Step 1: Write PlantUML** using C4_Deployment include (copy style from `18-aws-production-deployment.puml`). Required content from spec:
  - Edge: Route 53 [P], CloudFront [C], WAF [P], clients
  - VPC Multi-AZ [I], CIDR [U]
  - Public: ALB [C], NAT [I]
  - Private app: ECS services [C]
  - Private data: RDS [C], Redis [C]
  - VPC endpoints [P/I]: S3 gateway, SQS/ECR/Secrets/KMS interface
  - S3 media regional [C]; egress via NAT to athena/Auth0/Esper/CMS/SMS [C] outside VPC
  - Legend [C]/[I]/[P]/[U]; **no** Netlify/TTV

- [ ] **Step 2: Render + mirror** using Global Constraints render command for diagram 21.

- [ ] **Step 3: Verify** PNG is a real image (`file` shows PNG, dimensions reasonable), not an error page.

- [ ] **Step 4: Commit (only if requested)** `docs(diagrams): add AWS network topology 21`

---

### Task 2: PlantUML diagram 22 — SG tiers + PNG

**Files:**
- Create: `output_diagrams/22-aws-security-group-tiers.puml`
- Create: `output_diagrams/22-aws-security-group-tiers.png`
- Mirror under `output_docs/output_diagrams/`

- [ ] **Step 1: Write PlantUML** showing logical tiers as containers/nodes and **Proposed** Rel arrows:
  - Internet → Edge/WAF :443 [P]
  - → sg-alb :443 [P]
  - sg-alb → sg-ecs : TG ports [P]
  - sg-ecs → sg-data :5432, :6379 [P]
  - sg-ecs → sg-vpce :443 [P]
  - Note: sg-data no Internet [I]; deny-by-default [P]
  - Title must say Proposed allow paths; no invented AWS SG IDs

- [ ] **Step 2: Render + mirror.**

- [ ] **Step 3: Verify** PNG OK.

- [ ] **Step 4: Commit (only if requested)** `docs(diagrams): add AWS SG tier diagram 22`

---

### Task 3: Catalog README rows

**Files:**
- Modify: `output_diagrams/README.md`
- Modify: `output_docs/output_diagrams/README.md` (keep identical rows)

- [ ] **Step 1: Add rows** for 21 and 22 after the 18/20 entries (match existing table style).

- [ ] **Step 2: Verify** `rg -n "21-aws-network|22-aws-security" output_diagrams/README.md output_docs/output_diagrams/README.md`

- [ ] **Step 3: Commit (only if requested)** `docs(diagrams): catalog network topology 21/22`

---

### Task 4: Chapter 13 — Network topology section

**Files:**
- Modify: `output_docs/sad/chapters/13-deployment-and-infrastructure.md`

- [ ] **Step 1: Insert section** after **### Ingress** (before **### Compute**) titled `### Network topology` (or `## Network topology` if sibling structure prefers H2 — match chapter’s existing `###` pattern under Narrative).

Content must include:
1. Short purpose: DevOps network plane for Ladder A; tags; no invented CIDR/Region.  
2. Embed `../../output_diagrams/21-aws-network-topology.png` + caption (Figure 13-3 or next free number — if 13-1/13-2 already used in Diagrams section, use 13-3/13-4 in Network section **or** add figures in Diagrams section as 13-3/13-4 and reference from Network prose). Prefer: add Network subsection with embeds, and also list figures under `## Diagrams` as 13-3 and 13-4 for consistency.  
3. Embed `22-aws-security-group-tiers.png` + caption.  
4. SG summary Markdown table (tiers from spec).  
5. Callouts: Inferred Multi-AZ/NAT; Proposed WAF/R53/endpoints/SG matrix; Unknown CIDR + pointer to [Chapter 18](18-assumptions-and-open-questions.md) **Q-07**.

- [ ] **Step 2: Update `## Diagrams`** to include Figures 13-3 and 13-4 (21 and 22) after 13-1/13-2.

- [ ] **Step 3: Update Evidence** with links to `21`/`22` puml/png.

- [ ] **Step 4: White spots** — ensure CIDR called out as Unknown (may already be covered by Region Unknown; add CIDR explicitly if missing).

- [ ] **Step 5: Verify**

```bash
rg -n "21-aws-network|22-aws-security|Network topology|Q-07" output_docs/sad/chapters/13-deployment-and-infrastructure.md
rg -n "Netlify|TTV" output_docs/sad/chapters/13-deployment-and-infrastructure.md | head -5
# Network section must not newly claim Netlify for Ladder A (existing Ladder B row in mapping table is OK)
```

- [ ] **Step 6: Commit (only if requested)** `docs(sad): add network topology section to ch.13`

---

### Task 5: COVERAGE + pack check

**Files:**
- Modify: `output_docs/sad/COVERAGE.md` (ch.13 required diagrams row)

- [ ] **Step 1: Update** ch.13 checklist item for required diagrams to include `18` primary, `17` companion, **`21` network, `22` SG tiers**.

- [ ] **Step 2: Full verify**

```bash
ls output_diagrams/21-aws-network-topology.{puml,png} output_diagrams/22-aws-security-group-tiers.{puml,png}
ls output_docs/output_diagrams/21-aws-network-topology.{puml,png} output_docs/output_diagrams/22-aws-security-group-tiers.{puml,png}
rg -n "21-aws-network|22-aws-security" output_docs/sad/COVERAGE.md output_diagrams/README.md
```

- [ ] **Step 3: Commit (only if requested)** `docs(sad): cover network diagrams 21/22 in COVERAGE`

---

## Spec coverage (plan self-review)

| Spec requirement | Task |
|------------------|------|
| Diagram 21 puml+png | 1 |
| Diagram 22 puml+png | 2 |
| Catalog README | 3 |
| Ch.13 Network section + figures + SG table | 4 |
| COVERAGE | 5 |
| No invented CIDR/Region Confirmed; no Netlify on 21/22 | 1–2, Global Constraints |
| Commit only if requested | All |
