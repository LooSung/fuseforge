# Contributing to FuseForge

Thanks for considering a contribution. FuseForge is an experimental coordinator,
so the most valuable contributions narrow a claim or fix a reproducible failure
rather than add capability.

Read [`AGENTS.md`](../AGENTS.md) first. It is the repository's working contract
and it applies to human contributors as well as agents.

## Contributions we value

1. A reproducible failure in the documented install or Craft flow.
2. Evidence that strengthens, narrows, or contradicts a support claim.
3. Fixes to harness packaging, setup scripts, or repository checks.
4. Documentation corrections, especially claims that outrun the evidence.
5. Clarifying an existing coordination policy without widening its scope.

Please do not open a pull request that adds calendar application source, a new
vertical slice, specialist frontend or backend methodology, a tmux or daemon
runtime, an autonomous merge pipeline, or a new dependency. Those need a
maintainer-approved stage first. Open an issue instead.

## The stage rule

FuseForge separates Discovery, Design, Delivery Plan, Skeleton, Implement, and
Test, and each transition needs maintainer approval. A pull request that
implements an unapproved stage will be asked to become an issue, regardless of
quality. This is the project's main design constraint, not a formality.

## Local setup

```bash
git clone https://github.com/LooSung/fuseforge.git ~/.fuseforge
cd ~/.fuseforge
```

Follow [`docs/setup/install.md`](../docs/setup/install.md) to link the skill for
your harness, and [`docs/setup/bootstrap.md`](../docs/setup/bootstrap.md) to
prepare the Compforge and OOPforge packs. Bootstrap without `--apply` first; it
only prints a plan.

## Find the existing owner

| Area | Canonical location |
|---|---|
| Coordinator policy | `skills/workflow/` and `skills/coordination/` |
| Harness adapters | `commands/`, `.claude-plugin/`, `.codex-plugin/`, `.cursor-plugin/` |
| Setup and diagnosis | `scripts/setup/` |
| Repository checks | `scripts/ci/` |
| Install and harness usage | `docs/setup/` |
| Support boundaries | `docs/reference/support-scope.md` |
| Approved stages | `docs/planning/` |
| Behavior evidence | `docs/verification/` |
| Completed user-visible changes | `CHANGELOG.md` → `Unreleased` |

Extend the smallest existing owner before adding a file. Root-level historical
document paths under `docs/` are compatibility stubs; do not edit them.

## Verify locally

```bash
bash scripts/ci/lint-skills.sh
python3 scripts/ci/test-doc-links.py
python3 scripts/ci/check-release-readiness.py
python3 scripts/ci/check-selection-gate.py
python3 scripts/ci/check-workspace-contract.py
python3 scripts/ci/check-delegation-barrier.py
bash scripts/ci/bootstrap-smoke.sh
```

When you change a setup script, also run `shellcheck` on it. When you change a
load path, run the activation probe on the harnesses you can authenticate and
say which ones you could not.

## Evidence rules

Keep evidence levels distinct and never merge them in a summary:

- static packaging and routing;
- isolated filesystem behavior;
- authenticated live harness activation;
- connected frontend-client-to-backend behavior.

An authentication failure is an environment result, not a packaging failure.
Report observed failures separately from ideas for future work. Do not describe
an unverified harness or a later slice as supported.

## Skill rules

Every policy file under `skills/` must:

1. have valid frontmatter where the harness requires it;
2. stay at or below 200 lines;
3. cover one concept and name the behavior it forbids;
4. be registered in `skills/stability.json` with a matching status marker.

Adapters may route to canonical policy but must not duplicate it.

## Language policy

Skills, scripts, checks, and enforceable policy are English canonical. Korean
guidance lives in `README.ko.md` and `docs/reference/methodology.ko.md`, not in
per-skill translations. Issues and pull requests may use English or Korean.

## Commit and pull request scope

Use focused Conventional Commit messages:

```text
fix(setup): link the skill directory Cursor actually reads
docs(reference): narrow the Codex support claim
chore(ci): add a delegation barrier regression
```

Keep one decision per pull request and use the pull request template.

## Community

This project follows the [Code of Conduct](CODE_OF_CONDUCT.md). Report security
issues through the private process in [SECURITY.md](SECURITY.md).
