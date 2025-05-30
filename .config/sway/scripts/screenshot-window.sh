#!/bin/bash

# Create screenshots directory if it doesn't exist
mkdir -p ~/Pictures/Screenshots

# Generate filename with timestamp
FILENAME=~/Pictures/Screenshots/window-$(date +%Y-%m-%d-%H%M%S).png

# Get the focused window geometry and take screenshot
GEOMETRY=$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')

# Take screenshot of the focused window
grim -g "$GEOMETRY" "$FILENAME"

# Copy to clipboard
wl-copy < "$FILENAME"

# Optional: Show notification
notify-send "Screenshot" "Window screenshot saved to $FILENAME"
