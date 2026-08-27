# FuseForge with Cursor Agent

Status: **Experimental; live activation and isolated workspace flow verified**.

Start Cursor Agent with the FuseForge checkout:

```bash
cursor-agent --plugin-dir /path/to/fuseforge
```

Invoke:

```text
Use FuseForge craft: <product request>
```

Activation probe:

```bash
cursor-agent --trust --plugin-dir /path/to/fuseforge \
  -p "FUSEFORGE_ACTIVATION_PROBE"
```

Expected output:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

The approved Test evidence includes a read-only unconfirmed path flow and an
isolated exact-path workspace creation. It does not include calendar
application implementation or connected verification.

[`bootstrap.md`](bootstrap.md) can add missing local Cursor links for Compforge
and OOPforge. It does not install FuseForge itself.
