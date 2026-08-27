# FuseForge — Implementation Slice 3 Plan

- Status: Approved for implementation
- Date: 2026-08-26
- Approved: 2026-08-26
- Input: Approved `docs/planning/implementation/implementation-slice-2.md`
- Focus: Confirmed workspace paths and shared contract `rev-1`

## 1. User outcome

After the selection gate is complete, FuseForge presents one exact greenfield
workspace plan in the user's language.

Before confirmation, it creates nothing. After explicit confirmation, it
creates only:

- the selected monorepo or three-work-target directory structure;
- `docs/features/<feature-slug>/contract.md` at `rev-1`;
- `.craft/fuseforge/task-<feature-slug>.md`;
- a coordination-root `.gitignore` entry for `.craft/`.

It does not initialize Git or create frontend, backend, dependency, build, or
calendar implementation files.

## 2. Recorded decisions

- This slice handles greenfield work only.
- Product name, feature name, base directory, stacks, and topology must already
  be explicit.
- FuseForge proposes exact absolute paths and waits for one confirmation.
- Existing empty directories may be reused only when disclosed in that
  confirmation.
- Any non-empty destination returns to the existing-project flow.
- Minimal local continuity state is included.
- `rev-1` records approved calendar product semantics and acceptance examples.
- API operations, schemas, endpoint names, error codes, and authentication
  remain unresolved.
- No Git command is run.

## 3. Preconditions

The slice begins only when:

- the first selection gate is complete;
- required specialist packs are structurally compatible;
- frontend and backend stacks are selected;
- topology is `monorepo` or `polyrepo`;
- the product display name and filesystem slug are explicit;
- the feature slug is explicit;
- the base directory is explicit or can be proposed without using an installed
  FuseForge, Compforge, or OOPforge pack root.

If a product or feature name cannot be converted without guessing, ask for the
slug. Do not silently translate arbitrary user-language names.

For the selected calendar proof:

```text
product slug: calendar
feature slug: calendar
```

## 4. Path model

### 4.1 Monorepo

```text
<base>/calendar/
  .gitignore
  .craft/fuseforge/task-calendar.md
  docs/features/calendar/contract.md
  frontend/
  backend/
```

The monorepo root is the coordination root.

### 4.2 Three-work-target layout

```text
<base>/calendar-coordination/
  .gitignore
  .craft/fuseforge/task-calendar.md
  docs/features/calendar/contract.md
<base>/calendar-frontend/
<base>/calendar-backend/
```

Until the user initializes Git, these are work-target directories rather than
three repositories. FuseForge must not claim independent Git histories.

### 4.3 Base-directory safety

- Never create product paths inside the FuseForge, Compforge, or OOPforge pack
  root.
- Never infer the current FuseForge checkout as a product base.
- Expand `~` and show normalized absolute paths before confirmation.
- Reject `..` traversal that escapes the confirmed base.
- Treat symlink destinations as occupied and do not follow them for workspace
  creation.

## 5. Occupied-path policy

For every proposed root:

| Observed state | Response |
|---|---|
| Absent | Eligible for creation |
| Existing empty directory | Eligible only after the confirmation explicitly names it as reused |
| Existing non-empty directory | Stop and offer the existing-project flow |
| Existing file | Stop and ask for a different path |
| Existing symlink | Stop and ask for a different path |

Recheck all roots immediately before writing. A state change after confirmation
invalidates the plan and requires a new checkpoint.

## 6. Confirmation contract

Present:

```markdown
## Assumptions
- Context: greenfield
- Intent: feature
- Required tracks: frontend, backend

## Selection Summary
- Frontend stack: ...
- Backend stack: ...
- Topology: ...

## Workspace Plan
- Coordination root: ...
- Frontend target: ...
- Backend target: ...
- Shared contract: ...
- Local state: ...
- Existing empty directories reused: ...

## Safety
- No Git initialization
- No application source
- No dependency installation
```

Ask the user to create these exact paths or revise the plan. Stop after the
question.

Approval of a different earlier checkpoint is not path confirmation. The user
must confirm the exact paths shown in the current response.

## 7. Shared contract `rev-1`

Canonical path:

```text
docs/features/calendar/contract.md
```

### 7.1 Included authority

- feature identity and `rev-1`;
- approved calendar scope;
- schedule and internal calendar meanings;
- application timezone and UTC persistence meaning;
- weekly and yearly recurrence meaning;
- whole-series edit/delete behavior;
- foreground in-app reminder meaning;
- product-language acceptance examples;
- loading, empty, saved, validation, not-found, reminder, retryable, and
  non-retryable state meanings;
- exclusions from the approved Design;
- evidence ownership;
- unresolved cross-stack decisions.

### 7.2 Deliberately unresolved

- HTTP methods and endpoint paths;
- request and response field schemas;
- error codes and transport status mapping;
- authentication and authorization;
- idempotency and concurrency details;
- specialist component, domain, use-case, port, and transaction design.

Unresolved wire sections keep the specialist Design barrier closed. They are
not track-local guesses.

### 7.3 Excluded metadata

The tracked shared contract does not contain:

- absolute local paths;
- installed pack locations;
- harness identity;
- pack versions;
- mutable session progress.

## 8. Local continuity state

Canonical path:

```text
.craft/fuseforge/task-calendar.md
```

It records:

- product and feature identifiers;
- current stage;
- contract path and `rev-1`;
- context, intent, topology, and required tracks;
- selected stacks;
- absolute coordination, frontend, and backend targets;
- active harness and observed specialist versions;
- paths created or reused by this operation;
- next pending decision.

The coordination root `.gitignore` contains:

```text
.craft/
```

The task state is local progress, not a second source of product truth.

## 9. Mutation and rollback

After exact confirmation:

1. revalidate pack roots and proposed product roots;
2. record which paths are absent and which are reused empty directories;
3. create only the approved directory tree;
4. write the shared contract;
5. write local task state;
6. write or extend `.gitignore` with one `.craft/` entry;
7. verify every created artifact and ensure frontend/backend targets remain
   empty.

If the operation fails:

- remove only files created by this operation;
- remove only directories created by this operation that remain empty;
- never remove a reused directory;
- never alter unrelated `.gitignore` content;
- report the smallest safe retry.

Writing `.gitignore` must preserve existing lines and avoid duplicate `.craft/`
entries.

## 10. Proposed implementation scope

Modify canonical policy only:

```text
skills/SKILL.md
skills/workflow/craft.md
skills/coordination/logical-workspace.md
skills/coordination/shared-contract.md
```

Add focused verification:

```text
scripts/ci/check-workspace-contract.py
```

Harness adapters remain thin and unchanged because all three already route to
canonical policy.

## 11. Verification plan

### 11.1 Static policy

The dependency-free check verifies:

- selection completion is required;
- exact path confirmation is required;
- no path mutation occurs before confirmation;
- monorepo and polyrepo layouts match this plan;
- non-empty and symlink roots block;
- no Git or application source is authorized;
- the contract and local-state authority split is explicit;
- API/wire details remain unresolved;
- all three harness adapters still point to canonical policy.

### 11.2 Isolated live Cursor scenarios

Use temporary base directories and the local FuseForge plugin:

1. incomplete path request stops without creating files;
2. a complete but unconfirmed plan stops without creating files;
3. an explicitly confirmed monorepo creates only approved paths;
4. an explicitly confirmed polyrepo creates only approved paths;
5. an existing empty root is reused only when named;
6. a non-empty or symlink root blocks without mutation.

After each successful creation:

- no `.git/`, package manifest, dependency lock, or application source exists;
- `contract.md` contains `rev-1` and approved product semantics;
- local state contains absolute paths but the contract does not;
- frontend and backend targets are empty.

Authenticated live checks are maintainer evidence, not hosted CI.

## 12. Risks

### Agent confirmation can be ambiguous

Require the current response's exact paths to be confirmed. Do not reuse a
generic “continue” from another checkpoint.

### Product semantics may look like a complete wire contract

Mark wire sections unresolved and keep delegation blocked until specialists
return their Design artifacts.

### Local state may become a second contract

Restrict it to paths, versions, stage progress, and references. Product meaning
stays only in tracked `contract.md`.

### Existing empty directories may change concurrently

Recheck immediately before writing and invalidate the confirmation on drift.

### Rollback may remove user content

Track created versus reused paths and remove only artifacts created by the same
operation.

## 13. Human checkpoint — approved 2026-08-26

The maintainer approved:

- greenfield-only scope;
- exact path confirmation and pack-root exclusion;
- monorepo and three-work-target layouts;
- empty-directory reuse and occupied-path blocking;
- contract `rev-1` product-only depth;
- minimal local continuity state and `.gitignore`;
- no Git, dependencies, or application source;
- rollback ownership;
- static and isolated live verification.

This approval authorizes only the greenfield workspace and product-semantics
`rev-1` slice. It does not authorize application source or resolved wire
semantics.
