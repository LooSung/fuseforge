# FuseForge verification

Verification records packaging and coordinator behavior evidence. It is
separate from future product connected verification.

The approved coordinator Test baseline is
[`coordinator-test-2026-08-27.md`](coordinator-test-2026-08-27.md).

[`released-flow-acceptance-2026-08-27.md`](released-flow-acceptance-2026-08-27.md)
re-verifies that baseline against the published `v0.1.0` and supersedes its
harness claims. Read it before describing install or harness support.

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
