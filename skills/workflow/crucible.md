# Crucible Workflow

Contents: When to use · Load order · Stages · Stops · State · Completion report · Prohibited

Status: **Experimental**.

Run one full-stack slice from plan to tested, connected code in one request:
FuseForge Consult plan, FuseForge Craft, specialist Refactor when earned,
specialist Test, and a connected check. Crucible adds no coordination rules of
its own. Each stage runs its own policy file as written. Crucible orders the
stages, carries the approved plan forward, and decides when to stop.

## When to use

The request asks for the whole path of one full-stack slice: plan, build, clean
up, test. For one step, use that step's command. Advice only stays in Consult.
Work on one track only goes to `/compforge:crucible` or `/oopforge:crucible`.

## Load order

Read each file when its stage starts:

1. `craft.md` sections 1–7 for the selection gate and the workspace.
2. `consult.md` Document mode for the plan.
3. `craft.md` sections 8–9 with `../coordination/delegation.md`,
   `../coordination/stage-barrier.md`, and `../coordination/shared-contract.md`
   for Design and Implement.
4. `../coordination/connected-verification.md` for every connected check.
5. `../coordination/delegation.md`, Refactor and Test delegation, for stages 5–6.

After context compaction, read this file and the current stage's files again.

## Stages

### 1. Gate and workspace — Craft

Run Craft's selection gate and, for a new product, its workspace checkpoint. Each
is a stop while it has an open choice or an unconfirmed path. Settled choices
and an existing confirmed workspace skip it.

### 2. Plan — Consult, Document mode

Write one slice plan at `<coordination-root>/docs/features/<feature-slug>/plan.md`.
It records the product outcome in the user's words, the slice's inclusions and
exclusions, which Implement delegation copies verbatim, the stacks the gate
settled, each track's test strategy, the connected check's acceptance example,
and whether a refactor is expected on each track.

**Stop and ask the user to approve the plan.** This stop is mandatory.

### 3. Design — Craft section 8

Delegate specialist Design. The integrated `rev-2` checkpoint is a stop: the plan
does not approve wire semantics.

### 4. Build — Craft section 9, then the connected check

Delegate Implement against `rev-2` with the plan's inclusions and exclusions,
then run the connected check. The approved plan is the user's approval past the
integrated Implement checkpoint only when that barrier is fully ready and the
check passed. Report the checkpoint summary and continue. Anything else stops.

### 5. Refactor — specialist, only when earned

Per track, run only when the plan expected a refactor on that track or the
track's Implement result named a smell in `remaining_risks`. FuseForge never
decides a refactor from its own reading of the code. Otherwise record
`Refactor <track>: skipped — <reason>`.

### 6. Test — specialist gap pass

Per track, delegate only the gaps left in the plan's test strategy. A track with
no gap records `Test <track>: no gaps — <why>`.

### 7. Connected recheck

Rerun the connected check only when stage 5 changed a track's source. A failed
recheck is a stop, and the slice is not complete.

## Stops

Craft stops after workspace creation (section 7) and after the contract update
(section 8), each until a separately approved turn. In Crucible, the plan
approval is the approved turn that starts Design, and the `rev-2` approval is the
approved turn that starts Implement.

After the plan is approved, continue between stages without asking. Stop when:

- the gate has an open choice or a workspace path is unconfirmed (stage 1);
- the plan awaits approval (stage 2) or `rev-2` awaits approval (stage 3);
- a barrier is not ready: a missing, failed, stale, or partial track result;
- a specialist returns a decision request or scope drift;
- a connected check fails or cannot run;
- a test needs a production fix;
- the session is cut; stop at a stage boundary and record the next stage.

On a stop, report the stage, what is done, and the one question. If the user
asks to stop after every stage, do so for the rest of the run.

## State

Record the plan path, the current stage, the contract revision, and each track's
commit per stage in `.craft/fuseforge/task-<feature-slug>.md`. Without Git, a
commit is `unavailable`. Specialists keep no `.craft/` work doc for these stages.

## Completion report

```markdown
## Stages
- Gate: settled | <choices asked>
- Workspace: <coordination root> — confirmed | reused
- Plan: <path> — approved
- Design: rev-2 — approved
- Build: frontend <commit>, backend <commit>; connected check passed — <record>
- Refactor: frontend <commit | skipped — reason>; backend <commit | skipped — reason>
- Test: frontend <commit | no gaps — why>; backend <commit | no gaps — why>
- Connected recheck: passed — <record> | not needed — no source change
```

Then report slice completion under the slice completion barrier in
`../coordination/stage-barrier.md`.

## Prohibited

- Never skip the selection gate, path confirmation, the plan approval, or the
  `rev-2` approval.
- Never write application source or tests; the specialists do.
- Never run a specialist's crucible; delegate its Refactor and Test workflows.
- Never start a refactor on FuseForge's own judgment.
- Never report the slice complete without a passing, recorded connected check
  after the last source change.
- Never push, open a pull request, or release.
- Never run tracks in parallel except as `../coordination/delegation.md` allows.
