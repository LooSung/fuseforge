# FuseForge with Codex CLI

Status: **Experimental; live activation verified on 2026-08-27**.

Install with [`install.md`](install.md), which links
`~/.codex/skills/fuseforge` to the canonical `skills/` directory.

Invoke:

```text
Use FuseForge craft: <product request>
Use FuseForge consult: <coordination question>
```

Activation request:

```text
Use FuseForge craft: FUSEFORGE_ACTIVATION_PROBE
Use FuseForge consult: FUSEFORGE_CONSULT_PROBE
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

Live Craft activation passed with `codex-cli 0.148.0` against the published
`v0.1.0` checkout. Consult probe and one live Consult comparison against this
checkout are in
[consult verification](../verification/consult-2026-08-27.md). The earlier HTTP
401 result recorded at the coordinator Test checkpoint was an unauthenticated
environment, not a packaging failure. Evidence for the `v0.1.0` Craft flow is
in
[released-flow acceptance](../verification/released-flow-acceptance-2026-08-27.md).

[`bootstrap.md`](bootstrap.md) prepares missing specialist packs; it does not
install FuseForge itself.
