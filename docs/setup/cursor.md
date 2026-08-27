# FuseForge with Cursor Agent

Status: **Experimental; live activation verified through the skill-directory
install**.

Install with [`install.md`](install.md), which links
`~/.agents/skills/fuseforge` to the canonical `skills/` directory.

Invoke:

```text
Use FuseForge craft: <product request>
```

Activation probe:

```bash
cursor-agent --trust -p "FUSEFORGE_ACTIVATION_PROBE"
```

Expected output:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

`cursor-agent --plugin-dir <fuseforge-checkout>` does not load the skill and is
not a supported install path. See
[`install.md`](install.md#unsupported-install-paths) for the observed behavior.

The approved evidence covers activation, the read-only selection gate, an
exact-path workspace plan, confirmed workspace creation, specialist Design
delegation, and approval-gated `rev-2`. It does not include calendar
application implementation or connected verification.
