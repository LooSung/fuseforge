#!/usr/bin/env bash

set -euo pipefail

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/setup/lib/common.sh
source "$SETUP_DIR/lib/common.sh"

APPLY=0

usage() {
  cat <<'USAGE'
FuseForge specialist pack bootstrap

Usage:
  bash scripts/setup/bootstrap.sh          Inspect and print a safe change plan
  bash scripts/setup/bootstrap.sh --apply  Clone and link only missing items

This installs the Compforge and OOPforge specialist packs. Unlike those packs,
FuseForge's bootstrap does not install FuseForge itself; use
scripts/setup/install.sh for that.

Existing packs and occupied link destinations are never updated or replaced.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --apply)
      APPLY=1
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      usage >&2
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

BLOCKED=0
PLAN_COUNT=0
PLAN_TEXT=""

add_plan() {
  PLAN_COUNT=$((PLAN_COUNT + 1))
  PLAN_TEXT="${PLAN_TEXT}
- $1"
}

printf 'FuseForge Bootstrap Plan\n\n'
printf 'This installs Compforge and OOPforge. For FuseForge itself, run\n'
printf 'scripts/setup/install.sh.\n\n'
printf '%-10s %-13s %-10s %s\n' "Pack" "Status" "Version" "Root"
print_pack_row "Compforge" "$COMP_STATUS" "$COMP_VERSION" "$COMP_ROOT"
print_pack_row "OOPforge" "$OOP_STATUS" "$OOP_VERSION" "$OOP_ROOT"

case "$COMP_STATUS" in
  missing) add_plan "clone Compforge to $COMP_ROOT" ;;
  incompatible)
    printf 'Compforge: %s\n' "$COMP_REASON"
    BLOCKED=1
    ;;
esac
case "$OOP_STATUS" in
  missing) add_plan "clone OOPforge to $OOP_ROOT" ;;
  incompatible)
    printf 'OOPforge: %s\n' "$OOP_REASON"
    BLOCKED=1
    ;;
esac

printf '\nHarness links\n'

preflight_link() {
  local label="$1"
  local destination="$2"
  local expected="$3"
  local status detail

  IFS='|' read -r status detail <<EOF
$(link_status "$destination" "$expected")
EOF
  printf '%-28s %-13s %s\n' "$label" "$status" "$detail"
  case "$status" in
    missing)
      add_plan "link $destination -> $expected"
      ;;
    incompatible)
      printf 'Blocked link: %s (%s)\n' "$destination" "$detail"
      BLOCKED=1
      ;;
  esac
}

preflight_link "Claude Compforge skills" "$HOME/.claude/skills/compforge" "$COMP_ROOT/skills"
preflight_link "Claude Compforge commands" "$HOME/.claude/commands/compforge" "$COMP_ROOT/commands"
preflight_link "Claude OOPforge skills" "$HOME/.claude/skills/oopforge" "$OOP_ROOT/skills"
preflight_link "Claude OOPforge commands" "$HOME/.claude/commands/oopforge" "$OOP_ROOT/commands"
preflight_link "Codex Compforge skills" "$HOME/.codex/skills/compforge" "$COMP_ROOT/skills"
preflight_link "Codex OOPforge skills" "$HOME/.codex/skills/oopforge" "$OOP_ROOT/skills"
preflight_link "Cursor Compforge skills" "$HOME/.agents/skills/compforge" "$COMP_ROOT/skills"
preflight_link "Cursor OOPforge skills" "$HOME/.agents/skills/oopforge" "$OOP_ROOT/skills"

printf '\n'
if [ "$BLOCKED" -eq 1 ]; then
  printf 'Bootstrap blocked. No changes were made.\n'
  exit 1
fi

if [ "$PLAN_COUNT" -eq 0 ]; then
  printf 'No changes required.\n'
  exit 0
fi

printf 'Planned changes:%s\n\n' "$PLAN_TEXT"

if [ "$APPLY" -eq 0 ]; then
  printf 'Run with --apply to create only the listed missing items.\n'
  exit 0
fi

if { [ "$COMP_STATUS" = "missing" ] || [ "$OOP_STATUS" = "missing" ]; } &&
  ! command -v git >/dev/null 2>&1; then
  printf 'Bootstrap blocked. git is required to clone missing packs.\n' >&2
  exit 1
fi

clone_missing_pack() {
  local pack="$1"
  local root="$2"
  local repo_url branch temporary status version reason

  repo_url="$(pack_repo_url "$pack")"
  branch="$(pack_branch "$pack")"
  temporary="${root}.fuseforge-tmp.$$"

  if [ -e "$temporary" ] || [ -L "$temporary" ]; then
    printf 'Temporary clone path already exists: %s\n' "$temporary" >&2
    return 1
  fi

  mkdir -p "$(dirname "$root")"
  if [ -n "$branch" ]; then
    if ! git clone --quiet --branch "$branch" --single-branch "$repo_url" "$temporary"; then
      rm -rf "$temporary"
      printf 'Clone failed for %s.\n' "$pack" >&2
      return 1
    fi
  elif ! git clone --quiet "$repo_url" "$temporary"; then
    rm -rf "$temporary"
    printf 'Clone failed for %s.\n' "$pack" >&2
    return 1
  fi

  IFS='|' read -r status version reason <<EOF
$(inspect_pack "$pack" "$temporary")
EOF
  if [ "$status" != "compatible" ]; then
    rm -rf "$temporary"
    printf 'Cloned %s failed compatibility: %s\n' "$pack" "$reason" >&2
    return 1
  fi

  if ! mv "$temporary" "$root"; then
    rm -rf "$temporary"
    printf 'Could not install %s at %s.\n' "$pack" "$root" >&2
    return 1
  fi
  printf 'Installed missing %s %s at %s\n' "$pack" "$version" "$root"
}

if [ "$COMP_STATUS" = "missing" ]; then
  clone_missing_pack compforge "$COMP_ROOT"
fi
if [ "$OOP_STATUS" = "missing" ]; then
  clone_missing_pack oopforge "$OOP_ROOT"
fi

install_specialist_links() {
  local label="$1"
  local root="$2"

  if ! env INSTALL_CLAUDE=1 INSTALL_CODEX=1 bash "$root/scripts/setup/install.sh"; then
    printf '%s installer failed. Completed missing-only work was preserved; rerun is safe.\n' "$label" >&2
    return 1
  fi
}

install_specialist_links "Compforge" "$COMP_ROOT"
install_specialist_links "OOPforge" "$OOP_ROOT"

# Cursor Agent loads skills from vendor-neutral skill directories. A
# ~/.cursor/plugins/local link has no observed effect on skill availability.
create_agent_skill_link() {
  local source="$1"
  local destination="$2"

  if [ -L "$destination" ]; then
    return
  fi
  mkdir -p "$(dirname "$destination")"
  ln -s "$source" "$destination"
  printf 'Linked Cursor skills: %s -> %s\n' "$destination" "$source"
}

create_agent_skill_link "$COMP_ROOT/skills" "$HOME/.agents/skills/compforge"
create_agent_skill_link "$OOP_ROOT/skills" "$HOME/.agents/skills/oopforge"

if ! env COMPFORGE_HOME="$COMP_ROOT" bash "$COMP_ROOT/scripts/setup/doctor.sh"; then
  printf 'Compforge doctor failed. Existing installations were not changed or removed.\n' >&2
  exit 1
fi
if ! env OOPFORGE_HOME="$OOP_ROOT" bash "$OOP_ROOT/scripts/setup/doctor.sh"; then
  printf 'OOPforge doctor failed. Existing installations were not changed or removed.\n' >&2
  exit 1
fi

if ! bash "$SETUP_DIR/doctor.sh" --specialists; then
  printf 'FuseForge doctor failed after apply. Rerun is safe after resolving the reported issue.\n' >&2
  exit 1
fi

printf 'Bootstrap applied. Existing installations were preserved.\n'
