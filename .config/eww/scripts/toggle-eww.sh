#!/bin/bash
pgrep -x eww >/dev/null && killall eww || ~/.config/eww/scripts/launch.sh
