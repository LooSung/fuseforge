# FuseForge with Codex CLI

Status: **Experimental; static routing verified, live activation unproven**.

Expose the canonical [`skills/`](../../skills/) directory as a Codex skill
named `fuseforge`, then invoke:

```text
Use FuseForge craft: <product request>
```

Activation request:

```text
Use FuseForge craft: FUSEFORGE_ACTIVATION_PROBE
```

Expected output is:

```text
FUSEFORGE_LOADED
Assumptions
Selection Gate
```

The isolated live probe on 2026-08-27 was blocked by HTTP 401 because
authentication was unavailable. The maintainer accepted static manifest and
canonical routing evidence for the experimental Test checkpoint. This document
does not claim live Codex support.

[`bootstrap.md`](bootstrap.md) prepares missing specialist packs; it does not
install FuseForge itself.
