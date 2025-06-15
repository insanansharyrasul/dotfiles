# Fish function to start wob daemon
# Add this to your ~/.config/fish/config.fish or run it manually

function start-wob
    set USER_ID (id -u)
    set WOB_SOCK "/run/user/$USER_ID/wob.sock"
    
    # Kill any existing wob processes
    pkill -f "wob" 2>/dev/null; or true
    sleep 0.5
    
    # Remove old socket if it exists and create new one
    rm -f "$WOB_SOCK" 2>/dev/null; or true
    mkfifo "$WOB_SOCK" 2>/dev/null; or true
    
    echo "Starting wob daemon..."
    echo "Socket: $WOB_SOCK"
    
    # Start wob daemon in background the fish way
    tail -f "$WOB_SOCK" | wob --config ~/.config/wob/wob.ini &
    
    echo "Wob started successfully!"
end

# Quick start function
function wob-start
    start-wob
end
