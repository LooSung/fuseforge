#!/usr/bin/env bash
#
# Prove install.sh and uninstall.sh behavior inside a throwaway HOME.
# The real home directory is never touched.

set -euo pipefail

PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

FAKE_HOME="$WORK/home"
FAILED=0

pass() { printf 'ok    %s\n' "$1"; }
fail() {
  printf 'FAIL  %s\n' "$1"
  FAILED=1
}

reset_home() {
  rm -rf "$FAKE_HOME"
  mkdir -p "$FAKE_HOME/.claude" "$FAKE_HOME/.codex" "$FAKE_HOME/.agents"
}

# A pack that satisfies inspect_pack in scripts/setup/lib/common.sh. Without one,
# doctor fails for want of specialists and a FuseForge assertion cannot tell which
# condition it actually caught.
make_fake_pack() {
  local pack="$1"
  local root="$2"
  local markers

  case "$pack" in
    compforge)
      markers="TypeScript + React COMPFORGE_ACTIVATION_PROBE COMPFORGE_LOADED Assumptions Component Contract"
      ;;
    oopforge)
      markers="Java with Spring Python with FastAPI OOPFORGE_ACTIVATION_PROBE OOPFORGE_LOADED Assumptions OOP Contract"
      ;;
  esac

  mkdir -p "$root/skills" "$root/commands" "$root/docs/reference" \
    "$root/scripts/setup" "$root/.claude-plugin" "$root/.codex-plugin" \
    "$root/.cursor-plugin"
  printf '%s\n' "$markers" >"$root/skills/SKILL.md"
  printf '{"version":"9.9.9","implemented":[],"skeleton":[]}\n' \
    >"$root/skills/stability.json"
  printf 'craft\n' >"$root/commands/craft.md"
  printf 'consult\n' >"$root/commands/consult.md"
  printf 'scope\n' >"$root/docs/reference/support-scope.md"
  printf '#!/usr/bin/env bash\nexit 0\n' >"$root/scripts/setup/install.sh"
  printf '#!/usr/bin/env bash\nexit 0\n' >"$root/scripts/setup/doctor.sh"
  chmod +x "$root/scripts/setup/install.sh" "$root/scripts/setup/doctor.sh"
  for plugin in .claude-plugin .codex-plugin .cursor-plugin; do
    printf '{"name":"%s","version":"9.9.9"}\n' "$pack" >"$root/$plugin/plugin.json"
  done
}

install_fake_specialists() {
  local pack root
  for pack in compforge oopforge; do
    root="$FAKE_HOME/.$pack"
    make_fake_pack "$pack" "$root"
    mkdir -p "$FAKE_HOME/.claude/skills" "$FAKE_HOME/.claude/commands" \
      "$FAKE_HOME/.codex/skills"
    ln -s "$root/skills" "$FAKE_HOME/.claude/skills/$pack"
    ln -s "$root/commands" "$FAKE_HOME/.claude/commands/$pack"
    ln -s "$root/skills" "$FAKE_HOME/.codex/skills/$pack"
  done
}

run_doctor() {
  env HOME="$FAKE_HOME" COMPFORGE_HOME="$FAKE_HOME/.compforge" \
    OOPFORGE_HOME="$FAKE_HOME/.oopforge" \
    bash "$PACK_DIR/scripts/setup/doctor.sh" "$@" >"$WORK/out" 2>&1
}

run_install() {
  env HOME="$FAKE_HOME" bash "$PACK_DIR/scripts/setup/install.sh" "$@" >"$WORK/out" 2>&1
}

run_uninstall() {
  env HOME="$FAKE_HOME" bash "$PACK_DIR/scripts/setup/uninstall.sh" >"$WORK/out" 2>&1
}

tree_snapshot() {
  find "$FAKE_HOME" | sort
}

expected_links() {
  printf '%s\n' \
    "$FAKE_HOME/.claude/skills/fuseforge" \
    "$FAKE_HOME/.claude/commands/fuseforge" \
    "$FAKE_HOME/.codex/skills/fuseforge" \
    "$FAKE_HOME/.agents/skills/fuseforge"
}

printf '==> FuseForge install smoke\n\n'

# 1. --dry-run must change nothing.
reset_home
before="$(tree_snapshot)"
run_install --dry-run
after="$(tree_snapshot)"
if [ "$before" = "$after" ]; then
  pass "--dry-run changes nothing"
else
  fail "--dry-run modified the tree"
fi
if grep -q "would link" "$WORK/out"; then
  pass "--dry-run reports the actions it would take"
else
  fail "--dry-run printed no planned actions"
fi

# 2. Install creates exactly the four expected links and nothing else.
reset_home
run_install
missing=0
while read -r link; do
  if [ ! -L "$link" ]; then
    missing=1
    printf '      missing link: %s\n' "$link"
  fi
done <<<"$(expected_links)"
if [ "$missing" -eq 0 ]; then
  pass "install creates all four links"
else
  fail "install did not create every link"
fi

actual_count="$(find "$FAKE_HOME" -type l | wc -l | tr -d ' ')"
if [ "$actual_count" = "4" ]; then
  pass "install creates no extra symlink"
else
  fail "expected 4 symlinks, found $actual_count"
fi

if [ "$(readlink "$FAKE_HOME/.claude/skills/fuseforge")" = "$PACK_DIR/skills" ]; then
  pass "link points at this checkout"
else
  fail "link does not point at this checkout"
fi

# 3. Rerunning is safe and reports already-linked.
before="$(tree_snapshot)"
run_install
after="$(tree_snapshot)"
if [ "$before" = "$after" ] && grep -q "Already linked" "$WORK/out"; then
  pass "rerun is idempotent and says so"
else
  fail "rerun was not idempotent"
fi

# 4. A foreign symlink is preserved without --force.
reset_home
mkdir -p "$FAKE_HOME/.claude/skills" "$WORK/other"
ln -s "$WORK/other" "$FAKE_HOME/.claude/skills/fuseforge"
run_install
if [ "$(readlink "$FAKE_HOME/.claude/skills/fuseforge")" = "$WORK/other" ]; then
  pass "foreign symlink preserved without --force"
else
  fail "foreign symlink was replaced without --force"
fi

# 5. --force replaces a foreign symlink.
run_install --force
if [ "$(readlink "$FAKE_HOME/.claude/skills/fuseforge")" = "$PACK_DIR/skills" ]; then
  pass "--force replaces a foreign symlink"
else
  fail "--force did not replace the foreign symlink"
fi

# 6. A real file at a link path is never replaced, even with --force.
reset_home
mkdir -p "$FAKE_HOME/.codex/skills"
printf 'user content\n' >"$FAKE_HOME/.codex/skills/fuseforge"
run_install --force
if [ -f "$FAKE_HOME/.codex/skills/fuseforge" ] &&
  [ "$(cat "$FAKE_HOME/.codex/skills/fuseforge")" = "user content" ]; then
  pass "a real file is never replaced, even with --force"
else
  fail "a real file was destroyed"
fi

# 7. Absent harness directories are skipped rather than created.
reset_home
rm -rf "$FAKE_HOME/.codex" "$FAKE_HOME/.agents"
run_install
if [ ! -e "$FAKE_HOME/.codex" ] && [ ! -e "$FAKE_HOME/.agents" ]; then
  pass "absent harness directories are not created"
else
  fail "install created a harness directory that did not exist"
fi

# 8. An override installs into an absent harness.
reset_home
rm -rf "$FAKE_HOME/.codex"
env HOME="$FAKE_HOME" INSTALL_CODEX=1 bash "$PACK_DIR/scripts/setup/install.sh" \
  >"$WORK/out" 2>&1
if [ -L "$FAKE_HOME/.codex/skills/fuseforge" ]; then
  pass "INSTALL_CODEX=1 installs into an absent harness"
else
  fail "INSTALL_CODEX=1 did not install"
fi

# 9. Uninstall removes its own links and keeps a foreign one and the source.
reset_home
run_install
ln -s "$WORK/other" "$FAKE_HOME/.agents/skills/other-pack"
run_uninstall
remaining="$(find "$FAKE_HOME" -type l -name fuseforge | wc -l | tr -d ' ')"
if [ "$remaining" = "0" ]; then
  pass "uninstall removes every own link"
else
  fail "uninstall left $remaining own link(s)"
fi
if [ -L "$FAKE_HOME/.agents/skills/other-pack" ]; then
  pass "uninstall leaves an unrelated link alone"
else
  fail "uninstall removed an unrelated link"
fi
if [ -f "$PACK_DIR/skills/SKILL.md" ]; then
  pass "uninstall does not delete the pack source"
else
  fail "uninstall damaged the pack source"
fi

# 10. Uninstall keeps a link owned by a different checkout.
reset_home
mkdir -p "$FAKE_HOME/.claude/skills"
ln -s "$WORK/other" "$FAKE_HOME/.claude/skills/fuseforge"
run_uninstall
if [ -L "$FAKE_HOME/.claude/skills/fuseforge" ]; then
  pass "uninstall keeps a link owned by another checkout"
else
  fail "uninstall removed another checkout's link"
fi

# 11. update reinstalls from a clean state.
reset_home
run_install
env HOME="$FAKE_HOME" bash "$PACK_DIR/scripts/setup/install.sh" update >"$WORK/out" 2>&1
actual_count="$(find "$FAKE_HOME" -type l | wc -l | tr -d ' ')"
if [ "$actual_count" = "4" ]; then
  pass "update leaves exactly the four links"
else
  fail "update left $actual_count symlinks"
fi

# 12. With the specialists satisfied, doctor must pass. This pins the baseline the
# next two assertions depend on; without it they could pass for the wrong reason.
reset_home
install_fake_specialists
run_install
if run_doctor; then
  pass "doctor passes with FuseForge and both specialists installed"
else
  fail "doctor failed on a fully installed environment"
fi

# 13. Removing only the FuseForge links must fail doctor, with the specialists
# still satisfied, so the failure can only come from the FuseForge check.
run_uninstall
if run_doctor; then
  fail "doctor passed while only FuseForge was missing"
else
  if grep -q "FuseForge is not installed in any harness" "$WORK/out"; then
    pass "doctor fails on a missing FuseForge install alone"
  else
    fail "doctor failed without naming the FuseForge install"
  fi
fi

# 14. A partial FuseForge install is a defect, again with specialists satisfied.
reset_home
install_fake_specialists
run_install
rm "$FAKE_HOME/.claude/commands/fuseforge"
if run_doctor; then
  fail "doctor passed on a partial FuseForge install"
else
  if grep -q "FuseForge is partly installed" "$WORK/out"; then
    pass "doctor reports a partial install as a defect"
  else
    fail "doctor failed without naming the partial install"
  fi
fi

# 15. --specialists must pass with the specialists satisfied and FuseForge absent,
# because bootstrap.sh calls it and was not asked to install FuseForge.
reset_home
install_fake_specialists
if run_doctor --specialists; then
  if grep -q "FuseForge is not installed" "$WORK/out"; then
    fail "--specialists reported the FuseForge install it was told to skip"
  else
    pass "--specialists passes with FuseForge absent"
  fi
else
  fail "--specialists failed with both specialists satisfied"
fi

# 16. A non-FuseForge directory must be refused by the checkout guard by name.
# Asserting the message matters: link_path would also stop on a missing source, so
# a weaker assertion would pass even with the guard deleted.
reset_home
FAKE_PACK="$WORK/not-fuseforge"
rm -rf "$FAKE_PACK"
mkdir -p "$FAKE_PACK/scripts/setup/skills" "$FAKE_PACK/commands"
cp "$PACK_DIR/scripts/setup/install.sh" "$FAKE_PACK/scripts/setup/install.sh"
cp -r "$PACK_DIR/scripts/setup/lib" "$FAKE_PACK/scripts/setup/lib"
# Give it the directories a link would need, so only the guard can reject it.
mkdir -p "$FAKE_PACK/skills"
if env HOME="$FAKE_HOME" bash "$FAKE_PACK/scripts/setup/install.sh" >"$WORK/out" 2>&1; then
  fail "install accepted a directory that is not a FuseForge checkout"
elif ! grep -q "Not a FuseForge checkout" "$WORK/out"; then
  fail "install rejected the directory without the checkout guard"
elif [ "$(find "$FAKE_HOME" -type l | wc -l | tr -d ' ')" != "0" ]; then
  fail "install created links from a non-FuseForge checkout"
else
  pass "install refuses a non-FuseForge checkout without touching HOME"
fi

printf '\n'
if [ "$FAILED" -eq 0 ]; then
  printf 'FuseForge install smoke checks passed\n'
else
  printf 'FuseForge install smoke checks failed\n' >&2
  exit 1
fi
