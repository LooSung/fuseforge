# Self-install verification — 2026-08-27

- Subject: `scripts/setup/install.sh`, `uninstall.sh`, `quickstart.sh`, and the
  `doctor.sh` change, from implementation slice 8
- Machine: macOS, darwin 25.5.0, zsh
- Harnesses present: Claude Code, Codex CLI, Cursor Agent

## Why this slice existed

FuseForge required `scripts/setup/install.sh` of any specialist pack it would
accept, in `inspect_pack` in `scripts/setup/lib/common.sh`, while shipping no
installer of its own. Its documented install was a clone plus four `ln -s`
commands.

An observation worth recording: before this slice, FuseForge had never been
installed on the maintainer's machine. Every session ran from the development
checkout, where Cursor loads the workspace directly. The pack was published to a
public repository and released four times without anyone installing it the way a
reader of the README would.

## Isolated behavior

`scripts/ci/install-smoke.sh` runs against a throwaway `HOME` under `mktemp -d`.
Twenty-one assertions, all passing:

| Area | Assertions |
|---|---|
| `--dry-run` | tree is byte-identical before and after; planned actions are printed |
| Install | all four links created; no fifth symlink; link resolves to this checkout |
| Rerun | tree unchanged and "Already linked" reported |
| Foreign symlink | preserved without `--force`; replaced with `--force` |
| Real file at a link path | never replaced, even with `--force` |
| Absent harness | not created by default; installed with `INSTALL_CODEX=1` |
| Uninstall | own links removed; unrelated link kept; pack source intact |
| Another checkout's link | left in place by uninstall |
| `update` | leaves exactly the four links |
| `doctor.sh` | fails and names the cause when absent, and when partial |
| Not a FuseForge checkout | refused before any link is created |

### A defect the suite caught

The first run failed at the third assertion. Rerunning a complete install exited
non-zero with "No harness directory was found", because the counter that decided
whether any harness had been visited was only incremented when a link was
created; "Already linked" incremented nothing. A user reinstalling over a working
install would have seen a false error. The installer now counts harnesses
visited rather than links written.

This is the whole reason the rerun case was in the suite, and it would not have
been found by installing once and looking at the result.

## Negative tests

Thirteen violations were injected one at a time and every one was rejected. Files
are restored from a copy outside Git, and the baseline is asserted to pass before
any rejection is trusted, because a suite that reverts the change under test
produces rejections that mean nothing.

Injected: installer or uninstaller deleted; installer not executable; `--dry-run`
renamed away; the uninstaller's source-preservation promise removed; the shared
link plan renamed; `doctor.sh` no longer reading that plan; the installer
destroying a real file, ignoring `--force` for foreign links, creating absent
harness directories, or accepting a foreign directory; the uninstaller taking
another checkout's link; and `doctor.sh` tolerating a missing FuseForge install.

Two of these initially passed, and both revealed weak assertions rather than
correct code:

- The missing-install assertion ran with no specialist packs present, so doctor
  failed for that reason and the assertion could not tell which condition it had
  caught. The suite now installs fake packs that satisfy `inspect_pack`, so the
  only remaining failure cause is FuseForge, and it also asserts that the fully
  installed environment passes.
- Deleting the checkout guard still failed, because `link_path` stops on a missing
  source. Safe, but it meant the assertion did not pin the guard. It now requires
  the "Not a FuseForge checkout" message.

## Live round trip

Before: no FuseForge link existed in any harness, and `~/.fuseforge` did not
exist.

1. `./scripts/setup/install.sh --dry-run` printed four planned links and created
   nothing; the two spot-checked paths were still absent afterwards.
2. `./scripts/setup/install.sh` created all four links.
3. `./scripts/setup/doctor.sh` exited 0 and reported FuseForge `0.2.1` as
   available in Claude Code, Codex CLI, and Cursor Agent, alongside Compforge
   `1.3.1` and OOPforge `1.4.2`.
4. Activation probe on Claude Code, from a directory that is not the checkout:

   ```text
   $ claude -p "/fuseforge:craft FUSEFORGE_ACTIVATION_PROBE"
   FUSEFORGE_LOADED
   Assumptions
   Selection Gate
   ```

   Exactly the three documented lines, which is the evidence that the install
   activates the skill rather than merely placing a file.

5. `./scripts/setup/uninstall.sh` removed all four links, reported each one, and
   stated that the pack source was not removed. All four paths were absent
   afterwards, `~/.claude/skills/` still held `compforge` and `oopforge`, and the
   machine was back to its state before step 1.

A second observation from step 4: a first attempt phrased as "Run the
FUSEFORGE_ACTIVATION_PROBE", without the command prefix, was refused as a
possible prompt injection. The refusal named `fuseforge`, `fuseforge:craft`, and
`fuseforge:consult` in its available skills, which independently confirms the
install. The documented invocation includes the `/fuseforge:craft` prefix, and
only the documented form is claimed to work.

### A regression the existing suite caught

Making `doctor.sh` require a FuseForge install broke `bootstrap-smoke.sh`, because
`bootstrap.sh --apply` ends by running doctor, and bootstrap installs the
specialist packs without installing FuseForge. It failed on a condition it had not
been asked to fix.

Rather than weaken the new check, doctor gained a `--specialists` scope that
bootstrap uses. A smoke assertion now locks in that the scope stays silent about
the FuseForge install, so the two cannot drift back together.

## `doctor.sh` blind spot

Before this slice `doctor.sh` inspected only Compforge and OOPforge. It could
print "No changes required" while FuseForge was installed in no harness at all —
which was the true state of this machine. It now reports FuseForge's own links
first, and fails with the fix to run when they are absent or partial.

## Executable bits

No script under `scripts/setup/` was executable in Git; all four were mode
`100644`. This is why the install documentation needed a `chmod +x` step, and why
`./scripts/setup/doctor.sh` failed with "permission denied" on the first live
attempt. The setup and CI scripts are now committed executable.

## Quickstart

The clone path was exercised in an isolated `HOME` with `FUSEFORGE_REPO_URL`
pointing at a local checkout. The verification guard fired correctly: cloning the
then-current `HEAD`, which predates `install.sh`, was rejected with "Clone did not
produce a FuseForge checkout" and left nothing behind at the target path.

The remote curl form cannot be verified until this slice is on `main`, because the
script it fetches does not exist there yet. It is verified after the push and
recorded below.

## Not verified

- Windows and Linux. Only macOS was exercised.
- Codex CLI and Cursor Agent activation after this install. Only Claude Code was
  probed live; the links are identical in shape and were asserted by `doctor.sh`,
  which is weaker evidence than a probe.
- Concurrent installs from two checkouts at once.
- `quickstart.sh` update path against a real remote with local commits present.

## Post-push remote verification

Recorded after the release, from the published `main`:

- `bash -c "$(curl -fsSL .../scripts/setup/quickstart.sh)"` into a clean
  `FUSEFORGE_HOME`, followed by `doctor.sh`.
- Result: see the closing section of this file.
