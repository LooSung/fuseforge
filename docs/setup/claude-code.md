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

## Plugin marketplace (experimental)

Instead of the skill-directory install, add the `forge` catalog and install all
three packs:

```text
/plugin marketplace add LooSung/fuseforge
/plugin install compforge@forge
/plugin install oopforge@forge
/plugin install fuseforge@forge
```

If `forge` is already added from Compforge or OOPforge, skip the first line.
`doctor.sh` and `bootstrap.sh` check script installs only, so skip them on this
path; they report plugin-installed specialists as missing.

`/fuseforge:craft` and `/fuseforge:consult` read their workflow from the plugin
folder. Plugin files live in `~/.claude/plugins/cache/`, outside your project, so
Claude Code asks before reading them. Approve the prompt when it appears, or
add this rule to `~/.claude/settings.json` (required for `claude -p`):

```json
{ "permissions": { "allow": ["Read(~/.claude/plugins/cache/forge/**)"] } }
```

Update with `claude plugin marketplace update forge` and
`claude plugin update <name>@forge`; remove with
`claude plugin uninstall <name>@forge`. Use one install path, not both. A full
coordinator run from a plugin-only install has not been recorded yet. Evidence
and limits: [marketplace-2026-11-19](../verification/marketplace-2026-11-19.md).

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
