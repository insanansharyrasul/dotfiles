#!/usr/bin/env bash
SRC="@DEFAULT_AUDIO_SOURCE@"

level() { wpctl get-volume "$SRC" 2>/dev/null | awk '{print int($2 * 100)}'; }
muted() { wpctl get-volume "$SRC" 2>/dev/null | grep -q MUTED; }
icon() {
  if muted; then echo "󰍭"; else echo "󰍬"; fi
}
emit() {
  lvl=$(level)
  printf '{"level":%s,"icon":"%s"}\n' "${lvl:-0}" "$(icon)"
}

listen() {
  emit
  if command -v pactl >/dev/null 2>&1; then
    pactl subscribe 2>/dev/null | while read -r line; do
      case "$line" in
        *source*|*server*) emit ;;
      esac
    done
  else
    while sleep 1; do emit; done
  fi
}

case "$1" in
  get)    level ;;
  icon)   icon ;;
  set)    v=$(printf '%.0f' "${2:-0}"); wpctl set-volume "$SRC" "${v}%" ;;
  mute)   wpctl set-mute "$SRC" toggle ;;
  scroll)
    case "$2" in
      up)   wpctl set-volume "$SRC" 5%+ ;;
      down) wpctl set-volume "$SRC" 5%- ;;
    esac
    ;;
  listen) listen ;;
esac
