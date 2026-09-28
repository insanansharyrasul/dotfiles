#!/usr/bin/env bash
SINK="@DEFAULT_AUDIO_SINK@"

level() { wpctl get-volume "$SINK" 2>/dev/null | awk '{print int($2 * 100)}'; }
muted() { wpctl get-volume "$SINK" 2>/dev/null | grep -q MUTED; }
icon() {
  if muted; then echo "󰝟"
  else
    v=$(level)
    if   [ "${v:-0}" -eq 0 ];  then echo "󰕿"
    elif [ "${v:-0}" -lt 50 ]; then echo "󰖀"
    else echo "󰕾"; fi
  fi
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
        *sink*|*server*) emit ;;
      esac
    done
  else
    while sleep 1; do emit; done
  fi
}

case "$1" in
  get)    level ;;
  icon)   icon ;;
  set)    v=$(printf '%.0f' "${2:-0}"); wpctl set-volume "$SINK" "${v}%" ;;
  mute)   wpctl set-mute "$SINK" toggle ;;
  scroll)
    case "$2" in
      up)   wpctl set-volume "$SINK" 5%+ ;;
      down) wpctl set-volume "$SINK" 5%- ;;
    esac
    ;;
  listen) listen ;;
esac
