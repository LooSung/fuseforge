---
name: craft
description: Coordinate selection, confirmed greenfield setup, and approved specialist Design integration without creating product source.
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

The current implementation ends after approved specialist Design integration.
It must not create calendar product source.

User request:

**$ARGUMENTS**
