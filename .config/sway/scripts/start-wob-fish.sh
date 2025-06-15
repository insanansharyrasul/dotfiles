#!/usr/bin/fish
# Wob daemon startup script for fish shell

set USER_ID (id -u)
set WOB_SOCK "/run/user/$USER_ID/wob.sock"

# Kill any existing wob processes
pkill -f "wob" 2>/dev/null; or true
sleep 0.5

# Remove old socket if it exists and create new one
rm -f "$WOB_SOCK" 2>/dev/null; or true
mkfifo "$WOB_SOCK" 2>/dev/null; or true

echo "Starting wob daemon..."
echo "Socket created at: $WOB_SOCK"
echo "You can now use volume/brightness controls to see overlays."
echo ""
echo "Press Ctrl+C to stop wob daemon."

# Start wob in fish (this will run in foreground)
exec tail -f "$WOB_SOCK" | wob --config ~/.config/wob/wob.ini
