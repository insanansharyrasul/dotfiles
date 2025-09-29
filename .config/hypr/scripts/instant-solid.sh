#!/bin/bash
# Toggle between a solid color and a swww wallpaper.
# Usage: instant-solid.sh [PATH_TO_WALLPAPER]

STATE_FILE="/tmp/wallpaper_state"
# WALLPAPER="${1:-$HOME/Pictures/Wallpapers/neon.png}"
WALLPAPER="${1:-$HOME/Pictures/Wallpapers/thunderstorm.jpg}"
SOLID_PNG="/home/teaguy21/Pictures/Wallpapers/black.png"

# Helper function to set wallpaper with swww
set_swww_wallpaper() {
    local wallpaper_file="$1"
    
    if ! command -v swww >/dev/null 2>&1; then
        return 1
    fi
    
    # Check if swww daemon is running, start it if not
    if ! pgrep -x "swww-daemon" >/dev/null; then
        swww-daemon >/dev/null 2>&1 &
        sleep 0.5
    fi
    
    # Set wallpaper with transition effects
    swww img "$wallpaper_file" \
        --transition-type outer \
        --transition-step 90 \
        --transition-fps 90 \
        --transition-duration 2 \
        >/dev/null 2>&1
    
    return 0
}

if [ ! -f "$STATE_FILE" ]; then
    # First-ever call: set solid and record state
    pkill mpvpaper 2>/dev/null || true
    set_swww_wallpaper "$SOLID_PNG"
    echo "solid" > "$STATE_FILE"
    exit 0
fi

CURRENT_STATE=$(cat "$STATE_FILE" 2>/dev/null)

if [ "$CURRENT_STATE" = "solid" ]; then
    # Switch to wallpaper (use swww when available)
    pkill mpvpaper 2>/dev/null || true

    if [ -f "$WALLPAPER" ]; then
        set_swww_wallpaper "$WALLPAPER"
        echo "wallpaper" > "$STATE_FILE"
    else
        # Wallpaper not found; fallback to solid
        set_swww_wallpaper "$SOLID_PNG"
        echo "solid" > "$STATE_FILE"
    fi
else
    # Switch to solid color
    pkill mpvpaper 2>/dev/null || true
    set_swww_wallpaper "$SOLID_PNG"
    echo "solid" > "$STATE_FILE"
fi

exit 0