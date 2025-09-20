#!/bin/bash
# Toggle between a solid color and a hyprpaper wallpaper.
# Usage: instant-solid.sh [PATH_TO_WALLPAPER]

STATE_FILE="/tmp/wallpaper_state"
# WALLPAPER="${1:-$HOME/Pictures/Wallpapers/neon.png}"
WALLPAPER="${1:-$HOME/Pictures/Wallpapers/thunderstorm.jpg}"
SOLID_PNG="/home/teaguy21/Pictures/Wallpapers/black.png"

# Helper function to set wallpaper with hyprpaper
set_hyprpaper_wallpaper() {
    local wallpaper_file="$1"
    
    if ! command -v hyprpaper >/dev/null 2>&1; then
        return 1
    fi
    
    # Kill any existing hyprpaper
    pkill hyprpaper 2>/dev/null || true
    sleep 0.1
    
    # Get current monitors from hyprctl
    local monitors
    monitors=$(hyprctl monitors -j 2>/dev/null | jq -r '.[].name' 2>/dev/null) || return 1
    
    if [ -z "$monitors" ]; then
        return 1
    fi
    
    # Start hyprpaper in background
    hyprpaper >/dev/null 2>&1 &
    local hyprpaper_pid=$!
    sleep 0.2
    
    # Configure each monitor and set wallpaper
    echo "$monitors" | while read -r monitor; do
        [ -n "$monitor" ] && {
            hyprctl hyprpaper preload "$wallpaper_file" 2>/dev/null || true
            hyprctl hyprpaper wallpaper "$monitor,$wallpaper_file" 2>/dev/null || true
        }
    done
    
    return 0
}

if [ ! -f "$STATE_FILE" ]; then
    # First-ever call: set solid and record state
    pkill mpvpaper 2>/dev/null || true
    set_hyprpaper_wallpaper "$SOLID_PNG"
    echo "solid" > "$STATE_FILE"
    exit 0
fi

CURRENT_STATE=$(cat "$STATE_FILE" 2>/dev/null)

if [ "$CURRENT_STATE" = "solid" ]; then
    # Switch to wallpaper (use hyprpaper when available)
    pkill mpvpaper 2>/dev/null || true

    if [ -f "$WALLPAPER" ]; then
        set_hyprpaper_wallpaper "$WALLPAPER"
        echo "wallpaper" > "$STATE_FILE"
    else
        # Wallpaper not found; fallback to solid
        set_hyprpaper_wallpaper "$SOLID_PNG"
        echo "solid" > "$STATE_FILE"
    fi
else
    # Switch to solid color
    pkill mpvpaper 2>/dev/null || true
    set_hyprpaper_wallpaper "$SOLID_PNG"
    echo "solid" > "$STATE_FILE"
fi

exit 0