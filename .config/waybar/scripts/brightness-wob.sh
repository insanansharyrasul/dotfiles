#!/bin/bash
# Brightness control script with wob integration

# Get current brightness percentage
get_brightness() {
    brightnessctl get | awk -v max="$(brightnessctl max)" '{printf "%.0f", ($1/max)*100}'
}

# Create wob FIFO if it doesn't exist
WOB_SOCK="/run/user/$(id -u)/wob.sock"

# Function to send brightness to wob
send_to_wob() {
    local value="$1"
    # Ensure value is an integer between 0-100
    value=$(printf "%.0f" "$value")
    if [ "$value" -gt 100 ]; then
        value=100
    elif [ "$value" -lt 0 ]; then
        value=0
    fi
    echo "$value" > "$WOB_SOCK" 2>/dev/null || true
}

# Handle different commands
case "$1" in
    "up")
        brightnessctl set +5%
        current_brightness=$(get_brightness)
        send_to_wob "$current_brightness"
        ;;
    "down")
        brightnessctl set 5%-
        current_brightness=$(get_brightness)
        send_to_wob "$current_brightness"
        ;;
    "set")
        if [ -n "$2" ]; then
            brightnessctl set "$2%"
            send_to_wob "$2"
        else
            echo "Usage: $0 set <percentage>"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 {up|down|set <percentage>}"
        exit 1
        ;;
esac
