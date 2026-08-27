# FuseForge

FuseForge is an experimental thin full-stack coordinator for combining
[Compforge](https://github.com/LooSung/compforge) and
[OOPforge](https://github.com/LooSung/oopforge) through one full-stack feature
flow.

[English](./README.md) · [한국어](./README.ko.md)

## Status

Discovery, Design, Delivery Plan, Skeleton, eight implementation slices, and the
experimental coordinator Test checkpoint are approved. The package is not yet a
complete coordinator.

### What has actually been proven

On 2026-08-27 the whole flow ran once, end to end, and produced a working
feature:

> A user creates a schedule and sees it on the month view after it is saved.

FuseForge took one feature request, fixed a shared contract, delegated Design and
then Implement to Compforge and OOPforge, rejected a specialist result that
claimed an artifact it had not written, and proved the real frontend API client
against a running backend. The calendar product lives outside this repository by
design; this package holds only coordinator policy and evidence.

Evidence: [calendar Slice 1](docs/verification/calendar-slice-1-2026-08-27.md).

That is one slice, one stack pair, one harness. It shows the flow works; it does
not promise other stacks, harnesses, or later slices. Read the
[support scope](docs/reference/support-scope.md) before relying on anything.

The approved product direction is:

> A developer should be able to describe one product feature once, approve one
> integrated result per stage, and have the frontend and backend specialist
> packs work from the same product and API contract.

Compforge remains responsible for TypeScript and React frontend discipline.
OOPforge remains responsible for Java Spring and Python FastAPI backend
discipline. FuseForge is intended to own only cross-stack coordination,
shared-contract consistency, integrated checkpoints, and connected
verification.

## Install

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/LooSung/fuseforge/main/scripts/setup/quickstart.sh)"
```

This clones or updates `~/.fuseforge` and installs it into the harnesses it finds.
Then add the specialist packs, which FuseForge cannot delegate without:

```bash
bash ~/.fuseforge/scripts/setup/bootstrap.sh          # print a plan first
bash ~/.fuseforge/scripts/setup/bootstrap.sh --apply  # create missing items only
bash ~/.fuseforge/scripts/setup/doctor.sh             # check the result
```

Removal is `bash ~/.fuseforge/scripts/setup/uninstall.sh`, which removes only the
symlinks it created. Note that unlike the sibling packs, FuseForge's
`bootstrap.sh` installs its *specialists*; `install.sh` installs FuseForge. See
[Install](docs/setup/install.md) for pinned releases, flags, and manual setup.

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
- [Calendar Slice 1 proof](docs/verification/calendar-slice-1-2026-08-27.md)

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

## Implementation slices

Each slice has an approved plan and an evidence record. The index is
[docs/planning/implementation/README.md](docs/planning/implementation/README.md).

| Slice | Scope |
|---|---|
| 1 | Request classification and the selection gate |
| 2 | Read-only pack doctor and explicit missing-only bootstrap |
| 3 | Exact-path greenfield workspace and shared contract `rev-1` |
| 4 | Specialist Design delegation and parent-owned `rev-2` |
| 5 | Specialist Implement delegation, write roots, and dependency ownership |
| 6 | Parent-owned connected verification and the slice completion barrier |
| 7 | Asking about persistence instead of silently deciding the backend track |
| 8 | Self-install, uninstall, and doctor parity with the sibling packs |

Slices are approved one at a time, and no slice was implemented before its plan
was approved.

## Coordinator Test

Read [docs/verification/coordinator-test-2026-08-27.md](docs/verification/coordinator-test-2026-08-27.md) for the approved
Test checkpoint, and
[docs/verification/released-flow-acceptance-2026-08-27.md](docs/verification/released-flow-acceptance-2026-08-27.md) for the
re-verification against the published `v0.1.0`. Claude Code, Codex CLI, and
Cursor Agent activation all pass through the
[skill-directory install](docs/setup/install.md). Acceptance recorded five
install and documentation failures, all resolved, plus future enhancements that
remain open.

Read [docs/verification/calendar-slice-1-2026-08-27.md](docs/verification/calendar-slice-1-2026-08-27.md)
for the first execution of the full flow, including the connected check and the
Design result the barrier rejected.

## Repository checks and releases

Run `bash scripts/ci/lint-skills.sh` for packaging, skill-registry, and
documentation-link checks. Pull requests run the same checks plus the approved
coordinator regressions.

FuseForge is MIT licensed and uses a manual release process. See the
[changelog](CHANGELOG.md) and
[release process](docs/reference/release-process.md). Readiness automation does
not create commits, tags, pushes, or GitHub Releases.

## Contributing

Read [`AGENTS.md`](AGENTS.md) and
[`.github/CONTRIBUTING.md`](.github/CONTRIBUTING.md) before opening a pull
request. FuseForge approves one stage at a time, so a change that implements an
unapproved stage becomes an issue rather than a merge. An overstated support
claim is treated as a defect; report one with the
[claim-gap template](.github/ISSUE_TEMPLATE/claim-gap.md).

- [Code of Conduct](.github/CODE_OF_CONDUCT.md)
- [Security policy](.github/SECURITY.md)
- [Reviewer checklist](docs/reference/reviewer-checklist.md)

## Language policy

Skills, scripts, harness instructions, and enforceable policy use English as
their canonical language. Korean readers can use
[`README.ko.md`](./README.ko.md) and the conceptual
[`docs/reference/methodology.ko.md`](./docs/reference/methodology.ko.md) guide.
FuseForge does not maintain unstable per-skill translations.
