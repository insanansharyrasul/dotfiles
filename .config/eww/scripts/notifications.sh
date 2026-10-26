#!/usr/bin/env bash
case "$1" in
  listen)
    swaync-client -swb | jq -c --unbuffered '
      def icon($state):
        if $state == "notification" then "󱅫"
        elif $state == "dnd-notification" then "󰂠"
        elif $state == "dnd-none" then "󰪓"
        elif $state | test("inhibited-notification") then "󰂛"
        elif $state | test("inhibited-none") then "󰪑"
        else "󰂜"
        end;
      {
        count: (try (.text | tonumber) catch 0),
        state: (.alt // "none"),
        icon: icon(.alt // "none")
      }' ;;
  toggle) swaync-client -t -sw ;;
  dnd)    swaync-client -d -sw ;;
  clear)  swaync-client -C -sw ;;
esac
