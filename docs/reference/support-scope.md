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

Both have been exercised once, end to end, on Cursor Agent with Compforge 1.3.1
and OOPforge 1.4.2: calendar Slice 1 was built by delegated specialists and the
real frontend client was proven against a running backend. See
[calendar Slice 1](../verification/calendar-slice-1-2026-08-27.md).

That is one slice of one product with one stack pair. It is evidence that the
flow works, not a guarantee for other stacks, harnesses, or later slices.

## Classification stability

A request that does not say whether its data must outlive the browser leaves the
backend track unresolved, and the selection gate asks. Measured on Claude Code
over eight runs of one request, the gate asked in 8 of 8, against 3 of 8 at
`v0.2.0`. See
[track classification](../verification/track-classification-2026-08-27.md).

Eight runs are a distribution, not a guarantee, and only one phrasing on one
harness was measured. Context, intent, and topology classification have not been
measured this way.

## Installation

`scripts/setup/install.sh` installs FuseForge into Claude Code, Codex CLI, and
Cursor Agent, and `scripts/setup/uninstall.sh` removes it. Both were exercised on
2026-08-27 in a throwaway `HOME` across nineteen cases and once live, including
an activation probe and a return to the prior state. Evidence:
[self-install](../verification/self-install-2026-08-27.md).

The installer creates four symlinks and writes nothing else. It never replaces a
path that is not a symlink, and never replaces a symlink owned by another
checkout without `--force`. `uninstall.sh` removes only links pointing at its own
checkout and never deletes a pack source.

`scripts/setup/bootstrap.sh` installs the *specialist* packs. In Compforge and
OOPforge that filename is the self-install entry point, so the habit transfers to
the wrong action; FuseForge itself is `install.sh`.

Not covered: Windows, a package registry, and updating or repairing a specialist
pack that is already installed.

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
- calendar slices 2 through 6;
- browser-driven end-to-end coverage;
- calendar application source inside this pack, which is by design;
- production deployment;
- automatic updates or repair of existing specialist installations;
- a general-purpose multi-agent runtime.

See
[released-flow acceptance](../verification/released-flow-acceptance-2026-08-27.md)
for the current evidence boundary and
[coordinator Test evidence](../verification/coordinator-test-2026-08-27.md)
for the approved checkpoint it re-verified.
