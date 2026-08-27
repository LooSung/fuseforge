# FuseForge — Implementation Slice 5

- Status: Implemented; statically verified
- Date: 2026-08-27
- Input: Approved `implementation-slice-5-plan.md`

## Outcome

FuseForge now defines Implement-stage delegation for calendar Slice 1. It
requires `rev-2`, assigns one work target per track inside the user's product
workspace, gives dependency installation to the owning specialist, validates
extended result envelopes, and refuses to present a half-built feature as
working.

No calendar application source was created, and no dependency was installed.
This slice delivers coordinator policy and its check, as its plan approved.

## Implemented boundaries

- `rev-2` required before Implement delegation; earlier revisions are stale;
- activation-first delegation, unchanged from Design;
- one work-target write root per track, with the coordination root, shared
  contract, and `docs/features/` parent-owned;
- Slice 1 inclusions and exclusions carried in the delegation prompt, with an
  excluded capability reportable as `scope_drift`;
- dependency installation confined to the owning target, with database servers,
  containers, and external services forbidden;
- `dependencies_added` added to the result envelope;
- a result rejected for writing outside its target even when its code is
  correct;
- partial completion reported as a feature that does not work end to end, with
  retry limited to the failed track;
- connected verification explicitly unclaimed.

## Changed files

```text
skills/SKILL.md
skills/workflow/craft.md
skills/coordination/delegation.md
skills/coordination/stage-barrier.md
.cursor-plugin/skills/fuseforge/SKILL.md
scripts/ci/check-implement-delegation.py
.github/workflows/lint.yml
docs/reference/release-process.md
docs/reference/support-scope.md
```

`skills/stability.json` was not changed. The Implement policy lives in
`delegation.md` and `stage-barrier.md`, which were already registered as
implemented, so no new policy file was needed.

## Evidence

```text
FuseForge implement-delegation checks passed
FuseForge delegation-barrier checks passed
FuseForge workspace-contract checks passed
FuseForge selection-gate checks passed
FuseForge bootstrap smoke checks passed
PASS release readiness metadata for 0.1.1
```

Repository lint, documentation links, shell syntax, and shellcheck also pass.

`check-implement-delegation.py` asserts the revision, activation, write-root,
scope, dependency, envelope, barrier, and partial-completion rules, confirms that
`connected-verification.md` is still registered as Skeleton, and fails if calendar
source appears inside the pack.

### Negative tests

A check that only ever passes proves nothing, so four violations were injected
and reverted. Each was rejected with the expected message:

| Injected violation | Result |
|---|---|
| `rev-2` requirement removed from the Implement delegation | `missing: shared contract reached rev-2` |
| Partial-completion heading weakened in the barrier | `missing: ### Partial completion is not success` |
| `connected-verification.md` relabelled as implemented | `must remain Skeleton-only in this slice` |
| `backend/main.py` created inside the pack | `calendar source must not live in the pack` |

The working tree was restored after each test and the full suite passes again.

### Not verified

Live specialist Implement generation was not run. It is real product work that
belongs to the calendar slice execution, so this slice is statically and
policy verified only. `docs/reference/support-scope.md` states this limit.

## Observed constraint for slice 6

`skills/workflow/craft.md` is now 196 lines against the 200-line cap enforced by
`check-harness-packaging.py`. Four lines of headroom remain, so slice 6 cannot
add a Test-delegation section to `craft.md` in the same style.

Slice 6 must either compress `craft.md` or add the
`skills/coordination/implement.md` style policy file that the slice 5 plan
approved as a fallback, registering it in `skills/stability.json`. This is a
structural decision for the slice 6 plan, not an incidental edit.

## Checkpoint

Awaiting maintainer review. This slice does not authorize calendar product
source; that requires separate approval at stage 3.
