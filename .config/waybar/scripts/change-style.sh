#!/bin/bash

# Waybar style toggle script
# Toggles between style.css and style2.css

WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
STYLE1="$WAYBAR_CONFIG_DIR/style.css"
STYLE2="$WAYBAR_CONFIG_DIR/style2.css"
CURRENT_STYLE="$WAYBAR_CONFIG_DIR/current-style.txt"

# Create current-style.txt if it doesn't exist (default to style.css)
if [ ! -f "$CURRENT_STYLE" ]; then
    echo "style.css" > "$CURRENT_STYLE"
fi

# Read current style
current=$(cat "$CURRENT_STYLE")

# Toggle between styles
if [ "$current" = "style.css" ]; then
    new_style="style2.css"
    echo "style2.css" > "$CURRENT_STYLE"
else
    new_style="style.css"
    echo "style.css" > "$CURRENT_STYLE"
fi

# Kill and restart waybar with the new style
pkill waybar
sleep 0.2
waybar -c "$WAYBAR_CONFIG_DIR/config" -s "$WAYBAR_CONFIG_DIR/$new_style" &

echo "Waybar restarted with $new_style"