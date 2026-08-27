#!/usr/bin/env bash
#
# FuseForge quickstart
# Clones or updates ~/.fuseforge, then installs FuseForge into the harnesses it
# finds. Safe to pipe from curl, and safe to rerun.
#
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/LooSung/fuseforge/main/scripts/setup/quickstart.sh)"
#
# It installs FuseForge only. The Compforge and OOPforge specialist packs stay an
# explicit separate step, printed at the end.
#
# Environment:
#   FUSEFORGE_HOME    Install location, default ~/.fuseforge
#   FUSEFORGE_REPO_URL Clone source, default the public GitHub repository
#   FUSEFORGE_BRANCH  Branch or tag to check out, default the remote default

set -euo pipefail

PACK_DIR="${FUSEFORGE_HOME:-$HOME/.fuseforge}"
REPO_URL="${FUSEFORGE_REPO_URL:-https://github.com/LooSung/fuseforge.git}"
BRANCH="${FUSEFORGE_BRANCH:-}"

cyan() { printf '\033[36m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }
yellow() { printf '\033[33m%s\033[0m\n' "$*"; }
red() { printf '\033[31m%s\033[0m\n' "$*" >&2; }

for tool in git bash; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    red "$tool is required."
    exit 1
  fi
done

looks_like_fuseforge() {
  local root="$1"
  [ -f "$root/skills/SKILL.md" ] &&
    [ -f "$root/skills/workflow/craft.md" ] &&
    [ -f "$root/scripts/setup/install.sh" ]
}

cyan "==> FuseForge quickstart"
printf 'Install location: %s\n\n' "${PACK_DIR/#$HOME/~}"

if [ -e "$PACK_DIR" ] || [ -L "$PACK_DIR" ]; then
  if [ ! -d "$PACK_DIR/.git" ]; then
    red "Path exists but is not a Git checkout: $PACK_DIR"
    red "Move it aside, or set FUSEFORGE_HOME to a different location."
    exit 1
  fi
  if ! looks_like_fuseforge "$PACK_DIR"; then
    red "Path is a Git checkout but does not look like FuseForge: $PACK_DIR"
    exit 1
  fi
  cyan "--- Updating existing checkout"
  git -C "$PACK_DIR" fetch --quiet --tags origin
  if [ -n "$BRANCH" ]; then
    git -C "$PACK_DIR" checkout --quiet "$BRANCH"
  fi
  # Only fast-forward. Local commits or edits are the user's, not ours to discard.
  if git -C "$PACK_DIR" merge --ff-only --quiet '@{u}' 2>/dev/null; then
    green "Updated to $(git -C "$PACK_DIR" rev-parse --short HEAD)"
  else
    yellow "Left as is at $(git -C "$PACK_DIR" rev-parse --short HEAD); not fast-forwardable."
  fi
else
  cyan "--- Cloning"
  # Clone to a temporary path and move it into place only after it verifies, so a
  # failed clone cannot leave a half-installed pack at the real location.
  TEMP_DIR="${PACK_DIR}.quickstart-tmp.$$"
  if [ -e "$TEMP_DIR" ]; then
    red "Temporary path already exists: $TEMP_DIR"
    exit 1
  fi
  trap 'rm -rf "$TEMP_DIR"' EXIT
  mkdir -p "$(dirname "$PACK_DIR")"
  if [ -n "$BRANCH" ]; then
    git clone --quiet --branch "$BRANCH" "$REPO_URL" "$TEMP_DIR"
  else
    git clone --quiet "$REPO_URL" "$TEMP_DIR"
  fi
  if ! looks_like_fuseforge "$TEMP_DIR"; then
    red "Clone did not produce a FuseForge checkout."
    exit 1
  fi
  mv "$TEMP_DIR" "$PACK_DIR"
  trap - EXIT
  green "Cloned to ${PACK_DIR/#$HOME/~} at $(git -C "$PACK_DIR" rev-parse --short HEAD)"
fi

printf '\n'
bash "$PACK_DIR/scripts/setup/install.sh"

printf '\n'
cyan "==> Next"
printf 'Verify FuseForge:   bash %s/scripts/setup/doctor.sh\n' "${PACK_DIR/#$HOME/~}"
printf 'Specialist packs:   bash %s/scripts/setup/bootstrap.sh\n' "${PACK_DIR/#$HOME/~}"
printf '\nFuseForge coordinates Compforge and OOPforge, so it needs both before a\n'
printf 'Craft request can be delegated. Bootstrap prints a plan before changing anything.\n'
