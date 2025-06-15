# Fish Shell Wob Integration

## Working Solution ✅

The issue was fish shell's job control interfering with background processes started from bash scripts.

## Fixed Issues

### ✅ Process Locking Added
- Volume and brightness scripts now use lock files to prevent multiple instances
- Rapid scroll events no longer spam the task manager
- Scripts automatically clean up on exit

### ✅ Rate Limiting
- Added 50ms delay between wob updates
- Waybar scroll-step increased from 1 to 3 for better control
- Socket existence check prevents errors when wob isn't running

## Manual Startup (Recommended)

Add these functions to your `~/.config/fish/config.fish`:

```fish
# Wob daemon management functions
function start-wob
    set USER_ID (id -u)
    set WOB_SOCK "/run/user/$USER_ID/wob.sock"
    
    pkill -f "wob" 2>/dev/null; or true
    sleep 0.5
    rm -f "$WOB_SOCK" 2>/dev/null; or true
    mkfifo "$WOB_SOCK" 2>/dev/null; or true
    
    echo "Starting wob daemon..."
    tail -f "$WOB_SOCK" | wob --config ~/.config/wob/wob.ini &
    echo "✓ Wob started successfully!"
end

function stop-wob
    pkill -f "wob" 2>/dev/null; or true
    echo "✓ Wob stopped"
end
```

## Usage

```fish
# Start wob
start-wob

# Stop wob  
stop-wob

# Test volume (should show overlay)
~/.config/waybar/scripts/volume-wob.sh up
```

## Autostart Options

1. **Sway autostart** (may have timing issues):
   ```
   exec ~/.dotfiles/.config/sway/scripts/autostart-wob.fish
   ```

2. **Manual start after login** (most reliable):
   Just run `start-wob` in your terminal after Sway starts

3. **Fish config autostart** (add to ~/.config/fish/config.fish):
   ```fish
   # Auto-start wob if in graphical session
   if test "$XDG_SESSION_TYPE" = "wayland"
       start-wob
   end
   ```

## Why This Works

- Fish native functions avoid shell job control conflicts
- Direct `tail | wob &` works perfectly in fish
- No intermediate bash scripts causing SIGTERM issues

The manual command you tested works because fish handles it as a direct command, not through script execution!
