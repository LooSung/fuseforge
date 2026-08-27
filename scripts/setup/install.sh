#!/usr/bin/env bash
#
# FuseForge installer
# Symlinks this checkout into detected Claude Code, Codex CLI, and Cursor Agent
# skill directories. It never installs the specialist packs; that is
# scripts/setup/bootstrap.sh.
#
# Usage:
#   ./scripts/setup/install.sh             Install (skip existing links)
#   ./scripts/setup/install.sh update      Remove FuseForge links, then reinstall
#   ./scripts/setup/install.sh --force     Replace existing symlinks only
#   ./scripts/setup/install.sh --dry-run   Print actions without linking
#
# Environment:
#   INSTALL_CLAUDE=1  Install even when ~/.claude is absent
#   INSTALL_CODEX=1   Install even when ~/.codex is absent
#   INSTALL_CURSOR=1  Install even when ~/.agents is absent

set -euo pipefail

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/setup/lib/common.sh
source "$SETUP_DIR/lib/common.sh"

PACK_DIR="$(fuseforge_root "$SETUP_DIR")"
DRY_RUN=0
FORCE=0
MODE="install"
HARNESSES=0

usage() {
  cat <<'USAGE'
FuseForge installer

Usage:
  ./scripts/setup/install.sh [update] [--force] [--dry-run]

Environment:
  INSTALL_CLAUDE=0|1  Set 1 to install even when ~/.claude is missing
  INSTALL_CODEX=0|1   Set 1 to install even when ~/.codex is missing
  INSTALL_CURSOR=0|1  Set 1 to install even when ~/.agents is missing

This installs FuseForge only. Run scripts/setup/bootstrap.sh for the Compforge
and OOPforge specialist packs.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    update) MODE="update" ;;
    --force|-f) FORCE=1 ;;
    --dry-run|-n) DRY_RUN=1 ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      red "Unknown argument: $1"
      usage >&2
      exit 2
      ;;
  esac
  shift
done

for name in INSTALL_CLAUDE INSTALL_CODEX INSTALL_CURSOR; do
  case "${!name:-0}" in
    0|1) ;;
    *)
      red "$name must be 0 or 1 (got: ${!name})"
      exit 2
      ;;
  esac
done

# A checkout that is missing its own canonical policy would link a broken pack
# into every harness, so refuse before touching the home directory.
for required in skills/SKILL.md skills/workflow/craft.md commands/craft.md; do
  if [ ! -f "$PACK_DIR/$required" ]; then
    red "Not a FuseForge checkout: $PACK_DIR (missing $required)"
    exit 1
  fi
done

link_path() {
  local src="$1"
  local dst="$2"
  local current

  if [ ! -e "$src" ]; then
    red "Source does not exist: $src"
    exit 1
  fi

  if [ -L "$dst" ]; then
    current="$(readlink "$dst")"
    if [ "$current" = "$src" ]; then
      green "Already linked: ${dst/#$HOME/~}"
      return
    fi
    if [ "$FORCE" -eq 1 ]; then
      if [ "$DRY_RUN" -eq 1 ]; then
        yellow "[dry-run] would replace: ${dst/#$HOME/~} -> $src"
      else
        rm "$dst"
        mkdir -p "$(dirname "$dst")"
        ln -s "$src" "$dst"
        green "Re-linked: ${dst/#$HOME/~} -> $src"
      fi
      return
    fi
    yellow "Different symlink exists: ${dst/#$HOME/~} -> $current (use --force)"
    return
  fi

  # Replacing a real file or directory could destroy a user's own content, so it
  # is never done, with or without --force.
  if [ -e "$dst" ]; then
    yellow "Path exists and is not a symlink: ${dst/#$HOME/~} (skipped)"
    return
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    yellow "[dry-run] would link: ${dst/#$HOME/~} -> $src"
  else
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    green "Linked: ${dst/#$HOME/~} -> $src"
  fi
}

install_harness() {
  local harness="$1"
  local override="$2"
  local harness_dir label destination source

  harness_dir="$(fuseforge_harness_dir "$harness")"
  if [ ! -d "$harness_dir" ] && [ "${!override:-0}" != 1 ]; then
    return
  fi

  label="$(fuseforge_harness_label "$harness")"
  HARNESSES=$((HARNESSES + 1))
  cyan "--- $label"
  while IFS='|' read -r destination source; do
    [ -n "$destination" ] || continue
    link_path "$PACK_DIR/$source" "$destination"
  done <<EOF
$(fuseforge_link_plan "$harness")
EOF
}

if [ "$MODE" = "update" ]; then
  cyan "==> FuseForge update ($([ "$DRY_RUN" -eq 1 ] && echo dry-run || echo live))"
  if [ "$DRY_RUN" -eq 1 ]; then
    yellow "[dry-run] would run scripts/setup/uninstall.sh"
  else
    bash "$SETUP_DIR/uninstall.sh"
  fi
else
  cyan "==> FuseForge install ($([ "$DRY_RUN" -eq 1 ] && echo dry-run || echo live))"
fi

install_harness claude INSTALL_CLAUDE
install_harness codex INSTALL_CODEX
install_harness cursor INSTALL_CURSOR

printf '\n'
if [ "$HARNESSES" -eq 0 ]; then
  yellow "No harness directory was found."
  yellow "Set INSTALL_CLAUDE=1, INSTALL_CODEX=1, or INSTALL_CURSOR=1 to install anyway."
  exit 1
fi

green "==> Done. Restart each agent to pick up changes."
if [ "$DRY_RUN" -eq 1 ]; then
  yellow "Run again without --dry-run to apply changes."
elif [ "${FUSEFORGE_QUICKSTART:-0}" != 1 ]; then
  # quickstart.sh prints the same next steps with more context.
  printf 'Check the install:  bash %s/scripts/setup/doctor.sh\n' "${PACK_DIR/#$HOME/~}"
  printf 'Specialist packs:   bash %s/scripts/setup/bootstrap.sh\n' "${PACK_DIR/#$HOME/~}"
fi
