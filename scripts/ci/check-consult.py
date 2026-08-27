#!/usr/bin/env python3
"""Validate the FuseForge Consult workflow and its Craft boundary."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POLICY = "skills/workflow/consult.md"
CONSULT_PROBE_LINES = (
    "FUSEFORGE_CONSULT_LOADED",
    "Mode: answer",
    "Write permission: none",
)


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
    """Consult is experimental behavior, not a Skeleton interface."""
    text = read(POLICY)
    if "Skeleton only" in text:
        raise AssertionError(f"{POLICY} still declares itself Skeleton only")
    if "Experimental" not in text:
        raise AssertionError(f"{POLICY} must state its experimental status")

    registry = json.loads(read("skills/stability.json"))
    relative = "workflow/consult.md"
    if relative not in registry["implemented"]:
        raise AssertionError(f"{relative} must be registered as implemented")
    if relative in registry["skeleton"]:
        raise AssertionError(f"{relative} must no longer be registered as skeleton")
    if registry["skeleton"]:
        raise AssertionError(
            "stability registry still lists skeleton entries after Consult "
            f"promotion: {registry['skeleton']}"
        )


def check_modes() -> None:
    """Four sibling modes, comparison is Proposal, and the Mode header is required."""
    require(
        POLICY,
        "Select exactly one mode using the priority below.",
        "Begin with `Mode: <token> | Write permission: <none|one document>`",
        "exact lowercase mode token",
        "**Document**",
        "**Review**",
        "**Proposal**",
        "**Answer**",
        "always Proposal, even when",
        "complete Review or Answer only",
        "Do not change mode silently and do not implement",
    )


def check_read_only_default() -> None:
    """Consult must not implement or create coordinator product state."""
    require(
        POLICY,
        "read-only by default",
        "must not implement product behavior, change specialist source, or",
        "bypass workflow checkpoints",
        "Never implement product behavior or change specialist source.",
        "Never create a shared contract, workspace, or `.craft/fuseforge/` state.",
        "Never write a document without explicit document wording",
        "Write permission: one planning document",
        "Never write product source, specialist source, tests, configuration, CI, or",
    )


def check_craft_boundary() -> None:
    """Silent track, stack, and topology choices stay in Craft."""
    require(
        POLICY,
        "Never settle a silent track, stack, or topology.",
        "That decision belongs to Craft's selection gate",
        "Never emit Craft's `Assumptions` or `Selection Gate` from Consult.",
        "Do not switch to Craft because the",
        "question would be easier to answer by implementing",
    )


def check_specialist_boundary() -> None:
    """Consult does not impersonate Compforge or OOPforge methodology."""
    require(
        POLICY,
        "It does not duplicate",
        "A purely frontend question stops and names Compforge Consult.",
        "A purely backend question stops and names OOPforge Consult.",
        "Do not impersonate the specialist.",
        "Never claim a specialist Consult was executed.",
    )


def check_unread_policy() -> None:
    """An unreadable Consult file must stop the turn."""
    require(
        POLICY,
        "If it cannot be read, stop and",
        "Never reconstruct Consult from memory",
        "never emit `Mode`",
        "without having read the",
        "policy that defines it",
    )
    require(
        "skills/SKILL.md",
        "For a FuseForge Consult request:",
        "Read `workflow/consult.md`.",
        "If a required Consult policy file cannot be read, stop and report which file",
        "Never reconstruct Consult from memory",
        "never emit `Mode`",
    )


def check_routing() -> None:
    """Claude command and Cursor wrapper route Consult without duplicating policy."""
    require(
        "commands/consult.md",
        "FUSEFORGE_CONSULT_PROBE",
        *CONSULT_PROBE_LINES,
        "~/.claude/skills/fuseforge/workflow/consult.md",
        "${CLAUDE_PLUGIN_ROOT}/skills/workflow/consult.md",
        "**$ARGUMENTS**",
        "must not implement product behavior",
    )
    require(
        "skills/SKILL.md",
        "FUSEFORGE_CONSULT_PROBE",
        *CONSULT_PROBE_LINES,
        "Execute only the implemented Consult workflow.",
    )
    require(
        ".cursor-plugin/skills/fuseforge/SKILL.md",
        "FUSEFORGE_CONSULT_PROBE",
        *CONSULT_PROBE_LINES,
        "Consult is read-only by default and must not implement product behavior.",
    )
    skill = read("skills/SKILL.md")
    if "Skeleton interface" in skill:
        raise AssertionError(
            "skills/SKILL.md still calls a file a Skeleton interface after "
            "Consult promotion"
        )
    command = read("commands/consult.md")
    if "Skeleton only" in command:
        raise AssertionError("commands/consult.md still declares itself Skeleton only")


def main() -> None:
    check_status()
    check_modes()
    check_read_only_default()
    check_craft_boundary()
    check_specialist_boundary()
    check_unread_policy()
    check_routing()
    print("FuseForge consult checks passed")


if __name__ == "__main__":
    main()
