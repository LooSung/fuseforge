#!/usr/bin/env bash

set -euo pipefail

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/setup/lib/common.sh
source "$SETUP_DIR/lib/common.sh"

# bootstrap.sh installs the specialist packs and has no opinion on whether
# FuseForge itself is installed, so it asks for that scope instead of failing on
# a condition it was not asked to fix.
SCOPE="all"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --specialists)
      SCOPE="specialists"
      ;;
    --help|-h)
      cat <<'USAGE'
FuseForge pack doctor

Usage:
  bash scripts/setup/doctor.sh                Check FuseForge and both specialists
  bash scripts/setup/doctor.sh --specialists  Check the specialist packs only
USAGE
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      exit 2
      ;;
  esac
  shift
done

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

SELF_ROOT="$(fuseforge_root "$SETUP_DIR")"
SELF_VERSION="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' \
  "$SELF_ROOT/skills/stability.json" 2>/dev/null || printf '%s' '-')"

printf 'FuseForge Pack Doctor\n\n'
printf '%-10s %-13s %-10s %s\n' "Pack" "Status" "Version" "Root"
print_pack_row "FuseForge" "self" "$SELF_VERSION" "$SELF_ROOT"
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

# FuseForge itself was previously unchecked, so doctor could report a ready
# environment while the coordinator was not installed in any harness.
SELF_READY=""
SELF_BROKEN=0

tally_self() {
  local harness="$1"
  local label destination source status detail ok=0 missing=0

  label="$(fuseforge_harness_label "$harness")"
  while IFS='|' read -r destination source; do
    [ -n "$destination" ] || continue
    IFS='|' read -r status detail <<EOF2
$(link_status "$destination" "$SELF_ROOT/$source")
EOF2
    case "$status" in
      compatible) ok=$((ok + 1)) ;;
      missing) missing=$((missing + 1)) ;;
      *)
        printf '  %-26s %-13s %s\n' "$label" "$status" "$detail"
        SELF_BROKEN=1
        return
        ;;
    esac
  done <<EOF
$(fuseforge_link_plan "$harness")
EOF

  if [ "$ok" -gt 0 ] && [ "$missing" -gt 0 ]; then
    printf '  %-26s %-13s %s\n' "$label" "incomplete" "some FuseForge links are missing"
    SELF_BROKEN=1
  elif [ "$ok" -gt 0 ]; then
    printf '  %-26s %-13s %s\n' "$label" "compatible" "-"
    SELF_READY="$SELF_READY $label,"
  else
    printf '  %-26s %-13s %s\n' "$label" "missing" "-"
  fi
}

if [ "$SCOPE" = "all" ]; then
  printf '\nFuseForge itself\n\n'
  tally_self claude
  tally_self codex
  tally_self cursor

  if [ "$SELF_BROKEN" -eq 1 ]; then
    printf '\n  FuseForge is partly installed. Run scripts/setup/install.sh --force\n'
    FAILED=1
  elif [ -z "$SELF_READY" ]; then
    printf '\n  FuseForge is not installed in any harness. Run scripts/setup/install.sh\n'
    FAILED=1
  else
    printf '\n  FuseForge is available in:%s\n' "${SELF_READY%,}"
  fi
fi

printf '\nSpecialist harness links\n'

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
  printf 'Environment is not ready.\n'
  printf 'FuseForge itself:  bash scripts/setup/install.sh\n'
  printf 'Specialist packs:  bash scripts/setup/bootstrap.sh   (prints a plan first)\n'
  exit 1
fi
