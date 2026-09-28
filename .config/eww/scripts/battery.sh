#!/usr/bin/env bash
bat=/sys/class/power_supply/BAT0
per=$(cat "$bat/capacity" 2>/dev/null || echo 0)
status=$(cat "$bat/status" 2>/dev/null || echo Unknown)

icon() {
  if [ "$status" = "Charging" ] || [ "$status" = "Full" ]; then
    echo "󰂄"; return
  fi
  icons=(󰂎 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)
  idx=$(( per / 10 ))
  [ "$idx" -gt 10 ] && idx=10
  echo "${icons[$idx]}"
}

case "$1" in
  icon)    icon ;;
  percent) echo "$per" ;;
  status)  echo "$status" ;;
esac
