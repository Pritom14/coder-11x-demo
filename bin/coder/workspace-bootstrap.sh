#!/usr/bin/env bash
# First boot of a Coder workspace (run by the template's repo-dispatch.sh as
# ubuntu, cwd = repo root). STARTUP_OPTION: none | containers | seed | data-load.
# Blocks until the stack is healthy so the workspace only reports Ready after.
set -euo pipefail
cd "$(dirname "$0")/../.."
opt=${STARTUP_OPTION:-containers}
echo "workspace-bootstrap: STARTUP_OPTION=$opt"
case $opt in
  none) echo "Startup Option is none: not starting containers" ;;
  containers) make up wait ;;
  seed) make up wait seed ;;
  data-load) make up wait load ;;
  *) echo "unknown STARTUP_OPTION: $opt" >&2; exit 2 ;;
esac
# Remembered so handle-restart.sh knows whether the stack belongs up.
echo "$opt" >.coder-state
[ "$opt" = none ] || make status
