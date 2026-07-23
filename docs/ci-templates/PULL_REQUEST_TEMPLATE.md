<!-- Title: conventional prefix — feat: / fix: / chore: / docs: / refactor: (content: only if this repo holds content JSON) -->

## What & why

<!-- One or two lines. Link the issue: Closes #N -->

## How to verify

<!-- What should the reviewer run or check? -->

## Checklist

- [ ] Base branch is **`staging`** (never `main`) — Proposed for platform repos (ADR-016)
- [ ] If this repo holds content JSON: this PR is **either** content **or** code — not both (ADR-016)
- [ ] Ran locally: lint · typecheck · test · build (commands per repo README)
- [ ] No secrets committed; build/runtime config uses approved secret store / GHA secrets
