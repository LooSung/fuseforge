---
name: fuseforge
description: Use FuseForge for coordinated selection, confirmed greenfield setup, and approved specialist Design integration across Compforge and OOPforge.
---

# FuseForge

Status: **Experimental — approved coordinator slices 1–5**.

For `FUSEFORGE_ACTIVATION_PROBE`, output these three lines and stop without
reading other files:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

For a FuseForge Craft request:

1. Read `workflow/craft.md`.
2. Read `coordination/logical-workspace.md`.
3. Read `coordination/shared-contract.md`.
4. For an approved Design or Implement turn, read `coordination/delegation.md`
   and `coordination/stage-barrier.md`.
5. Execute only the implemented selection-gate, confirmed greenfield
   workspace, Design-integration, and Implement-delegation slices.

Before exact path confirmation, remain read-only. After confirmation, create
only the approved workspace directories, product-semantics contract `rev-1`,
local task state, and `.craft/` ignore entry.

Do not create frontend or backend source, initialize Git, or install
dependencies. Those belong to the specialist that owns the track, inside its own
work target, and only under an approved Implement delegation. Wire semantics
become authoritative only through the integrated checkpoint and parent-owned
`rev-2`.

Connected verification remains unimplemented, so never claim that a frontend
client was proven against a running backend.

`workflow/consult.md` and `coordination/connected-verification.md` remain
Skeleton interfaces.
