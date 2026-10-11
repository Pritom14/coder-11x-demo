#!/usr/bin/env bash
# Every workspace start after the first. Data survives in the Postgres volume, so
# this only brings the stack back and waits; it never re-seeds.
set -euo pipefail
cd "$(dirname "$0")/../.."
state=$(cat .coder-state 2>/dev/null || echo "${STARTUP_OPTION:-none}")
echo "handle-restart: first-boot option was $state"
if [ "$state" = none ]; then
  echo "stack was never started: nothing to do"
  exit 0
fi
make up wait
make status
