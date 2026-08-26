# FuseForge — Agent Instructions

## Mission

FuseForge explores a thin full-stack coordinator over Compforge and OOPforge.
It must preserve each specialist pack's scope while giving a developer one
feature-level workflow, shared contract, and integrated approval experience.

## Current stage

FuseForge is in **Discovery**.

- Read `docs/discovery.md` before proposing product structure.
- Separate observed facts, hypotheses, decisions, and open questions.
- Do not create implementation code, `SKILL.md`, installers, manifests, CI, or
  reference applications before the Discovery checkpoint is approved.
- Do not describe a candidate design as implemented or supported.

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
- Keep one source of truth for cross-stack semantics.
- Preserve monorepo and polyrepo as distinct contexts without assuming atomic
  commits across repositories.
- Do not add dependencies or external services during planning stages.
- Keep changes surgical and remove only artifacts created by the same change.
- Comments explain why; names explain what.

## Discovery checkpoint

Discovery is complete only when the maintainer can decide:

- whether the problem and target user are real;
- whether a separate coordinator is the correct product boundary;
- what must be shared between specialist tracks;
- what belongs explicitly outside the first Design;
- which open questions must be answered before Design.
