#!/usr/bin/env python3
"""Validate FuseForge harness packaging and skill registry contracts."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

SEMVER_RE = re.compile(
    r"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)"
    r"(?:-[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?"
    r"(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$"
)


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def frontmatter(path: Path) -> dict[str, str]:
    text = path.read_text(encoding="utf-8")
    assert text.startswith("---\n"), f"{path}: missing frontmatter"
    parts = text.split("---", 2)
    assert len(parts) == 3, f"{path}: unclosed frontmatter"
    values: dict[str, str] = {}
    for line in parts[1].splitlines():
        if ": " in line:
            key, value = line.split(": ", 1)
            values[key] = value
    return values


def check_manifests(root: Path) -> str:
    paths = (
        ".claude-plugin/plugin.json",
        ".codex-plugin/plugin.json",
        ".cursor-plugin/plugin.json",
    )
    claude, codex, cursor = [load_json(root / path) for path in paths]
    versions = {item["version"] for item in (claude, codex, cursor)}
    assert len(versions) == 1, "plugin manifest versions differ"
    version = versions.pop()
    assert SEMVER_RE.fullmatch(version), f"invalid SemVer: {version}"
    for manifest in (claude, codex, cursor):
        assert manifest["name"] == "fuseforge"
        assert manifest.get("license") == "MIT"
        assert isinstance(manifest.get("repository"), str)
    assert claude.get("skills") == ["./skills/"]
    assert claude.get("commands") == ["./commands/"]
    assert codex.get("skills") == "./skills/"
    assert cursor.get("skills") == "./.cursor-plugin/skills/"
    assert "commands" not in cursor, "Cursor must not package Claude commands"
    return version


def check_registry(root: Path, version: str) -> None:
    registry = load_json(root / "skills/stability.json")
    assert registry["version"] == version, "manifest and registry versions differ"
    assert registry["status"] == "experimental"
    listed = registry["implemented"] + registry["skeleton"]
    assert len(listed) == len(set(listed)), "stability registry has duplicates"
    for relative in listed:
        assert (root / "skills" / relative).is_file(), (
            f"stability registry references missing file: {relative}"
        )
    actual = sorted(
        str(path.relative_to(root / "skills"))
        for path in (root / "skills").rglob("*.md")
        if path.name != "SKILL.md"
    )
    assert sorted(listed) == actual, "stability registry differs from policy files"
    for relative in registry["implemented"]:
        assert "Experimental" in (root / "skills" / relative).read_text(encoding="utf-8")
    for relative in registry["skeleton"]:
        assert "Skeleton only" in (root / "skills" / relative).read_text(
            encoding="utf-8"
        )


def check_skill_claims(root: Path) -> None:
    """SKILL.md must not contradict the registry about another file's status.

    Slice 6 promoted connected-verification.md and updated the registry but left
    SKILL.md calling it Skeleton, and every check passed, because each policy
    file's own status line was validated while SKILL.md's claims about other
    files were not.
    """
    registry = load_json(root / "skills/stability.json")
    skill = (root / "skills/SKILL.md").read_text(encoding="utf-8")
    marker = "Skeleton interface"
    claim = next(
        (
            " ".join(block.split())
            for block in skill.split("\n\n")
            if marker in block
        ),
        None,
    )
    if not registry["skeleton"]:
        assert claim is None, (
            "skills/SKILL.md still names a Skeleton interface after the "
            "registry has no skeleton entries"
        )
        return
    assert claim is not None, f"skills/SKILL.md must state which files are {marker}s"
    for relative in registry["implemented"]:
        assert relative not in claim, (
            f"skills/SKILL.md calls {relative} a {marker} while the registry "
            "lists it as implemented"
        )
    for relative in registry["skeleton"]:
        assert relative in claim, (
            f"skills/SKILL.md omits skeleton policy {relative} from its "
            f"{marker} statement"
        )


def check_required_paths(root: Path) -> None:
    required = (
        "commands/craft.md",
        "commands/consult.md",
        ".cursor-plugin/skills/fuseforge/SKILL.md",
        "skills/SKILL.md",
        "skills/workflow/craft.md",
        "skills/workflow/consult.md",
        "skills/coordination/logical-workspace.md",
        "skills/coordination/shared-contract.md",
        "skills/coordination/delegation.md",
        "skills/coordination/stage-barrier.md",
        "skills/coordination/connected-verification.md",
        "docs/setup/claude-code.md",
        "docs/setup/codex.md",
        "docs/setup/cursor.md",
        "docs/reference/support-scope.md",
        "docs/setup/install.md",
    )
    for relative in required:
        assert (root / relative).is_file(), f"missing packaging path: {relative}"


def check_setup_parity(root: Path) -> None:
    """FuseForge requires an installer of every pack it accepts, in
    scripts/setup/lib/common.sh. Hold FuseForge itself to the same bar."""
    for relative in (
        "scripts/setup/install.sh",
        "scripts/setup/uninstall.sh",
        "scripts/setup/doctor.sh",
        "scripts/setup/quickstart.sh",
    ):
        path = root / relative
        assert path.is_file(), f"missing setup script: {relative}"
        assert path.stat().st_mode & 0o111, f"not executable: {relative}"

    installer = (root / "scripts/setup/install.sh").read_text(encoding="utf-8")
    for flag in ("--dry-run", "--force", "update"):
        assert flag in installer, f"install.sh does not accept {flag}"

    uninstaller = (root / "scripts/setup/uninstall.sh").read_text(encoding="utf-8")
    flat = " ".join(uninstaller.replace("#", " ").split())
    assert "never deletes the pack source" in flat, (
        "uninstall.sh must state that it never deletes the pack source"
    )

    # A link path known to only some of the three scripts would leak on uninstall
    # or go unreported by doctor, so all three read one shared plan.
    common = (root / "scripts/setup/lib/common.sh").read_text(encoding="utf-8")
    assert "fuseforge_link_plan()" in common, "common.sh must define the link plan"
    for relative in (
        "scripts/setup/install.sh",
        "scripts/setup/uninstall.sh",
        "scripts/setup/doctor.sh",
    ):
        text = (root / relative).read_text(encoding="utf-8")
        assert "fuseforge_link_plan" in text, (
            f"{relative} must use fuseforge_link_plan instead of its own paths"
        )


def check_frontmatter(root: Path) -> None:
    expected = {
        "commands/craft.md": "craft",
        "commands/consult.md": "consult",
        "skills/SKILL.md": "fuseforge",
        ".cursor-plugin/skills/fuseforge/SKILL.md": "fuseforge",
    }
    for relative, name in expected.items():
        metadata = frontmatter(root / relative)
        assert metadata.get("name") == name, f"{relative}: unexpected name"
        assert metadata.get("description"), f"{relative}: missing description"


def check_skill_size(root: Path) -> None:
    limit = 200
    for path in (root / "skills").rglob("*.md"):
        lines = len(path.read_text(encoding="utf-8").splitlines())
        assert lines <= limit, f"{path.relative_to(root)}: {lines} lines (limit {limit})"


def check_activation_probes(root: Path) -> None:
    for relative in (
        "commands/craft.md",
        "skills/SKILL.md",
        ".cursor-plugin/skills/fuseforge/SKILL.md",
    ):
        content = (root / relative).read_text(encoding="utf-8")
        assert "FUSEFORGE_ACTIVATION_PROBE" in content, f"missing probe: {relative}"
        assert "FUSEFORGE_LOADED" in content, f"missing probe result: {relative}"
    for relative in (
        "commands/consult.md",
        "skills/SKILL.md",
        ".cursor-plugin/skills/fuseforge/SKILL.md",
    ):
        content = (root / relative).read_text(encoding="utf-8")
        assert "FUSEFORGE_CONSULT_PROBE" in content, (
            f"missing consult probe: {relative}"
        )
        assert "FUSEFORGE_CONSULT_LOADED" in content, (
            f"missing consult probe result: {relative}"
        )


def main() -> None:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else Path(__file__).parents[2]).resolve()
    version = check_manifests(root)
    check_registry(root, version)
    check_skill_claims(root)
    check_required_paths(root)
    check_setup_parity(root)
    check_frontmatter(root)
    check_skill_size(root)
    check_activation_probes(root)
    print("PASS static harness packaging")


if __name__ == "__main__":
    main()
