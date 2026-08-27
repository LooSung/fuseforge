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

READY_HARNESSES=""
ABSENT_HARNESSES=""
OK=0
MISSING=0
BROKEN=0

# Tally one link into the current harness rather than failing immediately, so an
# unused harness cannot make a working environment look broken.
tally_link() {
  local label="$1"
  local destination="$2"
  local expected="$3"
  local status detail

  IFS='|' read -r status detail <<EOF
$(link_status "$destination" "$expected")
EOF
  printf '  %-26s %-13s %s\n' "$label" "$status" "$detail"
  case "$status" in
    compatible) OK=$((OK + 1)) ;;
    missing) MISSING=$((MISSING + 1)) ;;
    *) BROKEN=$((BROKEN + 1)) ;;
  esac
}

start_harness() {
  printf '\n  %s\n' "$1"
  OK=0
  MISSING=0
  BROKEN=0
}

# A harness is usable, absent, or half-linked. Only half-linked is a defect,
# because it loads some packs and silently omits others.
end_harness() {
  local harness="$1"

  if [ "$BROKEN" -gt 0 ] || { [ "$OK" -gt 0 ] && [ "$MISSING" -gt 0 ]; }; then
    printf '  %s is only partly linked and will load some packs but not others.\n' "$harness"
    FAILED=1
  elif [ "$OK" -gt 0 ]; then
    READY_HARNESSES="$READY_HARNESSES $harness,"
  else
    ABSENT_HARNESSES="$ABSENT_HARNESSES $harness,"
  fi
}

# Cursor Agent reads every skill directory below, so a pack linked for Claude or
# Codex is already available to it. Observed on Cursor Agent 2026.08.
cursor_pack_source() {
  local pack="$1"
  local expected="$2"
  local candidate status detail

  for candidate in "$HOME/.claude/skills/$pack" "$HOME/.codex/skills/$pack" \
    "$HOME/.agents/skills/$pack"; do
    IFS='|' read -r status detail <<EOF
$(link_status "$candidate" "$expected")
EOF
    if [ "$status" = "compatible" ]; then
      printf 'compatible|%s\n' "${candidate/#$HOME/~}"
      return 0
    fi
  done
  printf 'missing|-\n'
}

tally_cursor_pack() {
  local label="$1"
  local pack="$2"
  local expected="$3"
  local status detail

  IFS='|' read -r status detail <<EOF
$(cursor_pack_source "$pack" "$expected")
EOF
  printf '  %-26s %-13s %s\n' "$label" "$status" "$detail"
  case "$status" in
    compatible) OK=$((OK + 1)) ;;
    *) MISSING=$((MISSING + 1)) ;;
  esac
}

printf '\nHarness links\n'

start_harness "Claude Code"
tally_link "Compforge skills" "$HOME/.claude/skills/compforge" "$COMP_ROOT/skills"
tally_link "Compforge commands" "$HOME/.claude/commands/compforge" "$COMP_ROOT/commands"
tally_link "OOPforge skills" "$HOME/.claude/skills/oopforge" "$OOP_ROOT/skills"
tally_link "OOPforge commands" "$HOME/.claude/commands/oopforge" "$OOP_ROOT/commands"
end_harness "Claude Code"

start_harness "Codex CLI"
tally_link "Compforge skills" "$HOME/.codex/skills/compforge" "$COMP_ROOT/skills"
tally_link "OOPforge skills" "$HOME/.codex/skills/oopforge" "$OOP_ROOT/skills"
end_harness "Codex CLI"

start_harness "Cursor Agent"
tally_cursor_pack "Compforge skills" "compforge" "$COMP_ROOT/skills"
tally_cursor_pack "OOPforge skills" "oopforge" "$OOP_ROOT/skills"
end_harness "Cursor Agent"

printf '\n'
if [ -n "$READY_HARNESSES" ]; then
  printf 'Packs are available in:%s\n' "${READY_HARNESSES%,}"
fi
if [ -n "$ABSENT_HARNESSES" ]; then
  printf 'Not set up, which only matters if you use it:%s\n' "${ABSENT_HARNESSES%,}"
fi

if [ "$FAILED" -eq 0 ] && [ -z "$READY_HARNESSES" ]; then
  printf 'No harness can load the specialist packs.\n'
  FAILED=1
fi

if [ "$FAILED" -eq 0 ]; then
  printf 'No changes required.\n'
else
  printf 'Pack environment is not ready. Run bootstrap without --apply for a safe change plan.\n'
  exit 1
fi
