#!/usr/bin/env python3
"""Validate the greenfield workspace and rev-1 policy slice."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def read(relative_path: str) -> str:
    return (ROOT / relative_path).read_text(encoding="utf-8")


def require(source: str, *markers: str) -> None:
    text = read(source)
    missing = [marker for marker in markers if marker not in text]
    if missing:
        raise AssertionError(f"{source} is missing: {', '.join(missing)}")


def main() -> None:
    require(
        "skills/SKILL.md",
        "Before exact path confirmation, remain read-only.",
        "product-semantics contract `rev-1`",
        "Do not create frontend or backend source",
    )
    require(
        "skills/workflow/craft.md",
        "A prior generic approval is not path confirmation.",
        "Confirmation is incomplete unless it covers coordination, frontend, backend,",
        "and `.gitignore` paths from the current plan.",
        "existing empty directories may be reused only when named",
        "a non-empty directory, file, or symlink blocks",
        "Stop after workspace creation. Specialist Design begins only",
    )
    require(
        "skills/coordination/logical-workspace.md",
        "<base>/<product-slug>/",
        "<base>/<product-slug>-coordination/",
        "Never run `git init`.",
        ".craft/fuseforge/task-<feature-slug>.md",
        "meaning must not be copied into local state.",
    )
    require(
        "skills/coordination/shared-contract.md",
        "Revision: rev-1",
        "Product semantics approved; wire semantics unresolved",
        "## Unresolved wire decisions",
        "Absolute paths, pack versions, harness identity, and session progress",
        "specialist design. Do not guess",
    )

    stability = json.loads(read("skills/stability.json"))
    implemented = stability.get("implemented", [])
    if "coordination/shared-contract.md" not in implemented:
        raise AssertionError("shared-contract.md is not marked implemented")
    if "coordination/shared-contract.md" in stability.get("skeleton", []):
        raise AssertionError("shared-contract.md is still marked Skeleton-only")

    require(
        ".cursor-plugin/skills/fuseforge/SKILL.md",
        "../../../skills/SKILL.md",
    )
    require(
        "commands/craft.md",
        "${CLAUDE_PLUGIN_ROOT}/skills/workflow/craft.md",
    )

    print("FuseForge workspace-contract checks passed")


if __name__ == "__main__":
    main()
