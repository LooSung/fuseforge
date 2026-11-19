# Jira Workflow

Contents: When to use · Template source · Card mode · Children mode · Prohibited · Completion

Status: **Experimental**.

Write one Jira issue, or the child tasks of one existing epic or story, for a
feature that spans the frontend and the backend. Jira issues are the only
write. Never write code, tests, the shared contract, a workspace, or
`.craft/fuseforge/` state.

## When to use

Use when one card, or one parent's children, covers both tracks. A request for
one track only stops and names `/compforge:jira` or `/oopforge:jira`.

## Template source

FuseForge keeps no Jira template of its own. Read the specialist file, the
first readable in this order, and report which one was read:

1. the loaded Compforge skill's `workflow/jira-card.md` or
   `workflow/jira-children.md` — in a skill-directory install,
   `~/.claude/skills/compforge/workflow/`, `~/.codex/skills/compforge/workflow/`,
   or the Cursor skill directory;
2. the loaded OOPforge skill's same files.

If neither is readable, stop, report which paths failed, and point to
`docs/setup/bootstrap.md`. Never reconstruct the template, its sections, or its
Jira-writing rules from memory.

The specialist file owns the template, the voice, the writing rules, and the
rules for writing to Jira, including writing only on an explicit request.
FuseForge changes only what the next sections name.

## Card mode

A request for one issue follows `jira-card.md` as written. In `영향 범위`, a
full-stack card names both the frontend and the backend repository and their
modules.
Children of a new card come in the next turn, as the specialist file says.

## Children mode

The parent epic or story already exists and the request asks for its children.
Follow `jira-children.md` with these changes, because the specialist file
assumes one home track per repository and FuseForge coordinates both:

- The header is
  `Mode: children | Parent: <key> (epic|story) | Home: F.E+B.E | Tracks: <tracks> | Count: <n>`.
  Do not ask for a home track.
- `[F.E]` and `[B.E]` are both home children. The second `개요` bullet names the
  track's work target when a FuseForge workspace exists — for example
  `프론트 저장소(<frontend_target>)에서 구현함` — and otherwise
  `프론트 저장소에서 구현함` or `백엔드 저장소에서 구현함`. Never use
  foreign-child wording for `[F.E]` or `[B.E]`.
- `[AI]` and `[DOC]` keep the specialist foreign-child rules.
- When this feature already has a FuseForge shared contract, each `[F.E]` and
  `[B.E]` child names the contract revision (`rev-N`) and the operations it
  implements or calls, under `참고`. Without one, follow the specialist rule:
  name only what the parent settled, and never invent an endpoint, a payload,
  or a revision.
- Keep the specialist order. When the `[F.E]` child calls an operation the
  `[B.E]` child adds, say so in one `[F.E]` `개요` bullet.
- The specialist cap of six children applies.

## Prohibited

- Never write code, tests, configuration, the shared contract, a workspace, or
  `.craft/fuseforge/` state.
- Never write to Jira without an explicit request in this turn.
- Never invent a contract revision, endpoint, track, owner, date, or estimate.
- Never write a single-track card or single-track children here.
- Never claim a specialist command ran; FuseForge reads the specialist file and
  follows it itself.

## Completion

Report the template file that was read, each title and whether it is home or
foreign, the issue key or that the text is ready to paste, tracks skipped
because they were unclear or already present, and the decisions left open.
