# FuseForge with Claude Code

Status: **Experimental; live activation and the full coordinator flow verified
through the skill-directory install**.

Install with [`install.md`](install.md), which links
`~/.claude/skills/fuseforge` and `~/.claude/commands/fuseforge`.

Invoke:

```text
/fuseforge:craft <product request>
/fuseforge:consult <coordination question>
```

Activation probe:

```text
/fuseforge:craft FUSEFORGE_ACTIVATION_PROBE
/fuseforge:consult FUSEFORGE_CONSULT_PROBE
```

Expected output:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

Consult probe output:

```text
FUSEFORGE_CONSULT_LOADED
Mode: answer
Write permission: none
```

## Session plugin alternative

`claude --plugin-dir <fuseforge-checkout>` also loads the plugin, but the
canonical policy then lives outside the working directory. Add the checkout as a
readable directory or the workflow file read is denied:

```bash
claude --plugin-dir ~/.fuseforge --add-dir ~/.fuseforge
```

The skill-directory install needs no extra flags and is the recommended path.

[`bootstrap.md`](bootstrap.md) prepares missing Compforge and OOPforge packs. It
does not install or update FuseForge itself.

`/fuseforge:consult` is experimental advisory behavior. It does not implement
product work; use `/fuseforge:craft` for that.
