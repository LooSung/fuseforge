# FuseForge reviewer checklist

Use this checklist for coordinator policy and evidence, not for specialist
frontend or backend architecture.

## Contract authority

- [ ] Cross-stack meaning has one tracked shared contract.
- [ ] Local `.craft/fuseforge/` state contains progress and paths, not duplicate
      product semantics.
- [ ] Only the parent changes contract revisions.
- [ ] Wire proposals remain non-authoritative until user approval.

## Ownership and scope

- [ ] Compforge and OOPforge methodology remains in specialist packs.
- [ ] Delegated write roots are explicit and non-overlapping.
- [ ] Application source is absent unless its vertical slice was approved.
- [ ] Existing installations and unrelated files are preserved.

## Results and barriers

- [ ] Required tracks use the same current contract revision.
- [ ] Missing, failed, cancelled, decision-required, stale, or drifting results
      keep the barrier closed.
- [ ] A failed track retry preserves valid unrelated evidence.
- [ ] Observable conflicts return to the user in product language.

## Evidence and claims

- [ ] Static, isolated, and live evidence are distinguished.
- [ ] Authentication failures are not reported as packaging failures.
- [ ] Unverified harnesses and future slices are not described as supported.
- [ ] Connected verification is claimed only after a real frontend client calls
      a running backend.
