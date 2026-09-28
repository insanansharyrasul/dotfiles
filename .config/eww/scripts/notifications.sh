#!/usr/bin/env bash

listen() {
  if ! command -v swaync-client >/dev/null 2>&1; then
    while true; do
      printf '{"count":0,"state":"none","icon":"󰂜","tooltip":"SwayNC not found"}\n'
      sleep 5
    done
  fi

  swaync-client -swb | jq -c --unbuffered '
    def icon($state):
      if $state == "notification" then "󱅫"
      elif $state == "none" then "󰂜"
      elif $state == "dnd-notification" then "󰂠"
      elif $state == "dnd-none" then "󰪓"
      elif $state == "inhibited-notification" then "󰂛"
      elif $state == "inhibited-none" then "󰪑"
      elif $state == "dnd-inhibited-notification" then "󰂛"
      elif $state == "dnd-inhibited-none" then "󰪑"
      else "󰂜"
      end;
    {
      count: (try (.text | tonumber) catch 0),
      state: (.alt // "none"),
      tooltip: (.tooltip // "Notifications"),
      icon: icon(.alt // "none")
    }'
}

case "$1" in
  listen) listen ;;
  toggle) swaync-client -t -sw ;;
  dnd) swaync-client -d -sw ;;
  clear) swaync-client -C -sw ;;
  count) swaync-client -c ;;
esac
