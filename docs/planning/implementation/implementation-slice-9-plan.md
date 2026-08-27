# FuseForge — Implementation Slice 9 Plan

- Status: Approved 2026-08-27
- Input: maintainer request to proceed with the recorded `/fuseforge:consult`
  candidate in `.craft/next-session-prompt.md`

## Product-language outcome

A developer can ask FuseForge a coordination question, compare coordinator
choices, review shared-contract alignment, or write one planning document,
without that request becoming permission to implement.

Today `/fuseforge:consult` is the last Skeleton-only public entry point. Craft
classifies and coordinates; Consult was promised in Design and Delivery Plan
phase 1 item 1 and never given behavior. A reader who follows the documented
Consult command is told the interface exists and then that nothing will run.

## Why this is the next coordinator slice

The remaining candidates in the session prompt are not one slice:

- re-measuring classification on other harnesses;
- three unexercised phase 3 coordinator scenarios;
- calendar Slice 2 on an existing project;
- Consult.

Consult is the unimplemented product intent already in the approved Design. The
others are later proofs against existing Craft behavior. This slice implements
Consult and uses the live turn to close the post-install activation-probe gap
that slice 8 left on Codex CLI and Cursor Agent.

Out of this slice:

- calendar Slice 2;
- phase 3 mismatch, stale-retry, and resume scenarios;
- re-measuring track classification across eight runs per harness;
- specialist frontend or backend methodology;
- a live install on a non-macOS machine.

Isolated `install-smoke.sh` already runs on GitHub Actions `ubuntu-latest`. The
macOS-only record is the live round trip, not the isolated suite. This slice
does not claim a live Linux or Windows install.

## Scope

In scope:

- canonical Consult policy in `skills/workflow/consult.md`;
- Claude command routing in `commands/consult.md`;
- SKILL.md and Cursor wrapper routing for Consult requests;
- moving `workflow/consult.md` from skeleton to implemented;
- a Consult activation probe that does not require the rest of Craft;
- static checks that replace the slice-1 assertion that Consult stay Skeleton;
- documentation that Consult is experimental advisory behavior, not a Craft
  substitute;
- live Consult probe on at least one harness;
- live Craft activation probes on Codex CLI and Cursor Agent against the
  current skill-directory install, which slice 8 did only for Claude Code.

Out of scope:

- creating product source, contracts, or `.craft/fuseforge/` from Consult;
- settling a silent track, stack, or topology;
- delegating specialist Implement or impersonating Compforge or OOPforge
  Consult;
- calendar behavior;
- a version bump or release.

## Consult contract

Consult follows the sibling four-mode shape, scoped to coordination:

| Mode | Trigger | Write permission |
|---|---|---|
| `document` | explicit write/save/document wording | one planning document |
| `review` | review, audit, inspect, or rule-check wording | none |
| `proposal` | alternatives, recommendation, comparison | none |
| `answer` | default advisory question | none |

Comparison is always `proposal`, even when phrased as a question. "Review and
fix" completes Review only.

FuseForge Consult answers cross-stack meaning, shared-contract alignment, track
ownership, stage barriers, and coordinator tradeoffs. A purely frontend
question names Compforge Consult and stops. A purely backend question names
OOPforge Consult and stops. A mixed question answers the coordination part and
names the specialist Consult for the rest.

The response begins with:

```text
Mode: <token> | Write permission: <none|one document>
```

Never emit Craft's `Assumptions` or `Selection Gate` from Consult. Never
reconstruct the workflow if `consult.md` cannot be read.

## Write scope

```text
skills/workflow/consult.md
skills/SKILL.md
skills/stability.json
commands/consult.md
.cursor-plugin/skills/fuseforge/SKILL.md
scripts/ci/check-consult.py
scripts/ci/check-selection-gate.py
scripts/ci/check-harness-packaging.py
.github/workflows/lint.yml
AGENTS.md
CLAUDE.md
README.md
README.ko.md
CHANGELOG.md
docs/setup/claude-code.md
docs/setup/codex.md
docs/setup/cursor.md
docs/reference/support-scope.md
docs/reference/release-process.md
docs/planning/implementation/implementation-slice-9*.md
docs/planning/implementation/README.md
docs/verification/consult-2026-08-27.md
docs/verification/README.md
docs/README.md
```

## Verification

Static:

- `consult.md` is experimental, not Skeleton, and under the 200-line cap;
- SKILL.md routes Consult and no longer calls it a Skeleton interface;
- the stability registry lists it as implemented and has an empty skeleton
  list;
- packaging still passes when no Skeleton entries remain;
- `check-selection-gate.py` no longer requires Consult to stay Skeleton.

Behavioral, injected:

- Skeleton status restored;
- implementation permitted;
- Mode header omitted;
- silent track/stack/topology settlement allowed;
- unbounded write permission;
- Consult left registered as skeleton.

Live:

- Consult probe on at least one harness returns the three documented lines;
- Craft activation on Codex CLI and Cursor Agent, which slice 8 did not probe
  after installing.

## Risks

- An empty skeleton registry is new. The packaging check currently requires
  SKILL.md to name a Skeleton interface. That assertion must be inverted when
  the list is empty, or the suite will demand a claim that is no longer true.
- Consult could become a back door into Craft. Mitigated by the prohibited
  list and by refusing to switch mode when the user asked Consult.
- A specialist-owned question answered here would duplicate methodology.
  Mitigated by the coordinator-versus-specialist stop.

## Checkpoint

The slice is complete when the static checks pass, the injected violations are
rejected, a live Consult probe is recorded, and the Codex and Cursor Craft
activation results are recorded as pass or blocked rather than inferred from
`doctor.sh`.
