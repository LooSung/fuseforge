---
name: refactor
description: Restructure existing code in both tracks without behavior changes — each track by its own specialist's refactor rules, the API between them frozen, one approval before any edit.
argument-hint: "[what to clean up on the frontend and the backend]"
---

If the user request is exactly `FUSEFORGE_ACTIVATION_PROBE`, output these three
lines and stop without reading other files:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

Read and execute the first path that exists:

1. `~/.claude/skills/fuseforge/workflow/refactor.md` — skill-directory install
2. `${CLAUDE_PLUGIN_ROOT}/skills/workflow/refactor.md` — session plugin

Prefer the first path. Reading `CLAUDE_PLUGIN_ROOT` can require an extra
approval that stops a non-interactive session before the workflow loads.

If neither path can be read, stop and report which paths failed. Never edit
code without this workflow and the specialist refactor files it names.

Stop for approval before any edit. FuseForge writes no application source;
each track writes only inside its own work target.

User request:

**$ARGUMENTS**
