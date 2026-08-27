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
