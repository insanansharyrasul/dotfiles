#!/bin/bash

# Power menu for i3 using rofi

options="🔒 Lock\n🚪 Logout\n🔄 Restart\n⚡ Shutdown\n💤 Suspend"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme ~/.config/rofi/power.rasi)

case $chosen in
    *Lock)
        i3lock -c 000000
        ;;
    *Logout)
        i3-msg exit
        ;;
    *Restart)
        systemctl reboot
        ;;
    *Shutdown)
        systemctl poweroff
        ;;
    *Suspend)
        systemctl suspend
        ;;
esac
