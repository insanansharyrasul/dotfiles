#!/bin/bash
# woomer-launch.sh

rm -f /tmp/woomer-debug.log

export GDK_SCALE=1.6
export QT_SCALE_FACTOR=1.6
export GDK_DPI_SCALE=1.6
export QT_AUTO_SCREEN_SCALE_FACTOR=1

export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
export PATH="/home/teaguy21/.cargo/bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

echo "$(date): Launching woomer from keybinding" >> /tmp/woomer-debug.log
echo "WAYLAND_DISPLAY: $WAYLAND_DISPLAY" >> /tmp/woomer-debug.log
echo "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR" >> /tmp/woomer-debug.log
echo "PWD: $(pwd)" >> /tmp/woomer-debug.log
echo "PATH: $PATH" >> /tmp/woomer-debug.log

notify-send "Woomer" "Launching woomer..." -t 1000

WOOMER_PATH="/home/teaguy21/.local/bin/c-woomer"

if [ -f "$WOOMER_PATH" ]; then
    echo "woomer found at $WOOMER_PATH, launching..." >> /tmp/woomer-debug.log
    exec "$WOOMER_PATH" 2>> /tmp/woomer-debug.log
else
    echo "woomer not found at $WOOMER_PATH!" >> /tmp/woomer-debug.log
    notify-send "Error" "woomer not found at $WOOMER_PATH" -t 3000
fi 