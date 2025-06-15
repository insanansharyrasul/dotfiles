# Wob Troubleshooting Guide

## Fixed: Script Spam Issue ✅

**Problem**: Volume/brightness scripts were creating multiple processes when scrolling on Waybar modules.

**Solution Applied**:
1. **Process locking** - Scripts now use lock files (`/tmp/volume-wob.lock`, `/tmp/brightness-wob.lock`)
2. **Rate limiting** - 50ms delay between wob updates
3. **Scroll sensitivity** - Waybar scroll-step increased from 1 to 3
4. **Error handling** - Scripts check if wob socket exists before sending data

## Current Status

### ✅ Working Features:
- Volume up/down with wob overlay
- Brightness up/down with wob overlay  
- No more process spam when scrolling
- Proper script cleanup on exit
- Mute toggle with visual feedback

### 🎛️ Controls:
- **Function keys**: XF86Audio*/XF86MonBrightness* 
- **Manual keys**: $mod+F1/F2 for volume
- **Waybar scroll**: Scroll on audio/backlight modules (now less sensitive)
- **Waybar click**: Click audio module to toggle mute

## Quick Commands

```fish
# Start wob daemon
source ~/.dotfiles/.config/sway/scripts/wob-fish-functions.fish
start-wob

# Stop wob daemon  
stop-wob

# Test controls
~/.config/waybar/scripts/volume-wob.sh up
~/.config/waybar/scripts/brightness-wob.sh down

# Check if wob is running
ps aux | grep wob | grep -v grep

# Clean up lock files if needed
rm -f /tmp/volume-wob.lock /tmp/brightness-wob.lock
```

## Performance Notes

- Scripts now exit immediately if another instance is running
- Maximum one volume script and one brightness script can run simultaneously  
- Wob updates are throttled to prevent overwhelming the overlay system
- Waybar scroll requires more movement to trigger (scroll-step: 3)

Everything should now work smoothly without spamming your task manager! 🎉
