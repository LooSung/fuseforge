# Logical Workspace Interface

Status: **Experimental classification and greenfield setup interface**.

The topology-neutral workspace shape contains:

| Field | Meaning |
|---|---|
| `coordination_root` | Product coordination root |
| `feature_id` | Stable feature identifier |
| `context` | `greenfield` or `existing` |
| `intent` | `feature`, `bug-fix`, or `refactor` |
| `topology` | `monorepo` or `polyrepo` |
| `frontend_target` | Optional frontend work target |
| `backend_target` | Optional backend work target |
| `required_tracks` | Required specialist tracks |
| `write_roots` | Track-owned writable paths |
| `base_revisions` | Optional target Git revisions |
| `pack_versions` | Observed pack versions |
| `harness` | Active verified harness |

Local coordinator state belongs under `.craft/fuseforge/` at the coordination
root. Absolute local paths do not belong in the tracked shared contract.

The first implementation slice may infer only:

- context;
- intent;
- required tracks;
- existing-workspace topology;
- explicit or safely observable stacks.

Missing required stacks and unspecified greenfield topology remain user
decisions. Harness selection is inferred from the active environment.

## Greenfield path layouts

Monorepo:

```text
<base>/<product-slug>/
  .gitignore
  .craft/fuseforge/task-<feature-slug>.md
  docs/features/<feature-slug>/contract.md
  frontend/
  backend/
```

Three-work-target layout:

```text
<base>/<product-slug>-coordination/
  .gitignore
  .craft/fuseforge/task-<feature-slug>.md
  docs/features/<feature-slug>/contract.md
<base>/<product-slug>-frontend/
<base>/<product-slug>-backend/
```

Before exact user confirmation, path handling is read-only. Show normalized
absolute coordination, frontend, backend, contract, and local-state paths.

An absent root is eligible. An existing empty directory is eligible only when
the checkpoint explicitly names it as reused. A non-empty directory, file, or
symlink blocks creation. Recheck immediately before mutation.

Never create a product under a FuseForge, Compforge, or OOPforge pack root.
Never run `git init`.

## Minimal local state

`.craft/fuseforge/task-<feature-slug>.md` stores:

- product and feature identifiers;
- stage, contract reference, and revision;
- context, intent, topology, and required tracks;
- selected stacks;
- absolute work-target paths;
- active harness and observed pack versions;
- created and reused paths;
- next pending decision.

The coordination-root `.gitignore` contains one `.craft/` entry. Product
meaning must not be copied into local state.

Base-revision capture, existing-project attachment, and write-root enforcement
remain deferred.
