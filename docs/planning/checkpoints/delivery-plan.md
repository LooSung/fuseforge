# FuseForge — Delivery Plan

- Status: Approved for Skeleton
- Date: 2026-08-26
- Approved: 2026-08-26
- Inputs: Approved `docs/planning/checkpoints/discovery.md` and `docs/planning/checkpoints/design.md`

## 1. Delivery objective

Deliver the smallest reviewable FuseForge path that can:

1. accept one greenfield calendar request;
2. require the user to select missing frontend and backend stacks;
3. require the user to select an unspecified repository topology;
4. establish one tracked shared contract at `rev-1`;
5. delegate frontend and backend work through their specialist packs;
6. complete one calendar behavior through the real client/server boundary;
7. present one integrated product-language checkpoint.

The plan remains stack-neutral until the user completes the required selection
gate. No application Skeleton or source may be created before that selection.

## 2. Delivery rules

- Preserve the sequence `Delivery Plan → Skeleton → Implement → Test`.
- Implement one approved vertical slice at a time.
- Keep the shared feature contract authoritative for cross-stack meaning.
- Keep specialist methodology and stage artifacts in their owned tracks.
- Prefer sequential work; use parallel specialists only after the contract is
  stable and write roots are disjoint.
- Do not commit, push, create remotes, release, or deploy automatically.
- Do not add optional infrastructure or dependencies before a selected slice
  requires them.

## 3. Scope

### 3.1 In scope

- sibling-aligned FuseForge package and harness Skeleton;
- `craft` and read-only `consult` entry points;
- missing-only Compforge and OOPforge bootstrap behavior;
- installed-pack capability and activation checks;
- greenfield and existing-project routing;
- mandatory stack and topology ambiguity gates;
- tracked shared feature contract and `rev-N` revisions;
- local `.craft/fuseforge/` continuity;
- specialist delegation and track-result envelopes;
- integrated stage barriers, stale detection, retry, and resume;
- real frontend-client-to-backend connected verification;
- the approved calendar example delivered through separate vertical slices.

### 3.2 Out of scope

- tmux, persistent daemons, or a general-purpose multi-agent runtime;
- automatic commits, remotes, pushes, merges, releases, or deployments;
- silently choosing a stack or topology;
- changing or updating an existing Compforge or OOPforge installation;
- unsupported stacks, including Vue until Compforge supports it;
- external calendar-provider synchronization;
- background, email, or push notification delivery;
- per-user timezones and per-occurrence recurrence exceptions;
- production-readiness work;
- implementing all calendar capabilities in one slice.

## 4. Preconditions and user gates

### 4.1 Pack gate

During explicit FuseForge bootstrap:

1. inspect FuseForge, Compforge, and OOPforge locations;
2. install a missing specialist pack;
3. preserve every existing installation;
4. read the installed version and capability scope;
5. block with a repair message when an installed pack is incompatible;
6. verify activation before trusting delegated results.

Ordinary `craft` requests never update installed packs.

### 4.2 Stack gate

Before an application Skeleton:

- ask for the frontend stack when it is unspecified;
- ask for the backend stack when it is unspecified;
- combine both choices into one question when both are missing;
- show only capabilities from compatible loaded packs;
- explain Vite versus Next.js and Java versus Python only to the degree needed
  for the decision;
- derive the local database from the selected backend and ask again only if
  more than one materially different supported choice remains.

The gate closes without source changes if the user does not choose.

### 4.3 Topology gate

For greenfield work without a topology:

- ask the user to choose monorepo or three-repository polyrepo;
- explain that monorepo has one Git history while polyrepo has independent
  coordination, frontend, and backend histories;
- do not infer a topology from the current FuseForge pack checkout.

For existing work, infer topology from the supplied work targets and confirm
only when multiple roots or ownership are ambiguous.

### 4.4 Local path gate

FuseForge proposes product-name-based paths and asks for one confirmation.

For a three-repository selection:

```text
<product>-coordination/
<product>-frontend/
<product>-backend/
```

For a monorepo selection:

```text
<product>/
  frontend/
  backend/
```

After confirmation, greenfield setup may create the selected directories. It
does not run `git init`. Although Git initialization does not require user
identity, repository initialization remains outside the approved convenience
scope. It also does not create commits or remotes.

Until the user initializes Git, a three-repository selection is physically a
three-work-target directory layout. FuseForge must describe it that way and
must not claim independent repository histories yet.

## 5. Skeleton scope

After this Delivery Plan is approved, Skeleton may create structure without
coordinator behavior.

### 5.1 Root and canonical policy

```text
AGENTS.md
CLAUDE.md
README.md
skills/
  SKILL.md
  stability.json
  workflow/
    craft.md
    consult.md
  coordination/
    shared-contract.md
    logical-workspace.md
    delegation.md
    stage-barrier.md
    connected-verification.md
```

### 5.2 Harness adapters

```text
commands/
  craft.md
  consult.md
.claude-plugin/
  plugin.json
.codex-plugin/
  plugin.json
.cursor-plugin/
  plugin.json
  skills/fuseforge/SKILL.md
```

Adapters may point to canonical skills but contain no duplicated coordinator
policy.

### 5.3 Deferred setup and verification locations

```text
scripts/
  setup/
  ci/
docs/
  setup/
  reference/
  verification/
```

These directories are not created empty during Skeleton. Their first concrete
file is added only when a later approved slice requires setup or verification
behavior.

Skeleton creates only files needed to express approved interfaces. It does not
add working installers, CI behavior, examples, templates, dependencies, or
calendar source.

## 6. Delivery sequence

### Phase 1 — Coordinator foundation

Implement only the coordinator behavior required by the first product slice:

1. load and route `craft` and `consult`;
2. provide an explicit bootstrap that installs only missing specialist packs
   and preserves existing installations;
3. verify installed specialist capabilities and activation;
4. classify context, intent, topology, and required tracks;
5. stop at missing stack or topology gates;
6. propose and confirm greenfield paths;
7. create or load the tracked shared contract;
8. maintain local `.craft/fuseforge/` progress and `rev-N`;
9. delegate one stage and validate one track-result envelope;
10. combine required results behind one stage barrier.

Do not implement speculative schedulers, generalized workflow engines, plugin
registries, or autonomous recovery.

### Phase 2 — Calendar vertical slices

#### Slice 1 — Create and list schedules in month view

User outcome:

> Create a schedule and see it on the month view after it is saved.

Includes:

- one default internal calendar;
- title, start, end, location, and notes;
- create and list operations;
- application-local persistence;
- UTC persistence and application-timezone response offsets;
- loading, empty, saved, validation, and connection-error states;
- one real frontend-client-to-backend connected check.

Excludes update, delete, recurrence, reminders, multiple calendars, and other
views.

#### Slice 2 — Edit and delete schedules

User outcome:

> Change or remove an existing schedule and see the month view update.

Includes:

- update and delete;
- not-found and invalid-time errors;
- retry behavior that does not duplicate a completed write.

#### Slice 3 — Internal calendars and colors

User outcome:

> Organize schedules into internal calendars and distinguish them by color.

Includes calendar create, read, update, delete, schedule association, and
filtering. It excludes external provider accounts.

#### Slice 4 — Week, day, and year views

User outcome:

> View the same stored schedules at week, day, and year granularity.

This slice reuses existing schedule semantics and adds no new backend meaning
unless the selected specialist design identifies a required query boundary.

#### Slice 5 — Weekly and yearly recurrence

User outcome:

> Create a weekly or yearly recurring series and edit or delete the whole
> series.

Includes recurrence validation and occurrence projection. Per-occurrence
exceptions remain excluded.

#### Slice 6 — Foreground in-app reminders

User outcome:

> Receive a reminder while the application is open.

Includes reminder configuration and foreground display. It excludes service
workers, background jobs, email, and push delivery.

### Phase 3 — Coordinator proof scenarios

Exercise these scenarios against the smallest completed calendar slice that can
demonstrate them:

1. deliberate API-contract mismatch is rejected before completion;
2. a backend failure preserves valid frontend evidence;
3. a contract change from `rev-1` to `rev-2` marks dependent results stale;
4. only a failed or stale track is retried;
5. a clean session resumes from `.craft/fuseforge/` and the tracked contract.

## 7. Responsibility and write roots

| Area | Owner | Write boundary |
|---|---|---|
| FuseForge policy and adapters | Parent | FuseForge package paths approved by Skeleton |
| Shared contract and product-stage docs | Parent | Product coordination root |
| Frontend source and tests | Compforge specialist | Selected frontend work target |
| Backend source and tests | OOPforge specialist | Selected backend work target |
| Connected verification evidence | Parent | Coordination evidence location selected after Skeleton |

For monorepos, frontend and backend write roots must be disjoint before
parallel delegation. Shared files are parent-owned and never assigned to both
specialists.

## 8. Verification plan

### 8.1 Skeleton verification

- expected paths exist and no unapproved files are added;
- adapters point to one canonical policy location;
- no implementation behavior or specialist methodology is duplicated;
- no dependency or external service is introduced.

### 8.2 FuseForge static verification

After implementation is authorized:

- manifests reference existing skills and commands;
- the canonical skill and adapters agree on entry-point names;
- `FUSEFORGE_ACTIVATION_PROBE` has one positive and one isolated negative
  expectation;
- setup dry-run reports only missing-pack installation;
- existing specialist installations are not changed.

### 8.3 Specialist verification

Each calendar slice collects:

- Compforge-owned frontend tests and project-rule checks;
- OOPforge-owned domain, use-case, and HTTP adapter tests;
- the contract revision and target base revision used by each result.

Exact commands follow the stacks selected at the user gate and are recorded in
the slice's shared contract and specialist outputs.

### 8.4 Connected verification

Each completed calendar slice runs at least one check in which the actual
frontend API client calls a running backend.

The check verifies:

- approved request and response meaning;
- error mapping used by the frontend state;
- application-timezone offset behavior when time is involved;
- the current shared-contract revision.

OpenAPI-only validation does not satisfy this requirement. Browser E2E remains
outside the default scope.

## 9. Compatibility policy

- Record loaded pack versions and capabilities before delegation.
- Offer only stacks supported by those installed versions.
- Install only a missing specialist pack during explicit bootstrap.
- Preserve an existing compatible installation.
- Block and explain an incompatible installation; do not auto-update it.
- Keep Claude, Codex, and Cursor adapters thin and harness-specific.
- Do not assume subagent concurrency or shared environment inheritance.
- Preserve sequential execution as the compatibility baseline.
- When a work target has no Git history, record no `base_revision`, use
  contract-revision staleness only, and disclose the reduced code-drift
  assurance.

## 10. Failure and recovery

| Failure | Response |
|---|---|
| Missing stack or topology choice | Stop before Skeleton and ask one consolidated question |
| Missing specialist pack | Install during explicit bootstrap, then verify activation |
| Incompatible existing pack | Block with observed and required capability information |
| Activation probe failure | Reject delegated output and do not open the barrier |
| Specialist decision request | Parent resolves within approved behavior or asks the user |
| Track failure | Preserve valid results and retry only the failed track |
| Contract revision mismatch | Mark the result stale and revalidate affected work |
| Code base revision drift | Mark dependent Implement/Test evidence stale |
| Work target without Git history | Continue with contract-only staleness and report reduced assurance |
| User rejection | Keep artifacts, revise the smallest affected decision, and re-present |
| Cancellation | Record the stopped stage and one resumable next action |

## 11. Delivery risks

### Stack-neutral planning becomes branch explosion

Mitigation: keep one coordinator flow and select one concrete stack pair before
any application Skeleton. Do not implement all stack combinations in the first
proof.

### The sibling-aligned structure becomes empty boilerplate

Mitigation: Skeleton creates only approved interface files. Examples,
templates, working setup scripts, and CI wait until a slice needs them.

### Automatic installation changes existing environments

Mitigation: install only missing packs during explicit bootstrap. Never update,
replace, or relink a detected installation without a separate user decision.

### Polyrepo results drift independently

Mitigation: record each target's base revision, never claim atomic commits, and
mark dependent evidence stale when a target changes.

### Git-free greenfield targets cannot prove code revision drift

Mitigation: keep contract-revision checks active, state the reduced assurance,
and begin base-revision checks after the user initializes Git.

### Time conversion happens twice

Mitigation: persist UTC, return an explicit application-timezone offset, and
forbid a second implicit frontend conversion.

### Calendar scope expands

Mitigation: deliver the six slices separately and keep external sync,
background delivery, per-user timezones, and recurrence exceptions out.

### Connected verification turns into undeclared E2E

Mitigation: stop at the real frontend client and backend HTTP boundary. Add
browser automation only under a separately approved scope.

## 12. Delivery Plan checkpoint — approved 2026-08-26

The maintainer approved:

- the stack-neutral plan and mandatory stack/topology gates;
- product-name-based path suggestion and confirmation;
- directory creation without `git init`, commits, or remotes;
- the future Skeleton file scope;
- the six calendar vertical slices and proof scenarios;
- write-root ownership;
- static, specialist, and connected verification;
- compatibility, failure, recovery, and risk handling.

This approval authorizes Skeleton structure only. It does not authorize
coordinator behavior, working installers, CI, calendar source, or other
implementation.
