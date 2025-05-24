#!/usr/bin/env bash
current=$(swaymsg -t get_workspaces | jq '.[] | select(.focused == true) | .num')
workspaces=($(swaymsg -t get_workspaces | jq '.[].num' | sort -n))
direction=$1

if [ "$direction" == "next" ]; then
    next_ws=""
    for ws in "${workspaces[@]}"; do
        if (( ws > current )); then
            next_ws=$ws
            break
        fi
    done

    if [ -z "$next_ws" ]; then
        highest=${workspaces[-1]}
        next_ws=$((highest + 1))
        swaymsg "workspace number $next_ws"
    else
        swaymsg "workspace number $next_ws"
    fi
elif [ "$direction" == "prev" ]; then
    prev_ws=""
    for (( i=${#workspaces[@]}-1; i>=0; i-- )); do
        if (( ${workspaces[i]} < current )); then
            prev_ws=${workspaces[i]}
            break
        fi
    done

    if [ -n "$prev_ws" ]; then
        swaymsg "workspace number $prev_ws"
    fi
fi
