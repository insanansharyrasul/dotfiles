#!/usr/bin/env bash
bat=/sys/class/power_supply/BAT0
per=$(cat "$bat/capacity" 2>/dev/null || echo 0)
status=$(cat "$bat/status" 2>/dev/null || echo Unknown)

if [ "$status" = Charging ] || [ "$status" = Full ]; then
  icon="󰂄"
else
  icons=(󰂎 󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)
  icon=${icons[$(( per > 100 ? 10 : per / 10 ))]}
fi
printf '{"percent":%s,"status":"%s","icon":"%s"}\n' "$per" "$status" "$icon"
