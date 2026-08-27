# FuseForge with Claude Code

Status: **Experimental; live activation verified**.

From a FuseForge checkout, load the candidate as a session plugin:

```bash
claude --plugin-dir /path/to/fuseforge
```

Invoke:

```text
/fuseforge:craft <product request>
```

Activation probe:

```text
/fuseforge:craft FUSEFORGE_ACTIVATION_PROBE
```

Expected output:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

[`bootstrap.md`](bootstrap.md) prepares missing Compforge and OOPforge packs.
It does not install or update FuseForge itself.

`/fuseforge:consult` remains Skeleton-only.
