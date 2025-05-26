#!/bin/bash

# Get WiFi status and current connection
WIFI_STATUS=$(nmcli -t -f DEVICE,STATE device | grep wlo1 | cut -d: -f2)
CURRENT_SSID=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)
WIFI_STRENGTH=$(nmcli -t -f ACTIVE,SIGNAL dev wifi | grep '^yes' | cut -d: -f2)

# Build status line
if [ "$WIFI_STATUS" = "connected" ] && [ ! -z "$CURRENT_SSID" ]; then
    STATUS_LINE="Connected: $CURRENT_SSID ($WIFI_STRENGTH%)"
else
    STATUS_LINE="WiFi: $WIFI_STATUS"
fi

# Main menu
CHOICE=$(echo -e "$STATUS_LINE\n---\nConnect to WiFi\nDisconnect WiFi\nForget WiFi Network\nEnable Hotspot\nDisable Hotspot\nEdit Connections\nTurn WiFi Off\nTurn WiFi On\nShow WiFi Info" | wofi --dmenu --prompt "Network" --width 300 --height 400)

case "$CHOICE" in
    "Connect to WiFi")
        # Rescan for networks
        nmcli device wifi rescan
        sleep 2
        
        # Get available networks with better formatting
        NETWORKS=$(nmcli device wifi list --rescan-delay 0 | tail -n +2 | awk '
        {
            ssid = $2
            security = ""
            signal = ""
            for (i = 3; i <= NF; i++) {
                if ($i ~ /^[0-9]+$/) {
                    signal = $i "%"
                    break
                } else if ($i ~ /WPA|WEP|--/) {
                    security = $i
                }
            }
            if (ssid != "--") {
                printf "%-20s %s %s\n", ssid, security, signal
            }
        }' | sort -k3 -nr)
        
        if [ -z "$NETWORKS" ]; then
            notify-send "Network Menu" "No WiFi networks found"
            exit 1
        fi
        
        # Show networks in wofi
        SELECTED=$(echo "$NETWORKS" | wofi --dmenu --prompt "Select WiFi Network" --width 400 --height 300)
        
        if [ ! -z "$SELECTED" ]; then
            SSID=$(echo "$SELECTED" | awk '{print $1}')
            SECURITY=$(echo "$SELECTED" | awk '{print $2}')
            
            if [ "$SECURITY" = "--" ] || [ "$SECURITY" = "" ]; then
                # Open network
                notify-send "Network Menu" "Connecting to $SSID..."
                if nmcli device wifi connect "$SSID"; then
                    notify-send "Network Menu" "Successfully connected to $SSID"
                else
                    notify-send "Network Menu" "Failed to connect to $SSID"
                fi
            else
                # Secured network - prompt for password
                PASSWORD=$(echo "" | wofi --dmenu --prompt "Enter password for $SSID" --password --width 300)
                
                if [ ! -z "$PASSWORD" ]; then
                    notify-send "Network Menu" "Connecting to $SSID..."
                    if nmcli device wifi connect "$SSID" password "$PASSWORD"; then
                        notify-send "Network Menu" "Successfully connected to $SSID"
                    else
                        notify-send "Network Menu" "Failed to connect to $SSID - Check password"
                    fi
                fi
            fi
        fi
        ;;
    
    "Disconnect WiFi")
        if [ "$WIFI_STATUS" = "connected" ]; then
            nmcli device disconnect wlo1
            notify-send "Network Menu" "WiFi disconnected"
        else
            notify-send "Network Menu" "WiFi is not connected"
        fi
        ;;
    
    "Forget WiFi Network")
        # Get saved connections
        SAVED_CONNECTIONS=$(nmcli connection show | grep wifi | awk '{print $1}')
        
        if [ ! -z "$SAVED_CONNECTIONS" ]; then
            SELECTED_CONN=$(echo "$SAVED_CONNECTIONS" | wofi --dmenu --prompt "Select network to forget" --width 300)
            
            if [ ! -z "$SELECTED_CONN" ]; then
                if nmcli connection delete "$SELECTED_CONN"; then
                    notify-send "Network Menu" "Forgot network: $SELECTED_CONN"
                else
                    notify-send "Network Menu" "Failed to forget network: $SELECTED_CONN"
                fi
            fi
        else
            notify-send "Network Menu" "No saved WiFi networks found"
        fi
        ;;
    
    "Enable Hotspot")
        # Check if hotspot connection exists
        if nmcli connection show | grep -q "Hotspot"; then
            if nmcli connection up Hotspot; then
                notify-send "Network Menu" "Hotspot enabled"
            else
                notify-send "Network Menu" "Failed to enable hotspot"
            fi
        else
            # Create hotspot
            HOTSPOT_NAME=$(echo "MyHotspot" | wofi --dmenu --prompt "Hotspot name" --width 300)
            HOTSPOT_PASS=$(echo "" | wofi --dmenu --prompt "Hotspot password (min 8 chars)" --password --width 300)
            
            if [ ! -z "$HOTSPOT_NAME" ] && [ ${#HOTSPOT_PASS} -ge 8 ]; then
                if nmcli device wifi hotspot con-name "Hotspot" ssid "$HOTSPOT_NAME" password "$HOTSPOT_PASS"; then
                    notify-send "Network Menu" "Hotspot '$HOTSPOT_NAME' created and enabled"
                else
                    notify-send "Network Menu" "Failed to create hotspot"
                fi
            else
                notify-send "Network Menu" "Invalid hotspot name or password (min 8 chars)"
            fi
        fi
        ;;
    
    "Disable Hotspot")
        if nmcli connection down Hotspot 2>/dev/null; then
            notify-send "Network Menu" "Hotspot disabled"
        else
            notify-send "Network Menu" "No active hotspot found"
        fi
        ;;
    
    "Edit Connections")
        nm-connection-editor &
        ;;
    
    "Turn WiFi Off")
        nmcli radio wifi off
        notify-send "Network Menu" "WiFi turned off"
        ;;
    
    "Turn WiFi On")
        nmcli radio wifi on
        notify-send "Network Menu" "WiFi turned on"
        ;;
    
    "Show WiFi Info")
        if [ "$WIFI_STATUS" = "connected" ] && [ ! -z "$CURRENT_SSID" ]; then
            INFO=$(nmcli device show wlo1 | grep -E "GENERAL.CONNECTION|IP4.ADDRESS|IP4.GATEWAY|IP4.DNS")
            notify-send "WiFi Information" "$INFO"
        else
            notify-send "Network Menu" "WiFi is not connected"
        fi
        ;;
esac