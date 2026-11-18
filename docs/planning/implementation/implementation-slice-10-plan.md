# FuseForge — Implementation Slice 10 Plan

- Status: Approved 2026-11-18
- Input: an operator's report of one FuseForge run that joined two existing
  repositories behind an authenticated backend, and the maintainer's approval to
  close the gaps that the policy text itself left open

## Product-language outcome

A developer coordinating a feature can trust three things that the run showed
were missing or contradictory:

1. a three-work-target workspace gets the right write roots during Implement;
2. a backend that requires sign-in still gets a connected check, or an honest
   `blocked — credentials` record instead of a silent substitute;
3. specialist Design asks about the names users and other systems will see, not
   about every internal class and hook.

## Observed in the policy text

- `delegation.md` assigned Implement write roots under
  `<coordination-root>/frontend/` and `<coordination-root>/backend/`. That holds
  only for a monorepo. The three-work-target layout in `logical-workspace.md`
  puts the targets beside the coordination root.
- `logical-workspace.md` named the topology `polyrepo` in its table and
  "three-work-target" everywhere else.
- `shared-contract.md` deferred authentication to `rev-2`, but
  `connected-verification.md` never said how the check obtains a credential.
- `stage-barrier.md` already let the parent resolve meaning-preserving technical
  names, while both specialists require "the user's own word" for a structure.

## Reported by the operator, not reproduced here

- The run could not get a sign-in token, skipped the named check, and
  substituted a browser E2E run, which the policy places outside the connected
  check.
- The run asked the user about 39 names; most answers were "as recommended".

## Hypothesis

The specialists' "user's own word" rule drove the name questions. No other
policy text asks for name approval. A later run should count the questions to
confirm or refute this.

## Scope

- Implement write roots come from `frontend_target` and `backend_target`.
- One topology name in the workspace table.
- `rev-2` names a connected-check credential source for authenticated
  operations; an unavailable credential is recorded as blocked; browser E2E stays
  supplementary; a user-accepted gap is recorded as accepted, never complete.
- Design delegation splits public names (asked) from internal names (defaulted
  and listed).
- Static assertions for each rule.

## Out of scope

- Attaching existing repositories as a coordinator flow. The run decided the
  contract location and a per-track `rev-2` approval ad hoc; one more run on a
  different pair of existing repositories comes before those become rules.
- Cost measurement. Wall time and token use are now asked for by the specialist
  proof templates; FuseForge has no proof template yet.
- `craft.md`, which is at the 200-line skill limit.

## Verification

Run every check in `docs/reference/release-process.md`. Each new assertion must
fail when its rule is removed.
