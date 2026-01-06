#!/bin/sh
command -v hyprctl >/dev/null || exit 0

TARGET=${1:-10}
RETURN=${2:-$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id' 2>/dev/null)}

for i in $(seq 1 "$TARGET"); do
  hyprctl dispatch workspace "$i" >/dev/null 2>&1 || true
done

if [ -n "$RETURN" ] && [ "$RETURN" != "null" ]; then
  hyprctl dispatch workspace "$RETURN" >/dev/null 2>&1 || true
fi

exit 0