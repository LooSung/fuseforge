# FuseForge — Implementation Slice 6 Plan

- Status: Approved for implementation
- Date: 2026-08-27
- Approved: 2026-08-27
- Input: Approved `implementation-slice-5-plan.md` and `implementation-slice-5.md`
- Focus: Parent-owned connected verification for calendar Slice 1

## 1. User outcome

Given both tracks implemented against `rev-2`, FuseForge can prove:

> The real frontend API client called a running backend and observed the
> approved request, response, and error meaning.

It records that proof as durable evidence naming the contract revision, and it
refuses to claim a working feature without it.

## 2. Scope correction from the three-stage split

The split called this stage "Test delegation and connected verification". The
delegation half is not needed.

Approved Design section 11 makes connected verification **parent-owned**.
Specialist tests are specialist-owned and are already collected in the Implement
result envelope built in slice 5. If a specialist needs more tests, that is
another Implement delegation, not a new delegation type.

Slice 6 therefore adds one parent-owned check rather than a second delegation
interface.

## 3. What the check must do

From Design section 11 and Delivery Plan section 8.4, the check:

- uses the actual frontend transport/client boundary, not a re-implementation;
- uses the actual backend HTTP adapter;
- proves at least one accepted product flow;
- proves the error meaning the frontend state depends on;
- proves application-timezone offset behavior, because Slice 1 involves time;
- records the shared-contract revision;
- complements rather than replaces specialist tests.

OpenAPI validation alone does not satisfy it. Browser-driven E2E, deployment,
and production readiness stay out.

### Why no browser is needed

The real frontend API client is a module in the frontend target. The check
imports that module, points it at a running backend, and exercises it. That is
the actual client boundary, so the requirement is met without browser
automation, which the Design keeps outside scope.

## 4. Ownership — approved resolution

Slice 5 established that FuseForge writes no application source and does not run
a specialist suite on a specialist's behalf. Design says FuseForge *owns* the
connected check. Read literally those conflict, because the check is a test
living in a specialist's target.

Approved resolution:

- the **frontend specialist** creates the connected check in its own target,
  reading the backend base URL from the environment;
- the **parent** starts the backend, runs that one named check, and writes the
  evidence record.

The slice 5 rule is refined to say the parent runs no specialist suite *to
manufacture specialist evidence*. The single commissioned connected check is
parent-run by design and is stated as such.

Ownership stays clean: the specialist owns test code, the parent owns
orchestration and the evidence. This works in monorepo and polyrepo, keeps the
coordinator out of product code, and lets the parent report only what it
observed.

## 5. Slice boundary

### In scope

- turning `skills/coordination/connected-verification.md` from Skeleton into
  behavior;
- the connected-check contract: what is proven and what is recorded;
- backend process lifecycle owned by the parent;
- the evidence record format and location;
- the rule that a slice is not complete without a passing connected check;
- refusing to claim the check when it did not run;
- the `craft.md` size resolution carried over from slice 5.

### Out of scope

- creating calendar source or the connected check itself;
- running a live check, which belongs to stage 3;
- browser automation, deployment, containers, external services;
- calendar Slice 2 through 6;
- performance, load, or security testing;
- executing the product's connected check inside the FuseForge repository CI.

## 6. Evidence location — approved

The Delivery Plan deferred this as "Coordination evidence location selected
after Skeleton". Approved location, in the product workspace beside the contract
it references:

```text
<coordination-root>/docs/features/<feature-slug>/connected-verification.md
```

Rationale:

- the coordination root and `docs/features/` are already parent-owned, so no
  ownership rule changes;
- it sits next to the contract revision it cites;
- it is durable and visible in the product repository, unlike `.craft/`;
- it behaves identically in monorepo and polyrepo.

The FuseForge repository records only its own coordinator evidence under
`docs/verification/`. Product evidence never lands in the pack.

## 7. Backend lifecycle

The parent:

1. confirms both tracks are complete and current on `rev-2`;
2. starts the backend from the backend target using the command the backend
   specialist reported;
3. waits for a readiness signal by polling the backend's own endpoint rather
   than sleeping a fixed interval;
4. runs the one named connected check;
5. stops the backend, including on failure;
6. records the outcome.

Rules:

- persistence stays application-local; no database server or container;
- a port conflict is reported, not worked around by editing product source;
- a readiness timeout is a failed check, never a pass;
- teardown always runs.

## 8. Evidence record contents

- date and contract revision proven;
- frontend and backend commands actually run;
- the accepted flow proven, in product language;
- the error case proven and the frontend state it maps to;
- the timezone behavior observed;
- what was not proven, including browser behavior and deployment;
- the specialist test results this complements.

A record may not describe an outcome that was not observed. A blocked or failed
check is recorded as blocked or failed.

## 9. Completion rule

Calendar Slice 1 is complete only when both tracks are complete on `rev-2` and
the connected check passed and is recorded. Until then the coordinator reports
the feature as not proven end to end, reusing the partial-completion wording from
slice 5.

## 10. `craft.md` size resolution

Slice 5 left `craft.md` at 196 of 200 lines. Slice 6 therefore replaces the
"connected verification is not implemented" sentence with a short pointer to
`connected-verification.md`, which already exists and is registered, so no new
policy file is added.

If the pointer does not fit, section 3 is compressed; its F6 rule can be stated
in fewer lines without losing meaning.

## 11. Implementation scope

```text
skills/coordination/connected-verification.md
skills/coordination/stage-barrier.md
skills/coordination/delegation.md
skills/workflow/craft.md
skills/SKILL.md
skills/stability.json
scripts/ci/check-connected-verification.py
scripts/ci/check-implement-delegation.py
.github/workflows/lint.yml
docs/reference/release-process.md
docs/reference/support-scope.md
```

`check-implement-delegation.py` changes because slice 5 asserted that connected
verification is Skeleton-only. That assertion becomes false and is replaced by
the slice 6 assertions.

## 12. Verification plan

The static check verifies:

1. the check requires the real frontend client and the real backend HTTP
   adapter;
2. OpenAPI-only validation is rejected;
3. browser E2E, deployment, containers, and external services stay excluded;
4. the parent owns the record, and the evidence path is in the product
   workspace rather than the pack;
5. readiness is polled and a timeout is a failure;
6. teardown always runs;
7. an unobserved outcome may not be recorded;
8. a slice is incomplete without a passing recorded check;
9. `connected-verification.md` is registered as implemented and no longer
   declares itself Skeleton;
10. the specialist owns the check code while the parent runs it;
11. all earlier checks still pass.

Negative tests inject a violation per rule group, as in slice 5.

## 13. Risks

### Connected verification becomes undeclared E2E

Mitigation: stop at the client and HTTP adapter boundary. Browser automation
requires separate approval.

### A fixed sleep produces a flaky or false pass

Mitigation: readiness must be polled and a timeout must fail.

### The parent starts writing product test code

Mitigation: the approved resolution keeps test code specialist-owned, and the
static check forbids product source in the pack.

### An unrun check is reported as passing

Mitigation: the record must name commands and observed results, and the
completion rule blocks the slice without a passing record.

### The evidence lands in the FuseForge repository

Mitigation: the product evidence path is in the product workspace, and the check
fails if product evidence appears in the pack.

### Refining the slice 5 rule weakens it

Mitigation: the refinement narrows the parent's permission to exactly one
commissioned check and states it explicitly, rather than removing the rule.

## 14. Human checkpoint — approved 2026-08-27

The maintainer approved:

- the scope correction removing a separate Test-delegation interface;
- the ownership resolution in section 4, with the specialist writing the check
  and the parent running it and owning the record;
- the refinement of the slice 5 wording that this requires;
- the product-workspace evidence location in section 6;
- the parent-owned backend lifecycle with polled readiness and guaranteed
  teardown;
- the completion rule and the prohibition on recording unobserved outcomes;
- the `craft.md` pointer resolution without adding a policy file.

This approval authorizes the connected-verification policy slice. It does not
authorize calendar product source or a live check, which belong to stage 3.

## 15. Program context

Stage 2 of the three-stage split. Stage 3 then executes slices 5 and 6 against a
real product workspace to produce the first working full-stack proof, the last
unmet public-readiness condition.
