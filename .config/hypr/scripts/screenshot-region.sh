#!/usr/bin/env bash
mkdir -p "$HOME/Pictures/Screenshots"
FILENAME="$HOME/Pictures/Screenshots/region-$(date +%Y-%m-%d-%H%M%S).png"

if command -v slurp >/dev/null 2>&1 && command -v grim >/dev/null 2>&1; then
  GEO=$(slurp 2>/dev/null) || exit 0
  [ -n "$GEO" ] || exit 0
  grim -g "$GEO" "$FILENAME" || exit 1
else
  notify-send "Screenshot" "No slurp+grim available"
  exit 1
fi

command -v wl-copy >/dev/null 2>&1 && wl-copy < "$FILENAME"
ACTION=$(notify-send --wait --action=default=Open "Screenshot" "Region screenshot saved to $FILENAME")
[ "$ACTION" = "default" ] && nemo --no-desktop "$FILENAME"