#!/usr/bin/env bash
case "$1" in
  launcher) wofi --show drun --style "$HOME/.config/wofi/wofi-font.css" ;;
  wifi)     alacritty -e nmtui ;;
  audio)    pavucontrol ;;
  calendar|waifu) eww -c "$HOME/.config/eww" open --toggle "$1" ;;
esac
