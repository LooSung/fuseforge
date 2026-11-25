#!/usr/bin/env python3
"""Validate the FuseForge Review workflow: each track by its own specialist."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POLICY = "skills/workflow/review.md"
COMMAND = "commands/review.md"


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
    if "workflow/review.md" not in registry["implemented"]:
        raise AssertionError("workflow/review.md must be registered as implemented")


def check_target() -> None:
    """One target and one base commit for both tracks; a one-track change stops."""
    require(
        POLICY,
        "Resolve exactly one target in the specialists' order",
        "Every track reviews that same target and base commit.",
        "A change in one track only stops and names `/compforge:review` or `/oopforge:review`",
        "When a file's owner is ambiguous, ask instead of guessing.",
        "listed under **Not checked**",
    )


def check_specialist_rules() -> None:
    """Each track uses its own pack's review file, never a copy or the other pack's."""
    text = flatten(read(POLICY))
    frontend = text.find("frontend: the loaded Compforge skill's `workflow/review.md`")
    backend = text.find("backend: the loaded OOPforge skill's `workflow/review.md`")
    if frontend < 0 or backend < 0:
        raise AssertionError(f"{POLICY} must name each track's own specialist review file")
    require(
        POLICY,
        "report which file was read",
        "only that track's files",
        "The specialist file owns the checks, severity, finding format, tools, and `Next` commands.",
        "Drop its pointer to the other pack",
        "Never reconstruct a specialist's checks or severity from memory.",
        "Never judge one track by the other pack's rules, or copy a specialist check.",
    )
    if "| **P1** |" in read(POLICY):
        raise AssertionError(f"{POLICY} must not carry a copy of a severity table")


def check_cross_stack() -> None:
    """FuseForge adds only findings that need both halves, with both lines as evidence."""
    require(
        POLICY,
        "FuseForge adds only findings that need both halves",
        "a cross-stack finding cites both lines",
        "a broken API contract between the halves is P1.",
        "### Cross-stack",
        "cross-stack fixes first, naming the specialist command for each side",
    )


def check_write_boundary() -> None:
    require(
        POLICY,
        "Review reports findings and never changes code",
        "Never post to a pull request without an explicit request in this turn",
        "Never present an unrun check or an unread rule file as passed.",
    )
    require(
        COMMAND,
        "Review writes nothing.",
        "If neither path can be read, stop and report which paths failed.",
        "Never write a review without this workflow and the specialist review files it names.",
    )


def check_routing() -> None:
    require(
        "skills/SKILL.md",
        "For a FuseForge Review request",
        "Read `workflow/review.md`.",
        "never reconstruct its rules.",
        "/fuseforge:review",
        "A review of a plan or a shared contract without a code change stays Consult.",
    )
    require(
        "skills/workflow/consult.md",
        "A request to review a finished change — a pull request, branch, diff, or the working tree — is not Consult.",
    )
    command = read(COMMAND)
    first = command.find("~/.claude/skills/fuseforge/workflow/review.md")
    second = command.find("${CLAUDE_PLUGIN_ROOT}/skills/workflow/review.md")
    if first < 0 or second < 0 or first > second:
        raise AssertionError(f"{COMMAND} must prefer the skill-directory path")
    require(COMMAND, "FUSEFORGE_ACTIVATION_PROBE", "FUSEFORGE_LOADED")


def main() -> None:
    check_status()
    check_target()
    check_specialist_rules()
    check_cross_stack()
    check_write_boundary()
    check_routing()
    print("PASS review workflow")


if __name__ == "__main__":
    main()
