# FuseForge — Implementation Slice 14 Plan

- Status: Capability approved 2026-11-25 by the maintainer, in the same request
  as slice 13, with Discovery through release authorized.
- Amends: Design §4.1 again. Slices 11 and 12 recorded that `refactor` stays a
  specialist workflow reached only through Crucible's stage 5; this slice adds
  a standalone `refactor` command for existing code in both tracks.

## Product-language outcome

A developer can ask once to clean up code that spans the frontend and the
backend, have each side cleaned by its own pack's rules, and know that the
API between the two sides did not move.

## Observed

- `/compforge:refactor` and `/oopforge:refactor` preserve behavior, take one
  decision per branch, need tests or reproduction scenarios before and after,
  and split any behavior change into Craft. Compforge fills a job contract
  before code; OOPforge writes a refactor plan.
- `delegation.md` already holds Refactor delegation and its rejection rules,
  but only for Crucible: it assumes an approved `rev-2` and a passing
  connected check.
- An existing repository usually has no FuseForge workspace or shared contract,
  and attaching two existing repositories is not implemented.

## Decisions

- Split by work target as Review does; a one-track request stops and names
  `/compforge:refactor` or `/oopforge:refactor`. A behavior change is not a
  refactor and goes to Craft.
- Freeze the wire surface first: the routes, request and response shapes,
  status codes, error shapes, and frontend calls between the tracks. A shared
  contract's current revision is the surface when one exists; otherwise list
  it from code with lines.
- One mandatory stop before any edit: the write root per track, each track's
  job contract in its own pack's terms, the frozen surface, and the test
  commands each track runs before and after.
- Each track then runs its own pack's `workflow/refactor.md` inside its write
  root only, one track after the other (a fresh agent per track where the
  harness has them).
- Reuse `delegation.md`'s Refactor rejection rules, with the frozen surface
  standing in for the contract. A rejected result is never reported as done.
- A recorded connected check becomes stale; the report never claims connected
  proof. No commit unless the user asks.

## Scope

- `skills/workflow/refactor.md`, `commands/refactor.md`, routing and
  description in `skills/SKILL.md`, one paragraph in `delegation.md`, the
  registry, packaging checks, `scripts/ci/check-refactor.py`, setup docs,
  README, methodology, support scope.

## Out of scope

- Changing Crucible's stage 5.
- A FuseForge copy of either specialist's refactor rules.
- Attaching two existing repositories as one coordinator flow.

## Verification

Every check in `docs/reference/release-process.md`, each new assertion proven
to fail when its rule is removed, and one live Claude Code run on a scratch
full-stack repository to the approval stop, with write tools denied. Pass
criteria are fixed before the run.
