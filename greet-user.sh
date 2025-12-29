#!/bin/bash
# TODO: replace this script with a compiled rust binary to optimize runtime.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

greetings=(
  "Don't work too hard. The sun will expand and engulf this CPU anyway."
  "Everything you do today will eventually be overwritten."
  "Nothing matters. Build good software anyway."
  "That is all."
  "The loop continues."
  "The universe has not noticed."
  "Try not to take it too seriously."
)

count=${#greetings[@]}
msg="${greetings[RANDOM % count]}"

echo "Welcome back. $msg"
echo ""

"$SCRIPT_DIR/check-latest-full-system-upgrade.sh"
