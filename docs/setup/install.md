# FuseForge Install

Status: **Experimental; verified on 2026-08-27 for Claude Code, Codex CLI, and
Cursor Agent**.

FuseForge is a policy pack. Installing it means placing its canonical
[`skills/`](../../skills/) directory where a harness looks for agent skills. The
installer does that for every harness it finds, and nothing else.

## Quickstart

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/LooSung/fuseforge/main/scripts/setup/quickstart.sh)"
```

This clones or updates `~/.fuseforge`, then installs FuseForge into the harnesses
present on the machine. It is safe to rerun, and it does not install the
specialist packs; it prints that command at the end.

Then confirm the install:

```bash
bash ~/.fuseforge/scripts/setup/doctor.sh
```

## Install a fixed release instead

The quickstart tracks `main`. To pin a release:

```bash
git clone https://github.com/LooSung/fuseforge.git ~/.fuseforge
cd ~/.fuseforge
git checkout v0.3.0
chmod +x scripts/setup/*.sh
./scripts/setup/install.sh
./scripts/setup/doctor.sh
```

The checkout location matters. Harnesses restrict file reads to the workspace and
the home directory, so a checkout outside `$HOME` loads `SKILL.md` but then fails
to read `skills/workflow/craft.md`. Use `~/.fuseforge` to match the sibling
`~/.compforge` and `~/.oopforge` convention.

## Installer options

```bash
./scripts/setup/install.sh             # install, skipping paths already linked
./scripts/setup/install.sh update      # remove this checkout's links, then reinstall
./scripts/setup/install.sh --force     # replace symlinks pointing elsewhere
./scripts/setup/install.sh --dry-run   # print the actions and change nothing
```

By default a harness is installed only when its config directory exists. Set
`INSTALL_CLAUDE=1`, `INSTALL_CODEX=1`, or `INSTALL_CURSOR=1` to install anyway.

The installer creates only these four symlinks and writes nothing else:

| Harness | Link |
|---|---|
| Claude Code | `~/.claude/skills/fuseforge`, `~/.claude/commands/fuseforge` |
| Codex CLI | `~/.codex/skills/fuseforge` |
| Cursor Agent | `~/.agents/skills/fuseforge` |

It never replaces a path that is not a symlink, even with `--force`, and it never
replaces a symlink pointing at another checkout without `--force`.

## Manual install

The installer is a convenience. These commands are equivalent:

```bash
ln -s ~/.fuseforge/skills ~/.claude/skills/fuseforge
ln -s ~/.fuseforge/commands ~/.claude/commands/fuseforge
ln -s ~/.fuseforge/skills ~/.codex/skills/fuseforge
mkdir -p ~/.agents/skills && ln -s ~/.fuseforge/skills ~/.agents/skills/fuseforge
```

## Confirm activation

`doctor.sh` checks the pack and its links; it does not prove the skill loaded.
Run the probe for each harness you installed and expect exactly three lines:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

See [`claude-code.md`](claude-code.md), [`codex.md`](codex.md), and
[`cursor.md`](cursor.md) for the per-harness invocation.

## Specialist packs

FuseForge delegates to Compforge and OOPforge and cannot run a feature without
them. Install them with [`bootstrap.md`](bootstrap.md):

```bash
bash ~/.fuseforge/scripts/setup/bootstrap.sh          # print a plan
bash ~/.fuseforge/scripts/setup/bootstrap.sh --apply  # create missing items only
```

Unlike Compforge and OOPforge, where `bootstrap.sh` installs the pack itself,
FuseForge's `bootstrap.sh` installs its *specialists*. FuseForge itself is
`install.sh`. FuseForge never installs or updates anything during a Craft request.

## Uninstall

```bash
bash ~/.fuseforge/scripts/setup/uninstall.sh
```

This removes only links that point at that checkout. It leaves links owned by
another checkout, paths that are not symlinks, the specialist packs, and the pack
source itself. To remove the source too:

```bash
rm -rf ~/.fuseforge
```

## Unsupported install paths

`cursor-agent --plugin-dir <fuseforge-checkout>` does not make the skill
available. On Cursor Agent `2026.08.25` the skill is absent from the loaded skill
list and the probe returns free-form text. A `~/.cursor/plugins/local/fuseforge`
link behaves the same way. A minimal synthetic plugin reproduced the same result,
so the limitation is in plugin-directory skill loading rather than in the
FuseForge manifest.

`claude --plugin-dir <fuseforge-checkout>` does load the plugin, but it needs an
extra `--add-dir <fuseforge-checkout>` grant when the working directory differs
from the checkout. The skill-directory install above avoids that.

Evidence is recorded in
[released-flow acceptance](../verification/released-flow-acceptance-2026-08-27.md)
and [self-install](../verification/self-install-2026-08-27.md).
