# FuseForge

> **Describe one full-stack feature once. Approve one integrated result per stage.**

FuseForge is a thin, **experimental** coordinator for coding agents. It takes one
feature that spans a TypeScript + React frontend and a Java Spring or Python
FastAPI backend, fixes a shared API contract, and hands each side to its
specialist pack. Then it proves the real frontend client against the running
backend before it calls the slice done.

FuseForge writes no application code itself. Each specialist keeps its own
rules.

Installs into **Claude Code**, **Codex CLI**, and **Cursor Agent CLI**; live
activation passed on all three. What each harness has actually run is in the
[support scope](docs/reference/support-scope.md#harness-evidence).

[English](./README.md) · [한국어](./README.ko.md)

## The Forge family

| Pack | For | Stack |
|---|---|---|
| [Compforge](https://github.com/LooSung/compforge) | Frontend | TypeScript + React |
| [OOPforge](https://github.com/LooSung/oopforge) | Backend | Java Spring · Python FastAPI |
| **FuseForge** (this repo) | One feature across both | Coordinates Compforge + OOPforge (experimental) |

FuseForge needs both specialists. Either install below sets up all three.

## Install

**Claude Code**, from the plugin marketplace (experimental):

```text
/plugin marketplace add LooSung/fuseforge
/plugin install compforge@forge
/plugin install oopforge@forge
/plugin install fuseforge@forge
```

If `forge` is already added from another Forge repo, skip the first line. Skip
`doctor.sh` and `bootstrap.sh` on this path; they check script installs only.
Plugin files sit outside your project, so allow reading them once:
[read permission](docs/setup/claude-code.md#plugin-marketplace-experimental).

**Codex CLI, Cursor Agent CLI**, or Claude Code without plugins, with the
install scripts:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/LooSung/fuseforge/main/scripts/setup/quickstart.sh)"
bash ~/.fuseforge/scripts/setup/bootstrap.sh --apply   # add Compforge + OOPforge if missing
bash ~/.fuseforge/scripts/setup/doctor.sh              # check all three
```

The first line installs FuseForge into the harnesses it finds. Pick one path
per harness. `bootstrap.sh`
without `--apply` only prints a plan. Pinned releases and removal:
[install guide](docs/setup/install.md) · [bootstrap guide](docs/setup/bootstrap.md).

## Use

Start your agent from the folder where the new product should live. FuseForge
sets up a greenfield workspace; attaching two existing repositories is not
implemented yet.

```text
/fuseforge:craft Users create a schedule and see it on the month view after saving
/fuseforge:consult Should the error codes live in the shared contract?
```

| Harness | How to call |
|---|---|
| Claude Code | `/fuseforge:craft <request>` · `/fuseforge:consult <question>` |
| Codex CLI · Cursor Agent CLI | `Use FuseForge craft: <request>` · `Use FuseForge consult: <question>` |

| Command | Use it for | It never |
|---|---|---|
| `craft` | One full-stack feature, from selection gate to connected check | Picks a stack you left unspecified, or writes app code itself |
| `consult` | Ask, compare, review, or write one planning document | Implements product behavior |

## How it works

1. **Selection gate.** FuseForge asks for anything the request left open: which
   frontend and backend stack, monorepo or separate repositories, and whether
   data must outlive the browser.
2. **Shared contract.** After you confirm the exact workspace paths, it writes
   the product-semantics contract `rev-1`.
3. **Specialist Design, then Implement.** Compforge and OOPforge each design
   their side. You approve one integrated result (`rev-2`). Each specialist then
   implements inside its own write roots, and FuseForge rejects results that
   claim work they did not do.
4. **Connected check.** A slice is complete only after the real frontend client
   passes against the running backend, and the result is recorded.

## Status: what is proven

On 2026-08-27 the whole flow ran once, end to end, and produced a working
feature: *a user creates a schedule and sees it on the month view after it is
saved.* Evidence: [calendar Slice 1](docs/verification/calendar-slice-1-2026-08-27.md).

That is **one slice, one stack pair, one harness**. It shows that the flow works;
it does not promise other stacks, harnesses, or later slices. Read the
[support scope](docs/reference/support-scope.md) before relying on anything.

Out of scope for now: a tmux daemon, an autonomous merge pipeline, and a
general-purpose multi-agent runtime.

## Learn more

- Setup: [Install](docs/setup/install.md) · [Bootstrap](docs/setup/bootstrap.md) ·
  [Claude Code](docs/setup/claude-code.md) · [Codex](docs/setup/codex.md) ·
  [Cursor](docs/setup/cursor.md)
- [Support scope](docs/reference/support-scope.md) ·
  [Verification evidence](docs/verification/README.md) ·
  [All docs](docs/README.md)
- How it was built: [approved checkpoints](docs/planning/checkpoints/README.md) ·
  [implementation slices](docs/planning/implementation/README.md)
- [Changelog](CHANGELOG.md) · [Release process](docs/reference/release-process.md) ·
  [Contributing](.github/CONTRIBUTING.md) · [Agent notes for maintainers](AGENTS.md)

An overstated support claim is a defect; report one with the
[claim-gap template](.github/ISSUE_TEMPLATE/claim-gap.md).

## License

MIT
