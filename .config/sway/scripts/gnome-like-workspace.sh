#!/usr/bin/env bash

# Script to create a GNOME-like workspace behavior in Sway
# When there are no more workspaces in a direction, create a new one instead of cycling back

# Get the current workspace number
current=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .num')

# Get all workspace numbers as an array
workspaces=($(swaymsg -t get_workspaces | jq '.[].num' | sort -n))

# Direction can be "next" or "prev"
direction=$1

if [ "$direction" == "next" ]; then
    # Find the next workspace number
    next_ws=""
    for ws in "${workspaces[@]}"; do
        if (( ws > current )); then
            next_ws=$ws
            break
        fi
    done

    # If no next workspace exists, create a new one
    if [ -z "$next_ws" ]; then
        # Find the highest workspace number and add 1
        highest=${workspaces[-1]}
        next_ws=$((highest + 1))
        
        # Create and switch to the new workspace
        swaymsg "workspace number $next_ws"
    else
        # Switch to the existing next workspace
        swaymsg "workspace number $next_ws"
    fi
elif [ "$direction" == "prev" ]; then
    # Find the previous workspace number
    prev_ws=""
    for (( i=${#workspaces[@]}-1; i>=0; i-- )); do
        if (( ${workspaces[i]} < current )); then
            prev_ws=${workspaces[i]}
            break
        fi
    done

    # If a previous workspace exists, switch to it
    if [ -n "$prev_ws" ]; then
        swaymsg "workspace number $prev_ws"
    fi
    # If no previous workspace, do nothing (stay on current)
fi
