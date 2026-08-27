---
name: consult
description: Answer, compare, review, or write one planning document for coordinated full-stack work without implementation changes.
---

If the user request is exactly `FUSEFORGE_CONSULT_PROBE`, output these three
lines and stop without reading other files:

```text
FUSEFORGE_CONSULT_LOADED
Mode: answer
Write permission: none
```

Read and execute the first path that exists:

1. `~/.claude/skills/fuseforge/workflow/consult.md` — skill-directory install
2. `${CLAUDE_PLUGIN_ROOT}/skills/workflow/consult.md` — session plugin

Prefer the first path. Reading `CLAUDE_PLUGIN_ROOT` can require an extra
approval that stops a non-interactive session before the workflow loads.

Consult is read-only by default. It must not implement product behavior,
change specialist source, or create a shared contract.

User request:

**$ARGUMENTS**
