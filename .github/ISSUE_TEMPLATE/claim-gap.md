---
name: Unsupported claim or evidence gap
about: A document claims more than the evidence supports
title: "[claim] "
labels: documentation
---

FuseForge treats an overstated claim as a defect. Use this template when a
document describes something as implemented, supported, or verified beyond what
the evidence shows.

## The claim

Quote it and link the file and line.

## Why the evidence does not support it

What you observed, and which evidence level it belongs to:

- static packaging and routing
- isolated filesystem behavior
- authenticated live harness activation
- connected frontend-client-to-backend behavior

## What you observed

```text
<paste redacted output here>
```

## Suggested correction

The narrowest wording that would be accurate. If the claim should instead be
proven, say what evidence would settle it.

## Related documents

Other files that repeat the same claim, for example
`docs/reference/support-scope.md`, `README.md`, `README.ko.md`, or a record under
`docs/verification/`.
