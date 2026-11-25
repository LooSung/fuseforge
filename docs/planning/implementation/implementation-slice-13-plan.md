# FuseForge — Implementation Slice 13 Plan

- Status: Capability approved 2026-11-25 by the maintainer, who asked for a
  full-stack review and refactor that use each specialist's own rules, and
  authorized Discovery through release. Review ships first; refactor is
  slice 14.
- Amends: Design §4.1 again (slices 11 and 12 brought it to four commands).
  Slice 11 recorded that `refactor` and `test` stay specialist workflows; this
  slice adds `review`, and slice 14 revisits `refactor`.

## Product-language outcome

A developer can ask once for a review of a change that touches both the
frontend and the backend, and get one report: frontend findings by Compforge's
rules, backend findings by OOPforge's rules, and the places where the two
halves disagree — instead of running two reviews and comparing them by hand.

## Observed

- `/compforge:review` and `/oopforge:review` resolve one target (pull request,
  branch, pasted diff, or working tree), record a base commit, report P1–P3
  findings with a `Next` section, and never change code. Each names the other
  track's files in one line and points to the other pack.
- Unlike the Jira templates, the two `review.md` files differ: checks,
  severity examples, tools, and `Next` commands are pack-specific. One file
  cannot stand in for the other.
- Both read rules outside the linked skill directory (`{pack}/AGENTS.md`,
  `{pack}/docs/reference/reviewer-checklist.md`, `{pack}/scripts/ci/`).
- FuseForge Consult's Review mode is chosen by wording ("review", "audit") and
  reviews shared-contract alignment, ownership, and stage barriers. It has no
  rule for a finished diff.
- Neither specialist review can see a mismatch between the two halves: a
  backend response field that changed while the frontend still reads the old
  one is correct in each half alone.

## Decisions

- One target, resolved once with the specialists' order; one base commit.
  The changed files are split by work target: frontend, backend, and neither.
  Work targets come from `.craft/fuseforge/` state when it exists, otherwise
  from the repository, stated in Assumptions. Ambiguous ownership is asked,
  not guessed.
- Each track runs its own pack's `workflow/review.md` on that track's files
  only — a fresh agent per track where the harness has them, otherwise one
  track after the other in this session. The path read is reported; an
  unreadable file stops that track and is listed, never reconstructed.
- The specialists' "other track → other pack" pointer is dropped, because
  FuseForge covers both tracks.
- FuseForge adds only cross-stack findings. With a shared contract, compare
  each changed operation with the contract revision. Without one, a finding
  needs both lines: the backend wire shape and the frontend code that reads or
  sends it.
- Specialist findings and `Next` lines are kept verbatim under their track.
  Cross-stack fixes name the specialist command for each side; Craft is not
  offered, because FuseForge Craft is greenfield-only.
- A single-track change stops and names `/compforge:review` or
  `/oopforge:review`.
- Consult keeps its Review mode for plans and contracts. A request to review a
  finished change goes to `/fuseforge:review`.
- Posting follows the specialist rule: only on an explicit request in this
  turn.

## Scope

- `skills/workflow/review.md`, `commands/review.md`, routing and description in
  `skills/SKILL.md`, the Consult boundary, the registry, packaging checks,
  `scripts/ci/check-review.py`, setup docs, README, methodology, support scope.

## Out of scope

- A FuseForge copy of either specialist's checks or severity table.
- Fixing anything; review writes nothing.
- Attaching two existing repositories as one coordinator flow.

## Verification

Every check in `docs/reference/release-process.md`, each new assertion proven to
fail when its rule is removed, and one live Claude Code run on a scratch
full-stack branch seeded with one finding per track, one cross-stack mismatch,
and one clean file. Pass criteria are fixed before the run.
