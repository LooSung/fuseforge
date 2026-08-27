---
name: fuseforge
description: Use FuseForge in Cursor for selection, confirmed greenfield setup, approved specialist Design integration, and read-only consult without creating product source.
---

# FuseForge Cursor Wrapper

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

Read and follow `../../../skills/SKILL.md`.

Treat `../../../skills/` as the canonical skill root. The coordinator delegates
specialist work and must not create calendar product source itself. A product
slice is complete only after the parent-owned connected check was recorded.
Consult is read-only by default and must not implement product behavior.

If a required policy file cannot be read, stop and report it. Never reconstruct
the workflow from memory or emit the response contract without having read the
policy that defines it. Never settle a track the request left silent.
