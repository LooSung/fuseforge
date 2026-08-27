#!/usr/bin/env bash
#
# FuseForge uninstaller
# Removes only the symlinks that point at this checkout. It never deletes the
# pack source, and never touches the specialist packs.

set -euo pipefail

SETUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/setup/lib/common.sh
source "$SETUP_DIR/lib/common.sh"

PACK_DIR="$(fuseforge_root "$SETUP_DIR")"
REMOVED=0

rm_link() {
  local path="$1"
  local expected="$2"
  local actual

  if [ -L "$path" ]; then
    actual="$(readlink "$path")"
    # A link pointing at a different checkout belongs to that installation.
    if [ "$actual" != "$expected" ]; then
      yellow "Different symlink; leaving untouched: ${path/#$HOME/~} -> $actual"
      return
    fi
    rm "$path"
    green "Removed: ${path/#$HOME/~}"
    REMOVED=$((REMOVED + 1))
    return
  fi

  if [ -e "$path" ]; then
    yellow "Not a symlink; leaving untouched: ${path/#$HOME/~}"
  fi
}

cyan "==> FuseForge uninstall"

for harness in claude codex cursor; do
  while IFS='|' read -r destination source; do
    [ -n "$destination" ] || continue
    rm_link "$destination" "$PACK_DIR/$source"
  done <<EOF
$(fuseforge_link_plan "$harness")
EOF
done

printf '\n'
if [ "$REMOVED" -eq 0 ]; then
  yellow "No FuseForge links from this checkout were found."
else
  green "==> Uninstall complete. Removed $REMOVED link(s)."
fi
printf 'The pack source at %s was not removed.\n' "${PACK_DIR/#$HOME/~}"
