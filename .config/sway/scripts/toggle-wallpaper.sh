#!/bin/bash

STATE_FILE="/tmp/wallpaper_state"
if [ ! -f "$STATE_FILE" ]; then
    echo "solid" > "$STATE_FILE"
fi

CURRENT_STATE=$(cat "$STATE_FILE")

VIDEO_WALLPAPER="/home/teaguy21/Videos/live-wallpaper.mp4"
SOLID_COLOR="#000000" 

if [ -z "$1" ] || [ "$1" != "--initial" ]; then
    if [ "$CURRENT_STATE" = "animated" ]; then
        pkill mpvpaper
        swaybg -c "$SOLID_COLOR" &
        echo "solid" > "$STATE_FILE"
    else
        pkill swaybg
        mpvpaper -o "no-audio loop video-scale=oversample panscan=1.0" eDP-1 "$VIDEO_WALLPAPER" &
        echo "animated" > "$STATE_FILE"
    fi
else
    pkill mpvpaper 2>/dev/null
    pkill swaybg 2>/dev/null
    swaybg -c "$SOLID_COLOR" &
    echo "solid" > "$STATE_FILE"
fi