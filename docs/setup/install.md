# FuseForge Install

Status: **Experimental; verified on 2026-08-27 for Claude Code, Codex CLI, and
Cursor Agent**.

FuseForge is a policy pack. Installing it means placing its canonical
[`skills/`](../../skills/) directory where a harness looks for agent skills.

## 1. Clone inside your home directory

```bash
git clone https://github.com/LooSung/fuseforge.git ~/.fuseforge
```

The checkout location matters. Harnesses restrict file reads to the workspace
and the home directory, so a checkout outside `$HOME` loads `SKILL.md` but then
fails to read `skills/workflow/craft.md`. Use `~/.fuseforge` to match the
sibling `~/.compforge` and `~/.oopforge` convention.

## 2. Link the skill for each harness you use

Claude Code:

```bash
ln -s ~/.fuseforge/skills ~/.claude/skills/fuseforge
ln -s ~/.fuseforge/commands ~/.claude/commands/fuseforge
```

Codex CLI:

```bash
ln -s ~/.fuseforge/skills ~/.codex/skills/fuseforge
```

Cursor Agent:

```bash
mkdir -p ~/.agents/skills
ln -s ~/.fuseforge/skills ~/.agents/skills/fuseforge
```

Create only the links for harnesses you actually use. FuseForge has no
self-installer; these commands are the whole install.

## 3. Confirm activation

Run the probe for each harness you linked and expect exactly three lines:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

See [`claude-code.md`](claude-code.md), [`codex.md`](codex.md), and
[`cursor.md`](cursor.md) for the per-harness invocation.

## Specialist packs

FuseForge delegates to Compforge and OOPforge. Install them separately with
[`bootstrap.md`](bootstrap.md). FuseForge never installs or updates itself
during a Craft request.

## Uninstall

```bash
rm -f ~/.claude/skills/fuseforge ~/.claude/commands/fuseforge \
  ~/.codex/skills/fuseforge ~/.agents/skills/fuseforge
rm -rf ~/.fuseforge
```

## Unsupported install paths

`cursor-agent --plugin-dir <fuseforge-checkout>` does not make the skill
available. On Cursor Agent `2026.08.25` the skill is absent from the loaded
skill list and the probe returns free-form text. A
`~/.cursor/plugins/local/fuseforge` link behaves the same way. A minimal
synthetic plugin reproduced the same result, so the limitation is in
plugin-directory skill loading rather than in the FuseForge manifest.

`claude --plugin-dir <fuseforge-checkout>` does load the plugin, but it needs an
extra `--add-dir <fuseforge-checkout>` grant when the working directory differs
from the checkout. The skill-directory install above avoids that.

Evidence is recorded in
[released-flow acceptance](../verification/released-flow-acceptance-2026-08-27.md).
