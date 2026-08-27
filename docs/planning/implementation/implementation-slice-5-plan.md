# FuseForge — Implementation Slice 5 Plan

- Status: Approved for implementation
- Date: 2026-08-27
- Approved: 2026-08-27
- Input: Approved `implementation-slice-4.md` and
  `../../verification/released-flow-acceptance-2026-08-27.md`
- Focus: Specialist Implement delegation for calendar Slice 1

## 1. User outcome

Given an approved shared contract at `rev-2`, FuseForge can:

1. verify Compforge and OOPforge activation;
2. delegate Implement work for calendar Slice 1 to each specialist against the
   same `rev-2`;
3. collect structured track results with specialist-owned test evidence;
4. reject stale, failed, or scope-drifting results;
5. keep the barrier closed when either required track is incomplete;
6. present one integrated product-language checkpoint that states honestly
   whether the feature works end to end.

FuseForge writes no application source itself. Each specialist writes only
inside its own work target.

### What this slice delivers

Slice 5 delivers coordinator capability, not product code. Its deliverable is
canonical policy plus a static check. **No calendar source is created by slice 5,
and no dependency is installed by it.** The capability described above is first
exercised in stage 3, which requires its own approval.

## 2. Why this is a separate slice

The Implement delegation this slice defines differs from Design delegation in
three ways that change the safety rules, so it cannot reuse slice 4 unchanged:

- delegated specialists will create application source and install dependencies;
- write-root enforcement becomes load-bearing rather than advisory;
- a partially successful stage produces a product that does not run, which must
  not be summarized as success.

Connected verification stays out. A frontend client calling a running backend is
slice 6.

## 3. Slice boundary

### In scope

Every item below is a rule this slice defines and verifies, not an action it
performs:

- Implement-stage delegation for calendar Slice 1 only;
- activation probes before relying on a specialist;
- `rev-2` as the required contract revision;
- track-owned application source and test write roots;
- specialist-owned test evidence collection;
- dependency installation by the owning specialist inside its own target;
- `decision_required`, failure, cancellation, and stale handling;
- retry of only the failed or stale track;
- one integrated product-language checkpoint;
- honest reporting of partial completion.

### Out of scope

- creating any calendar application source, or installing any dependency, during
  slice 5 itself;
- running a live specialist Implement delegation as this slice's gate;
- connected frontend-client-to-backend verification;
- calendar Slice 2 through 6 behavior;
- edit, delete, multiple calendars, colors, week/day/year views, recurrence,
  and reminders;
- `git init`, commits, remotes, merges, releases, or deployment;
- database servers or containers beyond application-local persistence;
- production configuration, authentication, or deployment;
- FuseForge writing application source or running specialist test suites on a
  specialist's behalf;
- autonomous retry after changed product meaning.

## 4. Calendar Slice 1 scope this delegation carries

From the approved Delivery Plan, Slice 1 is:

> Create a schedule and see it on the month view after it is saved.

Included: one default internal calendar; title, start, end, location, and
notes; create and list operations; application-local persistence; UTC
persistence with application-timezone offset responses; loading, empty, saved,
validation, and connection-error states; and one real
frontend-client-to-backend connected check.

Excluded: update, delete, recurrence, reminders, multiple calendars, and other
views. A specialist that implements an excluded capability reports
`scope_drift`.

That last inclusion is why the three-stage order is not negotiable. The approved
Delivery Plan makes a connected check part of calendar Slice 1 itself, and
`../../../skills/coordination/connected-verification.md` is Skeleton only.
Calendar Slice 1 therefore cannot be delivered until coordinator slice 6 exists.
Slice 5 defines how the source gets built; slice 6 defines how the connected
check proves it.

## 5. Write roots

All paths in this section are relative to the product coordination root in the
user's separate product workspace. No path in this slice refers to the FuseForge
repository, which never receives calendar source. This matches the ownership
table in the approved Delivery Plan, section 7.

Roots must be disjoint before delegation. For a monorepo selection:

```text
<coordination-root>/frontend/   → Compforge
<coordination-root>/backend/    → OOPforge
```

Rules:

- each specialist writes only inside its own target;
- the coordination root, the shared contract, and `docs/features/` stay
  parent-owned and are never assigned to a specialist;
- a specialist may create its own `docs/features/calendar/` notes inside its own
  target, as in slice 4;
- writing outside the assigned root invalidates the result even when the code is
  otherwise correct;
- for a three-work-target layout, the frontend and backend directories are
  already separate roots and the same rules apply.

## 6. Dependency installation

The Delivery Plan forbids optional infrastructure before a slice requires it,
and slice 4 excluded dependency installation entirely. Calendar Slice 1 is the
first work that legitimately needs it, so this slice authors the rule.

Approved rule:

- the owning specialist installs dependencies inside its own work target;
- FuseForge never runs a package manager;
- installation is limited to what calendar Slice 1 requires;
- a lockfile belongs to the specialist's target, not the coordination root;
- persistence is application-local, so no database server, container, or
  external service may be introduced;
- the specialist reports what it installed in its result envelope.

No dependency is installed during slice 5 itself. This slice writes the rule and
the check that enforces it; the rule is first exercised in stage 3, when the
calendar slice runs.

## 7. Delegation envelope

| Field | Value for this slice |
|---|---|
| `track` | `frontend` or `backend` |
| `stage` | `Implement` |
| `intent` | `feature` |
| `work_target` | Exact confirmed target |
| `write_roots` | That track's work target only |
| `contract_ref` | Coordination-root contract path |
| `contract_revision` | `rev-2` |
| `base_revision` | Git revision or `unavailable` |
| `expected_output` | Working Slice 1 source, specialist tests, and one result envelope |

The prompt:

- uses the active harness's specialist Craft form;
- requires the specialist activation probe first;
- carries the approved `rev-2` wire semantics, not a paraphrase;
- names the Slice 1 inclusions and exclusions explicitly;
- states the single write root;
- forbids editing the shared contract;
- requires unresolved cross-stack changes as decision requests rather than
  local improvisation.

## 8. Execution order

Sequential is the baseline, and for this slice it is the recommended default.
Both tracks now write source, so a shared assumption error is more expensive
than in Design.

Parallel Implement is allowed only when every slice-4 condition holds and
additionally:

- both tracks already have an approved `rev-2`;
- neither track needs a decision from the other to start;
- write roots are verified disjoint immediately before delegation.

Parallelism never changes approval rules or result authority.

## 9. Result envelope

| Field | Requirement |
|---|---|
| `track` | Result owner |
| `stage` | `Implement` |
| `status` | `completed`, `decision_required`, `failed`, `cancelled`, or `stale` |
| `contract_revision` | Revision actually used |
| `base_revision` | Revision actually used or `unavailable` |
| `artifacts` | Source and test paths created or changed |
| `evidence` | Specialist test commands and their results |
| `dependencies_added` | Packages and versions installed in the owned target |
| `decision_requests` | Proposed shared changes |
| `scope_drift` | `none` or explicit unexpected scope |
| `remaining_risks` | Track-local risks |
| `product_summary` | Short user-language outcome |

`dependencies_added` is new for this slice. FuseForge stores normalized
references in local state and does not copy source or test output into a second
authoritative document.

## 10. Validation and stale rules

A result is invalid when:

- activation was not proven;
- required envelope fields are missing;
- its contract revision is not `rev-2`;
- it wrote outside its assigned work target;
- it implemented an excluded Slice 1 capability without reporting drift;
- it edited the shared contract;
- it claims an unresolved shared decision as approved;
- it reports passing evidence without a command and observed result;
- it introduced a database server, container, or external service.

Without Git, `base_revision` is `unavailable`. State the reduced code-drift
assurance explicitly. This matters more than in slice 4, because application
source now exists and can change between turns with no detectable revision.

## 11. Stage barrier

The integrated checkpoint stays closed while any required track:

- has no result;
- is `decision_required`, `failed`, `cancelled`, or `stale`;
- used a revision other than `rev-2`;
- drifted outside its work target;
- lacks specialist test evidence.

A failed track may retry against unchanged `rev-2`, and a valid unrelated result
is preserved. Changed product meaning requires a user decision before retry.

### Partial completion must not read as success

If one track completes and the other fails, the checkpoint reports that the
feature does not work end to end, names which half exists, and offers retry of
the failed track only. This slice adds no wording that implies a working
application before both tracks are complete and slice 6 has run.

## 12. Integrated checkpoint

Present one product-language checkpoint, not two specialist reports. It states:

- whether a user can create a schedule and see it on the month view;
- what each track built, in product terms;
- which specialist checks ran and what they showed;
- that connected frontend-to-backend verification has not run yet;
- dependencies introduced;
- unresolved conflicts or decision requests;
- remaining risks.

This checkpoint is coordinator runtime behavior, presented when an Implement
delegation completes during stage 3. User approval there authorizes moving that
feature to the Test stage and connected verification. It does not by itself
change the contract. If integration surfaced a genuine wire gap, the parent
raises it as a decision request, and only an approved integrated checkpoint may
produce `rev-3`.

## 13. Implementation scope

Modify canonical policy:

```text
skills/SKILL.md
skills/workflow/craft.md
skills/coordination/delegation.md
skills/coordination/stage-barrier.md
skills/stability.json
```

Add focused verification:

```text
scripts/ci/check-implement-delegation.py
```

Harness adapters remain unchanged.

**Size constraint.** `check-harness-packaging.py` caps every `skills/**/*.md` at
200 lines. `skills/workflow/craft.md` is already 183 lines, leaving 17 lines of
headroom, so the Implement routing there must be a short pointer with the detail
living in `delegation.md` and `stage-barrier.md`, which both have room.

If the pointer does not fit, the approved fallback is a new
`skills/coordination/implement.md` registered in `stability.json`.

## 14. Verification plan

The dependency-free static check verifies:

1. Implement delegation requires `rev-2`;
2. activation is required before delegation;
3. write roots are track-specific, disjoint, and exclude the coordination root;
4. FuseForge is forbidden from writing application source;
5. only the owning specialist installs dependencies, inside its own target;
6. database servers, containers, and external services are forbidden;
7. Slice 1 exclusions are named and drift is reportable;
8. all result statuses and fields, including `dependencies_added`, are present;
9. stale, failed, and drifting results keep the barrier closed;
10. retry preserves unrelated valid results;
11. partial completion cannot be presented as a working feature;
12. connected verification is not claimed by this slice;
13. only the parent edits the shared contract;
14. earlier selection, bootstrap, workspace, and delegation checks still pass.

Isolated scenario evidence covers:

- both tracks completed and current, so the checkpoint is ready while connected
  verification is still absent;
- frontend completed and backend failed, so partial completion is reported,
  frontend work is preserved, and retry is limited to backend;
- a result on `rev-1`, which is stale and blocked;
- a write outside the work target, which is invalid despite passing tests;
- an excluded capability implemented, which is reported as `scope_drift` and
  blocked;
- an external database proposed, which is blocked;
- no-Git targets, where reduced assurance is disclosed;
- rejection, which yields the smallest correction without losing valid work.

Live specialist Implement generation is real product work and consumes
authenticated harness calls. It belongs to the calendar slice execution, not to
this policy slice's automated gate.

## 15. Risks

### Specialists write real source with no revision safety net

Without `git init` the coordinator cannot detect code drift between turns.
Mitigation: contract-revision staleness stays active, the reduced assurance is
disclosed at every checkpoint, and the maintainer may initialize Git in the
product workspace at any time to enable base-revision checks.

### Dependency installation becomes scope creep

Mitigation: installation is limited to the owning target and to what Slice 1
requires, servers and containers are forbidden, and every package is reported in
the result envelope.

### A half-built feature is reported as done

Mitigation: the barrier stays closed, and the checkpoint wording rule in section
11 is verified by the static check.

### The coordinator starts writing application code

Mitigation: FuseForge owns only the contract, coordination root, and evidence.
Application source is specialist-owned and the static check forbids the
coordinator path.

### Slice 1 grows into the whole calendar

Mitigation: inclusions and exclusions are carried in the delegation prompt, and
implementing an excluded capability is reportable drift.

### `craft.md` outgrows the policy size limit

Mitigation: keep Implement routing as a pointer, with the approved fallback in
section 13.

## 16. Human checkpoint — approved 2026-08-27

The maintainer approved:

- Implement-stage delegation policy and its static check, with no calendar
  source or dependency created by this slice;
- the dependency-installation rule in section 6, limited to the owning target
  and excluding database servers, containers, and external services;
- track-owned write roots in the separate product workspace, with the
  coordination root and shared contract parent-owned;
- the extended result envelope including `dependencies_added`;
- the barrier rules and the requirement that partial completion never reads as
  success;
- React with Vite for frontend and Python FastAPI for backend, matching the
  released-flow acceptance selection, to be reconfirmed at stage 3 execution;
- `git init` remaining outside FuseForge, accepting contract-only staleness
  while application source exists;
- the `craft.md` pointer approach with `skills/coordination/implement.md` as the
  fallback if the size limit is reached.

This approval authorizes only the Implement delegation policy slice. It does not
authorize calendar product source, which requires separate approval at stage 3.

## 17. Program context

This is stage 1 of the approved three-stage split:

1. **Slice 5 — Implement delegation.** This plan.
2. **Slice 6 — Test delegation and connected verification.** Turns
   `connected-verification.md` from Skeleton into behavior and defines the
   evidence that a real frontend client called a running backend. It must also
   select the connected-evidence location that the Delivery Plan deferred.
3. **Calendar Slice 1 production.** Executes slices 5 and 6 against the product
   workspace to produce the first working full-stack proof, which is the last
   unmet public-readiness condition.
