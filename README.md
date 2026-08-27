# FuseForge

FuseForge is an experimental thin full-stack coordinator for combining
[Compforge](https://github.com/LooSung/compforge) and
[OOPforge](https://github.com/LooSung/oopforge) through one full-stack feature
flow.

[English](./README.md) · [한국어](./README.ko.md)

## Status

Discovery, Design, Delivery Plan, Skeleton, the first four implementation
slices, and the experimental coordinator Test checkpoint are approved. The
package is not yet a complete coordinator.

The approved product direction is:

> A developer should be able to describe one product feature once, approve one
> integrated result per stage, and have the frontend and backend specialist
> packs work from the same product and API contract.

Compforge remains responsible for TypeScript and React frontend discipline.
OOPforge remains responsible for Java Spring and Python FastAPI backend
discipline. FuseForge is intended to own only cross-stack coordination,
shared-contract consistency, integrated checkpoints, and connected
verification.

## Current boundaries

- One full-stack feature flow is the product goal.
- Native subagents may be an execution mechanism, not the product itself.
- tmux-based multi-agent orchestration is not in the current scope.
- Monorepos and separate frontend/backend repositories are both relevant.
- Greenfield and existing-project work are separate operating contexts.
- Missing frontend or backend stacks must be selected by the user from the
  capabilities actually supported by the loaded specialist packs.
- The first proof subject is a bounded calendar delivered in vertical slices.
- No implementation starts before the Design, Delivery Plan, and Skeleton
  checkpoints approve it.

## Documentation

Use [docs/README.md](docs/README.md) to find setup, reference, project,
checkpoint, implementation, and verification documents.

- [Install](docs/setup/install.md)
- [Support scope](docs/reference/support-scope.md)
- [Path convention](docs/reference/path-convention.md)
- [Released-flow acceptance](docs/verification/released-flow-acceptance-2026-08-27.md)

## Discovery

Read [docs/planning/checkpoints/discovery.md](docs/planning/checkpoints/discovery.md) for the approved product boundary,
decisions, risks, and Design questions.

## Design

Read [docs/planning/checkpoints/design.md](docs/planning/checkpoints/design.md) for the current coordinator contract,
workspace and state models, specialist interfaces, calendar semantics, and
Delivery Plan handoff candidates. The Design checkpoint is approved.

## Delivery Plan

Read [docs/planning/checkpoints/delivery-plan.md](docs/planning/checkpoints/delivery-plan.md) for the stack-neutral
selection gates, proposed Skeleton scope, calendar vertical slices,
verification, compatibility, and risks. The Delivery Plan checkpoint is
approved.

## Skeleton

Read [docs/planning/checkpoints/skeleton.md](docs/planning/checkpoints/skeleton.md) for the approved package and
interface-only file tree that preceded the first implementation slice.

## First implementation slice

Read [docs/planning/implementation/implementation-slice-1.md](docs/planning/implementation/implementation-slice-1.md) for the
approved experimental selection-gate behavior and evidence. Cursor activation
and the read-only stop boundary were exercised live; Claude Code and Codex
adapter structure is statically verified only.

## Second implementation slice plan

Read
[docs/planning/implementation/implementation-slice-2-plan.md](docs/planning/implementation/implementation-slice-2-plan.md) for
the approved read-only pack doctor and explicit missing-only bootstrap plan.

## Second implementation slice

Read [docs/planning/implementation/implementation-slice-2.md](docs/planning/implementation/implementation-slice-2.md) for the
approved bootstrap behavior, safety boundaries, and evidence. Usage is in
[docs/setup/bootstrap.md](docs/setup/bootstrap.md). No apply was run against the
maintainer's real home during verification.

## Third implementation slice plan

Read
[docs/planning/implementation/implementation-slice-3-plan.md](docs/planning/implementation/implementation-slice-3-plan.md) for
the approved exact-path confirmation, greenfield directory creation, shared
contract `rev-1`, and local continuity plan.

Read [docs/planning/implementation/implementation-slice-3.md](docs/planning/implementation/implementation-slice-3.md) for the
approved policy and isolated Cursor evidence.

## Fourth implementation slice plan

Read
[docs/planning/implementation/implementation-slice-4-plan.md](docs/planning/implementation/implementation-slice-4-plan.md) for
the approved specialist Design delegation, result validation, integrated wire
checkpoint, and parent-owned contract `rev-2`.

Read [docs/planning/implementation/implementation-slice-4.md](docs/planning/implementation/implementation-slice-4.md) for the
approved policy and static evidence.

## Coordinator Test

Read [docs/verification/coordinator-test-2026-08-27.md](docs/verification/coordinator-test-2026-08-27.md) for the approved
Test checkpoint, and
[docs/verification/released-flow-acceptance-2026-08-27.md](docs/verification/released-flow-acceptance-2026-08-27.md) for the
re-verification against the published `v0.1.0`. Claude Code, Codex CLI, and
Cursor Agent activation all pass through the
[skill-directory install](docs/setup/install.md). Acceptance recorded five
install and documentation failures, all resolved, plus future enhancements that
remain open.

## Repository checks and releases

Run `bash scripts/ci/lint-skills.sh` for packaging, skill-registry, and
documentation-link checks. Pull requests run the same checks plus the approved
coordinator regressions.

FuseForge is MIT licensed and uses a manual release process. See the
[changelog](CHANGELOG.md) and
[release process](docs/reference/release-process.md). Readiness automation does
not create commits, tags, pushes, or GitHub Releases.

## Language policy

Skills, scripts, harness instructions, and enforceable policy use English as
their canonical language. Korean readers can use
[`README.ko.md`](./README.ko.md) and the conceptual
[`docs/reference/methodology.ko.md`](./docs/reference/methodology.ko.md) guide.
FuseForge does not maintain unstable per-skill translations.
