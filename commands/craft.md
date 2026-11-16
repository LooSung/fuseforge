---
name: craft
description: Coordinate one full-stack feature across Compforge and OOPforge — selection gate, confirmed workspace, shared contract, specialist Design and Implement delegation, and connected verification.
argument-hint: "[full-stack feature request]"
---

If the user request is exactly `FUSEFORGE_ACTIVATION_PROBE`, output these three
lines and stop without reading other files:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

Read and execute the first path that exists:

1. `~/.claude/skills/fuseforge/workflow/craft.md` — skill-directory install
2. `${CLAUDE_PLUGIN_ROOT}/skills/workflow/craft.md` — session plugin

Prefer the first path. Reading `CLAUDE_PLUGIN_ROOT` can require an extra
approval that stops a non-interactive session before the workflow loads.

FuseForge writes no product source. Specialists write it under an approved
Implement delegation.

User request:

**$ARGUMENTS**
