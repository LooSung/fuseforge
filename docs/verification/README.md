# FuseForge verification

Verification records packaging and coordinator behavior evidence. Product
connected evidence lives in the product workspace; this directory records the
coordinator's own account of it.

The approved coordinator Test baseline is
[`coordinator-test-2026-08-27.md`](coordinator-test-2026-08-27.md).

[`released-flow-acceptance-2026-08-27.md`](released-flow-acceptance-2026-08-27.md)
re-verifies that baseline against the published `v0.1.0` and supersedes its
harness claims. Read it before describing install or harness support.

[`calendar-slice-1-2026-08-27.md`](calendar-slice-1-2026-08-27.md) records the
first execution of the full coordinator flow, including a passing
frontend-client-to-backend connected check. Read it before describing what
FuseForge has actually coordinated.

[`track-classification-2026-08-27.md`](track-classification-2026-08-27.md)
measures how often the coordinator asked about persistence instead of deciding
for the user, before and after the fix. Read it before describing classification
stability.

[`marketplace-2026-11-19.md`](marketplace-2026-11-19.md) records the Claude
Code plugin marketplace install, update, and removal of all three packs, plus
live root and activation probes on the installed copies.

[`jira-crucible-2026-11-19.md`](jira-crucible-2026-11-19.md) records the live
Jira and Crucible runs for slices 11 and 12, including the Jira run that wrote
cards without its workflow before the stop rule was added.

[`tag-ci-2026-11-25.md`](tag-ci-2026-11-25.md) records the first tag-triggered
release readiness check: every Lint step on a simulated tag, the failure on a
wrong tag, and the hosted tag run that gates the GitHub Release.

[`nestjs-selection-2026-11-25.md`](nestjs-selection-2026-11-25.md) records the
selection gate on a repository with a NestJS backend after OOPforge v1.15.0.

[`review-2026-11-25.md`](review-2026-11-25.md) records the first live
full-stack review against a seeded branch and its pass criteria.

[`self-install-2026-08-27.md`](self-install-2026-08-27.md) records the installer,
uninstaller, and self-aware doctor, with a live install, activation probe, and
removal. Read it before describing how FuseForge is installed.

[`consult-2026-08-27.md`](consult-2026-08-27.md) records Consult moving from
Skeleton to experimental advisory behavior, including the live probe and the
Codex and Cursor Craft activation probes that slice 8 did not run after
installing.

[`field-gaps-2026-11-18.md`](field-gaps-2026-11-18.md) records the policy
changes made after a run against two existing repositories behind an
authenticated backend. Read it before describing authenticated connected checks.

[`evals-2026-11-16.md`](evals-2026-11-16.md) records `claude plugin eval` with
and without the plugin, plus Haiku and Sonnet, for v0.5.0.

## Baseline contents

A coordinator Test record states:

- the date and approved implementation slices;
- static and isolated checks;
- live activation results per harness;
- skipped or blocked checks and their impact;
- whether connected evidence is applicable.

Evidence levels must remain distinct:

- static packaging and routing;
- isolated filesystem behavior;
- authenticated live harness activation;
- connected frontend-client-to-backend behavior.

Released-flow acceptance has live Claude, Codex, and Cursor activation through
the skill-directory install, and no connected calendar evidence.

The calendar Slice 1 record has connected evidence: the real frontend client
called a running backend on Cursor Agent with Compforge 1.3.1 and OOPforge 1.4.2.
It covers one slice of one product and does not generalize to other stacks,
harnesses, or later calendar slices.
