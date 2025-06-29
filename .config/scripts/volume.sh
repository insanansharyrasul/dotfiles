#!/bin/bash

# Volume control script for i3 (adapted from Sway version)

case $1 in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    toggle)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    mic-toggle)
        pactl set-source-mute @DEFAULT_SOURCE@ toggle
        ;;
esac

# Get current volume for notification
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o 'yes')

if [ "$MUTED" = "yes" ]; then
    notify-send -t 2000 -h string:x-canonical-private-synchronous:volume "Volume: Muted" -i audio-volume-muted
else
    notify-send -t 2000 -h string:x-canonical-private-synchronous:volume "Volume: ${VOLUME}%" -i audio-volume-high
fi
