#!/bin/bash

STATE_FILE="/tmp/wallpaper_state"
WALLPAPER_DIR="/home/teaguy21/Videos/LiveWallpaper"
WALLPAPER_PREFIX="live-wallpaper"
SOLID_COLOR="#000000"

if [ ! -f "$STATE_FILE" ]; then
    echo "solid" > "$STATE_FILE"
fi

CURRENT_STATE=$(cat "$STATE_FILE")

WALLPAPERS=($WALLPAPER_DIR/${WALLPAPER_PREFIX}*)
WALLPAPER_COUNT=${#WALLPAPERS[@]}

if [ -z "$1" ] || [ "$1" != "--initial" ]; then
    if [ "$CURRENT_STATE" = "solid" ]; then
        pkill swaybg 2>/dev/null
        mpvpaper -o "no-audio loop video-scale=oversample panscan=1.0" eDP-1 "${WALLPAPERS[0]}" &
        mpvpaper -o "no-audio loop video-scale=oversample panscan=1.0" HDMI-A-1 "${WALLPAPERS[0]}" &
        echo "animated:0" > "$STATE_FILE"
    elif [[ "$CURRENT_STATE" == animated:* ]]; then
        CURRENT_INDEX=${CURRENT_STATE#animated:}
        
        pkill mpvpaper 2>/dev/null
        
        NEXT_INDEX=$((CURRENT_INDEX + 1))
        
        if [ $NEXT_INDEX -ge $WALLPAPER_COUNT ]; then
            swaybg -c "$SOLID_COLOR" &
            echo "solid" > "$STATE_FILE"
        else
            mpvpaper -o "no-audio loop video-scale=oversample panscan=1.0" eDP-1 "${WALLPAPERS[$NEXT_INDEX]}" &
            mpvpaper -o "no-audio loop video-scale=oversample panscan=1.0" HDMI-A-1 "${WALLPAPERS[$NEXT_INDEX]}" &
            echo "animated:$NEXT_INDEX" > "$STATE_FILE"
        fi
    fi
else
    pkill mpvpaper 2>/dev/null
    pkill swaybg 2>/dev/null
    swaybg -c "$SOLID_COLOR" &
    echo "solid" > "$STATE_FILE"
fi
