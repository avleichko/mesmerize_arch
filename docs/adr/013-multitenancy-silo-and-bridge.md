# ADR-013: Dual-mode multitenancy (Silo DB vs Bridge + S3 folders)

- **Status:** Accepted
- **Date:** 2026-07-23
- **Decisions:** Tenant = Organization; clinic/site = sub-scope; two storage modes supported
- **Sources:** Architecture brainstorming (Approach 1); reference multitenancy patterns (Silo vs Bridge); Mesmerize `Organization` / `clinicId` / `deviceGroupId` model; zero-PHI ADRs

## Context

The platform must isolate customer data across healthcare organizations while allowing clinics/sites inside an org. Reference architectures use either dedicated DBs per tenant (Silo) or a shared DB with a tenant discriminator (Bridge), plus per-tenant object storage isolation.

## Decision

1. **Tenant boundary:** `tenantId` = **`organizationId`**.  
2. **Sub-scope:** `clinicId` / `deviceGroupId` nest **inside** a tenant (not a separate tenancy mode).  
3. **Two supported modes** (configurable per Organization, e.g. `tenancyMode: silo | bridge`):

| Mode | Database | Object storage (S3) |
|------|----------|---------------------|
| **Silo (isolated DB)** | Dedicated Postgres/Aurora **per Organization** | Org-dedicated bucket **or** org root prefix; paths `{tenantId}/{clinicId}/…` |
| **Bridge (shared DB)** | Shared Postgres/Aurora; **`tenantId` column** on all tenant-owned tables; every query scoped by `tenantId` | Shared bucket; **isolated folders** `{tenantId}/{clinicId}/…` |

4. **Default for SOW #3 / pilot:** **Bridge** (shared DB + `tenantId` + S3 folders).  
5. **Silo** available when an Organization requires stronger physical isolation.  
6. Async messages (SQS) **must** carry `tenantId` (and `clinicId` when relevant).  
7. No cross-tenant access in either mode. Still **no patient identifiers** on Mesmerize servers ([ADR-002](002-zero-phi-on-mesmerize-servers.md)).

## Consequences

- Data-access / “data service” layer resolves connection + S3 prefix from org tenancy config (aligned with Core → SQS → microservice → data access pattern).  
- Bridge mode requires mandatory tenant filters in ORM/repositories (fail closed).  
- Silo mode requires provisioning automation (DB + secrets + migrations per org).  
- Agents must not assume a single global schema without `tenantId` (Bridge) or without org DB routing (Silo).  
- Diagrams: `output_diagrams/08-multitenancy-overview.puml`, `09-multitenancy-silo.puml`, `10-multitenancy-bridge.puml`.
