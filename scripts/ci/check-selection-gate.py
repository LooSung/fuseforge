#!/usr/bin/env python3
"""Validate the first FuseForge implementation slice without dependencies."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
VERSION = "0.3.0"
PROBE_LINES = (
    "FUSEFORGE_LOADED",
    "Assumptions",
    "Selection Gate",
)


def read(relative_path: str) -> str:
    return (ROOT / relative_path).read_text(encoding="utf-8")


def load_json(relative_path: str) -> dict[str, object]:
    return json.loads(read(relative_path))


def flatten(text: str) -> str:
    """Collapse whitespace so a marker survives Markdown reflow."""
    return " ".join(text.split())


def require(text: str, markers: tuple[str, ...], source: str) -> None:
    flat = flatten(text)
    missing = [marker for marker in markers if flatten(marker) not in flat]
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
            "An unresolved track and a missing required stack are always user",
            "Ask all missing stack and topology choices in one checkpoint.",
            "Never ask the user to select Cursor, Claude, or Codex",
            "After presenting unresolved choices, stop.",
        ),
        "skills/workflow/craft.md",
    )

    require(
        craft,
        (
            "### 2.1 A track is never inferred from silence",
            "A track is settled only when the request states it or an existing"
            " project shows it. Silence is not a decision.",
            "If the request does not say whether the data must still be there"
            " after the browser is closed, the backend track is unresolved and"
            " belongs in the selection gate. Ask; do not choose.",
            "unresolved track, stack, and topology choices",
        ),
        "skills/workflow/craft.md",
    )

    if "a backend choice for frontend-only work" in craft:
        raise AssertionError(
            "craft.md must not let a self-made frontend-only classification "
            "forbid the backend question"
        )

    require(
        read("skills/SKILL.md"),
        (
            "If a required policy file cannot be read, stop and report which"
            " file and why.",
            "Never reconstruct the workflow from memory, and never emit"
            " `Assumptions`, `Selection Gate`, or any other section of the"
            " response contract without having read the policy that defines it.",
            "Never settle a frontend or backend track that the request left"
            " silent.",
        ),
        "skills/SKILL.md",
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
        (
            "../../../skills/SKILL.md",
            "must not create calendar",
            "If a required policy file cannot be read, stop and report it.",
            "Never settle a track the request left silent.",
        ),
        ".cursor-plugin/skills/fuseforge/SKILL.md",
    )

    if "Skeleton only" not in read("skills/workflow/consult.md"):
        raise AssertionError("Consult must remain Skeleton-only in this slice")

    print("FuseForge selection-gate checks passed")


if __name__ == "__main__":
    main()
