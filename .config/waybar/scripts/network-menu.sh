#!/bin/bash
WIFI_STATUS=$(nmcli -t -f DEVICE,STATE device | grep wifi | cut -d: -f2)
WIRED_STATUS=$(nmcli -t -f DEVICE,STATE device | grep ethernet | cut -d: -f2)

CHOICE=$(echo -e "WiFi: $WIFI_STATUS\nEthernet: $WIRED_STATUS\n---\nConnect to WiFi\nEnable Hotspot\nEdit Connections\nTurn WiFi Off\nTurn WiFi On" | wofi --dmenu --prompt "Network" --width 250)

case "$CHOICE" in
    "Connect to WiFi")
        nmcli device wifi rescan
        SSID=$(nmcli device wifi list | tail -n +2 | wofi --dmenu --prompt "Select WiFi" | awk '{print $2}')
        if [ ! -z "$SSID" ]; then
            nmcli device wifi connect "$SSID" --ask
        fi
        ;;
    "Enable Hotspot")
        nmcli connection up Hotspot
        ;;
    "Edit Connections")
        nm-connection-editor
        ;;
    "Turn WiFi Off")
        nmcli radio wifi off
        ;;
    "Turn WiFi On")
        nmcli radio wifi on
        ;;
esac