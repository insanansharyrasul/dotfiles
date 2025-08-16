#!/bin/bash
# Waybar TLP Profile Module
# Shows current TLP performance profile with icon

# Get the TLP switcher script path
TLP_SWITCHER="$HOME/.dotfiles/.config/scripts/tlp-switcher.sh"

# Check if the script exists
if [[ ! -f "$TLP_SWITCHER" ]]; then
    echo '{"text": "❌", "tooltip": "TLP Switcher not found", "class": "error"}'
    exit 1
fi

# Get current profile status
current_profile=$("$TLP_SWITCHER" status 2>/dev/null | grep "Current Profile:" | awk '{print $3}' || echo "unknown")

# Output JSON for Waybar
case "$current_profile" in
    "high")
        echo '{"text": "", "tooltip": "High Performance Mode\nClick to switch to Power Saving", "class": "performance"}'
        ;;
    "low")
        echo '{"text": "", "tooltip": "Power Saving Mode\nClick to switch to High Performance", "class": "powersave"}'
        ;;
    *)
        echo '{"text": "⚡", "tooltip": "Unknown TLP Profile\nClick to toggle", "class": "unknown"}'
        ;;
esac
