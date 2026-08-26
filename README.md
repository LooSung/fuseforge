# FuseForge

FuseForge is a product discovery for coordinating
[Compforge](https://github.com/LooSung/compforge) and
[OOPforge](https://github.com/LooSung/oopforge) through one full-stack feature
flow.

## Status

FuseForge is in **Discovery**. This repository currently defines the problem,
product boundary, actors, workflow hypotheses, and open questions. It does not
yet contain a coordinator skill, installer, runtime, or reference application.

The working hypothesis is:

> A developer should be able to describe one product feature once, approve one
> integrated result per stage, and have the frontend and backend specialist
> packs work from the same product and API contract.

Compforge remains responsible for TypeScript and React frontend discipline.
OOPforge remains responsible for Java Spring and Python FastAPI backend
discipline. FuseForge would own only cross-stack coordination, shared-contract
consistency, integrated checkpoints, and connected verification.

## Current boundaries

- One full-stack feature flow is the product goal.
- Native subagents may be an execution mechanism, not the product itself.
- tmux-based multi-agent orchestration is not in the current scope.
- Monorepos and separate frontend/backend repositories are both relevant.
- Greenfield and existing-project work are separate operating contexts.
- No implementation starts before the Discovery checkpoint is approved.

## Discovery

Read [docs/discovery.md](docs/discovery.md) for the current evidence,
hypotheses, risks, and open questions.
