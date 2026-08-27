# FuseForge Specialist Pack Bootstrap

Status: **Experimental — implementation slice 2**.

This setup path inspects and, only with explicit approval, installs missing
Compforge and OOPforge packs and harness links.

It does **not** install FuseForge. In Compforge and OOPforge, `bootstrap.sh` is
the self-install entry point; here it installs those two packs instead. FuseForge
itself is [`install.md`](install.md).

## Safe inspection

From a FuseForge checkout:

```bash
bash scripts/setup/bootstrap.sh
```

This command:

- reads pack manifests, capability markers, and link destinations;
- prints compatible, missing, or incompatible status;
- prints only the missing changes;
- does not contact a remote or change files.

Read-only readiness check:

```bash
bash scripts/setup/doctor.sh                # FuseForge and both specialists
bash scripts/setup/doctor.sh --specialists  # the specialist packs only
```

Without a flag, doctor also requires FuseForge itself to be installed, and names
`install.sh` when it is not. `bootstrap.sh` calls the `--specialists` scope,
because it installs the specialists and was not asked to install FuseForge.

Doctor exits successfully when both packs are compatible and at least one
harness can load them. A harness you have not set up is reported as absent, not
as a failure, so installing for Claude Code alone is a ready environment.

It still fails when a harness is only partly linked, because that loads some
packs and silently omits others.

Cursor Agent reads `~/.claude/skills/`, `~/.codex/skills/`, and
`~/.agents/skills/`, so packs linked for Claude or Codex are already available
to it. Doctor reports which directory supplies them.

## Apply missing items

Review the plan, then explicitly apply it:

```bash
bash scripts/setup/bootstrap.sh --apply
```

Apply mode may:

- clone a missing pack;
- call that pack's default missing-link installer for Claude and Codex;
- add a missing Cursor skill symlink under `~/.agents/skills/`.

It never pulls, updates, replaces, force-links, or deletes an existing
installation.

## Resolution and overrides

Pack roots:

```text
COMPFORGE_HOME, otherwise ~/.compforge
OOPFORGE_HOME, otherwise ~/.oopforge
```

Missing-pack sources:

```text
COMPFORGE_REPO_URL, otherwise https://github.com/LooSung/compforge.git
OOPFORGE_REPO_URL, otherwise https://github.com/LooSung/oopforge.git
```

Optional development/test branches:

```text
COMPFORGE_BRANCH
OOPFORGE_BRANCH
```

An explicit root that exists but fails its capability contract is
incompatible. FuseForge does not silently fall back to a different checkout.

## Compatibility meaning

Compatible means:

- three plugin manifests agree on the observed version;
- required skill, stability, command, setup, and support-scope files exist;
- the specialist stack and activation-contract markers are present.

It does not mean a live agent loaded the pack. Live activation remains an
explicit harness probe with local authentication.

Existing versions are preserved when their capability contract is compatible.
There is no hard-coded minimum version or automatic update.

## Managed links

Claude:

```text
~/.claude/skills/{compforge,oopforge}
~/.claude/commands/{compforge,oopforge}
```

Codex:

```text
~/.codex/skills/{compforge,oopforge}
```

Cursor:

```text
~/.agents/skills/{compforge,oopforge}
```

Cursor Agent loads skills from vendor-neutral skill directories. A
`~/.cursor/plugins/local` link has no observed effect on skill availability, so
bootstrap no longer creates one.

An occupied destination with a different target or a non-symlink blocks the
entire apply preflight. FuseForge reports manual repair guidance and preserves
the destination.

## Verification

The no-network smoke suite uses an isolated `HOME` and local Git fixtures:

```bash
bash scripts/ci/bootstrap-smoke.sh
```

It verifies no-change planning, missing-only apply, idempotence, link
preservation, manifest and capability blocking, and the absence of update
paths.
