#!/bin/bash
# Wob daemon startup script

USER_ID=$(id -u)
WOB_SOCK="/run/user/$USER_ID/wob.sock"

# Kill any existing wob processes
pkill -f "wob" 2>/dev/null

# Remove old socket if it exists
rm -f "$WOB_SOCK" 2>/dev/null

# Create the named pipe
mkfifo "$WOB_SOCK"

# Start wob with our configuration in the background
tail -f "$WOB_SOCK" | wob --config ~/.config/wob/wob.ini &

echo "Wob started with socket at $WOB_SOCK"
