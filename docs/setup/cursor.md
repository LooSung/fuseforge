# FuseForge with Cursor Agent

Status: **Experimental; live activation verified through the skill-directory
install**.

Install with [`install.md`](install.md), which links
`~/.agents/skills/fuseforge` to the canonical `skills/` directory.

Invoke:

```text
Use FuseForge craft: <product request>
Use FuseForge consult: <coordination question>
```

Activation probe:

```bash
cursor-agent --trust -p "FUSEFORGE_ACTIVATION_PROBE"
cursor-agent --trust -p "FUSEFORGE_CONSULT_PROBE"
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

`cursor-agent --plugin-dir <fuseforge-checkout>` does not load the skill and is
not a supported install path. See
[`install.md`](install.md#unsupported-install-paths) for the observed behavior.

Consult is experimental advisory behavior. It does not implement product work;
use Craft for that. Current harness evidence is in
[support scope](../reference/support-scope.md) and
[consult verification](../verification/consult-2026-08-27.md).
