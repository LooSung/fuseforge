#!/usr/bin/env python3
"""Validate Design delegation, barrier, and rev-2 authority policy."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def require(path: str, *markers: str) -> None:
    text = (ROOT / path).read_text(encoding="utf-8")
    missing = [marker for marker in markers if marker not in text]
    if missing:
        raise AssertionError(f"{path} missing: {', '.join(missing)}")


def main() -> None:
    require(
        "skills/coordination/delegation.md",
        "run its activation probe",
        "same shared contract `rev-1`",
        "disjoint roots",
        "creates application source",
        "`base_revision` is `unavailable`",
        "Preserve a valid unrelated track",
    )
    require(
        "skills/coordination/stage-barrier.md",
        ".craft/fuseforge/proposed-rev-2-calendar.md",
        "It is not authoritative.",
        "Only explicit approval permits the parent",
        "Specialists never edit the shared contract.",
    )
    require(
        "skills/coordination/shared-contract.md",
        "After the user approves one integrated wire checkpoint",
        "change the revision to `rev-2`",
        "all later delegation must use",
    )
    require(
        "skills/workflow/craft.md",
        "Keep the barrier closed for missing, failed, cancelled, decision-required,",
        "Do not edit the tracked shared contract before",
        "separate slice.",
    )

    stability = json.loads((ROOT / "skills/stability.json").read_text())
    implemented = set(stability["implemented"])
    for path in (
        "coordination/delegation.md",
        "coordination/stage-barrier.md",
    ):
        if path not in implemented:
            raise AssertionError(f"{path} is not marked implemented")

    print("FuseForge delegation-barrier checks passed")


if __name__ == "__main__":
    main()
