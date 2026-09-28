#!/usr/bin/env bash
iface=wlo1

icon() {
  state=$(cat "/sys/class/net/$iface/operstate" 2>/dev/null)
  [ "$state" = "up" ] && echo "󰤨" || echo "󰤭"
}

name() {
  ssid=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '/^yes/{print $2; exit}')
  [ -n "$ssid" ] && echo "$ssid" || echo "Disconnected"
}

case "$1" in
  icon) icon ;;
  name) name ;;
esac
