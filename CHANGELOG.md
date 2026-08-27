# Changelog

Completed user-visible changes are recorded under `Unreleased` before a
release. This file follows [Keep a Changelog](https://keepachangelog.com/);
future plans, private backlogs, and unsupported claims do not belong here.

## [Unreleased]

## [0.1.1] - 2026-08-27

### Added

- `docs/setup/install.md` with the verified skill-directory install for Claude
  Code, Codex CLI, and Cursor Agent.
- `docs/verification/released-flow-acceptance-2026-08-27.md` recording
  clean-checkout acceptance of `v0.1.0`, including live Codex activation.
- Contribution, conduct, security, pull-request, and issue guidance under
  `.github/`, including a template for reporting an overstated support claim.

### Changed

- Bootstrap and doctor now manage `~/.agents/skills/{compforge,oopforge}`
  instead of `~/.cursor/plugins/local/`, which had no observed effect on skill
  availability in Cursor Agent.
- The Claude `craft` command adapter prefers the skill-directory path so a
  non-interactive session is not stopped by a plugin-root approval prompt.
- Setup, support-scope, verification, and README harness claims now describe the
  install path that was actually verified.

### Fixed

- `cursor-agent --plugin-dir` was documented as a working install path but did
  not load the FuseForge skill.
- `claude --plugin-dir` needed an undocumented `--add-dir` grant when the
  working directory differed from the checkout.
- A checkout outside the home directory loaded the skill but could not read its
  own workflow files.
- `doctor.sh` reported a working environment as not ready.
- The selection gate could stop with the bootstrap blocker when a specialist
  pack's support-scope document was unreadable, even though the loaded
  specialist skill already stated its supported stacks.

### Known limitations

- Required-track classification is not stable across runs; a request may be
  classified as both tracks, frontend-only, or returned as a question. No run
  invented a stack or created a file.
- Calendar product source and connected frontend-to-backend evidence still have
  not been authorized or created.

## [0.1.0] - 2026-08-27

### Added

- Experimental full-stack selection, greenfield workspace, shared-contract,
  specialist Design delegation, and stage-barrier coordinator policy.
- Missing-only Compforge and OOPforge bootstrap with read-only diagnosis and
  isolated smoke coverage.
- English and Korean repository entry points with structured setup, reference,
  planning, and verification documentation.
- Repository packaging and Markdown-link lint with GitHub pull-request CI.
- MIT licensing, release-readiness checks, and a manual release process.

### Known limitations

- Codex live activation remains unverified because the isolated checkpoint
  environment returned HTTP 401; static packaging evidence passes.
- Calendar product source and connected frontend-to-backend evidence have not
  been authorized or created.
