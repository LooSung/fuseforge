#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BOOTSTRAP="$ROOT/scripts/setup/bootstrap.sh"
DOCTOR="$ROOT/scripts/setup/doctor.sh"
TEMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/fuseforge-bootstrap.XXXXXX")"
trap 'rm -rf "$TEMP_ROOT"' EXIT

fail() {
  printf 'FAIL %s\n' "$*" >&2
  exit 1
}

assert_contains() {
  local text="$1"
  local expected="$2"
  case "$text" in
    *"$expected"*) ;;
    *) fail "expected output to contain: $expected" ;;
  esac
}

assert_missing() {
  local path="$1"
  if [ -e "$path" ] || [ -L "$path" ]; then
    fail "expected path to remain missing: $path"
  fi
}

make_pack() {
  local pack="$1"
  local destination="$2"
  local version marker loaded contract support

  case "$pack" in
    compforge)
      version="1.3.4"
      marker="COMPFORGE_ACTIVATION_PROBE"
      loaded="COMPFORGE_LOADED"
      contract="Component Contract"
      support="TypeScript + React"
      ;;
    oopforge)
      version="1.4.2"
      marker="OOPFORGE_ACTIVATION_PROBE"
      loaded="OOPFORGE_LOADED"
      contract="OOP Contract"
      support="Java with Spring
Python with FastAPI"
      ;;
    *)
      fail "unknown fixture pack: $pack"
      ;;
  esac

  mkdir -p \
    "$destination/skills" \
    "$destination/commands" \
    "$destination/.claude-plugin" \
    "$destination/.codex-plugin" \
    "$destination/.cursor-plugin" \
    "$destination/docs/reference" \
    "$destination/scripts/setup"

  cat >"$destination/skills/SKILL.md" <<EOF
# $pack
$marker
$loaded
Assumptions
$contract
EOF
  printf '{}\n' >"$destination/skills/stability.json"
  printf '# craft\n%s\n' "$marker" >"$destination/commands/craft.md"
  printf '# consult\n%s\n' "$contract" >"$destination/commands/consult.md"
  printf '# support\n%s\nCraft\nConsult\n' "$support" >"$destination/docs/reference/support-scope.md"

  for manifest in .claude-plugin .codex-plugin .cursor-plugin; do
    printf '{"name":"%s","version":"%s"}\n' "$pack" "$version" \
      >"$destination/$manifest/plugin.json"
  done

  cat >"$destination/scripts/setup/install.sh" <<EOF
#!/usr/bin/env bash
set -euo pipefail
PACK_ROOT="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")/../.." && pwd)"
link_missing() {
  local source="\$1"
  local destination="\$2"
  if [ -L "\$destination" ]; then
    [ "\$(readlink "\$destination")" = "\$source" ] || exit 1
    return
  fi
  [ ! -e "\$destination" ] || exit 1
  mkdir -p "\$(dirname "\$destination")"
  ln -s "\$source" "\$destination"
}
link_missing "\$PACK_ROOT/skills" "\$HOME/.claude/skills/$pack"
link_missing "\$PACK_ROOT/commands" "\$HOME/.claude/commands/$pack"
link_missing "\$PACK_ROOT/skills" "\$HOME/.codex/skills/$pack"
EOF

  cat >"$destination/scripts/setup/doctor.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
exit 0
EOF
  chmod +x "$destination/scripts/setup/install.sh" "$destination/scripts/setup/doctor.sh"
}

make_remote() {
  local pack="$1"
  local destination="$2"
  make_pack "$pack" "$destination"
  git -C "$destination" init -q
  git -C "$destination" add .
  git -C "$destination" \
    -c user.name="FuseForge Smoke" \
    -c user.email="smoke@example.invalid" \
    commit -q -m "fixture"
}

COMP_REMOTE="$TEMP_ROOT/remotes/compforge"
OOP_REMOTE="$TEMP_ROOT/remotes/oopforge"
mkdir -p "$TEMP_ROOT/remotes"
make_remote compforge "$COMP_REMOTE"
make_remote oopforge "$OOP_REMOTE"

PLAN_HOME="$TEMP_ROOT/plan-home"
mkdir -p "$PLAN_HOME"
PLAN_OUTPUT="$(
  HOME="$PLAN_HOME" \
    COMPFORGE_REPO_URL="$COMP_REMOTE" \
    OOPFORGE_REPO_URL="$OOP_REMOTE" \
    bash "$BOOTSTRAP"
)"
assert_contains "$PLAN_OUTPUT" "Run with --apply to create only the listed missing items."
assert_missing "$PLAN_HOME/.compforge"
assert_missing "$PLAN_HOME/.oopforge"
assert_missing "$PLAN_HOME/.claude"
assert_missing "$PLAN_HOME/.codex"
assert_missing "$PLAN_HOME/.cursor"

APPLY_OUTPUT="$(
  HOME="$PLAN_HOME" \
    COMPFORGE_REPO_URL="$COMP_REMOTE" \
    OOPFORGE_REPO_URL="$OOP_REMOTE" \
    bash "$BOOTSTRAP" --apply
)"
assert_contains "$APPLY_OUTPUT" "Bootstrap applied. Existing installations were preserved."

for path in \
  "$PLAN_HOME/.compforge" \
  "$PLAN_HOME/.oopforge" \
  "$PLAN_HOME/.claude/skills/compforge" \
  "$PLAN_HOME/.claude/commands/compforge" \
  "$PLAN_HOME/.claude/skills/oopforge" \
  "$PLAN_HOME/.claude/commands/oopforge" \
  "$PLAN_HOME/.codex/skills/compforge" \
  "$PLAN_HOME/.codex/skills/oopforge" \
  "$PLAN_HOME/.cursor/plugins/local/compforge" \
  "$PLAN_HOME/.cursor/plugins/local/oopforge"; do
  if [ ! -e "$path" ] && [ ! -L "$path" ]; then
    fail "expected applied path: $path"
  fi
done

HOME="$PLAN_HOME" bash "$DOCTOR" >/dev/null
COMP_LINK_BEFORE="$(readlink "$PLAN_HOME/.claude/skills/compforge")"
SECOND_OUTPUT="$(
  HOME="$PLAN_HOME" \
    COMPFORGE_REPO_URL="$COMP_REMOTE" \
    OOPFORGE_REPO_URL="$OOP_REMOTE" \
    bash "$BOOTSTRAP" --apply
)"
assert_contains "$SECOND_OUTPUT" "No changes required."
[ "$(readlink "$PLAN_HOME/.claude/skills/compforge")" = "$COMP_LINK_BEFORE" ] ||
  fail "idempotent apply changed an existing compatible link"

BLOCK_HOME="$TEMP_ROOT/block-home"
mkdir -p "$BLOCK_HOME/.claude/skills" "$BLOCK_HOME/existing"
ln -s "$BLOCK_HOME/existing" "$BLOCK_HOME/.claude/skills/compforge"
if HOME="$BLOCK_HOME" \
  COMPFORGE_HOME="$COMP_REMOTE" \
  OOPFORGE_HOME="$OOP_REMOTE" \
  bash "$BOOTSTRAP" >"$TEMP_ROOT/block-output" 2>&1; then
  fail "wrong existing symlink should block bootstrap"
fi
[ "$(readlink "$BLOCK_HOME/.claude/skills/compforge")" = "$BLOCK_HOME/existing" ] ||
  fail "blocked bootstrap changed an existing symlink"
assert_missing "$BLOCK_HOME/.claude/commands/compforge"

NONLINK_HOME="$TEMP_ROOT/nonlink-home"
mkdir -p "$NONLINK_HOME/.codex/skills"
printf 'preserve me\n' >"$NONLINK_HOME/.codex/skills/oopforge"
if HOME="$NONLINK_HOME" \
  COMPFORGE_HOME="$COMP_REMOTE" \
  OOPFORGE_HOME="$OOP_REMOTE" \
  bash "$BOOTSTRAP" >"$TEMP_ROOT/nonlink-output" 2>&1; then
  fail "existing non-symlink destination should block bootstrap"
fi
[ "$(<"$NONLINK_HOME/.codex/skills/oopforge")" = "preserve me" ] ||
  fail "blocked bootstrap changed an existing non-symlink destination"
assert_missing "$NONLINK_HOME/.cursor"

MISMATCH_PACK="$TEMP_ROOT/mismatch-compforge"
cp -R "$COMP_REMOTE" "$MISMATCH_PACK"
printf '{"name":"compforge","version":"9.9.9"}\n' \
  >"$MISMATCH_PACK/.cursor-plugin/plugin.json"
MISMATCH_HOME="$TEMP_ROOT/mismatch-home"
mkdir -p "$MISMATCH_HOME"
if HOME="$MISMATCH_HOME" \
  COMPFORGE_HOME="$MISMATCH_PACK" \
  OOPFORGE_HOME="$OOP_REMOTE" \
  bash "$BOOTSTRAP" >"$TEMP_ROOT/mismatch-output" 2>&1; then
  fail "manifest version mismatch should block bootstrap"
fi
assert_contains "$(<"$TEMP_ROOT/mismatch-output")" "manifest versions differ"
assert_missing "$MISMATCH_HOME/.claude"

CAPABILITY_PACK="$TEMP_ROOT/capability-oopforge"
cp -R "$OOP_REMOTE" "$CAPABILITY_PACK"
python3 - "$CAPABILITY_PACK/docs/reference/support-scope.md" <<'PY'
import sys
from pathlib import Path

path = Path(sys.argv[1])
path.write_text(
    path.read_text(encoding="utf-8").replace("Python with FastAPI", "unsupported"),
    encoding="utf-8",
)
PY
CAPABILITY_HOME="$TEMP_ROOT/capability-home"
mkdir -p "$CAPABILITY_HOME"
if HOME="$CAPABILITY_HOME" \
  COMPFORGE_HOME="$COMP_REMOTE" \
  OOPFORGE_HOME="$CAPABILITY_PACK" \
  bash "$BOOTSTRAP" >"$TEMP_ROOT/capability-output" 2>&1; then
  fail "missing capability should block bootstrap"
fi
assert_contains "$(<"$TEMP_ROOT/capability-output")" "missing capability marker: Python with FastAPI"
assert_missing "$CAPABILITY_HOME/.cursor"

python3 - "$BOOTSTRAP" <<'PY'
import sys
from pathlib import Path

text = Path(sys.argv[1]).read_text(encoding="utf-8")
for forbidden in ("git pull", "git fetch", "install.sh update", "install.sh --force"):
    if forbidden in text:
        raise SystemExit(f"forbidden update path present: {forbidden}")
PY

python3 "$ROOT/scripts/ci/check-selection-gate.py" >/dev/null
printf 'FuseForge bootstrap smoke checks passed\n'
