# Imaging in-scope SAD chapters + ADR-019 — design

- **Date:** 2026-08-19
- **Status:** Draft for user review (brainstorming gate)
- **Sources:** `kb/`; `customer-kb/INFRASTRUCTURE.md` (device transport still **open** there); `customer-kb/docs/prebuild-proposal/08-*.md` and `09-*.md` (**inputs, not outline**); ADR-002/003/005/007/008/011; user choices: in-scope (B), Tier 1+2 (B), HITL writeback (A), approach 1, ADR rewrite not delete, **each new chapter embeds ≥1 diagram**

## Goal

Bring **exam-room imaging display + imaging evidence** into the Content Evidence SAD **as delivery architecture**, rewritten to this pack’s vision (zero PHI on Mesmerize servers; browser-held FHIR token; server-mediated devices; no Mesmerize DICOM viewer). Do **not** paste prebuild 08/09. Supersede ADR-009; rewrite DNB-9 and related “out of SOW imaging” wording. Add SAD **Ch.19** (evidence pointer) and **Ch.20** (architecture), each with PlantUML+PNG.

## Non-goals (this change set)

- Implementing WebRTC, FHIR imaging reads, or device UX
- Closing customer `D-xx` conflicts (Region, multi-repo, blue-green, per-tenant container) except where imaging text must not contradict them
- Building Epic/Cerner/eCW write-back adapters, Observation/Provenance, eCW HL7, Cornerstone/OHIF
- Inventing numeric SLOs, Region, or CIDR

## Decisions (locked)

| ID | Choice |
|----|--------|
| Scope | Imaging **in scope** for athena pilot delivery |
| Transport v1 | **Tier 1** web-native artifact push + **Tier 2** window/tab-scoped WebRTC mirror |
| Evidence | De-identified Platform event + physician HITL + browser **DocumentReference** |
| DICOM | **No** Mesmerize viewer; **no** WADO-RS ingest; **no** `ImagingStudy` as v1 path |
| Media / PHI | No pixels, DICOM, or patient identifiers on Mesmerize servers; P2P or clinician-browser fetch only |
| Mediation | SMART never talks to devices; Device Command API + signaling only for WebRTC |
| ADR files | **Rewrite/supersede**, do not delete |

## ADR-019 (new)

**Title:** Exam-room imaging display and imaging evidence (supersedes ADR-009)

**Decision:**

1. Tier 1: SMART (EHR token in browser) reads web-native US Core artifacts (DiagnosticReport presentedForm, DocumentReference files, Media, Observation/lab reports as PDF/HTML/JPEG/PNG/structured). Platform gets opaque session + deviceGroup + artifact **kind/opaque id** — not Patient ID, not payload. Device Command API instructs the exam-room PWA to display. Device does not use a **server-held** EHR token.
2. Tier 2: Provider shares **only** EHR/PACS viewer window/tab. WebRTC **media P2P** (clinician browser ↔ device). Platform **signaling only**. Full-desktop share is forbidden.
3. Evidence: `imaging_session` (name TBD in implementation, not Patient-linked) on Platform: timestamps, device id, session id, tier (1|2), artifact type or `mirror` flag. HITL approve then browser DocumentReference.write (existing write scope).
4. Forbidden: Mesmerize DICOM parser/viewer, ImagingStudy/WADO pipeline, storing imaging bytes in RDS/S3, logging PHI, SMART↔device data channel.

**Supersedes:** ADR-009 (out of SOW).  
**Amends:** ADR-011 DNB-9; ADR-005 (additive **read** scopes for Tier 1 artifacts — list explicitly in 019/005; still no ImagingStudy); decision register #20.

## ADR / NFR / chapter rewrites (no deletes)

| Artifact | Change |
|----------|--------|
| ADR-009 | Status **Superseded by ADR-019**; historical SOW exclusion preserved as context; live rule = no DICOM viewer/WADO ingest |
| ADR-011 DNB-9 | **No Mesmerize DICOM viewer / no server-side DICOM payloads**; imaging display + HITL evidence allowed |
| ADR-005 | Add v1 reads needed for Tier 1; keep EHR launch / 3-legged; no imaging **write** beyond DocumentReference |
| ADR README #20 + DNB-9 row | Point at 019 |
| NFR-PERF-02 | Remove “out of SOW”; qualitative display/mirror concern; no invented latency SLO |
| NFR-INT | Add INT row: imaging display is server-mediated; token stays in browser |
| NFR-SEC-01/02 | Unchanged; mention imaging payloads forbidden on servers |
| ASR checklist | Add imaging zero-payload / no-viewer bullets if they are ASRs |
| Ch.01, 02, 06 | Remove “imaging out of SOW”; in-scope Tier 1+2; roadmap four-EHR write-back |
| Ch.03 | Index ADR-019, Ch.19–20 |
| Ch.07 | Happy path optional imaging steps; still HITL |
| Ch.08 | Device-realtime signaling; no webrtc media on API |
| Ch.09 | Allowed imaging **metadata** vs forbidden payloads |
| Ch.10 | getDisplayMedia scoping; P2P |
| Ch.12 | Signaling vs SQS (signaling not SQS hot path) |
| Ch.14 | PERF-02 + new INT |
| Ch.15 / GLOSSARY | Patient Imaging Mirror = in-scope Tier 1+2; DICOM viewer = DNB |
| Ch.18 | Q-rows for imaging FHIR scope ratification / Confluence vs SAD if needed; drop “imaging OOS” unknowns |
| AGENTS.md invariants | Imaging allowed per 019; still no DICOM viewer; still no PHI on servers |
| ARCHITECTURE.md / PROJECT_CONTEXT / ENGINEERING_RULES / TESTING | Align; TESTING still bans **DICOM viewer** and real PHI fixtures, not all imaging |
| COVERAGE / PROGRESS / SAD README | Ch.19–20; diagrams 23–24 |
| `docs/ai/CURRENT_STATE.md` | Imaging no longer “out of SOW”; still not implemented |

Do **not** remove ADR-001–008, 010–018.

## SAD Ch.19 — Imaging-Mirror Evidence Addendum (pointer)

**File:** `output_docs/sad/chapters/19-imaging-mirror-evidence-addendum.md`  
**Template-like spine:** Purpose, Narrative (taxonomy, capture vs write-back), Diagram, Evidence, White spots, Open questions → Ch.18 IDs.

**Content rules:**

- Restate **our** model: Platform de-identified store is SoR; missing EHR write-back never drops evidence; HITL DocumentReference for athena v1.
- Confluence MESENG addendum + prebuild 08 = **pointers / provenance**, not competing outline.
- MESV2-213…217 = traceability; **v1 does not commit** to Observation/Provenance or eCW HL7.
- Capture universal; **write-back adapters beyond athena DocumentReference = roadmap**.

**Required diagram (catalog 23):** `output_diagrams/23-imaging-evidence-capture-writeback.{puml,png}`  
**Figure 19-1:** Clinician SMART → (FHIR in browser) / Platform (de-identified imaging_session) → HITL → DocumentReference to athena. Label **no pixels on Platform**. Evidence tags C/I/P.

## SAD Ch.20 — Exam-Room Imaging Mirror architecture

**File:** `output_docs/sad/chapters/20-exam-room-imaging-mirror.md`

**Content rules (rewrite of prebuild 09):**

- Five data types table; DICOM is minority and **not rendered by us**
- Invariants P1–P4 mapped to ADR-002/007/019 (thin device, no DICOM lib, zero PHI servers, non-diagnostic)
- Tier 1 sequence (command metadata only)
- Tier 2 sequence (scoped capture, P2P, signaling via Platform)
- Tier 3 Cornerstone = **rejected / do-not-build**
- Errors: unpaired device, signaling drop, wrong-window share, HITL reject — **never** retry pixels onto S3
- Testing: synthetic PDFs/JPEGs; no real PHI

**Required diagram (catalog 24):** `output_diagrams/24-imaging-mirror-transport.{puml,png}`  
**Figure 20-1:** C4-style: SMART, Platform (signaling + device command), exam-room PWA, athena FHIR (browser-only), WebRTC P2P dashed, **no** DICOM viewer box as a Mesmerize component (optional crossed-out “rejected”).  
**Second figure required in Ch.20 (catalog 25):** `output_diagrams/25-imaging-tier1-tier2-sequence.{puml,png}`  
**Figure 20-2:** Two swimlanes or two short sequences — Tier 1 push vs Tier 2 mirror — so the chapter is not a single overloaded box diagram.

Render with existing PlantUML jar + OpenJDK; mirror PNG/PUML under `output_docs/output_diagrams/`. Update both diagram READMEs.

## kb / customer-kb

- Re-analyze `kb/` Q&A imaging notes and prebuild 08/09 when filling chapters.
- Cite `customer-kb` prebuild as **non-settled input**; `INFRASTRUCTURE.md` device transport remains **open** — Ch.20 must say WebRTC/Socket.io signaling is **this pack’s Proposed/Confirmed per ADR-019**, not a customer `D-xx`.
- Do not treat Confluence as the SAD outline.

## Evidence tagging

Tier 1+2 in-scope + no DICOM viewer = **Confirmed** via ADR-019 (after ADR is written). Four-EHR write-back tiering = **Proposed/roadmap**. Exact FHIR read scope strings = **Proposed** until athena sandbox ratification (Ch.18 Q).

## Implementation order (for later plan)

1. ADR-019 + rewrite 009/011/005/README  
2. Diagrams 23, 24, 25 + catalog  
3. Ch.19 then Ch.20  
4. Ripple SAD + NFR + agent docs + COVERAGE  
5. Mirror `output_docs/`

## Spec self-review

- No TBD except implementation event name (`imaging_session`) — allowed as “name in code TBD; concept Confirmed”
- No contradiction: in-scope vs no DICOM viewer vs zero PHI
- Scope = docs/ADR/NFR/diagrams only
- Each of Ch.19 and Ch.20 has diagram(s) as specified
