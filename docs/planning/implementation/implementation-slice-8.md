# FuseForge — Implementation Slice 8

- Status: Implemented 2026-08-27
- Plan: [implementation-slice-8-plan.md](implementation-slice-8-plan.md)
- Evidence: [self-install](../../verification/self-install-2026-08-27.md)

## Outcome

FuseForge installs, checks, and removes itself with the same commands as
Compforge and OOPforge. It was previously the only one of the three packs with no
installer, while requiring an installer of every pack it accepts.

## What changed

| File | Change |
|---|---|
| `scripts/setup/install.sh` | New. Four symlinks, `update`, `--force`, `--dry-run`, `INSTALL_*` |
| `scripts/setup/uninstall.sh` | New. Removes only links owned by its own checkout |
| `scripts/setup/quickstart.sh` | New. Curl-able clone-or-update plus install |
| `scripts/setup/doctor.sh` | Reports FuseForge itself; fails when absent or partial |
| `scripts/setup/bootstrap.sh` | States that it installs specialists, not FuseForge |
| `scripts/setup/lib/common.sh` | One shared link plan and color helpers |
| `scripts/ci/install-smoke.sh` | New. Nineteen assertions in a throwaway `HOME` |
| `scripts/ci/check-harness-packaging.py` | Requires the setup scripts and the shared link plan |
| `.github/workflows/lint.yml` | Runs the install smoke check |
| `docs/setup/install.md` | Leads with the installer; documents flags and manual setup |
| `README.md`, `README.ko.md` | Install section; slice table extended to 7 and 8 |

## Boundaries held

- The installer touches only the four link paths and never writes elsewhere in a
  harness directory.
- A path that is not a symlink is never replaced, with or without `--force`.
- `uninstall.sh` never deletes a pack source and never touches a link owned by a
  different checkout.
- The specialist packs are untouched. `bootstrap.sh` behavior is unchanged.
- No coordinator policy, calendar behavior, or `/fuseforge:consult` scope changed.

## Three defects found while implementing

1. **A false error on reinstall.** Rerunning a complete install exited non-zero
   with "No harness directory was found", because the counter deciding whether a
   harness was visited only counted links written. Caught by the smoke suite's
   idempotence assertion, not by inspection.
2. **`doctor.sh` was blind to FuseForge.** It inspected only the specialist packs
   and reported this machine as ready while FuseForge was installed in no harness.
3. **No setup script was executable in Git.** All were mode `100644`, which is
   why the documentation needed a `chmod +x` step and why the first live
   `./scripts/setup/doctor.sh` failed with "permission denied".

A fourth was caused by this slice: the stricter doctor broke `bootstrap-smoke.sh`,
since `bootstrap.sh --apply` runs doctor and installs only the specialists. Doctor
gained a `--specialists` scope instead of relaxing the new check, and a smoke
assertion holds that scope silent about the FuseForge install.

## Two stale claims corrected

`skills/SKILL.md` and `AGENTS.md` still said six approved implementation slices
after `0.2.1` shipped the seventh, and the README slice table stopped at 6. Slice
7 shipped without updating any of the three. This slice corrects them and adds
itself.

## Naming decision

`bootstrap.sh` keeps its meaning, because `skills/workflow/craft.md` routes a
missing pack to `docs/setup/bootstrap.md`. The curl entry point is therefore
`quickstart.sh` rather than `bootstrap.sh`, which differs from the siblings. Both
`bootstrap.sh` outputs and the install documentation now state the difference,
since a silent difference is what made it a problem.

## Not verified

- Windows and Linux; only macOS was exercised.
- Live activation after install on Codex CLI and Cursor Agent. Only Claude Code
  was probed; the other two were asserted by `doctor.sh`, which is weaker.
- Concurrent installs from two checkouts.
