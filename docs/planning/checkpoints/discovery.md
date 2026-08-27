# FuseForge — Product Discovery

- Status: Approved for Design
- Date: 2026-08-26
- Approved: 2026-08-26

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

The maintainer has selected a separate, thin coordinator as the product
boundary to carry into Design. This decision does not yet validate a particular
coordinator contract, state model, interface, or implementation.

## 4. Goals

- Accept one product-language work request and classify its context and intent.
- Maintain one shared interpretation of cross-stack behavior.
- Delegate frontend and backend decisions to the appropriate specialist pack.
- Present one combined human checkpoint per workflow stage.
- Support greenfield product work and existing-project feature, bug-fix, and
  refactoring work without conflating their approval criteria.
- Involve frontend, backend, or both tracks according to the actual scope.
- Treat monorepos and separate repositories as first-class contexts.
- Detect contract drift and stale specialist results.
- Own the evidence that client and server work together.
- Preserve the existing scope and workflow discipline of both specialist packs.
- Give the developer a familiar, low-friction entry point that hides internal
  coordinator terminology unless it is needed for a decision.

### Simplicity and cleanliness constraints

FuseForge should be clean without becoming elaborate. The intended influences
from Clean Architecture, Kent Beck, Martin Fowler, and Ponytail are practical:

- understand the existing flow before choosing a solution;
- build only the coordination behavior that current evidence requires;
- prefer an existing repository convention, standard capability, or installed
  mechanism before adding a new abstraction or dependency;
- keep product behavior changes separate from behavior-preserving refactoring;
- make boundaries and dependency direction explicit without adding layers,
  interfaces, or factories only to appear architectural;
- work in small, reviewable steps with the smallest meaningful check;
- never simplify away trust-boundary validation, data-loss prevention,
  security, accessibility, or required error handling.

Clean means that product policy, specialist methodology, and harness-specific
integration do not leak into each other. It does not mean maximizing the number
of packages or indirection points.

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
- Reproducing every sibling-pack file when FuseForge has no coordinator need
  for it.
- Adding speculative layers, extension points, dependencies, or configuration
  solely for possible future requirements.
- Turning the first proof into a general calendar product.
- Claiming a supported coordinator, command, installer, or reference
  application during Discovery.

## 6. Glossary

| Term | Working meaning |
|---|---|
| Feature | One user-visible outcome that may require client and server changes |
| Work context | Whether the request starts a greenfield product or changes an existing project |
| Work intent | Feature, bug fix, or behavior-preserving refactor |
| Repository topology | Monorepo or polyrepo placement of the required work targets |
| Coordinator | The parent workflow that owns shared decisions and stage barriers |
| Specialist pack | Compforge or OOPforge operating only in its supported scope |
| Track | Frontend or backend work performed under one shared feature |
| Work target | The repository or directory a specialist is allowed to inspect or change |
| Logical workspace | A coordinator view over one or more work targets |
| Shared feature contract | Product and wire semantics both tracks must obey |
| Specialist contract | The execution-level OOP Contract or Component Contract owned by its pack |
| Stage artifact | A specialist workflow document such as Discovery or Design output |
| Contract revision | Stable identity for the shared contract used by a result |
| Stage barrier | A gate that opens only when all required tracks have valid results |
| Vertical slice | One user behavior completed across required frontend and backend work |
| Connected verification | Evidence produced with the real client/server boundary involved |
| Stale result | A track result based on an older contract or incompatible code revision |

These terms are for internal coordination. Human checkpoints should use the
developer's product language rather than this glossary.

## 7. Actors

### Full-stack developer

Describes the requested outcome once, answers cross-stack decisions, and
approves the integrated output of each required stage.

### Maintainer

Defines FuseForge's product boundary, compatibility policy, evidence threshold,
and release claims.

### Parent agent

Owns user interaction, shared-contract decisions, stage state, delegation, and
combined reporting. It may resolve a cross-stack decision within approved
product behavior. A decision that changes product behavior must return to the
user in product language.

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

## 8. Operating contexts and request classification

Project maturity, work intent, repository topology, and track participation are
independent dimensions. FuseForge should classify them before selecting a
workflow.

### Project context

| Context | Discovery emphasis | Primary risk |
|---|---|---|
| Greenfield (0 to 1) | Product scope, supported stacks, boundaries, and initial ownership | Premature structure |
| Existing project | Current behavior, contracts, conventions, and the smallest affected slice | Drive-by redesign |

For an existing project, the relevant Compforge and/or OOPforge specialist
should first inspect the affected target and report its current structure,
contracts, and conventions. FuseForge then coordinates only the cross-stack
delta. It should not require a complete architectural reconstruction before a
small feature or bug fix can proceed.

Inspection expands in this order:

1. inspect the affected feature, contracts, and call paths;
2. if the necessary scope appears broader, ask the user whether that
   interpretation is correct;
3. inspect the whole repository architecture only when the answer remains
   ambiguous or the broader dependency cannot otherwise be established.

### Work intent

| Intent | Meaning | Routing constraint |
|---|---|---|
| Feature | Add or change user-visible behavior | Use the feature workflow appropriate to the size of the change |
| Bug fix | Restore intended behavior | Establish the expected behavior before selecting the smallest corrective path |
| Refactor | Improve structure while preserving behavior | Keep separate from feature work; reclassify if behavior must change |

Greenfield work normally enters through a product or feature flow. Existing
projects may use any of the three intents.

### Repository topology

| Topology | Coordination emphasis | Constraint |
|---|---|---|
| Monorepo | Work-root and shared-file ownership | Frontend and backend writes must not overlap during parallel work |
| Polyrepo | Coordination root, independent histories, and compatibility | Do not imply atomic commits across repositories |

### Track participation

A request may require both tracks, frontend only, or backend only. The
coordinator should not create work for an unaffected track. A future design
should normalize the required targets as a logical workspace without pretending
their Git behavior is identical.

### Desired user experience

The developer should be able to:

1. describe the desired product outcome once;
2. let FuseForge infer the likely context, intent, topology, and required
   tracks from the available project;
3. select both frontend and backend stacks when the request does not specify
   them;
4. answer only unresolved product decisions, presented as one consolidated
   set rather than specialist jargon;
5. approve one integrated result at each required checkpoint;
6. receive a short completion summary with connected evidence, remaining
   risks, and the next optional step.

Advanced contract, harness, and retry details should remain available for
inspection without becoming mandatory input for the default path.

Stack ambiguity is never resolved silently. FuseForge should present only the
stacks currently supported by the loaded specialist packs and explain the
meaningful trade-off in one short question. For example, Vue must not be
offered until Compforge actually supports it.

## 9. Representative experience

The following is a candidate experience used to expose cross-stack ambiguity;
it is not current FuseForge behavior:

1. The developer describes the calendar outcome once.
2. The coordinator classifies the project context, work intent, repository
   topology, and required tracks.
3. Discovery establishes product terms and unresolved cross-stack behavior.
4. Design records shared behavior and wire semantics, then asks each specialist
   for its own contract.
5. FuseForge presents one integrated Design checkpoint.
6. Delivery planning divides the feature into vertical slices.
7. Each slice is delegated with the same contract revision and explicit write
   target.
8. FuseForge accepts, rejects, or marks each track result stale.
9. Specialists run tests at their owned boundaries, and the coordinator owns
   the connected client/server evidence.
10. The developer receives one combined result and remaining risks.

Calendar decisions that would require explicit agreement include:

- the frontend and backend stacks;
- time and timezone rules;
- recurrence boundaries and validation;
- CRUD operations plus their error meanings;
- loading, empty, saved, reminder, and error UI states.

The calendar is the approved first proof subject, but this section does not
authorize its architecture or implementation.

## 10. Responsibility model for Design

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

The current packs also produce persisted stage artifacts such as
`docs/planning/checkpoints/discovery.md` and `docs/planning/checkpoints/design.md`. These documents are distinct from the
execution-level specialist contracts. Neither pack currently defines a
FuseForge contract revision, stale-result rule, or link back to a shared
cross-stack artifact.

The artifact format, storage path, schema language, and revision mechanism are
Design questions, not Discovery decisions.

## 12. Workflow, routing, and stage-barrier model for Design

For greenfield products and sufficiently large features, FuseForge should
preserve, not collapse, the shared high-level sequence:

1. Discovery
2. Design
3. Delivery Plan
4. Skeleton
5. Implement
6. Test

The approved difference is one integrated human checkpoint per stage:

- each required track, and only a required track, returns a result or a
  decision request;
- the parent checks the shared contract revision and work-target boundary;
- a failed track keeps the barrier closed without discarding valid evidence;
- a changed contract makes dependent results stale;
- the user approves the combined product-language result;
- only then may the next stage begin.

Implementation may use native subagents in parallel only when the shared
contract is stable and write targets do not overlap. Sequential execution must
remain valid.

Focused bug fixes may use the smallest valid specialist path after expected
behavior is established. Refactoring remains a separate behavior-preserving
workflow and must not be used to introduce product changes. The exact
coordinator routing and checkpoint rules for these focused paths are Design
questions.

## 13. Success criteria

Discovery was approved because the maintainer agreed that:

- one request can be represented without duplicating frontend/backend
  interpretation;
- cross-stack decisions have one clear owner;
- specialist packs retain their scopes and contracts;
- stage approval is integrated without removing required checkpoints;
- greenfield/existing context, feature/bug-fix/refactor intent,
  monorepo/polyrepo topology, and required-track participation are
  distinguishable;
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
- Familiar sibling-pack structure becomes an excuse to create unused files or
  duplicate specialist behavior.
- Clean Architecture becomes layer or interface theater rather than clear
  ownership and dependency direction.
- The calendar proof expands into external-provider synchronization,
  background delivery, production operations, or other unapproved scope.
- Internal contract and harness terminology leaks into the default user
  experience.
- The coordinator asks twice as many questions instead of presenting one
  integrated decision.

## 15. Current facts, decisions, and hypotheses

### Current facts

- The inspected Compforge checkout is version `1.3.3` and targets TypeScript
  and React frontends using Vite or Next.js.
- The inspected OOPforge checkout is version `1.4.2` and targets Java Spring
  and Python FastAPI backends.
- Both packs preserve Discovery through Test stages and human checkpoints for
  large new work while allowing focused paths for smaller requests.
- Both packs define an execution-level specialist Contract before
  implementation and also produce separate stage artifacts.
- Compforge exposes `COMPFORGE_ACTIVATION_PROBE`; OOPforge exposes
  `OOPFORGE_ACTIVATION_PROBE`. Their doctor scripts validate installation
  structure but do not by themselves prove that a running agent loaded the
  skill.
- Both packs support local `.craft/` continuity, but neither supplies a shared
  cross-stack contract revision, stale-result model, or coordinator state.
- Native subagent execution is already available in at least one target
  harness.
- This repository contains Discovery documentation only.

### Decisions recorded for the next Design

- FuseForge is a separate thin coordinator, not a mode inside either specialist
  pack and not mutual invocation between the packs.
- Request classification uses greenfield versus existing project as the context
  axis.
- Existing-project work distinguishes feature, bug fix, and
  behavior-preserving refactor intents.
- Monorepo versus polyrepo remains an independent topology axis.
- Frontend-only, backend-only, and full-stack participation are explicit; an
  unaffected track is not invoked.
- Refactoring stays separate from feature delivery and is reclassified if a
  behavior change becomes necessary.
- Existing-project inspection expands from the affected slice to user
  confirmation and only then to whole-repository architecture analysis.
- Future FuseForge harness packaging follows the recognizable sibling layout
  and naming conventions: root guidance and readme files plus the smallest
  applicable subset of `skills/`, `commands/`, `docs/`, `examples/`,
  `scripts/`, `.claude-plugin/`, `.codex-plugin/`, and `.cursor-plugin/`.
  Equivalent structure does not authorize copying specialist methodology or
  creating empty directories.
- Clean Architecture is interpreted as clear ownership, inward dependency
  direction, testable policy, and harness adapters at the boundary, not as a
  requirement for maximum layers.
- FuseForge presents one integrated checkpoint per stage. It coordinates
  cross-stack decisions within approved behavior and asks the user before
  changing product behavior.
- If a request omits either stack, FuseForge must ask the user to select the
  frontend and backend from the capabilities currently supported by the loaded
  packs. It does not silently default or advertise future support.
- The first proof is a greenfield (0 to 1) calendar delivered as multiple
  vertical slices rather than one large implementation.
- The approved calendar scope includes schedule CRUD with title, start and end
  times, location, and notes; weekly or yearly recurrence; in-app reminders;
  year, month, week, and day views; and internal calendars or categories with
  color distinction.
- The first proof uses an internal application database appropriate to the
  selected backend, such as H2 for Java Spring. It does not require an external
  managed data service.
- External calendar-account synchronization and background email or push
  delivery are outside the first proof.
- The first proof's stack combination, exact storage choice, folder layout,
  repository topology, and vertical-slice order will be selected during Design
  and Delivery Planning.
- The default user path should require one product-language request and only
  the minimum unresolved decisions.

### Hypotheses requiring validation in Design

- A logical workspace can describe monorepo and polyrepo targets with one model.
- A shared contract revision is sufficient to detect stale track results.
- Native subagents are sufficient for an initial proof; tmux is unnecessary.

## 16. Questions the Design must answer

These questions are the prioritized inputs to Design:

1. How does a logical workspace identify its coordination root, frontend and
   backend work targets, topology, and base revisions?
2. Where is the authoritative shared feature contract stored and versioned,
   especially for an existing polyrepo product?
3. What is the minimum contract representation, and how do product semantics,
   OpenAPI or another wire schema, specialist contracts, and specialist stage
   artifacts relate without becoming competing sources of truth?
4. How are specialist-pack versions, capability maturity, harness type, and
   successful activation probes recorded?
5. Which coordinator state must survive a session restart, where is it stored,
   and how does it coexist with each pack's local `.craft/` state?
6. What invalidates a track result besides shared-contract and base-revision
   changes?
7. Who may edit shared files in a monorepo, and how are non-overlapping write
   roots enforced before parallel work?
8. What is the minimum connected verification that involves the real
   client/server boundary while remaining below undeclared browser E2E and
   production-readiness work?
9. How do stage barriers represent user rejection, decision requests, partial
   success, failure, cancellation, retry, and stale results?
10. How do unsupported stacks, one-sided requests, focused bug fixes, and
    behavior-preserving refactors route without forcing an irrelevant track or
    bypassing required approval?
11. What is the smallest FuseForge-specific mapping of the sibling harness
    structure, and which sibling files are unnecessary because coordination
    does not own specialist methodology?
12. What single default entry point, progressive inspection, mandatory stack
    ambiguity check, progressive disclosure, and product-language checkpoint
    make the common path easy without hiding consequential decisions?
13. What product semantics and vertical-slice order deliver the approved
    calendar scope without turning it into one large implementation?

## 17. Selected first proof, not implementation authorization

The first proof is a greenfield calendar example delivered through multiple
vertical slices. It exists to exercise one shared contract, specialist
delegation, and a real client/server boundary.

The approved product scope includes:

- schedule create, read, update, and delete;
- title, start time, end time, location, and notes;
- weekly and yearly recurrence;
- reminders shown while the application is open;
- year, month, week, and day views;
- multiple internal calendars or categories distinguished by color;
- persistence in an application-local database selected with the backend
  stack.

The initial proof intentionally excludes external calendar-provider account
synchronization, reminders delivered after the application closes, email or
push delivery, and production deployment or operations.

The proof should test:

- one successful end-to-end slice;
- one deliberate API-contract mismatch;
- one backend failure with frontend evidence preserved;
- one contract revision that makes both prior results stale;
- one clean restart and resume.

Design must first establish the coordinator contract, ownership, state model,
interfaces, and the proof's product semantics. Delivery Planning then selects
the stacks after an explicit user choice, the exact local storage, repository
topology, and vertical-slice sequence. Approval of the proof subject does not
approve its architecture or implementation.

## 18. Human checkpoint — approved 2026-08-26

The maintainer approved the Discovery checkpoint and authorized entry into
Design. The approved decisions are:

- use a separate thin coordinator;
- classify greenfield and existing-project contexts separately;
- distinguish feature, bug-fix, and behavior-preserving refactor intents for
  existing projects;
- keep monorepo/polyrepo and track participation as independent dimensions;
- align future harness packaging with the smallest applicable Compforge and
  OOPforge structure;
- use practical Clean Architecture and minimum-solution principles rather than
  speculative layers;
- use progressive existing-project inspection rather than whole-repository
  analysis by default;
- require explicit frontend and backend stack selection when either is
  unspecified;
- use the bounded calendar scope in Section 17 as the first greenfield proof,
  delivered through separate vertical slices;
- keep external account synchronization and background notification delivery
  outside that proof;
- optimize the default path for one product-language request and minimal
  questions.

Design must answer the prioritized questions in Section 16 and end at its own
human checkpoint. This approval authorizes Design documentation only. It does
not authorize a coordinator skill, installer, manifest, CI, reference
application, calendar code, or other implementation.
