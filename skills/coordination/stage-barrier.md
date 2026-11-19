# Stage Barrier Interface

Status: **Experimental — Design and Implement integration barriers**.

The future barrier remains closed when a required track:

- has no result;
- requests a shared decision;
- fails or is cancelled;
- uses an old contract revision;
- depends on a changed code base revision.

It becomes ready for approval only when:

- every required result is complete and current;
- write-root and scope checks pass;
- required evidence is attached;
- the parent has one product-language summary.

Only user approval opens the next stage. Rejection preserves valid artifacts
and returns to the smallest affected decision.

## Integrated Design checkpoint

For Design, the barrier also requires:

- Compforge and OOPforge activation evidence;
- frontend and backend `design.md` artifacts;
- Component and OOP Contracts;
- result envelopes using the same current revision;
- no application source or write-root drift.

When valid, create only a local proposal:

```text
.craft/fuseforge/proposed-rev-2-<feature-slug>.md
```

The proposal combines HTTP operations, schemas, error mapping, timezone rules,
idempotency, concurrency, backend-outcome-to-frontend-state mapping, risks, and
both artifact references. It is not authoritative.

Present one product-language checkpoint. Technical naming that preserves
meaning may be resolved by the parent. Ask only about public names, and show
internal names as one list of defaults the user may override (`delegation.md`,
Names). When the contract requires authentication, the proposal names the
connected-check credential source (`connected-verification.md`). Observable
behavior, accepted data, error recovery, acceptance criteria, or scope conflicts
require the user.

Only explicit approval permits the parent to update the tracked contract to
`rev-2`. Rejection preserves valid artifacts and returns to the smallest
correction. Specialists never edit the shared contract.

## Integrated Implement checkpoint

For Implement, the barrier also requires:

- Compforge and OOPforge activation evidence;
- both tracks on the current `rev-2`;
- specialist test evidence naming commands and observed results;
- source confined to each track's work target;
- reported `dependencies_added` for each track;
- no application source written by the parent.

### Partial completion is not success

When one track completes and the other fails, report that the feature does not
work end to end, name which half exists, preserve the valid track's work, and
offer retry of the failed track only. Never present a working application before
both tracks are complete and connected verification has run.

Present one product-language checkpoint stating whether a user can complete the
slice's primary acceptance example, what each track built, which specialist
checks ran and what they showed, which dependencies were introduced, and that
connected frontend-to-backend verification has not run.

Approval moves the feature to the Test stage. It does not by itself change the
contract. In Crucible, the approved slice plan is that approval when this barrier
is fully ready and the connected check passed (`../workflow/crucible.md`); any
unmet condition still stops. A genuine wire gap found during integration returns as a decision
request, and only an approved integrated checkpoint may produce `rev-3`.

## Slice completion barrier

A product slice is complete only when every required track is complete on the
approved revision and the parent-owned connected check in
`connected-verification.md` passed and was recorded. A missing, failed, or
unrecorded check keeps the slice incomplete.

Until then, report the feature as not proven end to end, using the same wording
rule as partial completion. Specialist tests alone never satisfy this barrier.
