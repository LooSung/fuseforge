# Implementation slices

- [Slice 1](implementation-slice-1.md)
- [Slice 2 plan](implementation-slice-2-plan.md) and [evidence](implementation-slice-2.md)
- [Slice 3 plan](implementation-slice-3-plan.md) and [evidence](implementation-slice-3.md)
- [Slice 4 plan](implementation-slice-4-plan.md) and [evidence](implementation-slice-4.md)
- [Slice 5 plan](implementation-slice-5-plan.md) and [evidence](implementation-slice-5.md)
- [Slice 6 plan](implementation-slice-6-plan.md) and [evidence](implementation-slice-6.md)
- [Slice 7 plan](implementation-slice-7-plan.md) and [evidence](implementation-slice-7.md)
- [Slice 8 plan](implementation-slice-8-plan.md) and [evidence](implementation-slice-8.md)
- [Slice 9 plan](implementation-slice-9-plan.md) and [evidence](implementation-slice-9.md)

Each slice preserves its approved scope and checkpoint evidence.

Slices 1 through 9 are implemented and statically verified. This pack contains no
calendar application source by design.

The coordinator flow has since been executed once end to end against a separate
product workspace, with a passing connected check. See
[calendar Slice 1](../../verification/calendar-slice-1-2026-08-27.md).

Slice 7 is the first slice verified by measuring live behavior before and after
the change, in
[track classification](../../verification/track-classification-2026-08-27.md).

Slice 8 gives FuseForge the installer, uninstaller, and self-aware doctor that its
sibling packs already had. Evidence:
[self-install](../../verification/self-install-2026-08-27.md).

Slice 9 turns `/fuseforge:consult` from a Skeleton interface into experimental
advisory behavior. Evidence:
[consult](../../verification/consult-2026-08-27.md).
