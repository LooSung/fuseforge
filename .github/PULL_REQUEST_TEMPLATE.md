## What this PR does

One sentence.

## Type of change

- [ ] Coordination policy clarification
- [ ] Harness adapter or packaging
- [ ] Setup script or diagnosis
- [ ] Repository check or CI
- [ ] Documentation or governance
- [ ] Bug fix
- [ ] Other:

## Stage and scope

- [ ] This does not implement an unapproved stage or vertical slice
- [ ] No calendar application source is added
- [ ] No specialist frontend or backend methodology is duplicated
- [ ] No dependency, external service, or agent runtime is introduced
- [ ] Approved stage records under `docs/planning/` are unchanged, or the
      change is a maintainer-approved correction

## FuseForge checklist

- [ ] The change carries one decision
- [ ] Cross-stack meaning still has a single source of truth
- [ ] Policy files stay ≤200 lines and remain registered in
      `skills/stability.json`
- [ ] Adapters route to canonical policy instead of copying it
- [ ] Harness and support claims match `docs/reference/support-scope.md` and the
      evidence in `docs/verification/`
- [ ] No credential, private path, or generated artifact is committed
- [ ] User-visible completed work is recorded under `CHANGELOG.md` →
      `Unreleased`

## Evidence

State which level each result belongs to and do not merge them.

- [ ] `bash scripts/ci/lint-skills.sh`
- [ ] `python3 scripts/ci/test-doc-links.py`
- [ ] `python3 scripts/ci/check-release-readiness.py`
- [ ] `python3 scripts/ci/check-selection-gate.py`
- [ ] `python3 scripts/ci/check-workspace-contract.py`
- [ ] `python3 scripts/ci/check-delegation-barrier.py`
- [ ] `bash scripts/ci/bootstrap-smoke.sh`
- [ ] `shellcheck`, if a shell script changed
- [ ] Live activation probe, if a load path changed

Harnesses exercised live:

Harnesses not exercised, and why:

## Related issue

Closes #

## Notes for reviewers

Risks, trade-offs, or claims that need a second look. See
[`docs/reference/reviewer-checklist.md`](../docs/reference/reviewer-checklist.md).
