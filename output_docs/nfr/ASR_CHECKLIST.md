# ASR checklist (Architecturally Significant NFRs)

Use in design reviews and before merging infrastructure/API boundary changes.

- [ ] **NFR-SEC-01** Zero patient identifiers on Mesmerize servers  
- [ ] **NFR-SEC-02** EHR FHIR token stays in browser  
- [ ] **NFR-SEC-03** No ambient audio / transcripts / clinical notes  
- [ ] **NFR-SEC-04** HIPAA-aligned AWS / BAA posture respected  
- [ ] **NFR-SEC-05** OWASP + pen-test path (Phase 3) not undermined  
- [ ] **NFR-SEC-07** No cross-tenant access (Organization = tenant)  
- [ ] **NFR-REL-01** Exponential backoff retries for failed transactions  
- [ ] **NFR-REL-02** Durable engagement / proof delivery  
- [ ] **NFR-SCAL-01** Design remains viable at fleet / 1,000+ screen scale  
- [ ] **NFR-UX-01** WCAG 2.1 AA for clinical UI  
- [ ] **NFR-UX-02** White-label supported without breaking iframe security  
- [ ] **NFR-OPS-01** Engagement vs diagnostic logs separated  
- [ ] **NFR-OPS-02** Diagnostic retention ≤ 90 days  
- [ ] **NFR-INT-01** SMART 3-legged EHR launch (Athena pilot)  
- [ ] **NFR-INT-02** Server-mediated device commands (Socket.io)  
- [ ] **NFR-INT-04** SQS patterns per ADR-014 (RR/correlation, fire-and-forget, enricher+DLQ; edge REST)  
- [ ] **NFR-DATA-01** UUID engagement integrity  
- [ ] **NFR-DATA-02** Tenant-isolated S3 paths  
- [ ] **NFR-DATA-03** Separate audit telemetry  

Full definitions: [NFR_CATALOG.md](NFR_CATALOG.md).
