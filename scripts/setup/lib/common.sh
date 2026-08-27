#!/usr/bin/env bash

fuseforge_root() {
  local setup_dir="$1"
  cd "$setup_dir/../.." && pwd
}

pack_root() {
  local pack="$1"
  case "$pack" in
    compforge)
      printf '%s\n' "${COMPFORGE_HOME:-$HOME/.compforge}"
      ;;
    oopforge)
      printf '%s\n' "${OOPFORGE_HOME:-$HOME/.oopforge}"
      ;;
    *)
      printf 'Unknown pack: %s\n' "$pack" >&2
      return 2
      ;;
  esac
}

pack_repo_url() {
  local pack="$1"
  case "$pack" in
    compforge)
      printf '%s\n' "${COMPFORGE_REPO_URL:-https://github.com/LooSung/compforge.git}"
      ;;
    oopforge)
      printf '%s\n' "${OOPFORGE_REPO_URL:-https://github.com/LooSung/oopforge.git}"
      ;;
    *)
      printf 'Unknown pack: %s\n' "$pack" >&2
      return 2
      ;;
  esac
}

pack_branch() {
  local pack="$1"
  case "$pack" in
    compforge)
      printf '%s\n' "${COMPFORGE_BRANCH:-}"
      ;;
    oopforge)
      printf '%s\n' "${OOPFORGE_BRANCH:-}"
      ;;
    *)
      printf 'Unknown pack: %s\n' "$pack" >&2
      return 2
      ;;
  esac
}

inspect_pack() {
  local pack="$1"
  local root="$2"

  python3 - "$pack" "$root" <<'PY'
import json
import sys
from pathlib import Path

pack = sys.argv[1]
root = Path(sys.argv[2]).expanduser()

if not root.exists():
    print("missing|-|pack root does not exist")
    raise SystemExit(0)

if not root.is_dir():
    print("incompatible|-|pack root is not a directory")
    raise SystemExit(0)

common_files = [
    "skills/SKILL.md",
    "skills/stability.json",
    "commands/craft.md",
    "commands/consult.md",
    ".claude-plugin/plugin.json",
    ".codex-plugin/plugin.json",
    ".cursor-plugin/plugin.json",
    "docs/reference/support-scope.md",
    "scripts/setup/install.sh",
    "scripts/setup/doctor.sh",
]
missing = [path for path in common_files if not (root / path).is_file()]
if missing:
    print(f"incompatible|-|missing required file: {missing[0]}")
    raise SystemExit(0)

try:
    manifests = [
        json.loads((root / path).read_text(encoding="utf-8"))
        for path in (
            ".claude-plugin/plugin.json",
            ".codex-plugin/plugin.json",
            ".cursor-plugin/plugin.json",
        )
    ]
    json.loads((root / "skills/stability.json").read_text(encoding="utf-8"))
except (OSError, json.JSONDecodeError) as error:
    print(f"incompatible|-|invalid JSON contract: {error}")
    raise SystemExit(0)

versions = [manifest.get("version") for manifest in manifests]
if not all(isinstance(version, str) and version for version in versions):
    print("incompatible|-|plugin manifest version is missing")
    raise SystemExit(0)
if len(set(versions)) != 1:
    print(f"incompatible|-|manifest versions differ: {', '.join(versions)}")
    raise SystemExit(0)

skill = (root / "skills/SKILL.md").read_text(encoding="utf-8")
support = (root / "docs/reference/support-scope.md").read_text(encoding="utf-8")
craft = (root / "commands/craft.md").read_text(encoding="utf-8")
consult = (root / "commands/consult.md").read_text(encoding="utf-8")
surface = "\n".join((skill, support, craft, consult))

if pack == "compforge":
    markers = (
        "TypeScript + React",
        "COMPFORGE_ACTIVATION_PROBE",
        "COMPFORGE_LOADED",
        "Assumptions",
        "Component Contract",
    )
elif pack == "oopforge":
    markers = (
        "Java with Spring",
        "Python with FastAPI",
        "OOPFORGE_ACTIVATION_PROBE",
        "OOPFORGE_LOADED",
        "Assumptions",
        "OOP Contract",
    )
else:
    print(f"incompatible|-|unknown pack type: {pack}")
    raise SystemExit(0)

for marker in markers:
    if marker not in surface:
        print(f"incompatible|{versions[0]}|missing capability marker: {marker}")
        raise SystemExit(0)

print(f"compatible|{versions[0]}|capability contract present")
PY
}

link_status() {
  local destination="$1"
  local expected="$2"

  python3 - "$destination" "$expected" <<'PY'
import os
import sys
from pathlib import Path

destination = Path(sys.argv[1]).expanduser()
expected = Path(sys.argv[2]).expanduser()

if destination.is_symlink():
    actual = os.path.realpath(destination)
    wanted = os.path.realpath(expected)
    if actual == wanted:
        print(f"compatible|{actual}")
    else:
        print(f"incompatible|points to {os.readlink(destination)}")
elif destination.exists():
    print("incompatible|destination is not a symlink")
else:
    print("missing|-")
PY
}

print_pack_row() {
  local label="$1"
  local status="$2"
  local version="$3"
  local root="$4"
  printf '%-10s %-13s %-10s %s\n' "$label" "$status" "$version" "$root"
}
