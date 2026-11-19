# FuseForge — Implementation Slice 11

- Status: Implemented; statically and behaviorally verified on Claude Code
- Plan: [implementation-slice-11-plan.md](implementation-slice-11-plan.md)

## Result

`/fuseforge:jira` writes one full-stack card, or the `[F.E]` and `[B.E]` home
children of one epic or story, from the specialist Jira template.

## Evidence

- `scripts/ci/check-jira.py` passes. Each of its 25 pinned markers was removed,
  one at a time and with line breaks ignored, in a copy of the repository, and
  the check failed every time. The path order and the registry entry were
  mutated separately and also failed.
- Live Claude Code 2.1.311, skill-directory install, `--tools Read`, with a
  pasted parent `DEMO-12`: the header was
  `Mode: children | Parent: DEMO-12 (story) | Home: F.E+B.E | Tracks: F.E, B.E | Count: 2`;
  both children were home (`프론트 저장소에서 구현함`, `백엔드 저장소에서 구현함`);
  the `[F.E]` child named the `POST /schedules` operation the `[B.E]` child adds;
  the report named `~/.claude/skills/compforge/workflow/jira-children.md` as the
  template read. Nothing was written to Jira.
- The first live run had no read permission for the workflow and wrote cards in
  a generic format anyway. `commands/jira.md` now stops when neither path can be
  read. The same run without read permission then stopped, named the denied
  path, and wrote no card.

## Not verified

- Codex CLI and Cursor Agent: static checks only.
- Writing to a real Jira site.
- Card mode, the stop for a single-track request, and citing an existing shared
  contract: covered by static checks, not by a live run.
- A plugin-only install, where the specialist skill lives in the plugin cache.
