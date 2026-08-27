# FuseForge — Skeleton

- Status: Approved for first implementation slice
- Date: 2026-08-26
- Approved: 2026-08-26
- Inputs: Approved `docs/planning/checkpoints/design.md` and `docs/planning/checkpoints/delivery-plan.md`

## 1. Purpose

The Skeleton establishes the approved package and interface boundaries without
coordinator behavior.

## 2. Canonical policy surface

```text
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

`skills/` is the future canonical policy root. Every file is explicitly marked
as Skeleton-only and non-runnable.

## 3. Harness adapter surface

```text
CLAUDE.md
commands/
  craft.md
  consult.md
.claude-plugin/plugin.json
.codex-plugin/plugin.json
.cursor-plugin/
  plugin.json
  skills/fuseforge/SKILL.md
```

Commands and manifests define package shape only. The Cursor wrapper points
toward canonical policy without implementing workflow behavior.

## 4. Intentionally absent

- working activation probes;
- workflow execution and specialist invocation;
- bootstrap, install, doctor, or uninstall scripts;
- CI and harness smoke behavior;
- dependencies and external services;
- product workspace generation;
- calendar frontend or backend source;
- examples, templates, commits, and remotes.

## 5. Verification

- all four JSON files parse;
- all expected Skeleton files exist;
- no empty setup, CI, example, or template directory was created;
- skill and command files state that behavior is not implemented;
- canonical policy and harness adapters remain separate;
- lint and `git diff --check` report no errors.

## 6. Skeleton checkpoint — approved 2026-08-26

The maintainer approved the Skeleton and authorized planning the first
implementation slice. This approval does not authorize multiple slices,
calendar application code, or unplanned installer and CI behavior.
