# Craft Selection Gate

Status: **Experimental — first implementation slice**.

This slice classifies a request and resolves only the choices required before
product files can exist.

## 1. Safety boundary

This slice is read-only. It must not:

- create or modify directories;
- initialize Git;
- create a shared contract or `.craft/fuseforge/` state;
- invoke a specialist implementation workflow;
- create frontend, backend, installer, CI, or calendar files;
- claim that later FuseForge slices are implemented.

## 2. Classify what can be inferred

Record explicit assumptions for:

- context: `greenfield` or `existing`;
- intent: `feature`, `bug-fix`, or `refactor`;
- required tracks, but only as far as section 2.1 allows;
- topology when an existing workspace makes it unambiguous;
- stacks that are explicit in the request or safely observable from existing
  project files.

Use the current harness. Never ask the user to select Cursor, Claude, or Codex
during a work request.

For existing projects, inspect only the affected manifests, configuration, and
work-target roots needed to infer these values. Whole-repository analysis is
outside this slice.

### 2.1 A track is never inferred from silence

A track is settled only when the request states it or an existing project shows
it. Silence is not a decision.

If the request does not say whether the data must still be there after the
browser is closed, the backend track is unresolved and belongs in the selection
gate. Ask; do not choose.

Deciding this without the user removes a product decision they own and drops a
specialist track, so a browser-only result must never be an assumption.

## 3. Verify available choices

For each required track, read the stack scope stated by the loaded specialist
skill and offer only stacks that the observed pack version supports. Prefer that
skill, whose scope is already available, and use the pack's support-scope
document only to refine the list. That document sits outside the linked skill
directory and may be unreadable; treat that as missing detail, not a missing
pack, and report no blocker when the loaded skill already states the stacks.

Report a blocker only when the required specialist skill itself cannot be found.
Then point the user to `docs/setup/bootstrap.md` and stop. Craft never invokes
bootstrap, applies environment changes, or invents choices.

Expected current families are TypeScript + React from Compforge and Java Spring
or Python FastAPI from OOPforge. Treat this as orientation, not a substitute for
inspecting the loaded pack, and do not offer planned support such as Vue until
the loaded contract includes it.

## 4. Build one combined selection gate

An unresolved track and a missing required stack are always user decisions.

For an unresolved backend track, offer keeping the data in the browser only and
saving it on a server, each with one consequence in the user's language. Ask any
backend stack question as conditional on that answer.

Greenfield topology is also a user decision when the request does not choose
between:

- monorepo — one product root and Git history;
- three-work-target layout — coordination, frontend, and backend directories
  that may later become independent repositories.

Ask all missing stack and topology choices in one checkpoint. Use the user's
language and one short consequence per option. If a structured question tool
is available, use one form with separate questions. Otherwise use a compact
numbered list.

Do not ask for:

- a stack already specified or safely inferred;
- a backend choice when the request or the existing project states that the work
  is frontend-only, which your own classification never establishes;
- a frontend choice for backend-only work that is stated or observed;
- topology for an existing workspace that is already clear;
- harness selection.

## 5. Response contract

Before the selection checkpoint, output:

```markdown
## Assumptions
- Context: ...
- Intent: ...
- Required tracks: <settled tracks, and any track left to the gate>
- Observed topology: ...

## Selection Gate
<only the unresolved track, stack, and topology choices>
```

State that no product files have been created.

After presenting unresolved choices, stop. Do not continue into path creation,
shared contracts, delegation, or implementation in the same response.

If no required choice is missing, summarize the confirmed selections and stop
the selection gate with:

```text
Selection gate complete.
```

## 6. Greenfield workspace checkpoint

Continue only for greenfield work when product name, product slug, feature
slug, base directory, stacks, and topology are explicit.

Read `../coordination/logical-workspace.md` and
`../coordination/shared-contract.md`. Propose normalized absolute paths for the
selected topology, never using a pack root as the product base.

Inspect proposed roots without changing them:

- absent roots may be created;
- existing empty directories may be reused only when named in the checkpoint;
- a non-empty directory, file, or symlink blocks this slice and returns to the
  existing-project flow or a new-path choice.

Present Assumptions, Selection Summary, Workspace Plan, and Safety sections.
Name every exact path, including `.gitignore`, any reused empty directory, and
the facts that Git, dependencies, and application source will not be created.

Ask the user to create those exact paths or revise them. Stop without writing.
A prior generic approval is not path confirmation. Confirmation is incomplete
unless it covers coordination, frontend, backend, contract, local-state, and
`.gitignore` paths from the current plan. If any path is omitted or changed,
present a corrected plan and remain read-only.

## 7. Confirmed workspace creation

After the user confirms every exact path in the current plan:

1. recheck every proposed root and invalidate approval on drift;
2. create only the approved coordination, frontend, and backend directories;
3. create `docs/features/<feature-slug>/contract.md` from the product-semantics
   `rev-1` contract;
4. create or extend the confirmed coordination-root `.gitignore` with one
   `.craft/` entry;
5. create `.craft/fuseforge/task-<feature-slug>.md` with local paths and
   progress;
6. verify that frontend and backend targets contain no application files;
7. report created versus reused paths and stop.

Track created and reused artifacts separately. On failure, remove only files and
still-empty directories created by this operation. Never remove a reused
directory or unrelated `.gitignore` content.

Stop after workspace creation. Specialist Design begins only in a separately
approved user turn.

## 8. Specialist Design integration

For an approved Design turn, read `../coordination/delegation.md` and
`../coordination/stage-barrier.md`. Verify Compforge and OOPforge activation,
then delegate the same current contract revision with disjoint Design-document
write roots. Validate both result envelopes before integration.

Keep the barrier closed for missing, failed, cancelled, decision-required,
stale, or scope-drifting results. Preserve unrelated valid work.

When both results are valid, create a local proposed revision and present one
product-language checkpoint. Do not edit the tracked shared contract before
explicit approval. After approval, only the parent applies `rev-2`.

Stop after the approved contract update. Application implementation is a
separately approved turn and a separate slice.

## 9. Specialist Implement delegation

For an approved Implement turn, read `../coordination/delegation.md` and
`../coordination/stage-barrier.md`. Delegate calendar Slice 1 against `rev-2`
with one work-target write root per track. Specialists own application source,
tests, and their own dependency installation; FuseForge writes no application
source and runs no package manager.

Keep the barrier closed for any incomplete track. When one track completes and
the other fails, report that the feature does not work end to end and retry only
the failed track. A slice is complete only after the parent-owned check in
`../coordination/connected-verification.md` passed and was recorded.
