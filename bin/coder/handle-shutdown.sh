#!/usr/bin/env bash
# Before the workspace instance stops: stop containers cleanly, keep volumes.
set -euo pipefail
cd "$(dirname "$0")/../.."
if [ -z "$(docker compose ps -q 2>/dev/null)" ]; then
  echo "handle-shutdown: nothing running"
  exit 0
fi
make down
