#!/usr/bin/env bash
# usage: audio.sh sink|source listen|mute|scroll up|down
kind=$1
T="@DEFAULT_AUDIO_${kind^^}@"

level() { wpctl get-volume "$T" | awk '{print int($2 * 100)}'; }
muted() { wpctl get-volume "$T" | grep -q MUTED; }
icon() {
  if [ "$kind" = source ]; then
    muted && echo "󰍭" || echo "󰍬"
  elif muted; then echo "󰝟"
  else
    v=$(level)
    if   [ "$v" -eq 0 ];  then echo "󰕿"
    elif [ "$v" -lt 50 ]; then echo "󰖀"
    else echo "󰕾"; fi
  fi
}
emit() { printf '{"level":%s,"icon":"%s"}\n' "$(level)" "$(icon)"; }

case "$2" in
  mute)   wpctl set-mute "$T" toggle ;;
  scroll) [ "$3" = up ] && wpctl set-volume "$T" 5%+ || wpctl set-volume "$T" 5%- ;;
  listen)
    emit
    pactl subscribe | while read -r line; do
      case "$line" in *$kind*|*server*) emit ;; esac
    done ;;
esac
