#!/usr/bin/env bash
entries="⏾ Suspend\n⏏ Logout\n⟳ Reboot\n⏻ Shutdown"

selected=$(echo -e $entries | wofi --dmenu --cache-file /dev/null --insensitive --width 250 --height 275 --style ~/.config/wofi/wofi-font.css --prompt "Power Menu" | awk '{print tolower($2)}')

case $selected in
  suspend)
    exec systemctl suspend
    ;;
  logout)
    exec loginctl terminate-session ${XDG_SESSION_ID-}
    ;;
  shutdown)
    exec systemctl poweroff
    ;;
  reboot)
    exec systemctl reboot
    ;;
  lock)
    exec swaylock -f -c 000000
    ;;
esac