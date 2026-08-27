# FuseForge — Implementation Slice 4 Plan

- Status: Approved for implementation
- Date: 2026-08-27
- Approved: 2026-08-27
- Input: Approved `docs/planning/implementation/implementation-slice-3.md`
- Focus: Specialist Design delegation and integrated wire checkpoint

## 1. User outcome

Given a confirmed greenfield workspace and product-semantics contract `rev-1`,
FuseForge can:

1. verify Compforge and OOPforge activation;
2. delegate Design-only work to each specialist with the same contract;
3. collect structured track results;
4. reject stale, failed, or scope-drifting results;
5. combine compatible proposals into one product-language wire checkpoint;
6. update the shared contract to `rev-2` only after user approval.

No frontend or backend application source is created.

## 2. Slice boundary

### In scope

- Design-only frontend and backend delegation;
- activation probes before relying on a specialist;
- delegation and result envelopes;
- track-owned Design documents;
- contract and base-revision validation;
- `decision_required`, failure, cancellation, and stale handling;
- one integrated wire-semantics proposal;
- user approval gate;
- parent-owned `rev-2` contract update after approval.

### Out of scope

- component or backend implementation;
- dependency installation;
- database setup;
- generated OpenAPI;
- connected verification;
- autonomous retries with changed semantics;
- general-purpose task scheduling or merge automation;
- calendar product slice implementation.

## 3. Specialist Design artifacts

Design is advisory and must not create specialist `.craft/` continuity tasks.
Each specialist may write exactly one requested tracked planning document:

```text
<frontend-target>/docs/features/calendar/design.md
<backend-target>/docs/features/calendar/design.md
```

Frontend Design owns:

- component and state boundaries;
- year/month/week/day view composition;
- API client boundary and UI-state mapping;
- accessibility and frontend verification plan;
- a Component Contract;
- wire proposals and decision requests.

Backend Design owns:

- schedule and calendar domain concepts;
- use cases and invariants;
- persistence and transaction boundaries;
- HTTP adapter proposal;
- an OOP Contract;
- wire proposals and decision requests.

Both documents reference `docs/features/calendar/contract.md` and `rev-1`.
Neither specialist may edit the shared contract.

## 4. Delegation envelope

Each request contains:

| Field | Value for this slice |
|---|---|
| `track` | `frontend` or `backend` |
| `stage` | `Design` |
| `intent` | `feature` |
| `work_target` | Exact confirmed target |
| `write_roots` | That track's `docs/features/calendar/` only |
| `contract_ref` | Coordination-root contract path |
| `contract_revision` | `rev-1` |
| `base_revision` | Git revision or `unavailable` |
| `expected_output` | One Design document and one result envelope |

The prompt:

- uses the active harness's specialist form;
- requires the specialist activation probe first;
- states Design-only and forbids application source;
- includes only the product contract and relevant target context;
- requires unresolved cross-stack changes as decision requests.

## 5. Execution order

Sequential execution is the compatibility baseline.

Read-only Design delegation may run in parallel only when:

- both activation probes pass;
- both specialists receive the same `rev-1`;
- frontend and backend write roots are disjoint;
- the harness supports isolated results;
- sequential fallback remains available.

Parallelism must not change output authority or approval rules.

## 6. Track result envelope

Each result includes:

| Field | Requirement |
|---|---|
| `track` | Result owner |
| `stage` | `Design` |
| `status` | `completed`, `decision_required`, `failed`, `cancelled`, or `stale` |
| `contract_revision` | Revision actually used |
| `base_revision` | Revision actually inspected or `unavailable` |
| `artifacts` | Design document and Component/OOP Contract reference |
| `evidence` | Design checks performed |
| `decision_requests` | Proposed shared wire or behavior changes |
| `scope_drift` | `none` or explicit unexpected scope |
| `remaining_risks` | Track-local risks |
| `product_summary` | Short user-language outcome |

FuseForge stores normalized result references in local coordinator state. It
does not copy specialist Design content into a second authoritative document.

## 7. Validation and stale rules

A result is invalid when:

- activation was not proven;
- required envelope fields are missing;
- its contract revision is not `rev-1`;
- its Design document does not reference `rev-1`;
- it writes outside the assigned Design-document root;
- it creates application source;
- it claims an unresolved shared decision as approved.

When a target has Git history, compare its recorded base revision. Without Git,
record `unavailable`, use contract-revision staleness only, and disclose reduced
code-drift assurance.

If one track changes the contract proposal, the parent does not mutate
`rev-1`. It treats the proposal as a decision request until integration.

## 8. Stage barrier

The integrated checkpoint is blocked while any required track:

- has no result;
- is `decision_required`, `failed`, `cancelled`, or `stale`;
- used a different contract revision;
- drifted outside its write root;
- lacks its owned Design contract or evidence.

A failed track may retry against unchanged `rev-1`; a valid unrelated result is
preserved. A changed product meaning requires a new user decision before retry.

## 9. Integrated wire proposal

When both results are valid, the parent creates a local proposal:

```text
.craft/fuseforge/proposed-rev-2-calendar.md
```

It contains:

- user-visible flows and acceptance impact;
- proposed HTTP operations;
- request and response meanings;
- error and status mapping;
- time and timezone mapping;
- idempotency and concurrency decisions;
- backend outcome to frontend state mapping;
- unresolved conflicts;
- evidence responsibilities;
- references to both specialist Design documents.

This proposal is not authoritative and does not change `rev-1`.

The parent may resolve equivalent technical naming, test organization, and
sequential versus parallel execution. It must ask the user when a resolution
changes observable behavior, accepted data meaning, error recovery, acceptance
criteria, or scope.

## 10. User checkpoint and `rev-2`

Present one product-language checkpoint, not two specialist reports.

The user may:

- approve the integrated wire proposal;
- reject it with one smallest correction;
- choose between unresolved observable alternatives.

Only approval authorizes the parent to update:

```text
docs/features/calendar/contract.md
```

The update:

- changes `Revision` from `rev-1` to `rev-2`;
- fills approved wire operations, schemas, errors, and mappings;
- preserves product semantics and exclusions;
- references evidence ownership;
- removes only resolved items from unresolved decisions.

Specialist Design documents remain references to `rev-1`; their approved
proposals are represented authoritatively in `rev-2`. Any later result must use
`rev-2`.

## 11. Proposed implementation scope

Modify canonical policy:

```text
skills/SKILL.md
skills/workflow/craft.md
skills/coordination/shared-contract.md
skills/coordination/delegation.md
skills/coordination/stage-barrier.md
skills/stability.json
```

Add focused verification:

```text
scripts/ci/check-delegation-barrier.py
```

Harness adapters remain unchanged.

## 12. Verification plan

The dependency-free static check verifies:

1. both delegations use the same `rev-1`;
2. activation is required;
3. write roots are track-specific and disjoint;
4. application source is forbidden;
5. all result statuses and fields are present;
6. stale and failed results keep the barrier closed;
7. retry preserves unrelated valid results;
8. the local proposal is not authoritative;
9. only user approval permits `rev-2`;
10. only the parent edits the shared contract;
11. earlier selection, bootstrap, and workspace checks still pass.

Isolated scenario evidence covers:

- two completed current results → integrated checkpoint ready;
- old contract revision → stale and blocked;
- one failed track → valid other result preserved;
- observable conflict → user decision required;
- technical naming conflict → parent resolution allowed;
- no-Git targets → reduced assurance disclosed;
- rejection → smallest correction without application source;
- approval → contract becomes `rev-2`.

Live specialist Design generation is optional maintainer evidence because it
may consume authenticated harness calls. Static policy and fixture envelopes
remain the default automated gate.

## 13. Risks

### Backend-first design can dictate the UI

Both tracks receive the same product contract. The parent owns integration;
neither track's wire proposal is authoritative by arrival order.

### Parallel output can hide incompatible assumptions

Parallelism is optional. Revision, envelope, and barrier validation are
identical to sequential execution.

### `rev-2` can be written before approval

Keep the proposal under local `.craft/fuseforge/` and make the tracked contract
mutation conditional on the explicit integrated checkpoint.

### Specialist planning documents can become duplicate truth

They own track Design only. Cross-stack meaning is authoritative solely in the
shared contract after parent integration and user approval.

### Git-free targets reduce drift detection

State the reduced assurance and rely on contract revision until the user
initializes Git.

## 14. Human checkpoint — approved 2026-08-27

The maintainer approved:

- Design-only specialist documents and write roots;
- activation-first delegation;
- sequential baseline with optional safe parallelism;
- result envelope and stale rules;
- integrated local wire proposal;
- user-visible conflict escalation;
- parent-only `rev-2` mutation after approval;
- static and isolated scenario verification.

This approval authorizes only the Design delegation and integrated wire
checkpoint slice. It does not authorize application implementation.
