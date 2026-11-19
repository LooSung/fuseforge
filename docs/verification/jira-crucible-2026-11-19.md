# Jira and Crucible — 2026-11-19

- Subject: `/fuseforge:jira` (slice 11) and `/fuseforge:crucible` (slice 12)
- Harness: Claude Code 2.1.311, skill-directory install, macOS
- Session: `claude -p --tools Read`, reads allowed for the FuseForge checkout and
  the installed Compforge and OOPforge skills, in an empty scratch directory

## Results

| Run | Result |
|---|---|
| Jira, children of a pasted parent `DEMO-12` | Pass: `Home: F.E+B.E`, both children home, `[F.E]` named the `[B.E]` operation it calls, template read from Compforge `jira-children.md`, nothing written to Jira |
| Jira without read permission (first attempt) | **Failed**: wrote cards in a generic format. Fixed by the stop rule in `commands/jira.md` |
| Jira without read permission (after the fix) | Pass: stopped, named the denied path, wrote no card |
| Crucible, new calendar product, no stack named | Pass: `Assumptions` and `Selection Gate` (persistence, both stacks, topology), stopped, no file created |
| Static checks | `check-jira.py` 25/25 and `check-crucible.py` 23/23 markers caught under mutation |

## Limits

- Crucible was not run past the selection gate: no plan, delegation, connected
  check, refactor, or test.
- Codex CLI and Cursor Agent: static checks only.
- Real Jira writes, card mode, and a plugin-only install were not run live.
