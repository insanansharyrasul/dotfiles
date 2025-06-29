#!/usr/bin/env bash
# Polybar launch script for i3/ayu-dark

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar
MONITOR=$(polybar --list-monitors | head -n1 | cut -d: -f1)
MONITOR=$MONITOR polybar main &
