# FuseForge support scope

This document records tested experimental scope, not a hosted-service SLA or a
claim that the complete calendar workflow is available.

## Implemented coordinator scope

- request context, intent, required-track, stack, and topology selection gate;
- read-only specialist doctor and explicit missing-only bootstrap;
- exact-path greenfield monorepo or three-work-target workspace setup;
- product-semantics shared contract `rev-1` and local continuity state;
- Design-only specialist delegation, result validation, stale handling, and
  approval-gated `rev-2` policy.

## Harness evidence

| Harness | Invocation | Evidence |
|---|---|---|
| Claude Code | `/fuseforge:craft …` | Live activation passed |
| Codex CLI | `Use FuseForge craft: …` | Static packaging and routing passed; live activation unproven |
| Cursor Agent | `Use FuseForge craft: …` | Live activation and isolated workspace behavior passed |

The activation response is:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

## Specialist and stack scope

FuseForge offers only capabilities observed in compatible loaded specialist
packs. Current families are:

- Compforge: TypeScript + React with Vite or Next.js;
- OOPforge: Java Spring or Python FastAPI.

FuseForge does not silently choose stacks and does not offer planned specialist
capabilities.

## Not currently implemented

- FuseForge Consult behavior;
- connected frontend-client-to-backend verification;
- calendar frontend or backend application source;
- production deployment;
- live Codex activation evidence;
- automatic updates or repair of existing specialist installations;
- a general-purpose multi-agent runtime.

See
[coordinator Test evidence](../verification/coordinator-test-2026-08-27.md)
for the approved evidence boundary.
