#!/bin/bash

# Get list of available devices
devices=$(kdeconnect-cli --list-available --name-only 2>/dev/null)

if [ -z "$devices" ]; then
    zenity --info --text="No KDE Connect devices available.\n\nMake sure:\n1. KDE Connect is running\n2. Your device is connected\n3. Your device is paired"
    exit 1
fi

# Convert devices to array for zenity
device_array=()
while IFS= read -r device; do
    if [ -n "$device" ]; then
        device_array+=("$device")
    fi
done <<< "$devices"

# Show device selection dialog
if [ ${#device_array[@]} -eq 1 ]; then
    # Only one device, use it directly
    selected_device="${device_array[0]}"
else
    # Multiple devices, show selection dialog
    selected_device=$(printf '%s\n' "${device_array[@]}" | zenity --list --title="Select Device" --text="Choose device to send file(s) to:" --column="Device Name" --height=300 --width=400)
fi

if [ -n "$selected_device" ]; then
    # Get device ID from name
    device_id=$(kdeconnect-cli --list-available | grep "$selected_device" | head -1 | cut -d: -f1 | tr -d ' ')
    
    if [ -n "$device_id" ]; then
        # Send files to selected device
        for file in "$@"; do
            kdeconnect-cli --device "$device_id" --share "$file"
        done
        notify-send "KDE Connect" "File(s) sent to $selected_device"
    else
        zenity --error --text="Could not find device ID for $selected_device"
    fi
fi
