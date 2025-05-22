#!/bin/bash
STATE_FILE="/tmp/wallpaper_state"
SOLID_COLOR="#000000"
pkill mpvpaper 2>/dev/null
pkill swaybg 2>/dev/null
swaybg -c "$SOLID_COLOR" &
echo "solid" > "$STATE_FILE"