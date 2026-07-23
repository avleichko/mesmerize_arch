# Multitenancy design — Mesmerize Content Evidence Platform

**Date:** 2026-07-23  
**Status:** Accepted (ADR-013)  
**Related:** `docs/adr/013-multitenancy-silo-and-bridge.md`

## Summary

Dual-mode multitenancy:

- **Tenant** = Organization (`tenantId` = `organizationId`)
- **Sub-scope** = clinic/site (`clinicId` / `deviceGroupId`)
- **Silo:** isolated DB per org + org-isolated S3
- **Bridge:** shared DB + `tenantId` column + S3 folders `{tenantId}/{clinicId}/…`
- **Pilot default:** Bridge

## Diagrams

- `output_diagrams/08-multitenancy-overview.puml`
- `output_diagrams/09-multitenancy-silo.puml`
- `output_diagrams/10-multitenancy-bridge.puml`

## Out of scope for this decision

- Changing PHI boundary
- Per-patient tenancy
- SFTP ingestion (reference diagrams only; Mesmerize uses S3 folders)
