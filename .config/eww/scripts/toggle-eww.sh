#!/bin/bash

if pgrep -x "eww" > /dev/null; then
    killall eww
else
    ~/.config/eww/scripts/launch
fi