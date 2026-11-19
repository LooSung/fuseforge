# FuseForge — agent notes

These notes are for agents changing **FuseForge itself**. To *use* FuseForge on a
product, follow `skills/SKILL.md` instead; it owns the Craft and Consult policy.

## What FuseForge is

A thin, experimental full-stack coordinator over
[Compforge](https://github.com/LooSung/compforge) (frontend) and
[OOPforge](https://github.com/LooSung/oopforge) (backend). It gives a developer
one feature-level workflow, one shared contract, and one integrated approval per
stage, while each specialist keeps its own scope.

Current state: Discovery, Design, Delivery Plan, Skeleton, ten Implement slices,
and the coordinator Test checkpoint are approved. The whole flow ran once
against a real product. Read `docs/verification/calendar-slice-1-2026-08-27.md`
before describing what FuseForge has coordinated: one slice, one stack pair, one
harness.

## Layout

| Path | Holds |
|---|---|
| `skills/SKILL.md` | Entry point; routes Craft and Consult |
| `skills/workflow/` | `craft.md` and `consult.md` |
| `skills/coordination/` | Workspace, shared contract, delegation, stage barrier, connected verification |
| `skills/stability.json` | Interface maturity, explained in `docs/reference/skill-stability.md` |
| `commands/` | Claude Code entry points |
| `.claude-plugin/`, `.codex-plugin/`, `.cursor-plugin/` | Harness packaging only; `.claude-plugin/marketplace.json` is the `forge` catalog of all three packs, kept identical across the three repositories except for which entry is `./` |
| `scripts/setup/` | `quickstart.sh` and `install.sh` install FuseForge; `bootstrap.sh` installs the **specialists**, unlike the sibling packs |
| `scripts/ci/` | Packaging, policy, and smoke checks |
| `docs/planning/` | Approved checkpoints and every slice's plan and evidence |
| `docs/verification/` | Packaging and behavior evidence |
| `evals/` | `claude plugin eval` suites |

## Checks

CI runs these; all must pass before a change is done:

```bash
bash scripts/ci/lint-skills.sh        # packaging, skill registry, doc links
python3 scripts/ci/test-doc-links.py
python3 scripts/ci/check-release-readiness.py
python3 scripts/ci/check-selection-gate.py
python3 scripts/ci/check-workspace-contract.py
python3 scripts/ci/check-delegation-barrier.py
python3 scripts/ci/check-implement-delegation.py
python3 scripts/ci/check-connected-verification.py
python3 scripts/ci/check-consult.py
bash scripts/ci/bootstrap-smoke.sh
bash scripts/ci/install-smoke.sh
```

## Product boundaries

- FuseForge coordinates; it does not duplicate frontend or backend methodology.
  Compforge owns TypeScript and React discipline; OOPforge owns Java Spring and
  Python FastAPI OOP/DDD discipline.
- FuseForge never writes application source or runs a package manager.
  Specialists do that inside their own work target. Consult never implements
  product behavior. Specialist bootstrap is an explicit script, never an implicit
  Craft mutation.
- The user approves product behavior in their own language. Internal terms and
  specialist contracts must not replace that checkpoint.
- The parent agent owns shared decisions and user interaction. Specialist work
  returns undecided cross-stack changes to the parent.
- Parallelism is allowed only after the shared contract is fixed and write roots
  do not overlap. It is an optimization, not a requirement.
- Do not introduce a tmux daemon, an autonomous merge pipeline, or a
  general-purpose multi-agent runtime without new evidence and a separately
  approved scope.

## Rules for changing the pack

- A new capability goes through Discovery → Design → Delivery Plan → Skeleton →
  Implement → Test, with human approval between stages. Read the four approved
  checkpoints in `docs/planning/checkpoints/` before implementing behavior, and
  implement exactly one approved vertical slice at a time. Read a slice's plan before working on it
  and its evidence before reviewing it; `docs/planning/implementation/README.md`
  indexes every slice. Stage completion criteria live in
  `docs/planning/checkpoints/README.md`.
- Read `docs/reference/support-scope.md` before describing support and
  `docs/verification/README.md` before changing evidence claims. Do not describe
  later slices or unverified harnesses as implemented or supported.
- Separate observed facts, hypotheses, decisions, and open questions.
- Keep one source of truth for cross-stack semantics. Treat monorepo and
  polyrepo as distinct contexts; never assume atomic commits across repositories.
- Add no unrelated installers, CI, dependencies, or external services, and no
  calendar source.
- Skills, scripts, and enforceable policy are in English. Korean guidance lives
  in `README.ko.md` and `docs/reference/methodology.ko.md`.
- Record only completed user-visible changes in `CHANGELOG.md`. Follow
  `docs/reference/release-process.md`; automation never creates tags or GitHub
  Releases.
- Keep changes surgical and remove only artifacts created by the same change.
  Comments explain why; names explain what.
