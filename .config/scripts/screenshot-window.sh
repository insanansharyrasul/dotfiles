#!/bin/bash

# Screenshot window script for i3 (using scrot instead of grim)

mkdir -p ~/Pictures/Screenshots
FILENAME=~/Pictures/Screenshots/window-$(date +%Y-%m-%d-%H%M%S).png

# Take screenshot of focused window
scrot -u "$FILENAME"

# Copy to clipboard
xclip -selection clipboard -t image/png -i "$FILENAME"

# Show notification
notify-send "Screenshot" "Window screenshot saved to $FILENAME"
