# FuseForge — Released-Flow Acceptance

- Status: Approved
- Date: 2026-08-27
- Approved: 2026-08-27
- Subject: published `v0.1.0`, commit `1c9ac96`
- Method: fresh `git clone --branch v0.1.0` from the public remote, run from a
  clean session with an isolated temporary workspace

This record supersedes the harness claims in
[`coordinator-test-2026-08-27.md`](coordinator-test-2026-08-27.md). Observed
failures and future enhancements are kept separate below.

## Automated evidence from the clean checkout

All repository checks pass from the released tag with no local modification:

```text
bash -n scripts/setup/*.sh scripts/setup/lib/*.sh scripts/ci/*.sh
shellcheck scripts/setup/*.sh scripts/setup/lib/*.sh scripts/ci/*.sh
bash scripts/ci/lint-skills.sh
python3 scripts/ci/test-doc-links.py
python3 scripts/ci/check-release-readiness.py
python3 scripts/ci/check-selection-gate.py
python3 scripts/ci/check-workspace-contract.py
python3 scripts/ci/check-delegation-barrier.py
bash scripts/ci/bootstrap-smoke.sh
git diff --check
```

`doctor.sh` and `bootstrap.sh` without `--apply` reported status, planned only
missing items, and left the checkout unmodified.

## Coordinator flow evidence

The full Craft flow was exercised through Claude Code against `v0.1.0`.

| Turn | Expectation | Result |
|---|---|---|
| 1 | Selection gate asks only unresolved choices and writes nothing | Passed: frontend stack, backend stack, and topology asked; workspace empty |
| 2 | Exact-path workspace plan stays read-only | Passed: Assumptions, Selection Summary, Workspace Plan, and Safety present; workspace empty |
| 3 | Confirmation creates only approved artifacts | Passed: `.gitignore`, `contract.md`, and local task state only |
| 4 | Design delegation keeps the tracked contract unchanged | Passed: disjoint specialist Design roots, local proposal only, contract still `rev-1` |
| 5 | Approval lets the parent apply `rev-2` | Passed: `rev-2` applied, local state advanced to `design-integrated` |

Boundary checks after every turn:

- no `git init`, commit, or remote;
- no dependency manifest, lockfile, or application source;
- frontend and backend targets empty until their specialist Design turn;
- contract `rev-1` carried no local absolute path;
- local task state carried absolute paths and the next pending decision.

## Live harness activation

| Harness | Install path | Result |
|---|---|---|
| Claude Code | `~/.claude/skills/fuseforge` | Passed: three probe lines, no extra flags |
| Codex CLI | `~/.codex/skills/fuseforge` | Passed: three probe lines, `codex-cli 0.148.0` |
| Cursor Agent | `~/.agents/skills/fuseforge` | Passed: three probe lines, no extra flags |
| Claude Code | `--plugin-dir` | Passed only with an added `--add-dir` grant |
| Cursor Agent | `--plugin-dir` | Failed: skill absent from the loaded skill list |
| Cursor Agent | `~/.cursor/plugins/local/fuseforge` | Failed: skill absent from the loaded skill list |

Live Codex activation is now proven. The HTTP 401 recorded at the coordinator
Test checkpoint was an unauthenticated environment, not a packaging failure.

## Observed failures

### F1 — the documented Cursor install did not load the skill

`cursor-agent --plugin-dir <checkout>` returned free-form text instead of the
three probe lines, and `fuseforge` was absent from the loaded skill list while
`compforge` and `oopforge` were present. A `~/.cursor/plugins/local` link
behaved identically. A minimal synthetic plugin with a root `plugin.json` and a
`skills/` directory also failed to load, so the limitation is in
plugin-directory skill loading on Cursor Agent `2026.08.25`, not in the
FuseForge manifest.

Linking the canonical `skills/` directory into a skill directory produced the
exact three lines. Resolution: the skill-directory install in
[`../setup/install.md`](../setup/install.md) is now the documented path, and
`bootstrap.sh` links `~/.agents/skills/` instead of `~/.cursor/plugins/local/`.

### F2 — the documented Claude Code command was incomplete

With a working directory outside the checkout, `claude --plugin-dir <checkout>`
loaded the plugin but was denied the read of `skills/workflow/craft.md`, so the
flow stopped before the selection gate. Adding `--add-dir <checkout>` resolved
it. Resolution: the skill-directory install needs no flags, and the session
plugin alternative now documents the required grant.

### F3 — `doctor.sh` required links with no observed effect

`doctor.sh` exited `1` because `~/.cursor/plugins/local/{compforge,oopforge}`
were absent, while the links that actually make the packs load were present and
all three harnesses worked. Resolution: doctor and bootstrap now check and
create `~/.agents/skills/{compforge,oopforge}`.

### F4 — a checkout outside `$HOME` loads `SKILL.md` but not the workflow

With the checkout in a temporary directory, the probe passed but the follow-on
read of `skills/workflow/craft.md` was denied because the symlink resolved
outside the home directory. Resolution: [`../setup/install.md`](../setup/install.md)
requires a `~/.fuseforge` checkout, matching `~/.compforge` and `~/.oopforge`.

### F5 — the Claude command adapter stalled on a plugin-root probe

`commands/craft.md` tried `${CLAUDE_PLUGIN_ROOT}` first, which requested an
extra approval and stopped a non-interactive session before the workflow
loaded. Resolution: the adapter now prefers the skill-directory path.

### F6 — the selection gate blocked on an unreadable support-scope document

In one run the gate reported the linked Compforge and OOPforge skill
directories as empty and stopped with the bootstrap blocker, although both
resolve correctly and state their stack scope in `SKILL.md`. A repeat run listed
the real supported options, including the Compforge structure choices and the
OOPforge architecture choices, so the behavior was not deterministic.

The gate's step 3 accepted either the loaded specialist skill or the pack's
`docs/reference/support-scope.md`, and that document sits outside the linked
skill directory. Resolution: `skills/workflow/craft.md` now reads the loaded
skill's stack scope first, treats an unreadable support-scope document as
missing detail rather than a missing pack, and reports a blocker only when the
loaded skill itself cannot be found.

## Future enhancements

These are recorded observations, not failures of an approved boundary.

- Required-track classification was not stable. The same month-view calendar
  request was classified as frontend and backend in one run, frontend-only in
  another, and as a user question about whether a backend is needed in a third.
  The gate never invented a stack, so no product file was written either way.
- The generated `rev-1` contract covered all six planned calendar slices rather
  than the Delivery Plan's Slice 1 boundary. Wire decisions were still
  deferred, so no approved boundary was crossed.
- As a session plugin, Claude Code wrapped the three probe lines in a code
  fence with commentary. The skill-directory install produced the bare lines.

## Post-fix re-verification

After the install and documentation fixes, the documented commands were run
again with no extra flags:

| Check | Result |
|---|---|
| Claude Code probe | Passed: three bare lines |
| Codex CLI probe | Passed: three bare lines |
| Cursor Agent probe | Passed: three bare lines |
| Claude Code selection gate | Passed: Assumptions and Selection Gate, workspace empty |
| `bootstrap.sh` plan | Proposes only the `~/.agents/skills/` links that affect loading |
| Repository checks | All pass, including the updated bootstrap smoke suite |

## Environment integrity

Diagnostic symlinks and temporary checkouts were removed after the run.
`~/.claude`, `~/.codex`, `~/.agents`, `~/.cursor`, the Compforge checkout, and
the OOPforge checkout were returned to their original state. No `--apply` ran
against the maintainer's real environment.

## Connected evidence

Frontend-client-to-backend connected verification remains not applicable.
Calendar application source has not been authorized or created.

## Acceptance checkpoint — approved 2026-08-27

The maintainer approved:

- the clean-checkout automated evidence;
- the five-turn coordinator flow results and boundary checks;
- the harness matrix, including live Codex activation and the unsupported
  Cursor plugin-directory path;
- the resolutions recorded for F1 through F6;
- the open items kept as future enhancements rather than fixed.

This approval covers released-flow acceptance only. It does not authorize
calendar product source, and it does not satisfy connected verification.
