# FuseForge — Agent Instructions

## Mission

FuseForge explores a thin full-stack coordinator over Compforge and OOPforge.
It must preserve each specialist pack's scope while giving a developer one
feature-level workflow, shared contract, and integrated approval experience.

## Current stage

FuseForge's **coordinator Test checkpoint is approved**. Discovery, Design,
Delivery Plan, Skeleton, and nine Implement slices are approved.

The whole flow has been executed once against a real product workspace and
produced calendar Slice 1 with a passing connected check. Read
`docs/verification/calendar-slice-1-2026-08-27.md` before describing what
FuseForge has coordinated. It is one slice, one stack pair, one harness.

FuseForge installs and uninstalls itself with `scripts/setup/install.sh` and
`scripts/setup/uninstall.sh`. `scripts/setup/bootstrap.sh` installs the
specialist packs, not FuseForge, which differs from the sibling packs.

- Read `docs/planning/checkpoints/discovery.md`,
  `docs/planning/checkpoints/design.md`,
  `docs/planning/checkpoints/delivery-plan.md`, and
  `docs/planning/checkpoints/skeleton.md` before implementing behavior.
- Read a slice's plan before working on it and its evidence before reviewing it.
  `docs/planning/implementation/README.md` indexes every slice.
- Use `docs/README.md` as the human documentation index. Read
  `docs/reference/support-scope.md` before describing current support and
  `docs/verification/README.md` before changing evidence claims.
- Separate observed facts, hypotheses, decisions, and open questions.
- Implement only one explicitly approved vertical slice.
- Do not add unrelated installers, CI, dependencies, calendar source, or
  coordinator behavior outside that slice.
- Do not describe later slices or unverified harnesses as implemented or
  supported.

## Required workflow

For a new capability or product-level change, keep these stages separate:

1. Discovery — problem, glossary, actors, contexts, scenarios, open questions.
2. Design — coordinator contract, ownership, state model, and interfaces.
3. Delivery Plan — scope, sequence, verification, compatibility, and risks.
4. Skeleton — package and skill structure without behavior.
5. Implement — one approved vertical slice.
6. Test — static packaging, harness behavior, and connected evidence.

Ask for human approval before moving from one stage to the next.

## Product boundaries

- FuseForge coordinates; it does not duplicate frontend or backend methodology.
- Compforge owns TypeScript and React component discipline.
- OOPforge owns Java Spring and Python FastAPI OOP/DDD discipline.
- The user approves product behavior in their language. Internal terms and
  specialist contracts must not replace that product-language checkpoint.
- A parent agent owns shared decisions and user interaction. Specialist work
  must return undecided cross-stack changes to that parent.
- Parallelism is allowed only after a shared contract is fixed and write roots
  do not overlap. Parallel execution is an optimization, not a requirement.
- Do not introduce a tmux daemon, autonomous merge pipeline, or general-purpose
  multi-agent runtime without new evidence and a separate approved scope.

## Repository and documentation discipline

- Keep future decisions in Discovery or the currently approved planning
  artifact; do not present them as current capabilities.
- Keep authoritative checkpoints and implementation records under
  `docs/planning/`. Root-level historical document paths are compatibility
  stubs, not sources to edit.
- Keep setup, stable reference, project positioning, and verification evidence
  in their corresponding `docs/` subdirectories.
- Keep agent-facing skills, scripts, and enforceable policy in English.
  Maintain Korean user guidance in `README.ko.md` and
  `docs/reference/methodology.ko.md` instead of per-skill translations.
- Keep one source of truth for cross-stack semantics.
- Preserve monorepo and polyrepo as distinct contexts without assuming atomic
  commits across repositories.
- Do not add dependencies or external services during planning stages.
- Record only completed user-visible changes in `CHANGELOG.md`. Follow
  `docs/reference/release-process.md`; repository automation must not create
  tags or publish GitHub Releases.
- Keep changes surgical and remove only artifacts created by the same change.
- Comments explain why; names explain what.

## Discovery checkpoint

Status: **Approved 2026-08-26**.

Discovery is complete only when the maintainer can decide:

- whether the problem and target user are real;
- whether a separate coordinator is the correct product boundary;
- what must be shared between specialist tracks;
- what belongs explicitly outside the first Design;
- which open questions must be answered before Design.

## Design checkpoint

Status: **Approved 2026-08-26**.

Design is complete only when the maintainer can decide:

- the coordinator contract and one source of truth for shared semantics;
- ownership and escalation rules across the parent and specialist tracks;
- the logical-workspace, contract-revision, track-result, and stage-barrier
  state models;
- the smallest sibling-aligned harness structure and interfaces;
- the default user flow, including mandatory stack ambiguity checks;
- the calendar proof semantics and boundaries needed for Delivery Planning.

## Delivery Plan checkpoint

Status: **Approved 2026-08-26**.

Delivery Planning is complete only when the maintainer can decide:

- the first proof's frontend stack, backend stack, topology, and local database;
- the ordered vertical slices and acceptance examples;
- the Skeleton scope and non-overlapping write roots;
- static, specialist, and connected verification for each slice;
- compatibility assumptions, failure handling, and delivery risks.

## Skeleton checkpoint

Status: **Approved 2026-08-26**.

Skeleton is complete only when the maintainer can decide:

- whether the file tree matches the approved sibling-aligned boundary;
- whether canonical policy and harness adapters are separated;
- whether every created file expresses an approved interface;
- whether any implementation behavior, dependency, or empty placeholder scope
  was introduced early;
- whether the first implementation slice can begin without restructuring the
  package.

## Implement checkpoint

An implementation slice is complete only when:

- its product-language outcome and write scope were approved in advance;
- it preserves the shared contract and specialist ownership boundaries;
- focused static and behavior checks pass;
- no later slice or unsupported harness behavior was added;
- the maintainer approves moving to the next slice or Test.
