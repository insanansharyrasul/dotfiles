#!/usr/bin/env bash
# Restart the eww daemon and open the bar.
CFG="$HOME/.config/eww"

eww -c "$CFG" kill 2>/dev/null
eww -c "$CFG" daemon
sleep 0.5
eww -c "$CFG" open bar-left
eww -c "$CFG" open bar-right
