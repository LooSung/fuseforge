# FuseForge path convention

Commands and harness adapters reference canonical policy from the pack root.
They do not duplicate policy inside a harness-specific tree.

## Resolve pack roots

FuseForge:

1. `$FUSEFORGE_HOME` when set;
2. `~/.fuseforge` after installation;
3. the repository root while maintaining the pack.

Specialists:

1. `$COMPFORGE_HOME` or `$OOPFORGE_HOME`;
2. `~/.compforge` or `~/.oopforge`;
3. an explicitly supplied compatible checkout.

## Canonical source paths

```text
{pack}/skills/SKILL.md
{pack}/skills/workflow/craft.md
{pack}/skills/coordination/shared-contract.md
{pack}/skills/coordination/logical-workspace.md
{pack}/skills/coordination/delegation.md
{pack}/skills/coordination/stage-barrier.md
```

Claude commands and the Cursor wrapper route to this tree. Codex loads the same
canonical skill root.

## Product workspace boundary

Pack roots are never product roots. A product workspace stores its tracked
shared contract under `docs/features/<feature-slug>/contract.md` and local
coordinator progress under `.craft/fuseforge/`.

Absolute work-target paths belong only in local state, never in the tracked
shared contract.
