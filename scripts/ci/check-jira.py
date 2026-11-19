#!/usr/bin/env python3
"""Validate the FuseForge Jira workflow: specialist template, both tracks home."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POLICY = "skills/workflow/jira.md"
COMMAND = "commands/jira.md"


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
    if "workflow/jira.md" not in registry["implemented"]:
        raise AssertionError("workflow/jira.md must be registered as implemented")


def check_template_source() -> None:
    """The template is read from a specialist pack, never copied or rebuilt."""
    text = flatten(read(POLICY))
    compforge = text.find("the loaded Compforge skill's")
    oopforge = text.find("the loaded OOPforge skill's")
    if compforge < 0 or oopforge < 0 or compforge > oopforge:
        raise AssertionError(f"{POLICY} must read Compforge first, then OOPforge")
    require(
        POLICY,
        "FuseForge keeps no Jira template of its own.",
        "report which one was read",
        "Never reconstruct the template, its sections, or its Jira-writing rules from memory.",
        "point to `docs/setup/bootstrap.md`",
    )
    if "## 개요" in read(POLICY):
        raise AssertionError(f"{POLICY} must not carry a copy of the template")


def check_children_overrides() -> None:
    """FuseForge owns both tracks, so F.E and B.E are home children."""
    require(
        POLICY,
        "Home: F.E+B.E",
        "Do not ask for a home track.",
        "`[F.E]` and `[B.E]` are both home children.",
        "Never use foreign-child wording for `[F.E]` or `[B.E]`.",
        "`[AI]` and `[DOC]` keep the specialist foreign-child rules.",
        "never invent an endpoint, a payload, or a revision.",
        "The specialist cap of six children applies.",
    )


def check_write_boundary() -> None:
    require(
        POLICY,
        "Jira issues are the only write.",
        "Never write code, tests, configuration, the shared contract, a workspace, or `.craft/fuseforge/` state.",
        "Never write to Jira without an explicit request in this turn.",
        "Never write a single-track card or single-track children here.",
    )
    require(
        COMMAND,
        "Jira issues are the only write.",
        "If neither path can be read, stop and report which paths failed.",
        "Never write a card or a child without this workflow and the specialist template it names.",
    )


def check_routing() -> None:
    require(
        "skills/SKILL.md",
        "For a FuseForge Jira request:",
        "Read `workflow/jira.md`.",
        "never reconstruct the template.",
        "/fuseforge:jira",
    )
    command = read(COMMAND)
    first = command.find("~/.claude/skills/fuseforge/workflow/jira.md")
    second = command.find("${CLAUDE_PLUGIN_ROOT}/skills/workflow/jira.md")
    if first < 0 or second < 0 or first > second:
        raise AssertionError(f"{COMMAND} must prefer the skill-directory path")
    require(COMMAND, "FUSEFORGE_ACTIVATION_PROBE", "FUSEFORGE_LOADED")


def main() -> None:
    check_status()
    check_template_source()
    check_children_overrides()
    check_write_boundary()
    check_routing()
    print("PASS jira workflow")


if __name__ == "__main__":
    main()
