#!/usr/bin/env bash
mkdir -p "$HOME/Pictures/Screenshots"
FILENAME="$HOME/Pictures/Screenshots/region-$(date +%Y-%m-%d-%H%M%S).png"

if command -v slurp >/dev/null 2>&1 && command -v grim >/dev/null 2>&1; then
  GEO=$(slurp 2>/dev/null)
  [ -n "$GEO" ] && grim -g "$GEO" "$FILENAME"
else
  notify-send "Screenshot" "No slurp+grim available"
  exit 1
fi

command -v wl-copy >/dev/null 2>&1 && wl-copy < "$FILENAME"
notify-send "Screenshot" "Region screenshot saved to $FILENAME"