#!/usr/bin/env bash
CFG="$HOME/.config/eww"

toggle_calendar() {
  if eww -c "$CFG" active-windows 2>/dev/null | grep -q '^calendar'; then
    eww -c "$CFG" close calendar
  else
    eww -c "$CFG" open calendar
  fi
}

toggle_waifu() {
  if eww -c "$CFG" active-windows 2>/dev/null | grep -q '^waifu'; then
    eww -c "$CFG" close waifu
  else
    eww -c "$CFG" open waifu
  fi
}


case "$1" in
  launcher) wofi --show drun --style "$HOME/.config/wofi/wofi-font.css" ;;
  wifi)     alacritty -e nmtui ;;
  audio)    pavucontrol ;;
  calendar) toggle_calendar ;;
  waifu) toggle_waifu ;;
esac
