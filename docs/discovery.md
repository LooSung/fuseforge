# FuseForge — Product Discovery

Status: Draft for human checkpoint  
Date: 2026-08-26

## 1. Background

Compforge and OOPforge provide disciplined workflows for different halves of a
full-stack product:

- Compforge governs TypeScript and React frontend work.
- OOPforge governs Java Spring and Python FastAPI backend work.

Each pack can guide its own target well, but neither owns a product feature that
crosses the client/server boundary. A developer asking for a calendar feature
can therefore receive two locally reasonable implementations that disagree on
behavior, API meaning, errors, time semantics, or completion evidence.

Agent harnesses can already launch native subagents. The unresolved problem is
not how to run more agents. It is how to preserve one product decision across
two specialist workflows and report one coherent result to the developer.

## 2. Problem

A developer must currently coordinate frontend and backend work manually:

1. repeat or reinterpret the requirement for each specialist;
2. reconcile separate discoveries and design assumptions;
3. decide which side owns the API and cross-stack semantics;
4. align implementation order and contract changes;
5. determine whether both sides actually work together;
6. manage duplicated questions and approval checkpoints.

This creates contract drift, duplicated decision-making, and a gap between
"frontend tests pass plus backend tests pass" and "the feature works."

## 3. Product hypothesis

FuseForge can provide one full-stack feature flow over the two specialist
packs:

> Describe one product feature once, approve one integrated result per stage,
> and keep frontend and backend work aligned to one shared contract through
> connected verification.

FuseForge is hypothesized as a separate, thin coordinator rather than a mode
inside either specialist pack.

## 4. Goals

- Accept one product-language feature request.
- Maintain one shared interpretation of cross-stack behavior.
- Delegate frontend and backend decisions to the appropriate specialist pack.
- Present one combined human checkpoint per workflow stage.
- Support greenfield and existing-project feature work.
- Treat monorepos and separate repositories as first-class contexts.
- Detect contract drift and stale specialist results.
- Own the evidence that client and server work together.
- Preserve the existing scope and workflow discipline of both specialist packs.

## 5. Non-goals

- Replacing Compforge or OOPforge.
- Creating a general-purpose multi-agent runtime.
- Requiring tmux, persistent agent daemons, or autonomous agent-to-agent mail.
- Making independent frontend and backend changes appear atomically committed
  across repositories.
- Automatically committing, merging, pushing, releasing, or deploying changes.
- Supporting stacks outside the verified scopes of the specialist packs.
- Generating an entire application in one unreviewed turn.
- Selecting infrastructure or production architecture without user evidence.
- Claiming a supported coordinator, command, installer, or reference
  application during Discovery.

## 6. Glossary

| Term | Working meaning |
|---|---|
| Feature | One user-visible outcome that may require client and server changes |
| Coordinator | The parent workflow that owns shared decisions and stage barriers |
| Specialist pack | Compforge or OOPforge operating only in its supported scope |
| Track | Frontend or backend work performed under one shared feature |
| Work target | The repository or directory a specialist is allowed to inspect or change |
| Logical workspace | A coordinator view over one or more work targets |
| Shared feature contract | Product and wire semantics both tracks must obey |
| Specialist contract | OOP Contract or Component Contract owned by its pack |
| Contract revision | Stable identity for the shared contract used by a result |
| Stage barrier | A gate that opens only when all required tracks have valid results |
| Vertical slice | One user behavior completed across required frontend and backend work |
| Connected verification | Evidence produced with the real client/server boundary involved |
| Stale result | A track result based on an older contract or incompatible code revision |

These terms are for internal coordination. Human checkpoints should use the
developer's product language rather than this glossary.

## 7. Actors

### Full-stack developer

Describes the feature once, answers cross-stack decisions, and approves the
integrated output of each stage.

### Maintainer

Defines FuseForge's product boundary, compatibility policy, evidence threshold,
and release claims.

### Parent agent

Owns user interaction, shared-contract decisions, stage state, delegation, and
combined reporting. It is the only agent that may resolve a cross-stack
decision without returning to the user.

### Frontend specialist

Uses Compforge against the frontend work target. It owns components, state
placement, queries and mutations, accessibility, and frontend tests. It may not
unilaterally change shared semantics.

### Backend specialist

Uses OOPforge against the backend work target. It owns domain behavior,
use cases, ports, transaction boundaries, adapters, and backend tests. It may
not unilaterally change shared semantics.

### Agent harness

Provides the parent session and optional native subagents. Subagents are an
execution mechanism; FuseForge must not depend on a specific concurrency model
until compatibility is proven.

## 8. Operating contexts

Repository topology and project maturity are independent dimensions.

| Context | Discovery emphasis | Primary risk |
|---|---|---|
| Greenfield monorepo | Product scope, stacks, architecture, root layout | Premature structure |
| Greenfield polyrepo | Product scope plus ownership and coordination root | Cross-repo lifecycle |
| Existing monorepo | Current boundaries, contracts, conventions, affected slice | Drive-by redesign |
| Existing polyrepo | Current contracts, independent histories, compatibility | Drift and stale results |

A future design should normalize these contexts as a logical workspace without
pretending their Git behavior is identical.

## 9. Representative experience

A calendar request illustrates the desired flow:

1. The developer describes the calendar outcome once.
2. FuseForge identifies whether the work is greenfield or an extension and
   locates the frontend and backend targets.
3. Discovery establishes product terms and unresolved cross-stack behavior.
4. Design records shared behavior and wire semantics, then asks each specialist
   for its own contract.
5. FuseForge presents one integrated Design checkpoint.
6. Delivery planning divides the feature into vertical slices.
7. Each slice is delegated with the same contract revision and explicit write
   target.
8. FuseForge accepts, rejects, or marks each track result stale.
9. Specialist tests and connected verification run at their owned boundaries.
10. The developer receives one combined result and remaining risks.

Calendar decisions that would require explicit agreement include:

- timed events versus all-day events;
- timezone and daylight-saving behavior;
- interval boundary semantics;
- create, edit, cancel, and conflict behavior;
- API operations, errors, authorization, and concurrency;
- loading, empty, error, and conflict UI states.

The calendar is an example of cross-stack ambiguity, not an approved product
fixture or implementation scope.

## 10. Responsibility hypothesis

| Concern | FuseForge | Compforge | OOPforge |
|---|---|---|---|
| Product-language feature scope | Own | Consume | Consume |
| Shared behavior and wire semantics | Own | Validate and consume | Validate and consume |
| Integrated stage checkpoint | Own | Supply track result | Supply track result |
| Component and state design | Coordinate only | Own | None |
| Domain and transaction design | Coordinate only | None | Own |
| Frontend tests | Collect evidence | Own | None |
| Backend tests | Collect evidence | None | Own |
| Connected client/server evidence | Own | Participate | Participate |
| Cross-stack contract change | Decide or ask user | Request | Request |
| Specialist methodology | Do not duplicate | Own frontend | Own backend |

## 11. Shared feature contract hypothesis

The coordinator likely needs one authoritative artifact containing only facts
that cross track boundaries:

- feature identity, contract revision, and approved scope;
- user flows and acceptance examples;
- API operations, schemas, errors, and authentication meaning;
- cross-stack rules such as time, locale, ordering, idempotency, and
  concurrency;
- mapping between backend outcomes and named frontend states;
- responsibility and test-evidence ownership;
- explicit open decisions.

The OOP Contract and Component Contract should remain separate specialist
artifacts linked to this shared contract. Neither specialist should silently
rewrite it.

The artifact format, storage path, schema language, and revision mechanism are
Design questions, not Discovery decisions.

## 12. Workflow and stage-barrier hypothesis

FuseForge should preserve, not collapse, the shared high-level sequence:

1. Discovery
2. Design
3. Delivery Plan
4. Skeleton
5. Implement
6. Test

The proposed difference is one integrated human checkpoint per stage:

- each required track returns a result or a decision request;
- the parent checks the shared contract revision and work-target boundary;
- a failed track keeps the barrier closed without discarding valid evidence;
- a changed contract makes dependent results stale;
- the user approves the combined product-language result;
- only then may the next stage begin.

Implementation may use native subagents in parallel only when the shared
contract is stable and write targets do not overlap. Sequential execution must
remain valid.

## 13. Success criteria

Discovery will justify Design when the maintainer agrees that:

- one request can be represented without duplicating frontend/backend
  interpretation;
- cross-stack decisions have one clear owner;
- specialist packs retain their scopes and contracts;
- stage approval is integrated without removing required checkpoints;
- monorepo/polyrepo and greenfield/existing contexts are distinguishable;
- connected verification has an explicit owner;
- failure, staleness, and contract changes can be made visible to the user;
- the first proof can test the hypothesis without claiming broad support.

Future product success would require evidence that:

- frontend and backend outputs reference the same approved contract;
- a deliberate contract mismatch is detected before completion;
- a failed track can be retried without rerunning unrelated valid work;
- an existing project is extended without architectural drive-by changes;
- a connected feature check catches an error missed by isolated tests;
- clean sessions load the intended specialist packs without scope leakage.

## 14. Risks

- FuseForge grows into a general orchestrator and duplicates harness features.
- Shared-contract ownership becomes a third methodology instead of a thin
  coordination boundary.
- The two packs evolve independently and break coordinator assumptions.
- A polyrepo workflow implies atomicity it cannot provide.
- Multiple continuity documents compete or become stale.
- Frontend and backend agents modify shared files concurrently.
- Connected verification silently becomes undeclared browser E2E or production
  readiness.
- Generated client types are mistaken for complete behavioral compatibility.
- Existing architectures are replaced merely to fit a preferred fixture.
- The coordinator asks twice as many questions instead of presenting one
  integrated decision.

## 15. Current facts and hypotheses

### Current facts

- Compforge targets TypeScript and React frontends.
- OOPforge targets Java Spring and Python FastAPI backends.
- Both packs use Discovery through Test stages and human checkpoints for large
  work.
- Both packs define a specialist Contract before implementation.
- Native subagent execution is already available in at least one target
  harness.
- This repository contains Discovery documentation only.

### Hypotheses requiring validation

- A separate coordinator is smaller and safer than mutual pack invocation.
- One stage-level approval can represent both track outputs without hiding
  important decisions.
- A logical workspace can describe monorepo and polyrepo targets with one model.
- A shared contract revision is sufficient to detect stale track results.
- Native subagents are sufficient for an initial proof; tmux is unnecessary.
- React with Vite plus Python FastAPI is a useful first proof combination.

## 16. Open questions

1. Where is the coordination root for an existing polyrepo product?
2. Which repository, if any, versions the shared feature contract?
3. What is the minimum machine-readable contract: OpenAPI, a FuseForge schema,
   or both?
4. How are specialist-pack versions and compatibility recorded?
5. How does the parent prove that a requested skill actually loaded in each
   target harness?
6. Which state must survive a session restart, and where is it stored?
7. What invalidates a track result besides contract and base-revision changes?
8. Who may edit shared files in a monorepo?
9. What is the minimum connected verification that remains below explicit
   browser E2E and production-readiness gates?
10. How should unsupported stacks or a one-sided feature be routed?
11. How are user rejection, partial success, cancellation, and retry represented?
12. Should the first proof start from a greenfield fixture or an existing code
    pair?

## 17. Candidate proof, not an approved plan

A small calendar vertical slice using React with Vite and Python FastAPI is a
candidate because it exercises data queries, mutations, UI states, domain
rules, API errors, and time semantics.

A future proof could test:

- one successful end-to-end slice;
- one deliberate API-contract mismatch;
- one backend failure with frontend evidence preserved;
- one contract revision that makes both prior results stale;
- one clean restart and resume.

This candidate does not authorize creating an example, selecting architecture,
or implementing a coordinator.

## 18. Human checkpoint

Before Design, the maintainer should approve or revise:

- the problem and product hypothesis;
- the separate coordinator boundary;
- the actor and responsibility model;
- the four operating contexts;
- the shared-contract and stage-barrier hypotheses;
- the non-goals and first-proof boundary;
- the Open Questions that Design must answer.
