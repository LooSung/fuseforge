# FuseForge — Implementation Slice 8 Plan

- Status: Approved 2026-08-27
- Input: maintainer requirement that FuseForge install and run like its siblings

## Product-language outcome

A developer installs FuseForge the same way they installed Compforge and
OOPforge, checks it with the same command, and removes it with the same command.

Today FuseForge is the only pack of the three with no installer. Its install is
a clone plus four symlinks the user types by hand, which is both more work and
easier to get wrong than the packs it coordinates.

## The gap, measured against the siblings

| Capability | Compforge | OOPforge | FuseForge at `v0.2.1` |
|---|---|---|---|
| `scripts/setup/install.sh` | Yes | Yes | **Missing** |
| `scripts/setup/uninstall.sh` | Yes | Yes | **Missing** |
| `scripts/setup/doctor.sh` | Yes | Yes | Yes, but blind to itself |
| One-line remote install | Yes, via `bootstrap.sh` | Yes | **Missing** |
| `install` / `update` / `--force` / `--dry-run` | Yes | Yes | **Missing** |

Two further problems found while comparing:

1. **`doctor.sh` is blind to FuseForge itself.** It inspects only Compforge and
   OOPforge, so it can print "No changes required" while FuseForge is not
   installed in any harness.
2. **`bootstrap.sh` means the opposite of what a sibling user expects.** In
   Compforge and OOPforge, `bootstrap.sh` is the self-install entry point. In
   FuseForge it installs the *specialist packs*. A user who transfers the habit
   runs it and does not get FuseForge installed.

FuseForge also requires `scripts/setup/install.sh` of any pack it accepts, in
`inspect_pack` in `scripts/setup/lib/common.sh`. It holds the specialists to a
standard it does not meet.

## Scope

In scope:

- `scripts/setup/install.sh` installing FuseForge into Claude Code, Codex CLI,
  and Cursor Agent, with the siblings' `install`, `update`, `--force`, and
  `--dry-run` behavior and `INSTALL_*` overrides;
- `scripts/setup/uninstall.sh` removing only links that point at this checkout;
- `doctor.sh` reporting FuseForge's own installation, and failing when no harness
  can load it;
- a curl-able entry point that clones or updates `~/.fuseforge` and installs it;
- resolving the `bootstrap.sh` naming surprise without breaking its documented
  behavior;
- documentation that leads with the installer, and Korean parity;
- an isolated install and uninstall smoke check in CI.

Out of scope:

- changing what `bootstrap.sh` does to the specialist packs;
- `/fuseforge:consult`, which stays Skeleton-only;
- any coordinator policy or calendar behavior;
- publishing to a package registry;
- Windows support, which none of the three packs claim.

## Write scope

```text
scripts/setup/install.sh
scripts/setup/uninstall.sh
scripts/setup/quickstart.sh
scripts/setup/bootstrap.sh
scripts/setup/doctor.sh
scripts/setup/lib/common.sh
scripts/ci/install-smoke.sh
scripts/ci/check-harness-packaging.py
.github/workflows/lint.yml
docs/setup/install.md
docs/setup/bootstrap.md
README.md
README.ko.md
CHANGELOG.md
docs/reference/support-scope.md
docs/reference/release-process.md
docs/planning/implementation/implementation-slice-8*.md
docs/planning/implementation/README.md
docs/verification/self-install-2026-08-27.md
```

## Naming decision

`bootstrap.sh` keeps its current meaning, because `skills/workflow/craft.md`
routes a missing pack to `docs/setup/bootstrap.md` and changing that would break
approved coordinator policy.

The curl entry point is therefore `quickstart.sh`, and `bootstrap.sh` gains one
line telling a user who expected self-install to run `install.sh`. The difference
from the siblings is documented rather than hidden, because a silent difference
is what caused the problem.

## Safety rules

The installer touches only symlinks under harness config directories:

- never write inside a harness directory other than the four link paths;
- never replace a path that is not a symlink;
- never replace a symlink pointing elsewhere without `--force`;
- `uninstall.sh` removes a link only when it points at this checkout, and never
  deletes the pack source;
- `--dry-run` prints the exact actions and changes nothing;
- rerunning is safe and reports already-linked paths as such.

`quickstart.sh` clones into a temporary path and moves it into place only after
the checkout looks like FuseForge, so a failed clone cannot leave a half pack at
`~/.fuseforge`. It installs FuseForge only, and prints the specialist bootstrap
command instead of running it, because specialist installation stays explicit.

## Verification

Static:

- shell syntax and shellcheck on every new script;
- packaging check asserts the installer and uninstaller exist and are executable;
- the full existing suite continues to pass.

Behavioral, in an isolated `HOME`:

- `--dry-run` changes nothing, proven by comparing the directory tree before and
  after;
- install creates exactly the four expected links and nothing else;
- rerunning install reports already-linked and changes nothing;
- a foreign symlink is preserved without `--force` and replaced with it;
- a real file at a link path is never replaced;
- uninstall removes only its own links and leaves a foreign link and the pack
  source intact;
- `doctor.sh` fails when FuseForge is not installed and passes when it is.

Live, on the maintainer's machine:

- install, then run the activation probe on at least one harness, then uninstall
  and confirm the environment returned to its prior state.

## Risks

- The installer writes to the user's home directory, which is the first
  FuseForge script to do so outside `bootstrap.sh`. Mitigated by the safety
  rules above and by an isolated-`HOME` smoke check.
- A curl-piped script is executed sight unseen. Mitigated by keeping it small,
  making it install only FuseForge, and documenting the clone-first alternative
  next to it.
- `doctor.sh` gaining a new failure condition could reject an environment that
  was previously reported ready. That is the intended correction, and the message
  must name the fix.

## Checkpoint

The slice is complete when the isolated smoke checks pass, a live install and
uninstall round trip is recorded, and the maintainer approves the release.
