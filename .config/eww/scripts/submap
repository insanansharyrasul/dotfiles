#!/usr/bin/env bash
# Stream the current Hyprland submap name (empty when in the default submap).

echo ""

socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
[ -S "$socket" ] || exit 0

socat -u "UNIX-CONNECT:$socket" - | while read -r line; do
  case "$line" in
    submap\>\>*) echo "${line#submap>>}" ;;
  esac
done
