#!/bin/bash

# Brightness control script for i3

case $1 in
    up)
        brightnessctl set +10%
        ;;
    down)
        brightnessctl set 10%-
        ;;
esac

# Get current brightness for notification
BRIGHTNESS=$(brightnessctl get)
MAX_BRIGHTNESS=$(brightnessctl max)
PERCENTAGE=$((BRIGHTNESS * 100 / MAX_BRIGHTNESS))

notify-send -t 2000 -h string:x-canonical-private-synchronous:brightness "Brightness: ${PERCENTAGE}%" -i display-brightness
