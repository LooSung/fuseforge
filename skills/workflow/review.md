# Review Workflow

Contents: When to use · Target · Split by track · Specialist reviews · Cross-stack checks · Report · Prohibited · Completion

Status: **Experimental**.

Review one finished change that touches both the frontend and the backend.
Each track is judged by its own specialist's review rules; FuseForge adds only
what neither half can see alone. Review reports findings and never changes
code, tests, configuration, the shared contract, or coordinator state.

## When to use

Use for a pull request, branch, pasted diff, or working tree whose changed
files fall in both tracks. A change in one track only stops and names
`/compforge:review` or `/oopforge:review` (Codex and Cursor:
`Use Compforge review:` or `Use OOPforge review:`). A review of a plan or a
shared contract without a code change is Consult's Review mode.

## Target

Resolve exactly one target in the specialists' order: pull request, branch
against its merge base with the default branch, pasted diff, then the working
tree against `HEAD`. Record the base commit (the short SHA of the reviewed
head, or `pasted`). Every track reviews that same target and base commit. If
the target has no diff, say so and stop.

## Split by track

Assign every changed file to a work target:

1. `.craft/fuseforge/` state, when it exists, names the frontend and backend
   work targets;
2. otherwise read the repository: the directories whose manifests show the
   frontend and backend stacks. State the split under `Assumptions`.

Files in neither target — root configuration, CI, shared docs — are listed
under **Not checked**. When a file's owner is ambiguous, ask instead of
guessing.

## Specialist reviews

For each track, read its own pack's review workflow and report which file was
read:

- frontend: the loaded Compforge skill's `workflow/review.md` — in a
  skill-directory install `~/.claude/skills/compforge/workflow/review.md`,
  `~/.codex/skills/compforge/workflow/review.md`, or the Cursor skill directory;
- backend: the loaded OOPforge skill's `workflow/review.md` at the same places.

Run each track as its own review — a fresh agent per track where the harness
has them, otherwise one track after the other in this session — with the
target, the base commit, and only that track's files. The specialist file owns
the checks, severity, finding format, tools, and `Next` commands. Drop its
pointer to the other pack: FuseForge covers both tracks.

If a track's review workflow cannot be read, stop that track, list the failed
paths under **Not checked**, and point to `docs/setup/bootstrap.md`. Never
reconstruct a specialist's checks or severity from memory.

## Cross-stack checks

FuseForge adds only findings that need both halves:

- a field, status code, or error shape the backend change alters while
  frontend code — changed in this diff or not — still sends or reads the old
  one;
- a frontend call, new or existing, to an operation the backend does not
  provide or no longer provides;
- with a shared contract (`docs/features/<slug>/contract.md`), any changed
  operation that differs from its current revision.

Without a contract, a cross-stack finding cites both lines: the backend wire
shape and the frontend code that sends or reads it. Use the specialists'
P1–P3 meaning: a broken API contract between the halves is P1.

## Report

Write in the user's language:

```markdown
## Review — <target> @ <base commit>

Before merge: <N> (P1 <a> · P2 <b>). Optional: <c> (P3).
Rules read: <frontend review path> · <backend review path>

### Frontend — Compforge
<the specialist report's levels, findings, and Next, verbatim>

### Backend — OOPforge
<the specialist report's levels, findings, and Next, verbatim>

### Cross-stack
<findings with both lines, or "none">

### Not checked
### Scope drift
### Next
```

The final `Next` orders the work: cross-stack fixes first, naming the
specialist command for each side, then each track's own `Next` lines in its
order. With no findings, say so and list what was checked.

## Prohibited

- Never change production code, tests, configuration, the shared contract, a
  workspace, or `.craft/fuseforge/` state.
- Never post to a pull request without an explicit request in this turn; then
  follow the specialist posting rule.
- Never judge one track by the other pack's rules, or copy a specialist check.
- Never report a cross-stack finding without the lines that prove it.
- Never present an unrun check or an unread rule file as passed.

## Completion

Report the target and base commit, the rule files read per track, the counts
per level per track and for cross-stack, the files not assigned to a track,
what was not checked, and the ordered `Next` commands.
