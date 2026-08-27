# FuseForge — Implementation Slice 7

- Status: Implemented; statically and behaviorally verified
- Date: 2026-08-27
- Input: Approved `implementation-slice-7-plan.md`

## Outcome

When a request does not say whether the data must outlive the browser, FuseForge
now asks instead of deciding. Measured on a real harness, the backend track went
from being silently dropped in 5 of 8 runs to being asked in 8 of 8.

Two defects found during the reproduction were fixed in the same slice: a
self-contradicting `SKILL.md` shipped in `v0.2.0`, and the absence of any rule
for failing to read a required policy file.

## Implemented boundaries

- a track is settled only when the request states it or an existing project shows
  it, and silence is never a decision;
- an unresolved backend track is a selection-gate question offering browser-only
  storage or server-side storage, with the backend stack question conditional on
  the answer;
- the "do not ask" list applies only to work stated or observed to be
  frontend-only, never to a classification the agent just made itself;
- the response contract's gate template carries the unresolved track;
- an unreadable required policy file stops the turn, and no section of the
  response contract may be emitted without having read the policy that defines
  it;
- `SKILL.md` may not contradict `stability.json` about another file's status.

## Changed files

```text
skills/SKILL.md
skills/workflow/craft.md
.cursor-plugin/skills/fuseforge/SKILL.md
scripts/ci/check-harness-packaging.py
scripts/ci/check-selection-gate.py
scripts/ci/check-workspace-contract.py
docs/verification/track-classification-2026-08-27.md
docs/planning/implementation/implementation-slice-7-plan.md
docs/planning/implementation/implementation-slice-7.md
docs/planning/implementation/README.md
docs/reference/support-scope.md
CHANGELOG.md
```

`check-workspace-contract.py` was outside the plan's write scope. It was included
because compressing `craft.md` rewrapped a paragraph its assertions matched
across a line break, which is the same brittleness the slice was already fixing.

`skills/stability.json` was not changed. No policy file was added or promoted;
the classification rule belongs in the already-implemented `craft.md`.

## The 200-line cap forced a real decision

`craft.md` was at 198 of 200 lines, so the rule could not simply be appended.
Section 3 was compressed as the plan directed, and sections 6 through 9 gave up
further lines by joining paragraphs. The file is now 199 lines with every
approved rule intact.

Compression is where meaning is easiest to lose, so the existing assertions were
treated as the guard: the workspace-contract check failed on the reflow and was
read rather than weakened.

## Evidence

```text
FuseForge repository lint: OK JSON, PASS static harness packaging, OK doc links
FuseForge selection-gate checks passed
FuseForge workspace-contract checks passed
FuseForge delegation-barrier checks passed
FuseForge implement-delegation checks passed
FuseForge connected-verification checks passed
PASS release readiness metadata
```

Shell syntax, shellcheck, documentation links, and whitespace also pass.

### Behavioral evidence

Eight runs before and eight after, one request, separate empty directories
outside this repository. Full record in
[track classification](../../verification/track-classification-2026-08-27.md).

| Outcome | `v0.2.0` | After |
|---|---|---|
| Backend track asked | 3 of 8 | 8 of 8 |
| Backend track dropped without asking | 5 of 8 | 0 of 8 |

No run wrote a file. The measurement link into `~/.claude/skills/` was removed
afterward and the environment returned to its prior contents.

### Negative tests

Eleven violations were injected and reverted; each was rejected. The list is in
the verification record. The new packaging assertion rejects the exact
contradiction that shipped in `v0.2.0`.

The first attempt at these tests was invalid: restoring with
`git checkout -- skills/` reverted the uncommitted change under test, so five
cases failed for the wrong reason and were discarded. The rerun restores from a
copy outside Git and asserts the baseline passes before trusting a rejection.

### Not verified

- Only Claude Code was measured. Codex CLI and Cursor Agent read the same policy
  but were not re-run.
- Only one phrasing was measured. A request that implies persistence without
  stating it may still classify inconsistently.
- Eight runs are a distribution, not a guarantee.

## Observed, not fixed

- One post-fix run omitted the "no product files have been created" sentence
  while still writing nothing. The behavior held; the statement did not.
- Non-interactive Claude Code sessions cannot read the linked skill directory
  without an explicit grant. This is harness permission behavior, and the
  documented interactive install is unaffected, so it stays out of scope. The
  new stop rule means such a session now refuses instead of improvising.
- `craft.md` is at 199 of 200 lines. The next slice needing Craft routing must
  move detail into a coordination policy file; compression headroom is spent.

## Checkpoint

Awaiting maintainer review and a release decision. The fixed contradiction is
live in `v0.2.0`, so a patch release is the way a new user receives it.
