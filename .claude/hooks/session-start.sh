#!/bin/bash
# SessionStart hook for Claude Code cloud sessions.
#
# Installs the workspace and builds the packages the tests import, mirroring
# .github/workflows/ci.yml, so a cloud session can run `pnpm lint`,
# `pnpm test`, the core tests and the Python skill helper tests straight away.
# Cloud only: a local checkout keeps its own environment. Idempotent: pnpm
# skips work when node_modules already matches the lockfile.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}"

# `prepare` builds core as part of the install.
pnpm install --frozen-lockfile
pnpm --filter @understand-anything/skill build
