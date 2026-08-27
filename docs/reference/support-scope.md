# FuseForge support scope

This document records tested experimental scope, not a hosted-service SLA or a
claim that the complete calendar workflow is available.

## Implemented coordinator scope

- request context, intent, required-track, stack, and topology selection gate;
- read-only specialist doctor and explicit missing-only bootstrap;
- exact-path greenfield monorepo or three-work-target workspace setup;
- product-semantics shared contract `rev-1` and local continuity state;
- Design-only specialist delegation, result validation, stale handling, and
  approval-gated `rev-2` policy;
- Implement-stage delegation policy for calendar Slice 1, covering write roots,
  dependency ownership, result validation, and partial-completion reporting;
- parent-owned connected-verification policy, covering the real client and HTTP
  adapter boundary, backend lifecycle, evidence record, and the rule that a
  slice is incomplete without a passing recorded check.

Implement delegation and connected verification are defined and statically
verified. Neither has been exercised against a live specialist or a running
backend, and no calendar application source exists. Treat both as policy, not as
demonstrated behavior.

## Harness evidence

Support requires the skill-directory install in
[setup/install.md](../setup/install.md).

| Harness | Invocation | Evidence |
|---|---|---|
| Claude Code | `/fuseforge:craft …` | Live activation and the full coordinator flow passed |
| Codex CLI | `Use FuseForge craft: …` | Live activation passed |
| Cursor Agent | `Use FuseForge craft: …` | Live activation and isolated workspace behavior passed |

The activation response is:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

`cursor-agent --plugin-dir` is not a supported install path; it does not load
the skill. A FuseForge checkout outside `$HOME` is also unsupported because the
canonical workflow files then become unreadable.

## Specialist and stack scope

FuseForge offers only capabilities observed in compatible loaded specialist
packs. Current families are:

- Compforge: TypeScript + React with Vite or Next.js;
- OOPforge: Java Spring or Python FastAPI.

FuseForge does not silently choose stacks and does not offer planned specialist
capabilities.

## Not currently implemented

- FuseForge Consult behavior;
- any executed connected frontend-client-to-backend check;
- calendar frontend or backend application source;
- production deployment;
- automatic updates or repair of existing specialist installations;
- a general-purpose multi-agent runtime.

See
[released-flow acceptance](../verification/released-flow-acceptance-2026-08-27.md)
for the current evidence boundary and
[coordinator Test evidence](../verification/coordinator-test-2026-08-27.md)
for the approved checkpoint it re-verified.
