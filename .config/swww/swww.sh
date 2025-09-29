#!/usr/bin/env bash

# Set PATH to include .local/bin for GUI applications
export PATH="$HOME/.local/bin:$PATH"

IMG1="$HOME/Pictures/Wallpapers/thunderstorm.jpg"
IMG2="$HOME/Pictures/Wallpapers/black.png"
STATE_FILE="/tmp/wallpaper_state"
LIVE_OR_STATIC="tmp/wallpaper_current"
ANIMATION="grow"

if pgrep -x mpvpaper >/dev/null 2>&1; then
    pkill mpvpaper 2>/dev/null
    sleep 0.1  # Give it a moment to terminate
fi

# Check if swww daemon is running, start if needed
if ! pgrep -x "swww-daemon" >/dev/null; then
    "$HOME/.local/bin/swww-daemon" >/dev/null 2>&1 &
    sleep 0.5
fi

if [ ! -f "$STATE_FILE" ]; then
    echo "1" > "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")

if [ "$STATE" = "1" ]; then
    "$HOME/.local/bin/swww" img "$IMG1" --transition-type "$ANIMATION" --transition-duration 2 --transition-fps 90
    echo "2" > "$STATE_FILE"
else
    "$HOME/.local/bin/swww" img "$IMG2" --transition-type "$ANIMATION" --transition-duration 2 --transition-fps 90
    echo "1" > "$STATE_FILE"
fi