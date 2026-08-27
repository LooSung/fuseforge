#!/usr/bin/env python3
"""Validate parent-owned connected verification policy and its boundaries."""

from __future__ import annotations

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
POLICY = "skills/coordination/connected-verification.md"


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def require(path: str, *markers: str) -> None:
    text = read(path)
    missing = [marker for marker in markers if marker not in text]
    if missing:
        raise AssertionError(f"{path} missing: {', '.join(missing)}")


def check_real_boundary() -> None:
    """The check must use the real client and the real HTTP adapter."""
    require(
        POLICY,
        "The real frontend API client called a running backend",
        "actual frontend transport client and the actual backend",
        "never a re-implementation or a mock of either side",
        "at least one accepted product flow end to end",
        "the error meaning the frontend state depends on",
        "application-timezone offset behavior",
        "the shared-contract revision it ran against",
    )


def check_excluded_scopes() -> None:
    """OpenAPI-only, browser E2E, and infrastructure stay out."""
    require(
        POLICY,
        "OpenAPI-only validation is insufficient",
        "Browser E2E, deployment, and",
        "production readiness remain separate opt-in scopes",
        "no database server, container, or external",
        "A browser is not required",
    )


def check_ownership() -> None:
    """Specialist writes the check; parent runs it and owns the record."""
    require(
        POLICY,
        "## Ownership",
        "The frontend specialist writes the connected check inside its own work",
        "The parent starts the backend,",
        "runs that one named check, and writes the evidence record",
        "runs no specialist suite to manufacture specialist evidence",
        "The parent never writes the check, product source",
    )
    require(
        "skills/coordination/delegation.md",
        "The one parent-run exception is the commissioned",
    )


def check_lifecycle() -> None:
    """Readiness is polled, timeouts fail, and teardown always runs."""
    require(
        POLICY,
        "waits for readiness by polling the backend's own endpoint",
        "Poll for readiness rather than sleeping a fixed interval",
        "A readiness timeout is",
        "a failed check, never a pass",
        "Teardown always runs",
        "stops the backend, including on failure",
        "Report a port conflict instead of editing product source",
    )


def check_evidence_record() -> None:
    """Evidence is parent-written, product-located, and observation-only."""
    require(
        POLICY,
        "<coordination-root>/docs/features/<feature-slug>/connected-verification.md",
        "Product evidence never lands in a pack repository",
        "the frontend and backend commands actually run",
        "what was not proven, including browser behavior and deployment",
        "Never record an outcome that was not observed",
        "recorded as blocked or failed",
    )


def check_completion_rule() -> None:
    """A slice is incomplete without a passing, recorded check."""
    require(
        POLICY,
        "## Completion rule",
        "the connected check passed and was recorded",
        "report the feature as not proven end to end",
    )
    require(
        "skills/coordination/stage-barrier.md",
        "## Slice completion barrier",
        "A missing, failed, or",
        "unrecorded check keeps the slice incomplete",
        "Specialist tests alone never satisfy this barrier",
    )
    require(
        "skills/workflow/craft.md",
        "A slice is complete only after the parent-owned check in",
    )
    require(
        "skills/SKILL.md",
        "A product slice is complete only after the parent-owned connected check",
        "Never claim that a frontend client was proven against a",
    )


def check_registry() -> None:
    """The policy is registered as implemented and no longer Skeleton."""
    text = read(POLICY)
    if "Skeleton only" in text:
        raise AssertionError(f"{POLICY} still declares itself Skeleton only")
    if "Experimental" not in text:
        raise AssertionError(f"{POLICY} must state its experimental status")

    registry = json.loads(read("skills/stability.json"))
    relative = "coordination/connected-verification.md"
    if relative not in registry["implemented"]:
        raise AssertionError(f"{relative} must be registered as implemented")
    if relative in registry["skeleton"]:
        raise AssertionError(f"{relative} must no longer be registered as skeleton")


def check_no_product_evidence_in_pack() -> None:
    """Product connected evidence must not be recorded inside the pack."""
    features = ROOT / "docs" / "features"
    if features.exists():
        raise AssertionError(
            "docs/features/ is a product-workspace path; it must not exist in the pack"
        )


def main() -> None:
    check_real_boundary()
    check_excluded_scopes()
    check_ownership()
    check_lifecycle()
    check_evidence_record()
    check_completion_rule()
    check_registry()
    check_no_product_evidence_in_pack()
    print("FuseForge connected-verification checks passed")


if __name__ == "__main__":
    main()
