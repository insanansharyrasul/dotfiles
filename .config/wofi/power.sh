#!/usr/bin/env bash
# filepath: ~/.config/wofi/power.sh

entries="⏻ Shutdown\n⟳ Reboot\n⏾ Suspend\n⏏ Logout\n🔒 Lock"

selected=$(echo -e $entries | wofi --dmenu --cache-file /dev/null --insensitive --width 250 --height 210 --style ~/.config/wofi/wofi-font.css --prompt "Power Menu" | awk '{print tolower($2)}')

case $selected in
  shutdown)
    exec systemctl poweroff
    ;;
  reboot)
    exec systemctl reboot
    ;;
  suspend)
    exec systemctl suspend
    ;;
  logout)
    exec loginctl terminate-session ${XDG_SESSION_ID-}
    ;;
  lock)
    exec swaylock -f -c 000000
    ;;
esac