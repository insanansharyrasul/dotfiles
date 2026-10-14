#!/usr/bin/env bash
mkdir -p "$HOME/Pictures/Screenshots"
FILENAME="$HOME/Pictures/Screenshots/fullscreen-$(date +%Y-%m-%d-%H%M%S).png"

if command -v grim >/dev/null 2>&1; then
  grim "$FILENAME" || exit 1
else
  notify-send "Screenshot" "No grim installed"
  exit 1
fi

command -v wl-copy >/dev/null 2>&1 && wl-copy < "$FILENAME"
ACTION=$(notify-send --wait --action=default=Open "Screenshot" "Full screenshot saved to $FILENAME")
[ "$ACTION" = "default" ] && nemo --no-desktop "$FILENAME"