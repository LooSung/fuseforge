---
name: crucible
description: Run one full-stack slice end to end — plan, specialist Design and Implement, connected check, specialist Refactor when earned, and Test — stopping for plan and rev-2 approval.
argument-hint: "[the full-stack slice to plan, build, refactor, and test]"
---

If the user request is exactly `FUSEFORGE_ACTIVATION_PROBE`, output these three
lines and stop without reading other files:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

Read and execute the first path that exists:

1. `~/.claude/skills/fuseforge/workflow/crucible.md` — skill-directory install
2. `${CLAUDE_PLUGIN_ROOT}/skills/workflow/crucible.md` — session plugin

Prefer the first path. Reading `CLAUDE_PLUGIN_ROOT` can require an extra
approval that stops a non-interactive session before the workflow loads.

If neither path can be read, stop and report which paths failed. Never run a
stage without this workflow and the stage's own policy file.

FuseForge writes no application source or tests; the specialists do. Stop for
the plan approval and the `rev-2` approval.

User request:

**$ARGUMENTS**
