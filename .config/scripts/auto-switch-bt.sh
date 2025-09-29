#!/bin/bash

# Auto switch to Bluetooth sink when it connects
pactl subscribe | grep --line-buffered "Event 'new' on sink" | while read -r _; do
  BT_SINK=$(pactl list short sinks | grep bluez_output | awk '{print $2}')
  if [ -n "$BT_SINK" ]; then
    pactl set-default-sink "$BT_SINK"
  fi
done
