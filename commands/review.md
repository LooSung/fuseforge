---
name: review
description: Review one full-stack diff, branch, or pull request with each track's specialist review rules plus cross-stack checks, without changing code.
argument-hint: "[pull request, branch, or nothing for the working tree]"
---

If the user request is exactly `FUSEFORGE_ACTIVATION_PROBE`, output these three
lines and stop without reading other files:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

Read and execute the first path that exists:

1. `~/.claude/skills/fuseforge/workflow/review.md` — skill-directory install
2. `${CLAUDE_PLUGIN_ROOT}/skills/workflow/review.md` — session plugin

Prefer the first path. Reading `CLAUDE_PLUGIN_ROOT` can require an extra
approval that stops a non-interactive session before the workflow loads.

If neither path can be read, stop and report which paths failed. Never write a
review without this workflow and the specialist review files it names.

Review writes nothing. Never change code, tests, the shared contract, or
coordinator state.

User request:

**$ARGUMENTS**
