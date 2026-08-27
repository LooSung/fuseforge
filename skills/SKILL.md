---
name: fuseforge
description: Use FuseForge for coordinated selection, confirmed greenfield setup, and approved specialist Design integration across Compforge and OOPforge.
---

# FuseForge

Status: **Experimental — approved coordinator slices 1–4**.

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
4. For an approved Design turn, read `coordination/delegation.md` and
   `coordination/stage-barrier.md`.
5. Execute only the implemented selection-gate, confirmed greenfield
   workspace, and Design-integration slices.

Before exact path confirmation, remain read-only. After confirmation, create
only the approved workspace directories, product-semantics contract `rev-1`,
local task state, and `.craft/` ignore entry.

Do not create frontend or backend source, initialize Git, or install
dependencies. Wire semantics become authoritative only through the integrated
checkpoint and parent-owned `rev-2`. Connected verification and calendar
implementation remain unimplemented.

`workflow/consult.md` and `coordination/connected-verification.md` remain
Skeleton interfaces.
