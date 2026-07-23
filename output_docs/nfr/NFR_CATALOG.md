# Non-Functional Requirements (NFR) Catalog

> **Sources:** Jul 14 2026 functional/non-functional meeting notes; SOW #3; Architecture / Strategy / Implementation Context; Mesmerize Q&A; ADRs 001–016.  
> **Rule:** Do not invent numeric SLOs not present in kb. Items without kb metrics are marked **Open** or **Target (qualitative)**.  
> **ASR** = Architecturally Significant Requirement (drives structure, boundaries, or technology choices).

Agent mirror: [`docs/ai/NFR.md`](../../docs/ai/NFR.md). ASR checklist: [`ASR_CHECKLIST.md`](ASR_CHECKLIST.md).

## Legend

| Column | Meaning |
|--------|---------|
| ID | Stable NFR id |
| ASR? | **Yes** = architecturally significant |
| Priority | Must / Should / Could (MoSCoW for delivery) |
| Status | Confirmed (kb/ADR) / Aligned (doc) / Open (needs Mesmerize confirm) |
| Category | Quality attribute |

---

## NFR table

| ID | ASR? | Priority | Category | Requirement | Rationale / notes | Status | Traceability |
|----|------|----------|----------|-------------|-------------------|--------|--------------|
| NFR-SEC-01 | **Yes** | Must | Security / Privacy | **Zero patient identifiers on Mesmerize servers.** Backend may store ICD-10 + device/clinic/session + engagement only. | Core product & compliance posture | Confirmed | ADR-002, ASR |
| NFR-SEC-02 | **Yes** | Must | Security / Privacy | **EHR FHIR access token never leaves the browser.** Platform API uses a separate Mesmerize session token. | Prevents server-side EHR credential handling | Confirmed | ADR-002, ADR-005, DNB-8 |
| NFR-SEC-03 | **Yes** | Must | Security / Privacy | **No ambient audio, transcripts, or clinical notes** stored or processed by Mesmerize. | Content Evidence pivot; liability | Confirmed | ADR-001, ADR-011 |
| NFR-SEC-04 | **Yes** | Must | Security / Compliance | **HIPAA-aligned AWS** posture; minimize PHI handling. BAAs: Auth0 + SMS/email required; AWS possibly not if de-identified. | SOW + architecture BAA table | Confirmed (AWS BAA Open) | SECURITY.md |
| NFR-SEC-05 | **Yes** | Must | Security | **OWASP hardening** + **penetration test** in SOW Phase 3. | Contractual hardening | Confirmed | SOW Phase 3 |
| NFR-SEC-06 | Should | Should | Security | HTTPS everywhere for SMART hosting; CORS allow EHR domains; iframe embedding allowed for Athena. | SMART hosting requirements | Confirmed | Implementation Context |
| NFR-SEC-07 | **Yes** | Must | Security / Isolation | **No cross-tenant access.** Tenant = Organization; clinic = sub-scope. | Multitenancy | Confirmed | ADR-013 |
| NFR-SEC-08 | Should | Should | Security | Diagnostic/audit logs must **exclude PII/PHI**. | Jul 14 logging | Confirmed | SECURITY.md |
| NFR-REL-01 | **Yes** | Must | Reliability | **Retry with exponential backoff** for failed transactions (device/command/engagement delivery). Configurable; avoid unbounded retry scope creep. | Jul 14 aligned decision | Confirmed | ENGINEERING_RULES, TESTING |
| NFR-REL-02 | **Yes** | Must | Reliability | Engagement / proof-of-play must be **durable**: store proof and retry until acknowledged (within product retry policy). | Jul 14 reliability discussion | Confirmed (qualitative) | tech F/NFR notes |
| NFR-REL-03 | Should | Should | Reliability | Device **heartbeat** + email alerts for failures; admin correction UI **deferred**. | Jul 14 | Confirmed | SECURITY.md |
| NFR-REL-04 | Should | Should | Availability | Design for availability/reliability of device↔cloud path (qualitative for pilot). **No numeric SLO in kb.** | Open for formal SLO | Open | Jul 14 |
| NFR-PERF-01 | Should | Should | Performance | SMART app usable in **EHR iframe** (~400–800px sidebar); no pop-up-dependent primary flows. | Clinician time pressure | Confirmed | Implementation Context |
| NFR-PERF-02 | Could | Could | Performance | Imaging/mirroring latency noted as concern — **out of SOW**; do not optimize as MVP NFR. | Jul 14 + ADR-009 | Confirmed OOS | ADR-009 |
| NFR-SCAL-01 | **Yes** | Should | Scalability | Architecture must support fleet scale (**~4,400** devices today; **1,000+ screens** proof for Jul 2027 planning). Prefer async SQS for non-interactive work. | Business + ops | Confirmed | Q&A, STRATEGY |
| NFR-SCAL-02 | Should | Should | Scalability | Dual tenancy modes (Bridge default, Silo when needed) without rewriting domain APIs. | ADR-013 | Confirmed | ADR-013 |
| NFR-UX-01 | **Yes** | Must | Usability / A11y | Clinical UI meets **WCAG 2.1 AA** (SOW Phase 2). | Contractual | Confirmed | SOW Phase 2 |
| NFR-UX-02 | **Yes** | Must | Usability / Branding | **White-labeling** (customer branding/CSS) is a **hard requirement**. Must not break iframe/CSP security. | Jul 14 | Confirmed | ENGINEERING_RULES |
| NFR-UX-03 | Should | Should | Usability | SMART app responsive for provider desktop/tablet; device kiosk is a separate surface. | Q&A | Confirmed | PROJECT_CONTEXT |
| NFR-UX-04 | Must | Must | Scope / Context | Product is **ambulatory / outpatient only** — not inpatient or surgical. | Jul 14 | Confirmed | ENGINEERING_RULES |
| NFR-OPS-01 | **Yes** | Must | Observability | Separate **engagement** telemetry from **diagnostic** logs. | Jul 14 | Confirmed | SECURITY.md |
| NFR-OPS-02 | **Yes** | Must | Observability | Diagnostic log **retention ≤ 90 days** (then tiering/expiry per ops). Engagement/business logs may use a **different** retention (Open — confirm with Brandon/MM). | Jul 14 | Confirmed (diag 90d); Open (engagement years) | SECURITY.md |
| NFR-OPS-03 | Should | Should | Observability | Diagnostic path: **Kinesis + S3** table buckets (as aligned). Monitoring: Mesmerize-approved / Datadog reference. | Jul 14 + ADR-010 | Confirmed direction | ADR-010 |
| NFR-OPS-04 | Should | Should | Observability | Video ad telemetry baseline: **VAST**. | Jul 14 | Confirmed | GLOSSARY |
| NFR-OPS-05 | Should | Should | Operability | Environments: **Dev / Staging / Prod**; Staging PHI-free vs Athena sandbox; Prod gated to pilot. | Q&A | Confirmed | ENGINEERING_RULES |
| NFR-OPS-06 | Should | Should | Maintainability | **Ladder A (platform):** CI/CD via **GitHub Actions**; IaC **Terraform**; Mesmerize-owned AWS (ECR → ECS). Deploy strategy (blue/green, canary, etc.) **Unknown**. | ADR-010, ADR-016 | Confirmed (CI/IaC); Unknown (deploy strategy) | ADR-010, ADR-016 |
| NFR-OPS-07 | Should | Should | Operability | **Ladder B (device/PWA):** Netlify branch preview ≠ device path; TelemetryTV (TTV) filesync **human-triggered**; merge to `staging` = QA/canary devices; promote `staging → main` = production fleet. Do not apply Netlify/TTV to NestJS/ECS. | touchscreen-ux DEPLOYMENT; ADR-016 | Confirmed (PWA) | ADR-007, ADR-016 |
| NFR-INT-01 | **Yes** | Must | Interoperability | SMART on FHIR **3-legged Authorization Code Grant**; EHR launch only; Athena pilot first. | ADR-005 | Confirmed | ADR-005 |
| NFR-INT-02 | **Yes** | Must | Interoperability | Device commands **server-mediated** (REST + Socket.io); no direct SMART↔device app channel. | ADR-007 | Confirmed | ADR-007 |
| NFR-INT-04 | **Yes** | Must | Interoperability | Internal messaging: SQS **Request/Reply + Correlation ID** (per-target reply queues), **Fire-and-forget** for async, **Content Enricher + DLQ** for failures; edge remains REST. | ADR-014 | Confirmed | ADR-014 |
| NFR-INT-03 | Should | Should | Interoperability | EHR-agnostic core so Epic/Cerner can be added without core rewrite. | SOW Phase 1 / ADR-004 | Confirmed | ADR-004 |
| NFR-DATA-01 | **Yes** | Must | Data integrity | UUID-based content/engagement tracking; engagement events complete (start/duration/completion). | Jul 14 + UC7 | Confirmed | ADR-008 |
| NFR-DATA-02 | **Yes** | Must | Data isolation | S3 object paths tenant-isolated: `{tenantId}/{clinicId}/…` (Bridge) or org-isolated root/bucket (Silo). | ADR-013 | Confirmed | ADR-013 |
| NFR-DATA-03 | Should | Should | Auditability | Separate **audit telemetry log** (not only EHR writeback). Billing export CSV/JSON. | Q&A / SOW | Confirmed | ADR-008 |
| NFR-BUS-01 | Must | Must | Business constraint | Billing engine **suggests** only — **no claim / EDI submission**. | ADR-008, DNB-7 | Confirmed | ADR-011 |
| NFR-BUS-02 | Must | Must | Business constraint | Physician **human-in-the-loop** before writeback; writeback disable-able per customer. | SOW / ADR-003 | Confirmed | ADR-003 |
| NFR-BUS-03 | Should | Should | Localization | Clinician SMART UI may be **English-only** for pilot; exam-room content already multi-language. | Q&A | Confirmed | Q&A |

---

## Architecturally Significant Requirements (ASR summary)

These NFRs **must** shape architecture and are binding for agents:

| ASR ID | Statement |
|--------|-----------|
| NFR-SEC-01 | Zero PHI identifiers on Mesmerize servers |
| NFR-SEC-02 | FHIR token browser-only |
| NFR-SEC-03 | No ambient audio/notes path |
| NFR-SEC-04 | HIPAA-aligned cloud / BAA posture |
| NFR-SEC-05 | OWASP + pen test (Phase 3) |
| NFR-SEC-07 | Strict tenant isolation (Organization tenant) |
| NFR-REL-01 | Exponential backoff retries |
| NFR-REL-02 | Durable engagement proof delivery |
| NFR-SCAL-01 | Fleet / screen-volume scale readiness |
| NFR-UX-01 | WCAG 2.1 AA clinical UI |
| NFR-UX-02 | White-label hard requirement |
| NFR-OPS-01 | Split engagement vs diagnostic logging |
| NFR-OPS-02 | Diagnostic retention ≤ 90 days |
| NFR-INT-01 | SMART 3-legged EHR launch (Athena) |
| NFR-INT-02 | Server-mediated device realtime |
| NFR-INT-04 | SQS RR + correlation / fire-and-forget / enricher+DLQ (ADR-014) |
| NFR-DATA-01 | UUID engagement integrity |
| NFR-DATA-02 | Tenant-isolated S3 layout |
| NFR-DATA-03 | Separate audit telemetry |

---

## Open items (do not invent)

| Topic | Action |
|-------|--------|
| Numeric availability / latency SLOs | Confirm with Mesmerize (none fixed in kb) |
| Engagement / business log retention (e.g. 3 years discussed) | Confirm with Brandon / MM |
| AWS BAA necessity | Compliance owner |
| Formal observability toolchain | AM / Mesmerize-approved pack |
| Platform (Ladder A) deploy strategy; Region; RTO/RPO | Open — do not invent; see ADR-016 |

---

## Conflict check vs existing rules

| Area | Result |
|------|--------|
| ADRs 001–016 | **Aligned** — NFRs formalize existing decisions |
| AGENTS hard invariants | **Aligned** — map to NFR-SEC-01/02/03, INT-02, BUS-01/02 |
| ENGINEERING_RULES (iframe, WCAG, ambulatory, white-label, backoff) | **Aligned** |
| SECURITY (90d diag logs, VAST, BAAs) | **Aligned** |
| Multitenancy ADR-013 | **Aligned** with NFR-SEC-07, DATA-02, SCAL-02 |
| Messaging ADR-014 | **Aligned** with NFR-REL-01/02, INT-02/04; edge REST preserved for iframe latency |
| Imaging performance | **No conflict** — marked OOS (NFR-PERF-02) |

If a future change conflicts with an **ASR** NFR, update this catalog + add/supersede an ADR before coding.
