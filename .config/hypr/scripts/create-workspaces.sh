#!/bin/sh
# Idempotent script to ensure workspaces 1..N exist and optionally visit them briefly
# Keeps things safe on reloads; uses hyprctl to create and return to initial workspace.

# How many workspaces to create
TARGET=${1:-10}
# Where to return afterwards (default to current workspace)
RETURN=${2:-$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id' 2>/dev/null)}

# If hyprctl not available, exit silently
command -v hyprctl >/dev/null || exit 0

# Iterate and create by dispatching workspace if not present
for i in $(seq 1 "$TARGET"); do
  hyprctl dispatch workspace "$i" >/dev/null 2>&1 || true
done

# Return to previous workspace if known
if [ -n "$RETURN" ] && [ "$RETURN" != "null" ]; then
  hyprctl dispatch workspace "$RETURN" >/dev/null 2>&1 || true
fi

exit 0