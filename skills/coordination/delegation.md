# Specialist Delegation Interface

Status: **Experimental — Design delegation**.

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

## Result validation

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
