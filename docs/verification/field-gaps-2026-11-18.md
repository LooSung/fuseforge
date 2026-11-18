# Field gaps — 2026-11-18

Records slice 10: policy changes made after one operator-reported run that
joined two existing repositories behind an authenticated backend. The product,
its repositories, and its evidence are private and are not reproduced here.

## What the run reported

These are the operator's report, not reproduced here.

| Report | Policy before this slice |
|---|---|
| The connected check needed a sign-in token and never ran; browser E2E was used instead | No credential rule; browser E2E is outside the connected check |
| 39 name questions, mostly answered "as recommended" | Specialists ask for the user's word; the parent may resolve technical names |
| Contract location and per-track `rev-2` approval were decided ad hoc | Existing-repository attachment is deferred |

Under the policy at the time, that slice was not complete: its connected check
was blocked, not passed.

## Static verification

Run on macOS from the development checkout:

```text
python3 scripts/ci/check-delegation-barrier.py      passed
python3 scripts/ci/check-implement-delegation.py    passed
python3 scripts/ci/check-connected-verification.py  passed
```

Each new assertion was checked by removing its rule and observing the check
fail: `## Authenticated backends`, `### Names`, and the work-target write-root
sentence were each caught.

## Not verified

- No live coordinator run against an authenticated backend after this change.
- No measurement of how many name questions the new split asks.
- Existing-repository attachment, which this slice leaves deferred.
