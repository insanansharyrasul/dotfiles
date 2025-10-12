#!/usr/bin/env bash
mkdir -p "$HOME/Pictures/Screenshots"
FILENAME="$HOME/Pictures/Screenshots/fullscreen-$(date +%Y-%m-%d-%H%M%S).png"

# Prefer grimblast, fallback to grim
if command -v grimblast >/dev/null 2>&1; then
  grimblast save "$FILENAME" >/dev/null 2>&1 || grim "$FILENAME"
elif command -v grim >/dev/null 2>&1; then
  grim "$FILENAME"
else
  notify-send "Screenshot" "No grimblast or grim installed"
  exit 1
fi

# Copy to clipboard and notify
command -v wl-copy >/dev/null 2>&1 && wl-copy < "$FILENAME"
notify-send "Screenshot" "Full screenshot saved to $FILENAME"