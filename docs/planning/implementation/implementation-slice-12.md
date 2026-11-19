# FuseForge — Implementation Slice 12

- Status: Implemented; statically verified, live to the first stop on Claude Code
- Plan: [implementation-slice-12-plan.md](implementation-slice-12-plan.md)

## Result

`/fuseforge:crucible` runs one full-stack slice through the gate, a plan,
specialist Design and Implement, the connected check, specialist Refactor when
earned, specialist Test, and a connected recheck when source changed.

## Evidence

- `scripts/ci/check-crucible.py` passes. Each of its 23 pinned markers was
  removed, one at a time and with line breaks ignored, in a copy of the
  repository, and the check failed every time. The stage order, path order, and
  registry entry were mutated separately and also failed.
- The existing coordinator checks still pass after the `delegation.md` and
  `stage-barrier.md` additions.
- Live Claude Code 2.1.311, skill-directory install, `--tools Read`, in an empty
  directory, with a new calendar request that named no stack: Crucible returned
  `Assumptions` and a `Selection Gate` asking about persistence, both stacks, and
  topology, stopped there, created no file, and named the remaining order —
  workspace paths, plan approval, Design with `rev-2` approval, then build,
  refactor, and test.

## Not verified

- Any stage after the selection gate. No Crucible run has written a plan,
  delegated Design, Implement, Refactor, or Test, or run a connected check.
- Codex CLI and Cursor Agent: static checks only.
