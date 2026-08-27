#!/usr/bin/env bash
#
# FuseForge repository lint entrypoint.

set -euo pipefail

PACK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

printf '%s\n' "==> FuseForge repository lint"

python3 -m json.tool "$PACK_DIR/.claude-plugin/plugin.json" >/dev/null
python3 -m json.tool "$PACK_DIR/.codex-plugin/plugin.json" >/dev/null
python3 -m json.tool "$PACK_DIR/.cursor-plugin/plugin.json" >/dev/null
python3 -m json.tool "$PACK_DIR/skills/stability.json" >/dev/null
printf '%s\n' "OK JSON manifests and registry"

python3 "$PACK_DIR/scripts/ci/check-harness-packaging.py" "$PACK_DIR"
python3 "$PACK_DIR/scripts/ci/check-doc-links.py"

printf '%s\n' "==> lint complete: no issues"
