#!/usr/bin/env bash
mkdir -p "$HOME/Pictures/Screenshots"
FILENAME="$HOME/Pictures/Screenshots/window-$(date +%Y-%m-%d-%H%M%S).png"

# Get active window geometry (hyprctl + jq)
if command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  GEO=$(hyprctl activewindow -j 2>/dev/null | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' 2>/dev/null)
else
  GEO=""
fi

# Try grimblast first (if it supports crop it will succeed), otherwise use grim with -g
if command -v grimblast >/dev/null 2>&1; then
  # attempt to use grimblast; if it fails, fallback to grim (with geometry if available)
  grimblast save "$FILENAME" 2>/dev/null \
    || { [ -n "$GEO" ] && command -v grim >/dev/null 2>&1 && grim -g "$GEO" "$FILENAME" || grim "$FILENAME"; }
elif command -v grim >/dev/null 2>&1; then
  if [ -n "$GEO" ]; then
    grim -g "$GEO" "$FILENAME"
  else
    grim "$FILENAME"
  fi
else
  notify-send "Screenshot" "No grimblast or grim installed"
  exit 1
fi

command -v wl-copy >/dev/null 2>&1 && wl-copy < "$FILENAME"
notify-send "Screenshot" "Window screenshot saved to $FILENAME"