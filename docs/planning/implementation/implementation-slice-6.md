# FuseForge — Implementation Slice 6

- Status: Implemented; statically verified
- Date: 2026-08-27
- Input: Approved `implementation-slice-6-plan.md`

## Outcome

FuseForge now owns a connected check that runs the real frontend API client
against a running backend. A product slice is incomplete until that check passed
and was recorded, so specialist tests alone can no longer make a feature look
finished.

`skills/coordination/connected-verification.md` moved from Skeleton to
implemented. No calendar source was created and no check was executed; that is
stage 3.

## Implemented boundaries

- the check must use the actual frontend transport client and the actual backend
  HTTP adapter, with mocks and re-implementations of either side rejected;
- it proves one accepted flow, the error meaning the frontend state depends on,
  timezone offset behavior, and the contract revision it ran against;
- OpenAPI-only validation, browser E2E, deployment, containers, and external
  services stay excluded;
- the frontend specialist writes the check in its own target; the parent starts
  the backend, runs that one named check, and writes the record;
- readiness is polled rather than slept, a readiness timeout is a failure, and
  teardown always runs;
- the record lives in the product workspace beside the contract, never in this
  pack;
- an unobserved outcome may not be recorded, and a blocked or failed check is
  recorded as blocked or failed;
- a slice is incomplete without a passing recorded check.

## Ownership conflict resolved

Slice 5 stated that FuseForge "runs no specialist test suite on a specialist's
behalf", while the approved Design makes connected verification parent-owned.
Read literally those conflicted, because the check is a test inside a
specialist's target.

The rule was narrowed rather than removed. It now reads that the parent runs no
specialist suite *to manufacture specialist evidence*, and names the single
commissioned connected check as the one parent-run exception. The specialist
still owns all test code; the parent owns orchestration and the evidence.

This keeps the coordinator out of product code, works in monorepo and polyrepo,
and lets the parent report only what it observed.

## Deferred decision now settled

The Delivery Plan left the connected-evidence location as "selected after
Skeleton". It is now:

```text
<coordination-root>/docs/features/<feature-slug>/connected-verification.md
```

The coordination root and `docs/features/` were already parent-owned, so no
ownership rule changed.

## Changed files

```text
skills/coordination/connected-verification.md
skills/coordination/stage-barrier.md
skills/coordination/delegation.md
skills/workflow/craft.md
skills/SKILL.md
skills/stability.json
.cursor-plugin/skills/fuseforge/SKILL.md
scripts/ci/check-connected-verification.py
scripts/ci/check-implement-delegation.py
.github/workflows/lint.yml
docs/reference/release-process.md
docs/reference/support-scope.md
```

`check-implement-delegation.py` changed because slice 5 asserted that connected
verification was Skeleton-only. That assertion became intentionally false, so it
was replaced by the slice 6 assertions rather than left to pass vacuously.

## Evidence

```text
FuseForge connected-verification checks passed
FuseForge implement-delegation checks passed
FuseForge delegation-barrier checks passed
FuseForge workspace-contract checks passed
FuseForge selection-gate checks passed
FuseForge bootstrap smoke checks passed
PASS release readiness metadata for 0.1.1
```

Repository lint, documentation links, shell syntax, and shellcheck also pass.

### Negative tests

Six violations were injected and reverted. Each was rejected:

| Injected violation | Result |
|---|---|
| Mocks allowed instead of the real boundary | `missing: never a re-implementation or a mock of either side` |
| Fixed sleep allowed instead of polled readiness | `missing: Poll for readiness rather than sleeping a fixed interval` |
| Recording an unobserved outcome permitted | `missing: Never record an outcome that was not observed` |
| Completion barrier removed | `missing: ## Slice completion barrier` |
| Policy left registered as skeleton | `must be registered as implemented` |
| Product evidence written inside the pack | `docs/features/ is a product-workspace path` |

The working tree was restored after each test and the full suite passes again.

### Not verified

No connected check has run. There is no calendar source to run it against, and
no backend to start. `docs/reference/support-scope.md` records that both
Implement delegation and connected verification are policy rather than
demonstrated behavior.

## Observed constraint

`skills/workflow/craft.md` is now 198 lines against the 200-line cap. Two lines
of headroom remain, so the next slice that needs `craft.md` routing must first
compress it or move routing detail into a coordination policy file. Section 3
carries the most compressible wording.

## Checkpoint

Awaiting maintainer review. Stage 3 executes slices 5 and 6 against a real
product workspace and requires separate approval.
