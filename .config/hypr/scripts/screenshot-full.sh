#!/usr/bin/env bash
mkdir -p "$HOME/Pictures/Screenshots"
FILENAME="$HOME/Pictures/Screenshots/fullscreen-$(date +%Y-%m-%d-%H%M%S).png"

if command -v grim >/dev/null 2>&1; then
  grim "$FILENAME"
else
  notify-send "Screenshot" "No grim installed"
  exit 1
fi

command -v wl-copy >/dev/null 2>&1 && wl-copy < "$FILENAME"
notify-send "Screenshot" "Full screenshot saved to $FILENAME"