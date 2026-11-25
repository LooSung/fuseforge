# Refactor Workflow

Contents: When to use · Split by track · Freeze the wire surface · Approval stop · Run each track · Accept or reject · Report · Prohibited · Completion

Status: **Experimental**.

Clean up existing code in both tracks without changing behavior. Each track is
refactored by its own specialist's refactor rules; FuseForge keeps the wire
surface between the tracks fixed and adds one approval before any edit.
FuseForge itself writes no application source.

## When to use

Use when the request asks to restructure code on both the frontend and the
backend. A request for one track only stops and names `/compforge:refactor` or
`/oopforge:refactor` (Codex and Cursor: `Use Compforge refactor:` or
`Use OOPforge refactor:`). A request that changes behavior is not a refactor:
name the specialist Craft and stop. Inside a Crucible slice, Crucible's stage 5
governs instead.

## Split by track

Assign the request to work targets the way Review does: `.craft/fuseforge/`
state when it exists, otherwise the directories whose manifests show the
frontend and backend stacks, stated under `Assumptions`. Ask when ownership is
ambiguous.

For each track, read its own pack's refactor workflow and report which file
was read:

- frontend: the loaded Compforge skill's `workflow/refactor.md` — in a
  skill-directory install `~/.claude/skills/compforge/workflow/refactor.md`,
  `~/.codex/skills/compforge/workflow/refactor.md`, or the Cursor skill
  directory;
- backend: the loaded OOPforge skill's `workflow/refactor.md` at the same
  places.

If a track's refactor workflow cannot be read, stop, report the failed paths,
and point to `docs/setup/bootstrap.md`. Never reconstruct specialist rules from
memory.

## Freeze the wire surface

List what crosses between the tracks around the code in scope: routes, request
and response shapes, status codes, error shapes, and the frontend calls that
use them, each with its file and line. With a shared contract
(`docs/features/<slug>/contract.md`), its current revision is the frozen
surface. Nothing on this list may change during the refactor.

## Approval stop

Before any edit, show:

1. the write root for each track — its work target, nothing outside it;
2. each track's job contract in its own pack's terms: in scope, out of scope,
   behavior to preserve, and the one decision;
3. the frozen wire surface;
4. the test commands each track runs before and after.

**Stop and ask the user to approve.** This stop is mandatory, even when the
request said to proceed.

## Run each track

After approval, run each track as its own refactor — a fresh agent per track
where the harness has them, otherwise one track after the other in this
session — with stage `refactor`, its write root, its job contract, and the
frozen surface, as `coordination/delegation.md` describes. The track follows its
own pack's `workflow/refactor.md` and writes only inside its write root.

## Accept or reject

Reject a track result when it changes visible behavior, a public name, or the
frozen wire surface; lacks a passing test run before and after, with commands
and observed results; or carries feature work. A rejected result is never
reported as done: show what it changed and ask whether to discard it or turn
it into a separate Craft job.

A recorded connected check is stale once source changed. Say so; never claim
the halves were proven together.

## Report

Write in the user's language: the rule file read per track; each track's
decision, files changed, tests before and after, and whether it was accepted;
the frozen surface and whether it stayed unchanged; the connected check as
stale or not run; and `Next`: `/fuseforge:review` on the result.

## Prohibited

- Never edit before the approval stop.
- Never change the frozen wire surface, a public name, or visible behavior;
  split that into Craft.
- Never write outside a track's write root, or let one track edit the other.
- Never refactor one track by the other pack's rules, or copy a specialist rule.
- Never pick a refactor target from FuseForge's own reading of the code; the
  request and each track's job contract name it.
- Never claim a connected check after source changed.
- Never commit unless the user asked in this request.

## Completion

Report the write roots, the rule files read, per-track results and test
evidence, accepted or rejected status, the frozen surface check, the connected
check status, and the next command.
