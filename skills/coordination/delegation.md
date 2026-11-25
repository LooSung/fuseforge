# Specialist Delegation Interface

Contents: Request envelope · Result envelope · Design delegation · Design result validation · Implement delegation · Refactor and Test delegation

Status: **Experimental — Design, Implement, Refactor, and Test delegation**.

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
| `read_first` | Exact paths the specialist reads in full before anything else |

Each prompt lists `read_first`. Beyond those paths, the specialist searches only
for what they name and reads only the needed range of target source. It quotes
summaries and failures from command output, never full logs.

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

## Design delegation

Before relying on a track, run its activation probe. A failed or missing probe
blocks delegation.

Both tracks receive the same shared contract `rev-1`, Design stage, feature
intent, exact target, and disjoint write root inside each work target:

```text
<frontend_target>/docs/features/<feature-slug>/
<backend_target>/docs/features/<feature-slug>/
```

Each specialist may create only `design.md` in its assigned root. The prompt
uses Consult/Design-only behavior, forbids application source and `.craft/`
execution continuity, and requires a Component Contract or OOP Contract.

### Names

The prompt tells each specialist to split names in two:

- **public** — endpoint paths, error codes, user-visible text, and domain
  concepts the user or another system will see; each becomes a decision request;
- **internal** — classes, hooks, modules, files, and private fields; each gets a
  default, following the existing project's convention when one exists, and is
  listed in `design.md` without a question.

The integrated checkpoint asks only about public names and shows internal names
as one list the user may override. A specialist's "user's own word" rule is
evidence that a structure is needed, not a reason to ask about every name.

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

## Implement delegation

Before relying on a track, run its activation probe. Delegate only after the
shared contract reached `rev-2`. A result on an earlier revision is stale.

Each track receives Implement stage, feature intent, its exact target, the
approved `rev-2` wire semantics rather than a paraphrase, and one write root.
The write root is the track's confirmed work target — `frontend_target` or
`backend_target` in `logical-workspace.md` — never a path derived from the
coordination root:

```text
monorepo:           <coordination-root>/frontend/
                    <coordination-root>/backend/
three-work-target:  <base>/<product-slug>-frontend/
                    <base>/<product-slug>-backend/
```

Those roots live in the user's product workspace, never in a pack repository.
The coordination root, the shared contract, and `docs/features/` stay
parent-owned and are never assigned to a specialist.

The prompt names the slice's inclusions and exclusions exactly as the approved
contract and delivery plan record them, never a paraphrase. Anything the slice
excludes is named as excluded.

Sequential execution is the baseline. Because both tracks write source, parallel
Implement additionally requires an approved `rev-2`, no cross-track dependency at
start, and write roots verified disjoint immediately before delegation.

### Long-running delegation

Give each phase to a fresh agent by default. Continue the same agent into the
next phase only when that phase builds directly on the code it just wrote and
the agent has not been summarized; this saves re-reading the target.

Replace a running agent — stop it, then start a fresh one with a handoff of
commit hashes, the task doc, and the remaining scope — when any is true:

- the agent's context was automatically summarized;
- no file has changed for about ten minutes while it is not waiting on a
  command;
- it repeats steps it already finished;
- its context passes about 200K tokens, by the harness's token count for that
  agent.

Tell the user before replacing and why. Run full verification suites and slow
integration tests once at the end of a multi-phase plan when the user has
chosen speed; say that problems then surface late.

### Dependencies

The owning specialist installs dependencies inside its own work target and
reports them. FuseForge never runs a package manager. Installation is limited to
what the slice requires, and a lockfile belongs to that target rather than the
coordination root. A database server, container, or external service may be
introduced only when the approved contract names it.

### Implement result validation

Reject an Implement result when it:

- lacks activation evidence;
- does not use `rev-2`;
- omits source, tests, or `dependencies_added`;
- writes outside its assigned work target;
- implements an excluded capability without reporting `scope_drift`;
- edits the shared contract;
- reports passing evidence without a command and an observed result;
- introduces a database server, container, or external service the approved
  contract does not name.

FuseForge writes no application source and runs no specialist suite to
manufacture specialist evidence. The one parent-run exception is the commissioned
connected check in `connected-verification.md`. A write outside the assigned
target invalidates the result even when the code is otherwise correct.

Without Git, `base_revision` is `unavailable`. Disclose the reduced code-drift
assurance, which matters more once application source exists.

Preserve a valid unrelated track when another track fails, and retry only
against unchanged `rev-2`.

## Refactor and Test delegation

Crucible uses these after a passing connected check. Run each track's
activation probe first. A track receives stage `refactor` or `test`, the
approved `rev-2`, its work-target write root, and the plan's refactor reason or
test strategy. The prompt names that specialist's own `workflow/refactor.md` or
`workflow/test.md`, never its crucible, and forbids a specialist `.craft/` doc.

Reject a Refactor result when it changes visible behavior, a public name, or the
contract; lacks a passing test run before and after, with commands and observed
results; or carries feature work.

Reject a Test result when it changes production code. A test that needs a
production fix returns as a decision request, not as a Test result.

Both report artifacts and a commit, or `unavailable` without Git. A Refactor
result that changed source invalidates the last connected check.
