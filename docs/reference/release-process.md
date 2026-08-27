# Manual release process

FuseForge releases are maintainer-driven. Repository checks prepare evidence;
they do not create commits, tags, pushes, or GitHub Releases.

## Preconditions

- Release only completed, user-visible behavior.
- Keep unsupported harness and connected-verification limits explicit.
- Keep the release version identical in all three plugin manifests and
  `skills/stability.json`.
- Treat `0.x` as initial development and keep experimental support boundaries
  explicit. The current release version is `0.1.0`.

## Procedure

1. Choose the version and update:
   - `.claude-plugin/plugin.json`
   - `.codex-plugin/plugin.json`
   - `.cursor-plugin/plugin.json`
   - `skills/stability.json`
2. Move completed `CHANGELOG.md` entries from `Unreleased` to a dated version
   heading. Leave an empty `Unreleased` heading for the next release.
3. Run the repository and coordinator checks:

   ```bash
   bash scripts/ci/lint-skills.sh
   python3 scripts/ci/test-doc-links.py
   python3 scripts/ci/check-selection-gate.py
   python3 scripts/ci/check-workspace-contract.py
   python3 scripts/ci/check-delegation-barrier.py
   bash scripts/ci/bootstrap-smoke.sh
   python3 scripts/ci/check-release-readiness.py --tag v0.1.0
   git diff --check
   ```

4. Record dated verification evidence under `docs/verification/`. Preserve
   blocked or not-applicable evidence instead of converting it into a pass.
5. Review and commit the release changes.
6. Create an annotated `v<version>` tag at that reviewed commit and push the
   commit and tag.
7. Create the GitHub Release manually from the same tag using the changelog
   entry as release notes.
8. Verify the GitHub Release points to the expected commit and does not claim
   unsupported capabilities.

## Readiness checker

`scripts/ci/check-release-readiness.py` validates SemVer, version agreement,
license and changelog presence, verification evidence, and an optional tag.
Without `--tag`, it checks repository preparation only. In GitHub tag CI it
also reads `GITHUB_REF_NAME`.

The checker intentionally reports the accepted static Codex and absent
connected evidence as limitations. It does not require provider credentials
and does not publish anything.
