---
name: fuseforge
description: Use FuseForge for coordinated selection, confirmed greenfield setup, approved specialist Design integration, and read-only consult across Compforge and OOPforge.
---

# FuseForge

Status: **Experimental — approved coordinator slices 1–9**.

For `FUSEFORGE_ACTIVATION_PROBE`, output these three lines and stop without
reading other files:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

For `FUSEFORGE_CONSULT_PROBE`, output these three lines and stop without
reading other files:

```text
FUSEFORGE_CONSULT_LOADED
Mode: answer
Write permission: none
```

For a FuseForge Consult request:

1. Read `workflow/consult.md`.
2. Execute only the implemented Consult workflow.
3. Never implement product behavior, change specialist source, or create a
   shared contract from Consult.

If a required Consult policy file cannot be read, stop and report which file
and why. Never reconstruct Consult from memory, and never emit `Mode` or any
other section of the Consult response contract without having read the policy
that defines it.

For a FuseForge Craft request:

1. Read `workflow/craft.md`.
2. Read `coordination/logical-workspace.md`.
3. Read `coordination/shared-contract.md`.
4. For an approved Design or Implement turn, read `coordination/delegation.md`
   and `coordination/stage-barrier.md`.
5. Before reporting a product slice complete, read
   `coordination/connected-verification.md`.
6. Execute only the implemented selection-gate, confirmed greenfield workspace,
   Design-integration, Implement-delegation, and connected-verification slices.

If a required policy file cannot be read, stop and report which file and why.
Never reconstruct the workflow from memory, and never emit `Assumptions`,
`Selection Gate`, or any other section of the response contract without having
read the policy that defines it. Output shaped like the gate, produced without
the gate, is indistinguishable from the real thing to the reader.

Never settle a frontend or backend track that the request left silent. Section
2.1 of `workflow/craft.md` makes an unresolved track a user decision.

Before exact path confirmation, remain read-only. After confirmation, create
only the approved workspace directories, product-semantics contract `rev-1`,
local task state, and `.craft/` ignore entry.

Do not create frontend or backend source, initialize Git, or install
dependencies. Those belong to the specialist that owns the track, inside its own
work target, and only under an approved Implement delegation. Wire semantics
become authoritative only through the integrated checkpoint and parent-owned
`rev-2`.

A product slice is complete only after the parent-owned connected check passed
and was recorded. Never claim that a frontend client was proven against a
running backend without that record.
