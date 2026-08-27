#!/usr/bin/env python3
"""Validate Implement delegation, dependency, and partial-completion policy."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def require(path: str, *markers: str) -> None:
    text = (ROOT / path).read_text(encoding="utf-8")
    missing = [marker for marker in markers if marker not in text]
    if missing:
        raise AssertionError(f"{path} missing: {', '.join(missing)}")


def forbid(path: str, *markers: str) -> None:
    text = (ROOT / path).read_text(encoding="utf-8")
    present = [marker for marker in markers if marker in text]
    if present:
        raise AssertionError(f"{path} must not claim: {', '.join(present)}")


def check_delegation() -> None:
    """Revision, activation, write roots, scope, and dependency rules."""
    require(
        "skills/coordination/delegation.md",
        "## Calendar Implement delegation",
        "run its activation probe",
        "shared contract reached `rev-2`",
        "A result on an earlier revision is stale.",
        "<coordination-root>/frontend/",
        "<coordination-root>/backend/",
        "never in a pack repository",
        "parent-owned and are never assigned to a specialist",
        "recurrence, reminders, multiple calendars, and other views",
        "write roots verified disjoint immediately before delegation",
        "The owning specialist installs dependencies inside its own work target",
        "FuseForge never runs a package manager",
        "no database server,",
        "container, or external service may be introduced",
        "omits source, tests, or `dependencies_added`",
        "writes outside its assigned work target",
        "without reporting `scope_drift`",
        "edits the shared contract",
        "reports passing evidence without a command and an observed result",
        "FuseForge writes no application source and runs no specialist suite to",
        "manufacture specialist evidence",
        "against unchanged `rev-2`",
    )


def check_barrier() -> None:
    """Barrier closure, partial completion, and contract authority."""
    require(
        "skills/coordination/stage-barrier.md",
        "## Integrated Implement checkpoint",
        "both tracks on the current `rev-2`",
        "specialist test evidence naming commands and observed results",
        "source confined to each track's work target",
        "reported `dependencies_added` for each track",
        "no application source written by the parent",
        "### Partial completion is not success",
        "work end to end, name which half exists",
        "offer retry of the failed track only",
        "connected frontend-to-backend verification has not run",
        "only an approved integrated checkpoint may produce `rev-3`",
    )


def check_entry_points() -> None:
    """Craft routing and the canonical skill boundary."""
    require(
        "skills/workflow/craft.md",
        "## 9. Specialist Implement delegation",
        "Delegate calendar Slice 1 against `rev-2`",
        "runs no package manager",
    )
    require(
        "skills/SKILL.md",
        "Do not create frontend or backend source",
        "only under an approved Implement delegation",
    )
    require(
        ".cursor-plugin/skills/fuseforge/SKILL.md",
        "must not create calendar",
    )


def check_registry() -> None:
    """Implement policy lives in registered, implemented policy files."""
    registry = json.loads((ROOT / "skills/stability.json").read_text(encoding="utf-8"))
    for relative in ("coordination/delegation.md", "coordination/stage-barrier.md"):
        if relative not in registry["implemented"]:
            raise AssertionError(f"{relative} is not marked implemented")


def check_no_calendar_source() -> None:
    """This slice adds coordinator policy, never product source."""
    forbidden = [
        path
        for pattern in ("*.tsx", "*.jsx", "*.ts", "*.py")
        for path in (ROOT / "frontend").glob(pattern)
    ]
    forbidden += [path for path in (ROOT / "backend").glob("*") if path.is_file()]
    if forbidden:
        names = ", ".join(str(path.relative_to(ROOT)) for path in forbidden)
        raise AssertionError(f"calendar source must not live in the pack: {names}")


def main() -> None:
    check_delegation()
    check_barrier()
    check_entry_points()
    check_registry()
    check_no_calendar_source()
    print("FuseForge implement-delegation checks passed")


if __name__ == "__main__":
    main()
