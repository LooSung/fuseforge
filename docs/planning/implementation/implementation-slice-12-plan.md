# FuseForge — Implementation Slice 12 Plan

- Status: Approved 2026-11-19 by the maintainer, in the same request as slice 11.
  The maintainer confirmed the stop design under Decisions, including the plan
  standing in for the Implement approval, the same day.
- Amends: Design §4.1, as recorded in slice 11. Crucible is a FuseForge command;
  it delegates the specialists' Refactor and Test workflows rather than adding
  `refactor` or `test` commands.

## Product-language outcome

A developer can ask once for one full-stack slice to go from plan to built,
cleaned-up, tested, and connected code, approving only the decisions that need
them.

## Decisions

- Order: selection gate and workspace, plan, Design, Build with the connected
  check, Refactor when earned, Test, and a connected recheck when source changed.
- Stops kept: the selection gate and path confirmation while they are open, the
  plan approval, and the `rev-2` approval. Crucible adds no new stop and removes
  none of FuseForge's.
- The approved plan is the approval past the integrated Implement checkpoint,
  and only when that barrier is fully ready and the connected check passed. This
  is the one change to `stage-barrier.md`.
- The plan lives at `<coordination-root>/docs/features/<feature-slug>/plan.md`
  and is the delivery plan that Implement delegation copies verbatim.
- Refactor runs only when the plan expected it or a specialist reported a smell;
  FuseForge never decides one from its own reading of the code.
- The specialists' own `workflow/refactor.md` and `workflow/test.md` are
  delegated, never their crucible.

## Scope

- `skills/workflow/crucible.md`, `commands/crucible.md`, routing in
  `skills/SKILL.md`, Refactor and Test delegation in `delegation.md`, one
  paragraph in `stage-barrier.md`, the registry, packaging checks, and
  `scripts/ci/check-crucible.py`.

## Out of scope

- Changing `craft.md`, which is at the 200-line limit.
- Parallel tracks beyond what `delegation.md` already allows.
- Existing-repository coordination, which stays unimplemented.

## Verification

Every check in `docs/reference/release-process.md`, each new assertion proven to
fail when its rule is removed, and one live Claude Code run to the first stop.
