# FuseForge — Implementation Slice 9

- Status: Implemented; statically verified
- Date: 2026-08-27
- Plan: [implementation-slice-9-plan.md](implementation-slice-9-plan.md)
- Evidence: [consult](../../verification/consult-2026-08-27.md)

## Outcome

`/fuseforge:consult` is experimental advisory behavior. A developer can ask a
coordination question, compare coordinator choices, review shared-contract
alignment, or write one explicitly requested planning document, without that
request becoming permission to implement.

It was the last Skeleton-only public entry point. Design and Delivery Plan
phase 1 item 1 already named it; this slice gives it the sibling four-mode
shape, scoped to coordination rather than frontend or backend methodology.

## Implemented boundaries

- four modes: `document`, `review`, `proposal`, `answer`; comparison is always
  Proposal;
- response starts with `Mode: <token> | Write permission: <none|one document>`;
- write permission is none except one planning document after explicit document
  wording;
- silent track, stack, and topology choices stay in Craft;
- a purely frontend or backend question names the specialist Consult and stops;
- an unreadable `consult.md` stops the turn;
- Consult does not create a shared contract, workspace, or `.craft/fuseforge/`
  state.

## Empty skeleton registry

Promoting Consult emptied `skills/stability.json`'s skeleton list. The
packaging check required SKILL.md to name a Skeleton interface, which would
have forced a false claim. The check now requires that claim only when skeleton
entries remain.

`check-selection-gate.py` required Consult to stay Skeleton. That assertion
became intentionally false and was removed rather than left to pass vacuously.

## Changed files

See the write scope in the [plan](implementation-slice-9-plan.md). Canonical
policy, routing, checks, and support documentation moved together.

## Evidence

Recorded in [consult-2026-08-27.md](../../verification/consult-2026-08-27.md).

Static checks passed. Six injected violations were rejected. The Consult probe
returned the three documented lines on Claude Code, Codex CLI, and Cursor
Agent. A live comparison on Codex loaded `consult.md`, started with
`Mode: proposal`, and wrote nothing.

## Observed follow-up

Non-interactive `claude -p` still cannot read `~/.claude/skills/` without
`--add-dir`. A real Consult question then stops rather than improvising, which
is the unread-policy rule working. With the grant, Claude selected Proposal
and wrote nothing, but spoke before the Mode header.

Codex CLI and Cursor Agent Craft activation probes also passed against the
current skill-directory install. Slice 8 had probed only Claude Code after
installing.

## Not in this slice

Calendar Slice 2, the three unexercised phase 3 coordinator scenarios, and
re-measuring track classification across harnesses remain later candidates.
A live install on a non-macOS machine was not attempted; isolated
`install-smoke.sh` already runs on GitHub Actions `ubuntu-latest`.
