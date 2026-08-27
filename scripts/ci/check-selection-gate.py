#!/usr/bin/env python3
"""Validate the first FuseForge implementation slice without dependencies."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
VERSION = "0.2.0"
PROBE_LINES = (
    "FUSEFORGE_LOADED",
    "Assumptions",
    "Selection Gate",
)


def read(relative_path: str) -> str:
    return (ROOT / relative_path).read_text(encoding="utf-8")


def load_json(relative_path: str) -> dict[str, object]:
    return json.loads(read(relative_path))


def require(text: str, markers: tuple[str, ...], source: str) -> None:
    missing = [marker for marker in markers if marker not in text]
    if missing:
        raise AssertionError(f"{source} is missing: {', '.join(missing)}")


def main() -> None:
    manifests = (
        ".claude-plugin/plugin.json",
        ".codex-plugin/plugin.json",
        ".cursor-plugin/plugin.json",
    )
    for manifest in manifests:
        data = load_json(manifest)
        if data.get("version") != VERSION:
            raise AssertionError(f"{manifest} version is not {VERSION}")

    stability = load_json("skills/stability.json")
    if stability.get("version") != VERSION:
        raise AssertionError("skills/stability.json version is inconsistent")

    probe_sources = (
        "skills/SKILL.md",
        "commands/craft.md",
        ".cursor-plugin/skills/fuseforge/SKILL.md",
    )
    for source in probe_sources:
        require(read(source), ("FUSEFORGE_ACTIVATION_PROBE", *PROBE_LINES), source)

    craft = read("skills/workflow/craft.md")
    require(
        craft,
        (
            "This slice is read-only.",
            "A missing required stack is always a user decision.",
            "Ask all missing stack and topology choices in one checkpoint.",
            "Never ask the user to select Cursor, Claude, or Codex",
            "After presenting unresolved choices, stop.",
        ),
        "skills/workflow/craft.md",
    )

    command = read("commands/craft.md")
    require(
        command,
        (
            "${CLAUDE_PLUGIN_ROOT}/skills/workflow/craft.md",
            "~/.claude/skills/fuseforge/workflow/craft.md",
            "**$ARGUMENTS**",
        ),
        "commands/craft.md",
    )

    cursor_wrapper = read(".cursor-plugin/skills/fuseforge/SKILL.md")
    require(
        cursor_wrapper,
        ("../../../skills/SKILL.md", "must not create calendar"),
        ".cursor-plugin/skills/fuseforge/SKILL.md",
    )

    if "Skeleton only" not in read("skills/workflow/consult.md"):
        raise AssertionError("Consult must remain Skeleton-only in this slice")

    print("FuseForge selection-gate checks passed")


if __name__ == "__main__":
    main()
