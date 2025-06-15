#!/bin/bash
# Volume control script with wob integration

# Lock file to prevent multiple instances
LOCK_FILE="/tmp/volume-wob.lock"

# Check if another instance is running
if [ -f "$LOCK_FILE" ]; then
    # Check if the process is actually running
    if kill -0 "$(cat "$LOCK_FILE")" 2>/dev/null; then
        # Another instance is running, exit quietly
        exit 0
    else
        # Stale lock file, remove it
        rm -f "$LOCK_FILE"
    fi
fi

# Create lock file with current PID
echo $$ > "$LOCK_FILE"

# Cleanup function
cleanup() {
    rm -f "$LOCK_FILE"
    exit 0
}

# Set up trap to cleanup on exit
trap cleanup EXIT INT TERM

# Get current volume and mute status
get_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | head -n 1 | awk '{print $5}' | sed 's/%//'
}

get_mute_status() {
    pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'
}

# Create wob FIFO if it doesn't exist
WOB_SOCK="/run/user/$(id -u)/wob.sock"

# Function to send value to wob
send_to_wob() {
    local value="$1"
    local muted="$2"
    
    # Check if wob socket exists
    if [ ! -p "$WOB_SOCK" ]; then
        # Socket doesn't exist, skip wob update
        return 0
    fi
    
    # Ensure value is an integer between 0-100
    value=$(printf "%.0f" "$value")
    if [ "$value" -gt 100 ]; then
        value=100
    elif [ "$value" -lt 0 ]; then
        value=0
    fi
    
    if [[ "$muted" == "yes" ]]; then
        # Send muted indicator (0)
        echo "0" > "$WOB_SOCK" 2>/dev/null || true
    else
        # Send current volume as integer
        echo "$value" > "$WOB_SOCK" 2>/dev/null || true
    fi
    
    # Small delay to prevent overwhelming wob
    sleep 0.05
}

# Handle different commands
case "$1" in
    "up")
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        # Cap volume at 100%
        current_vol=$(get_volume)
        if [ "$current_vol" -gt 100 ]; then
            pactl set-sink-volume @DEFAULT_SINK@ 100%
            current_vol=100
        fi
        send_to_wob "$current_vol" "$(get_mute_status)"
        ;;
    "down")
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        current_vol=$(get_volume)
        send_to_wob "$current_vol" "$(get_mute_status)"
        ;;
    "toggle")
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        current_vol=$(get_volume)
        send_to_wob "$current_vol" "$(get_mute_status)"
        ;;
    "mic-toggle")
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        # For mic, we'll just show a brief notification without wob
        if [ "$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')" = "yes" ]; then
            notify-send "🎤 Microphone" "Muted" -t 1000
        else
            notify-send "🎤 Microphone" "Unmuted" -t 1000
        fi
        ;;
    *)
        echo "Usage: $0 {up|down|toggle|mic-toggle}"
        exit 1
        ;;
esac
