#!/usr/bin/env python3
"""Check FuseForge release metadata without publishing a release."""

from __future__ import annotations

import argparse
import json
import os
import re
from pathlib import Path

SEMVER_RE = re.compile(
    r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)"
    r"(?:-[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?"
    r"(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$"
)


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def release_tag(argument: str | None) -> str | None:
    if argument:
        return argument
    if os.environ.get("GITHUB_REF_TYPE") == "tag":
        return os.environ.get("GITHUB_REF_NAME")
    return None


def check(root: Path, tag: str | None) -> str:
    manifests = [
        read_json(root / relative)
        for relative in (
            ".claude-plugin/plugin.json",
            ".codex-plugin/plugin.json",
            ".cursor-plugin/plugin.json",
        )
    ]
    versions = {manifest["version"] for manifest in manifests}
    assert all(manifest.get("license") == "MIT" for manifest in manifests)
    versions.add(read_json(root / "skills/stability.json")["version"])
    assert len(versions) == 1, "plugin manifests and stability registry differ"
    version = versions.pop()
    assert SEMVER_RE.fullmatch(version), f"invalid SemVer: {version}"

    license_text = (root / "LICENSE").read_text(encoding="utf-8")
    assert license_text.startswith("MIT License\n"), "LICENSE must contain MIT text"

    changelog = (root / "CHANGELOG.md").read_text(encoding="utf-8")
    assert "## [Unreleased]" in changelog, "CHANGELOG lacks Unreleased section"

    process = root / "docs/reference/release-process.md"
    evidence = root / "docs/verification/coordinator-test-2026-08-27.md"
    assert process.is_file(), "manual release process is missing"
    assert evidence.is_file(), "coordinator verification evidence is missing"
    evidence_text = evidence.read_text(encoding="utf-8")
    assert "Approved with static Codex evidence" in evidence_text
    assert "Connected evidence" in evidence_text

    if tag is not None:
        assert tag == f"v{version}", (
            f"tag {tag!r} must match repository version v{version}"
        )
    return version


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--tag", help="expected release tag, for example v0.1.0")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[2]
    tag = release_tag(args.tag)
    version = check(root, tag)
    print(f"PASS release readiness metadata for {version}")
    if tag:
        print(f"PASS release tag matches: {tag}")
    else:
        print("NOTICE no tag supplied; repository preparation checked only")
    print("NOTICE Codex live activation is static-only at the approved checkpoint")
    print("NOTICE connected calendar verification is not yet applicable")


if __name__ == "__main__":
    main()
