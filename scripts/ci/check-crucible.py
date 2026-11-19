#!/usr/bin/env python3
"""Validate FuseForge Crucible: stage order, kept checkpoints, specialist delegation."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POLICY = "skills/workflow/crucible.md"
COMMAND = "commands/crucible.md"
DELEGATION = "skills/coordination/delegation.md"
BARRIER = "skills/coordination/stage-barrier.md"


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def flatten(text: str) -> str:
    return " ".join(text.split())


def require(path: str, *markers: str) -> None:
    text = flatten(read(path))
    missing = [marker for marker in markers if flatten(marker) not in text]
    if missing:
        raise AssertionError(f"{path} missing: {', '.join(missing)}")


def check_status() -> None:
    require(POLICY, "Status: **Experimental**.")
    registry = json.loads(read("skills/stability.json"))
    if "workflow/crucible.md" not in registry["implemented"]:
        raise AssertionError("workflow/crucible.md must be registered as implemented")


def check_stage_order() -> None:
    """Gate, plan, Design, Build, Refactor, Test, recheck — in that order."""
    text = read(POLICY)
    headings = (
        "### 1. Gate and workspace",
        "### 2. Plan",
        "### 3. Design",
        "### 4. Build",
        "### 5. Refactor",
        "### 6. Test",
        "### 7. Connected recheck",
    )
    positions = [text.find(heading) for heading in headings]
    if -1 in positions or positions != sorted(positions):
        raise AssertionError(f"{POLICY} stages missing or out of order")


def check_kept_checkpoints() -> None:
    """Crucible never removes a FuseForge human checkpoint."""
    require(
        POLICY,
        "**Stop and ask the user to approve the plan.** This stop is mandatory.",
        "The integrated `rev-2` checkpoint is a stop: the plan does not approve wire semantics.",
        "Each is a stop while it has an open choice or an unconfirmed path.",
        "Never skip the selection gate, path confirmation, the plan approval, or the `rev-2` approval.",
        "the plan approval is the approved turn that starts Design, and the `rev-2` approval is the approved turn that starts Implement.",
    )
    require(
        BARRIER,
        "In Crucible, the approved slice plan is that approval when this barrier is fully ready and the connected check passed",
        "any unmet condition still stops.",
    )


def check_delegation() -> None:
    """Refactor and Test stay specialist work, triggered by evidence."""
    require(
        POLICY,
        "FuseForge never decides a refactor from its own reading of the code.",
        "Never write application source or tests; the specialists do.",
        "Never run a specialist's crucible; delegate its Refactor and Test workflows.",
        "Rerun the connected check only when stage 5 changed a track's source.",
        "Never report the slice complete without a passing, recorded connected check after the last source change.",
    )
    require(
        DELEGATION,
        "## Refactor and Test delegation",
        "never its crucible",
        "Reject a Test result when it changes production code.",
        "A Refactor result that changed source invalidates the last connected check.",
    )


def check_routing() -> None:
    require(
        "skills/SKILL.md",
        "For a FuseForge Crucible request:",
        "Read `workflow/crucible.md`",
        "/fuseforge:crucible",
    )
    command = read(COMMAND)
    first = command.find("~/.claude/skills/fuseforge/workflow/crucible.md")
    second = command.find("${CLAUDE_PLUGIN_ROOT}/skills/workflow/crucible.md")
    if first < 0 or second < 0 or first > second:
        raise AssertionError(f"{COMMAND} must prefer the skill-directory path")
    require(
        COMMAND,
        "FUSEFORGE_ACTIVATION_PROBE",
        "If neither path can be read, stop and report which paths failed.",
        "Stop for the plan approval and the `rev-2` approval.",
    )


def main() -> None:
    check_status()
    check_stage_order()
    check_kept_checkpoints()
    check_delegation()
    check_routing()
    print("PASS crucible workflow")


if __name__ == "__main__":
    main()
