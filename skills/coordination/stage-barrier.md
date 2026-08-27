# Stage Barrier Interface

Status: **Experimental — Design integration barrier**.

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

For calendar Design, the barrier also requires:

- Compforge and OOPforge activation evidence;
- frontend and backend `design.md` artifacts;
- Component and OOP Contracts;
- result envelopes using the same current revision;
- no application source or write-root drift.

When valid, create only a local proposal:

```text
.craft/fuseforge/proposed-rev-2-calendar.md
```

The proposal combines HTTP operations, schemas, error mapping, timezone rules,
idempotency, concurrency, backend-outcome-to-frontend-state mapping, risks, and
both artifact references. It is not authoritative.

Present one product-language checkpoint. Technical naming that preserves
meaning may be resolved by the parent. Observable behavior, accepted data,
error recovery, acceptance criteria, or scope conflicts require the user.

Only explicit approval permits the parent to update the tracked contract to
`rev-2`. Rejection preserves valid artifacts and returns to the smallest
correction. Specialists never edit the shared contract.
