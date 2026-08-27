#!/usr/bin/env bash

set -euo pipefail

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/setup/lib/common.sh
source "$SETUP_DIR/lib/common.sh"

if ! command -v python3 >/dev/null 2>&1; then
  printf 'Bootstrap blocked. python3 is required for contract inspection.\n' >&2
  exit 1
fi

COMP_ROOT="$(pack_root compforge)"
OOP_ROOT="$(pack_root oopforge)"

IFS='|' read -r COMP_STATUS COMP_VERSION COMP_REASON <<EOF
$(inspect_pack compforge "$COMP_ROOT")
EOF
IFS='|' read -r OOP_STATUS OOP_VERSION OOP_REASON <<EOF
$(inspect_pack oopforge "$OOP_ROOT")
EOF

printf 'FuseForge Pack Doctor\n\n'
printf '%-10s %-13s %-10s %s\n' "Pack" "Status" "Version" "Root"
print_pack_row "Compforge" "$COMP_STATUS" "$COMP_VERSION" "$COMP_ROOT"
print_pack_row "OOPforge" "$OOP_STATUS" "$OOP_VERSION" "$OOP_ROOT"

FAILED=0
if [ "$COMP_STATUS" != "compatible" ]; then
  printf 'Compforge: %s\n' "$COMP_REASON"
  FAILED=1
fi
if [ "$OOP_STATUS" != "compatible" ]; then
  printf 'OOPforge: %s\n' "$OOP_REASON"
  FAILED=1
fi

printf '\nHarness links\n'

check_link() {
  local label="$1"
  local destination="$2"
  local expected="$3"
  local status detail

  IFS='|' read -r status detail <<EOF
$(link_status "$destination" "$expected")
EOF
  printf '%-28s %-13s %s\n' "$label" "$status" "$detail"
  if [ "$status" != "compatible" ]; then
    FAILED=1
  fi
}

check_link "Claude Compforge skills" "$HOME/.claude/skills/compforge" "$COMP_ROOT/skills"
check_link "Claude Compforge commands" "$HOME/.claude/commands/compforge" "$COMP_ROOT/commands"
check_link "Claude OOPforge skills" "$HOME/.claude/skills/oopforge" "$OOP_ROOT/skills"
check_link "Claude OOPforge commands" "$HOME/.claude/commands/oopforge" "$OOP_ROOT/commands"
check_link "Codex Compforge skills" "$HOME/.codex/skills/compforge" "$COMP_ROOT/skills"
check_link "Codex OOPforge skills" "$HOME/.codex/skills/oopforge" "$OOP_ROOT/skills"
check_link "Cursor Compforge skills" "$HOME/.agents/skills/compforge" "$COMP_ROOT/skills"
check_link "Cursor OOPforge skills" "$HOME/.agents/skills/oopforge" "$OOP_ROOT/skills"

printf '\n'
if [ "$FAILED" -eq 0 ]; then
  printf 'No changes required.\n'
else
  printf 'Pack environment is not ready. Run bootstrap without --apply for a safe change plan.\n'
  exit 1
fi
