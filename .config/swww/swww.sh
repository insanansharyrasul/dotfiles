#!/usr/bin/env bash
# Flexible swww wallpaper switcher - cycles through N wallpapers
# Usage: swww.sh [WALLPAPER_INDEX]

# Set PATH to include .local/bin for GUI applications
export PATH="$HOME/.local/bin:$PATH"

# Define your wallpapers here - easily add more!
WALLPAPERS=(
    "$HOME/Pictures/Wallpapers/thunderstorm.jpg"
    "$HOME/Pictures/Wallpapers/sakura.jpg"
    "$HOME/Pictures/Wallpapers/neon.png"
    "$HOME/Pictures/Wallpapers/black.png"
    # Add more wallpapers here:
    # "$HOME/Pictures/Wallpapers/mountain.jpg"
    # "$HOME/Pictures/Wallpapers/ocean.jpg"
)

STATE_FILE="/tmp/wallpaper_state"
LIVE_OR_STATIC="/tmp/wallpaper_current"
ANIMATION="wipe" # Options: fade, wipe, outer, inner, zoom_in, zoom_out

# Helper function to validate wallpaper index
validate_wallpaper_index() {
    local index="$1"
    local total_wallpapers=${#WALLPAPERS[@]}
    
    if [[ "$index" =~ ^[0-9]+$ ]] && [ "$index" -ge 0 ] && [ "$index" -lt "$total_wallpapers" ]; then
        return 0
    else
        return 1
    fi
}

# Helper function to get next wallpaper index
get_next_wallpaper_index() {
    local current_index="$1"
    local total_wallpapers=${#WALLPAPERS[@]}
    echo $(( (current_index + 1) % total_wallpapers ))
}

# Kill mpvpaper if running
if pgrep -x mpvpaper >/dev/null 2>&1; then
    pkill mpvpaper 2>/dev/null
    sleep 0.1  # Give it a moment to terminate
fi

# Check if swww daemon is running, start if needed
if ! pgrep -x "swww-daemon" >/dev/null; then
    "$HOME/.local/bin/swww-daemon" >/dev/null 2>&1 &
    sleep 0.5
fi

# Initialize state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo "0" > "$STATE_FILE"
fi

# Read current wallpaper index
CURRENT_INDEX=$(cat "$STATE_FILE" 2>/dev/null)

# Validate current index, reset to 0 if invalid
if ! validate_wallpaper_index "$CURRENT_INDEX"; then
    CURRENT_INDEX=0
    echo "0" > "$STATE_FILE"
fi

# Handle command line argument for specific wallpaper
if [ -n "$1" ]; then
    if validate_wallpaper_index "$1"; then
        WALLPAPER_INDEX="$1"
    else
        echo "Error: Invalid wallpaper index '$1'. Valid range: 0-$((${#WALLPAPERS[@]} - 1))"
        echo "Available wallpapers:"
        for i in "${!WALLPAPERS[@]}"; do
            echo "  [$i] $(basename "${WALLPAPERS[$i]}")"
        done
        exit 1
    fi
else
    # No argument provided, cycle to next wallpaper
    WALLPAPER_INDEX=$(get_next_wallpaper_index "$CURRENT_INDEX")
fi

# Get the wallpaper path
WALLPAPER_PATH="${WALLPAPERS[$WALLPAPER_INDEX]}"

# Check if wallpaper file exists
if [ ! -f "$WALLPAPER_PATH" ]; then
    echo "Warning: Wallpaper not found: $WALLPAPER_PATH"
    echo "Falling back to first available wallpaper..."
    
    # Find first existing wallpaper
    for i in "${!WALLPAPERS[@]}"; do
        if [ -f "${WALLPAPERS[$i]}" ]; then
            WALLPAPER_PATH="${WALLPAPERS[$i]}"
            WALLPAPER_INDEX="$i"
            break
        fi
    done
    
    if [ ! -f "$WALLPAPER_PATH" ]; then
        echo "Error: No wallpapers found!"
        exit 1
    fi
fi

# Set the wallpaper
echo "Setting wallpaper [$WALLPAPER_INDEX]: $(basename "$WALLPAPER_PATH")"
"$HOME/.local/bin/swww" img "$WALLPAPER_PATH" \
    --transition-type "$ANIMATION" \
    --transition-duration 2 \
    --transition-fps 90

# Update state file
echo "$WALLPAPER_INDEX" > "$STATE_FILE"

# Update current wallpaper info
echo "$(basename "$WALLPAPER_PATH")" > "$LIVE_OR_STATIC"