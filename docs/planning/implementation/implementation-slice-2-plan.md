# FuseForge — Implementation Slice 2 Plan

- Status: Approved for implementation
- Date: 2026-08-26
- Approved: 2026-08-26
- Input: Approved `docs/planning/implementation/implementation-slice-1.md`
- Focus: Pack doctor and missing-only bootstrap

## 1. User outcome

From an existing FuseForge checkout, a developer can inspect whether Compforge
and OOPforge are ready without changing the environment:

```text
bash scripts/setup/bootstrap.sh
```

The report identifies each pack as compatible, missing, or incompatible and
shows only the changes needed for missing packs or harness links.

The developer explicitly applies that plan with:

```text
bash scripts/setup/bootstrap.sh --apply
```

Apply mode clones only missing packs, creates only missing harness links, and
preserves every existing compatible installation.

## 2. Recorded decisions

- Inspection and planning are the default; mutation requires `--apply`.
- Existing pack repositories are never pulled, updated, replaced, or relinked.
- Missing packs use the current default branch from their configured source.
- Existing versions are recorded but no numeric minimum version is forced.
- Compatibility is based on manifest consistency and required capability
  contracts.
- Claude and Codex reuse each specialist pack's default `install.sh` behavior.
- Cursor gets missing-only local plugin links under
  `~/.cursor/plugins/local/`.
- Ordinary `craft` never invokes bootstrap or changes the developer
  environment.

## 3. Observed specialist behavior

Both specialist packs provide:

- `scripts/setup/install.sh` with default skip-existing behavior;
- `scripts/setup/install.sh --dry-run`;
- `scripts/setup/doctor.sh`;
- static packaging and activation-probe checks;
- Claude and Codex symlink installation.

Both existing `scripts/setup/bootstrap.sh` implementations call an update path
that can pull and relink existing installations. FuseForge must not invoke
those bootstrap scripts or pass `update` or `--force` to specialist installers.

Neither specialist installer manages Cursor links. FuseForge owns only the
missing-only Cursor link adaptation in this slice.

## 4. Slice boundary

### 4.1 In scope

- read-only specialist doctor;
- pack-root resolution through explicit environment overrides and conventional
  home locations;
- status classification: `compatible`, `missing`, or `incompatible`;
- observed version and capability reporting;
- no-change bootstrap plan;
- explicit missing-only apply;
- missing Compforge and OOPforge clone;
- missing Claude, Codex, and Cursor adapter links;
- static activation-contract inspection;
- dependency-free isolated smoke verification.

### 4.2 Out of scope

- installing or cloning FuseForge itself;
- remote one-line FuseForge bootstrap;
- Git pull, update, checkout switching, replacement, or `--force`;
- repairing incompatible existing paths;
- deleting any existing pack, link, file, or directory;
- live paid/authenticated harness probes by default;
- product paths, shared contracts, coordinator state, or delegation;
- calendar source;
- CI workflow configuration.

## 5. Proposed file scope

```text
scripts/setup/
  bootstrap.sh
  doctor.sh
  lib/common.sh
scripts/ci/
  bootstrap-smoke.sh
docs/setup/
  bootstrap.md
```

Existing selection-gate policy may receive one sentence directing a missing
pack blocker to the explicit bootstrap command. No other workflow behavior
changes in this slice.

## 6. Pack resolution

### 6.1 Compforge

Resolve the first configured candidate:

1. `COMPFORGE_HOME`, when set;
2. `~/.compforge`.

When neither candidate exists, classify the pack as missing. Do not scan
arbitrary sibling directories.

Default missing-pack source:

```text
https://github.com/LooSung/compforge.git
```

`COMPFORGE_REPO_URL` and `COMPFORGE_BRANCH` may override source and branch for
development or isolated tests.

### 6.2 OOPforge

Resolve the first configured candidate:

1. `OOPFORGE_HOME`, when set;
2. `~/.oopforge`.

Default missing-pack source:

```text
https://github.com/LooSung/oopforge.git
```

`OOPFORGE_REPO_URL` and `OOPFORGE_BRANCH` may override source and branch.

An explicit environment path that exists but is invalid is incompatible, not
missing. FuseForge must not fall through to another pack silently.

## 7. Capability compatibility

### 7.1 Shared checks

A pack is compatible only when:

- `skills/SKILL.md` exists;
- Claude, Codex, and Cursor manifests exist and report one identical version;
- `skills/stability.json` parses;
- the pack's activation probe and expected loaded marker exist;
- the required support-scope contract exists.

The report records the observed version. It does not compare it with a hard
coded minimum.

### 7.2 Compforge contract

Require observable support for:

- TypeScript + React;
- Craft and Consult entry surfaces;
- `COMPFORGE_ACTIVATION_PROBE`;
- `COMPFORGE_LOADED`;
- `Assumptions`;
- `Component Contract`.

### 7.3 OOPforge contract

Require observable support for:

- Java Spring or Python FastAPI backend selection;
- Craft and Consult entry surfaces;
- `OOPFORGE_ACTIVATION_PROBE`;
- `OOPFORGE_LOADED`;
- `Assumptions`;
- `OOP Contract`.

If these checks fail, report the exact missing contract and a manual repair or
update suggestion. Do not modify the pack.

## 8. Bootstrap flow

### 8.1 Default plan mode

1. resolve both pack candidates;
2. validate every existing candidate;
3. inspect current harness link destinations;
4. stop immediately if any existing candidate or occupied link is
   incompatible;
5. print one deterministic report;
6. print the changes that `--apply` would make;
7. exit without filesystem or network mutation.

Planning a missing pack does not contact its remote.

### 8.2 Apply mode

1. run the complete read-only preflight;
2. clone each missing pack into a temporary sibling path;
3. validate its capability contract before moving it to the final home path;
4. invoke each compatible pack's `install.sh` in default mode for missing
   Claude and Codex links;
5. create a Cursor local plugin symlink only when its destination is absent;
6. run `doctor.sh`;
7. print the final observed versions, capabilities, and link states.

Apply must never invoke:

```text
specialist bootstrap.sh
install.sh update
install.sh --force
git pull
git fetch
```

A temporary clone created by the same failed operation may be removed. An
existing or successfully installed pack is never removed as rollback.

## 9. Harness links

### 9.1 Claude

Delegate missing-link creation to each pack's default installer:

```text
~/.claude/skills/compforge
~/.claude/commands/compforge
~/.claude/skills/oopforge
~/.claude/commands/oopforge
```

### 9.2 Codex

Delegate missing-link creation to each pack's default installer:

```text
~/.codex/skills/compforge
~/.codex/skills/oopforge
```

### 9.3 Cursor

FuseForge creates these only when absent:

```text
~/.cursor/plugins/local/compforge -> <resolved-compforge-root>
~/.cursor/plugins/local/oopforge  -> <resolved-oopforge-root>
```

An existing correct symlink is preserved. A different symlink or non-symlink
path is incompatible and blocks apply with a manual repair message.

## 10. Output contract

The plan and apply report uses one row per pack:

```text
Pack       Status        Version   Root
Compforge  compatible    <actual>  <resolved-root>
OOPforge   missing       -         ~/.oopforge
```

It then lists harness states and one of:

```text
No changes required.
Run with --apply to create only the listed missing items.
Bootstrap applied. Existing installations were preserved.
Bootstrap blocked. No changes were made.
```

No report may say a pack is activated from structure or links alone.
Activation is a separate evidence level.

## 11. Failure and recovery

| Failure | Required response |
|---|---|
| Invalid explicit pack root | Block before all mutations and name the failed contract |
| Manifest versions differ | Block; report each observed version |
| Existing wrong symlink | Block; preserve it and print manual repair guidance |
| Existing non-symlink destination | Block; preserve it and print manual repair guidance |
| Missing `git` for a required clone | Block apply before clone |
| Clone failure | Remove only the temporary clone and preserve other state |
| Cloned pack fails compatibility | Remove only the temporary clone and block |
| Specialist installer fails | Preserve completed missing-only work; report partial state and safe rerun |
| Doctor fails after apply | Report not-ready; do not auto-update or delete installations |

Rerunning the same command must be safe. A successful second run after apply
must report no changes required.

## 12. Verification plan

`scripts/ci/bootstrap-smoke.sh` uses an isolated temporary `HOME`, local pack
fixtures or local Git remotes, and no network.

Required scenarios:

1. default plan mode creates no files and performs no clone;
2. two compatible installed packs produce no-change output;
3. missing packs are the only planned changes;
4. `--apply` clones only missing packs from local test remotes;
5. second `--apply` is idempotent;
6. existing compatible links are unchanged;
7. missing Claude, Codex, and Cursor links are created;
8. wrong symlinks and non-symlink paths are preserved and block;
9. manifest-version mismatch blocks before mutation;
10. missing capability or activation contract blocks before mutation;
11. source contains no update, force, pull, or fetch execution path;
12. ordinary Craft selection-gate checks still pass.

Optional maintainer evidence may execute each specialist's live activation
probe in the current harness. It is not part of default bootstrap and does not
run in CI.

## 13. Risks

### Main is not a released version

Missing installs use current default-branch content, not a guaranteed latest
release tag. The report must show the observed manifest version after clone.

### Specialist installers have different detection details

FuseForge delegates only their established default missing-link behavior and
tests it in an isolated home. It does not copy or rewrite specialist install
logic.

### Partial apply across two packs

Preflight and temporary validation happen before links. If a later installer
fails, completed safe additions remain and the deterministic report supports a
rerun.

### Cursor discovery can leak through global home state

Smoke tests use isolated `HOME`. Live probes remain explicit maintainer
actions and must not be interpreted as clean isolation without that evidence.

### Capability text can drift

Check stable probe and contract markers plus manifest consistency. Do not parse
prose into a broad capability engine in this slice.

## 14. Human checkpoint — approved 2026-08-26

The maintainer approved:

- default plan mode and explicit `--apply`;
- capability-based compatibility without numeric version minimums;
- current default-branch source for missing packs;
- no update, repair, replacement, or deletion;
- missing-only Cursor local plugin links;
- exact five new files plus the scoped Craft blocker guidance;
- isolated no-network verification scenarios;
- the distinction between structural readiness and live activation.

This approval authorizes only this Pack doctor and missing-only bootstrap
slice. It does not authorize product workspaces, shared contracts, delegation,
or calendar source.
