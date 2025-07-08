#!/bin/bash
# TLP Performance Profile Switcher
# Script to switch between high and low performance TLP profiles
# For integration with Waybar battery module

set -e

# Paths to configuration files
HIGH_PERF_CONFIG="$HOME/.dotfiles/.config/scripts/high_perf_tlp.conf"
LOW_PERF_CONFIG="$HOME/.dotfiles/.config/scripts/low_perf_tlp.conf"
SYSTEM_TLP_CONFIG="/etc/tlp.conf"
STATUS_FILE="$HOME/.cache/tlp_profile_status"

# Colors for notifications
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to show usage
show_usage() {
    echo "Usage: $0 [high|low|toggle|status]"
    echo ""
    echo "Commands:"
    echo "  high    - Switch to high performance profile"
    echo "  low     - Switch to low performance profile (power saving)"
    echo "  toggle  - Toggle between high and low performance"
    echo "  status  - Show current profile status"
    echo ""
    echo "This script requires sudo privileges to modify /etc/tlp.conf"
}

# Function to get current profile
get_current_profile() {
    if [[ -f "$STATUS_FILE" ]]; then
        cat "$STATUS_FILE"
    else
        echo "unknown"
    fi
}

# Function to apply TLP configuration
apply_tlp_config() {
    local config_file="$1"
    local profile_name="$2"
    
    if [[ ! -f "$config_file" ]]; then
        echo -e "${RED}Error: Configuration file $config_file not found!${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}Applying $profile_name profile...${NC}"
    
    # Backup current config if it doesn't exist
    if [[ ! -f "${SYSTEM_TLP_CONFIG}.backup" ]]; then
        echo "Creating backup of original TLP configuration..."
        sudo cp "$SYSTEM_TLP_CONFIG" "${SYSTEM_TLP_CONFIG}.backup"
    fi
    
    # Copy configuration
    sudo cp "$config_file" "$SYSTEM_TLP_CONFIG"
    
    # Restart TLP service
    echo "Restarting TLP service..."
    sudo systemctl restart tlp.service
    
    # Apply settings immediately
    sudo tlp start
    
    # Save status
    echo "$profile_name" > "$STATUS_FILE"
    
    # Send notification
    if command -v notify-send >/dev/null 2>&1; then
        if [[ "$profile_name" == "high" ]]; then
            notify-send "TLP Profile" "🚀 High Performance mode activated" -i "preferences-system-power" -t 3000
        else
            notify-send "TLP Profile" "🔋 Power Saving mode activated" -i "battery" -t 3000
        fi
    fi
    
    echo -e "${GREEN}Successfully applied $profile_name performance profile!${NC}"
    
    # Show some key settings
    echo ""
    echo "Current TLP status:"
    tlp-stat -s | head -10
}

# Function to show current status
show_status() {
    local current_profile=$(get_current_profile)
    
    echo "===================="
    echo "TLP Profile Status"
    echo "===================="
    echo "Current Profile: $current_profile"
    echo ""
    
    if [[ "$current_profile" != "unknown" ]]; then
        echo "TLP Service Status:"
        systemctl is-active tlp.service
        echo ""
        echo "Key Settings:"
        tlp-stat -p | grep -E "(CPU|Platform|Governor)" | head -5
    else
        echo "No profile information available."
        echo "Use '$0 high' or '$0 low' to set a profile."
    fi
}

# Function to toggle between profiles
toggle_profile() {
    local current_profile=$(get_current_profile)
    
    if [[ "$current_profile" == "high" ]]; then
        apply_tlp_config "$LOW_PERF_CONFIG" "low"
    else
        # Default to high if unknown or currently low
        apply_tlp_config "$HIGH_PERF_CONFIG" "high"
    fi
}

# Function for Waybar integration (returns simple status)
waybar_status() {
    local current_profile=$(get_current_profile)
    case "$current_profile" in
        "high")
            echo '{"text": "🚀", "tooltip": "High Performance Mode\\nClick to switch to Power Saving", "class": "performance"}'
            ;;
        "low")
            echo '{"text": "🔋", "tooltip": "Power Saving Mode\\nClick to switch to High Performance", "class": "powersave"}'
            ;;
        *)
            echo '{"text": "⚡", "tooltip": "Unknown TLP Profile\\nClick to set High Performance", "class": "unknown"}'
            ;;
    esac
}

# Main script logic
case "${1:-}" in
    "high")
        apply_tlp_config "$HIGH_PERF_CONFIG" "high"
        ;;
    "low")
        apply_tlp_config "$LOW_PERF_CONFIG" "low"
        ;;
    "toggle")
        toggle_profile
        ;;
    "status")
        show_status
        ;;
    "waybar")
        waybar_status
        ;;
    "")
        show_usage
        exit 1
        ;;
    *)
        echo -e "${RED}Error: Unknown command '$1'${NC}"
        show_usage
        exit 1
        ;;
esac
