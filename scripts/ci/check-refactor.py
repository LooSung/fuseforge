#!/usr/bin/env python3
"""Validate the FuseForge Refactor workflow: specialist rules, frozen wire, one stop."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POLICY = "skills/workflow/refactor.md"
COMMAND = "commands/refactor.md"
DELEGATION = "skills/coordination/delegation.md"


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
    if "workflow/refactor.md" not in registry["implemented"]:
        raise AssertionError("workflow/refactor.md must be registered as implemented")


def check_scope() -> None:
    """Both tracks, no behavior change, and Crucible keeps its own stage 5."""
    require(
        POLICY,
        "A request for one track only stops and names `/compforge:refactor` or `/oopforge:refactor`",
        "A request that changes behavior is not a refactor",
        "Inside a Crucible slice, Crucible's stage 5 governs instead.",
        "Ask when ownership is ambiguous.",
    )


def check_specialist_rules() -> None:
    text = flatten(read(POLICY))
    frontend = text.find("frontend: the loaded Compforge skill's `workflow/refactor.md`")
    backend = text.find("backend: the loaded OOPforge skill's `workflow/refactor.md`")
    if frontend < 0 or backend < 0:
        raise AssertionError(f"{POLICY} must name each track's own specialist refactor file")
    require(
        POLICY,
        "report which file was read",
        "Never reconstruct specialist rules from memory.",
        "The track follows its own pack's `workflow/refactor.md` and writes only inside its write root.",
        "Never refactor one track by the other pack's rules, or copy a specialist rule.",
    )


def check_wire_and_stop() -> None:
    """The wire surface is frozen and one approval precedes any edit."""
    text = flatten(read(POLICY))
    order = [
        text.find("## Freeze the wire surface"),
        text.find("## Approval stop"),
        text.find("## Run each track"),
    ]
    if -1 in order or order != sorted(order):
        raise AssertionError(f"{POLICY} must freeze, then stop, then run")
    require(
        POLICY,
        "Nothing on this list may change during the refactor.",
        "its current revision is the frozen surface",
        "**Stop and ask the user to approve.** This stop is mandatory, even when the request said to proceed.",
        "the write root for each track — its work target, nothing outside it;",
        "the test commands each track runs before and after.",
        "Never edit before the approval stop.",
    )


def check_acceptance() -> None:
    require(
        POLICY,
        "Reject a track result when it changes visible behavior, a public name, or the frozen wire surface",
        "lacks a passing test run before and after, with commands and observed results; or carries feature work.",
        "A rejected result is never reported as done",
        "A recorded connected check is stale once source changed.",
        "Never commit unless the user asked in this request.",
        "Never pick a refactor target from FuseForge's own reading of the code",
    )
    require(
        DELEGATION,
        "Standalone Refactor (`workflow/refactor.md`) uses the Refactor half without `rev-2` or a connected check",
        "with the frozen surface standing in for the contract",
    )


def check_routing() -> None:
    require(
        "skills/SKILL.md",
        "For a FuseForge Refactor request",
        "Read `workflow/refactor.md` and `coordination/delegation.md`.",
        "Stop for approval before any edit.",
        "/fuseforge:refactor",
    )
    require(
        COMMAND,
        "If neither path can be read, stop and report which paths failed.",
        "Stop for approval before any edit.",
        "FUSEFORGE_ACTIVATION_PROBE",
        "FUSEFORGE_LOADED",
    )
    command = read(COMMAND)
    first = command.find("~/.claude/skills/fuseforge/workflow/refactor.md")
    second = command.find("${CLAUDE_PLUGIN_ROOT}/skills/workflow/refactor.md")
    if first < 0 or second < 0 or first > second:
        raise AssertionError(f"{COMMAND} must prefer the skill-directory path")


def main() -> None:
    check_status()
    check_scope()
    check_specialist_rules()
    check_wire_and_stop()
    check_acceptance()
    check_routing()
    print("PASS refactor workflow")


if __name__ == "__main__":
    main()
