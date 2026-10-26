#!/usr/bin/env bash
CFG="$HOME/.config/eww"
eww -c "$CFG" kill 2>/dev/null
env -u LC_ALL LOCPATH="$HOME/.local/share/locale" LC_TIME=id_MON.UTF-8 eww -c "$CFG" daemon
sleep 0.5
eww -c "$CFG" open bar --id bar-left --arg monitor=eDP-1
if hyprctl monitors -j | grep -q '"name":"HDMI-A-1"'; then
	eww -c "$CFG" open bar --id bar-right --arg monitor=HDMI-A-1
fi
