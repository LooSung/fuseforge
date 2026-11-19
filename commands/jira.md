---
name: jira
description: Write one full-stack Jira issue, or the frontend and backend child tasks of one existing epic or story, from the specialist template without changing code.
argument-hint: "[card request, or the parent key for child tasks]"
---

If the user request is exactly `FUSEFORGE_ACTIVATION_PROBE`, output these three
lines and stop without reading other files:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

Read and execute the first path that exists:

1. `~/.claude/skills/fuseforge/workflow/jira.md` — skill-directory install
2. `${CLAUDE_PLUGIN_ROOT}/skills/workflow/jira.md` — session plugin

Prefer the first path. Reading `CLAUDE_PLUGIN_ROOT` can require an extra
approval that stops a non-interactive session before the workflow loads.

If neither path can be read, stop and report which paths failed. Never write a
card or a child without this workflow and the specialist template it names.

Jira issues are the only write. Never change code, tests, the shared contract,
or coordinator state.

User request:

**$ARGUMENTS**
