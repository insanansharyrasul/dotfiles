#!/bin/bash
# Interactive TLP Profile Manager for Alacritty
# Provides a user-friendly menu interface for TLP profile switching

set -e

# Colors for better terminal display
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# TLP switcher script path
TLP_SWITCHER="$HOME/.dotfiles/.config/scripts/tlp-switcher.sh"

# Clear screen and show header
clear_and_show_header() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║         TLP Performance Manager        ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
}

# Function to show current status with colors
show_current_status() {
    echo -e "${WHITE}Current Status:${NC}"
    echo -e "${BLUE}═══════════════${NC}"
    
    # Get current profile
    local current_profile=$("$TLP_SWITCHER" status 2>/dev/null | grep "Current Profile:" | awk '{print $3}' || echo "unknown")
    
    case "$current_profile" in
        "high")
            echo -e "Profile: ${RED}🚀 HIGH PERFORMANCE${NC}"
            echo -e "Mode: ${RED}Maximum CPU performance, higher power consumption${NC}"
            ;;
        "low")
            echo -e "Profile: ${GREEN}🔋 POWER SAVING${NC}"
            echo -e "Mode: ${GREEN}Extended battery life, reduced performance${NC}"
            ;;
        *)
            echo -e "Profile: ${YELLOW}⚡ UNKNOWN${NC}"
            echo -e "Mode: ${YELLOW}No profile set, using system defaults${NC}"
            ;;
    esac
    
    # Show TLP service status
    if systemctl is-active --quiet tlp.service; then
        echo -e "TLP Service: ${GREEN}✓ Active${NC}"
    else
        echo -e "TLP Service: ${RED}✗ Inactive${NC}"
    fi
    
    echo ""
}

# Function to show menu options
show_menu() {
    echo -e "${WHITE}Available Actions:${NC}"
    echo -e "${BLUE}══════════════════${NC}"
    echo -e "${GREEN}1)${NC} Switch to ${RED}High Performance${NC} Mode 🚀"
    echo -e "${GREEN}2)${NC} Switch to ${GREEN}Power Saving${NC} Mode 🔋"
    echo -e "${GREEN}3)${NC} ${PURPLE}Toggle${NC} between modes ⚡"
    echo -e "${GREEN}4)${NC} Show detailed ${CYAN}Status${NC} 📊"
    echo -e "${GREEN}5)${NC} ${YELLOW}Refresh${NC} this menu 🔄"
    echo -e "${GREEN}q)${NC} ${WHITE}Quit${NC} ❌"
    echo ""
}

# Function to execute TLP command with feedback
execute_tlp_command() {
    local command="$1"
    local description="$2"
    
    echo -e "${BLUE}$description...${NC}"
    echo ""
    
    # Execute the command
    if "$TLP_SWITCHER" "$command"; then
        echo ""
        echo -e "${GREEN}✓ Success!${NC}"
        sleep 2
    else
        echo ""
        echo -e "${RED}✗ Failed! Check if you have sudo privileges.${NC}"
        echo -e "${YELLOW}Press Enter to continue...${NC}"
        read
    fi
}

# Function to show detailed status
show_detailed_status() {
    clear_and_show_header
    echo -e "${WHITE}Detailed TLP Status:${NC}"
    echo -e "${BLUE}═══════════════════${NC}"
    echo ""
    
    "$TLP_SWITCHER" status
    
    echo ""
    echo -e "${YELLOW}Press Enter to return to menu...${NC}"
    read
}

# Main interactive loop
main_loop() {
    while true; do
        clear_and_show_header
        show_current_status
        show_menu
        
        echo -e "${WHITE}Choose an option:${NC} "
        read -r choice
        
        case "$choice" in
            "1")
                execute_tlp_command "high" "Switching to High Performance mode"
                ;;
            "2")
                execute_tlp_command "low" "Switching to Power Saving mode"
                ;;
            "3")
                execute_tlp_command "toggle" "Toggling TLP profile"
                ;;
            "4")
                show_detailed_status
                ;;
            "5")
                # Just refresh by continuing the loop
                ;;
            "q"|"Q"|"quit"|"exit")
                echo -e "${GREEN}Goodbye! 👋${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please try again.${NC}"
                sleep 1
                ;;
        esac
    done
}

# Check if TLP switcher exists
if [[ ! -f "$TLP_SWITCHER" ]]; then
    echo -e "${RED}Error: TLP switcher script not found at $TLP_SWITCHER${NC}"
    echo -e "${YELLOW}Make sure the script exists and is executable.${NC}"
    exit 1
fi

# Start the interactive menu
main_loop
