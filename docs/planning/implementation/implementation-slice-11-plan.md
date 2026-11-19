# FuseForge — Implementation Slice 11 Plan

- Status: Capability approved 2026-11-19 by the maintainer, in the request that
  asked for `/fuseforge:jira` and `/fuseforge:crucible`
- Amends: Design §4.1, which exposed two product intents (`craft`, `consult`).
  This slice adds `jira`; slice 12 adds `crucible`. `refactor` and `test` stay
  specialist workflows, not FuseForge commands.

## Product-language outcome

A developer can turn one full-stack story into its frontend and backend child
tasks in one request, instead of running the Compforge and OOPforge Jira
commands separately and stitching the halves together.

## Observed

- Compforge and OOPforge `jira-card.md` and `jira-children.md` are identical
  apart from the pack name.
- `jira-children.md` assumes one home track per repository. The other track is
  written as a foreign child that only describes how another repository works.

## Scope

- `skills/workflow/jira.md`: card mode passes through to `jira-card.md`;
  children mode follows `jira-children.md` with `[F.E]` and `[B.E]` both home.
- The template is read from the loaded Compforge skill, then OOPforge. FuseForge
  keeps no copy, and stops instead of reconstructing it.
- A contract revision and its operations are cited only when the feature already
  has a FuseForge shared contract.
- `commands/jira.md`, routing in `skills/SKILL.md`, the registry, packaging
  checks, and `scripts/ci/check-jira.py`.

## Out of scope

- A FuseForge-owned Jira template.
- Creating a shared contract, a workspace, or `.craft/fuseforge/` state.
- Writing to Jira without an explicit request.

## Verification

Every check in `docs/reference/release-process.md`, each new assertion proven to
fail when its rule is removed, and one live Claude Code run on a pasted parent
with only the Read tool.
