# Specialist Delegation Interface

Status: **Experimental — Design and Implement delegation**.

## Request envelope

| Field | Meaning |
|---|---|
| `track` | `frontend` or `backend` |
| `stage` | Current approved stage |
| `intent` | Classified work intent |
| `work_target` | Exact specialist target |
| `write_roots` | Allowed writable paths |
| `contract_ref` | Shared-contract reference |
| `contract_revision` | Delegated `rev-N` |
| `base_revision` | Optional target Git revision |
| `expected_output` | Required artifact or evidence |

## Result envelope

| Field | Meaning |
|---|---|
| `track` | Result owner |
| `stage` | Stage attempted |
| `status` | Completion, decision, failure, cancellation, or stale status |
| `contract_revision` | Revision actually used |
| `base_revision` | Code revision actually used |
| `artifacts` | Specialist artifact references |
| `evidence` | Specialist-owned checks |
| `dependencies_added` | Packages installed in the owned target; Implement only |
| `decision_requests` | Proposed shared changes |
| `scope_drift` | Unexpected work |
| `remaining_risks` | Unresolved track risks |
| `product_summary` | User-facing result |

## Calendar Design delegation

Before relying on a track, run its activation probe. A failed or missing probe
blocks delegation.

Both tracks receive the same shared contract `rev-1`, Design stage, feature
intent, exact target, and disjoint write root:

```text
frontend/docs/features/calendar/
backend/docs/features/calendar/
```

Each specialist may create only `design.md` in its assigned root. The prompt
uses Consult/Design-only behavior, forbids application source and `.craft/`
execution continuity, and requires a Component Contract or OOP Contract.

Sequential execution is the baseline. Parallel Design is allowed only with
passing probes, identical contract revision, disjoint roots, isolated results,
and a sequential fallback.

## Design result validation

Require every envelope field above. Reject a result when it:

- lacks activation evidence;
- does not use `rev-1`;
- omits its Design artifact or owned specialist contract;
- writes outside its Design root;
- creates application source;
- treats a shared decision request as approved.

Without Git, `base_revision` is `unavailable`; disclose reduced code-drift
assurance and use contract-revision staleness.

Preserve a valid unrelated track when another track fails. Retry only against
unchanged `rev-1`; changed product meaning returns to the user first.

## Calendar Implement delegation

Before relying on a track, run its activation probe. Delegate only after the
shared contract reached `rev-2`. A result on an earlier revision is stale.

Each track receives Implement stage, feature intent, its exact target, the
approved `rev-2` wire semantics rather than a paraphrase, and one write root:

```text
<coordination-root>/frontend/
<coordination-root>/backend/
```

Those roots live in the user's product workspace, never in a pack repository.
The coordination root, the shared contract, and `docs/features/` stay
parent-owned and are never assigned to a specialist.

The prompt names the Slice 1 inclusions — one default internal calendar; title,
start, end, location, and notes; create and list; application-local persistence;
UTC storage with application-timezone offsets; and loading, empty, saved,
validation, and connection-error states — and its exclusions: update, delete,
recurrence, reminders, multiple calendars, and other views.

Sequential execution is the baseline. Because both tracks write source, parallel
Implement additionally requires an approved `rev-2`, no cross-track dependency at
start, and write roots verified disjoint immediately before delegation.

### Dependencies

The owning specialist installs dependencies inside its own work target and
reports them. FuseForge never runs a package manager. Installation is limited to
what Slice 1 requires, and a lockfile belongs to that target rather than the
coordination root. Persistence is application-local, so no database server,
container, or external service may be introduced.

### Implement result validation

Reject an Implement result when it:

- lacks activation evidence;
- does not use `rev-2`;
- omits source, tests, or `dependencies_added`;
- writes outside its assigned work target;
- implements an excluded Slice 1 capability without reporting `scope_drift`;
- edits the shared contract;
- reports passing evidence without a command and an observed result;
- introduces a database server, container, or external service.

FuseForge writes no application source and runs no specialist test suite on a
specialist's behalf. A write outside the assigned target invalidates the result
even when the code is otherwise correct.

Without Git, `base_revision` is `unavailable`. Disclose the reduced code-drift
assurance, which matters more once application source exists.

Preserve a valid unrelated track when another track fails, and retry only
against unchanged `rev-2`.
