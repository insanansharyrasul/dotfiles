#!/usr/bin/env python3
import subprocess
import json
import sys


def get_player_status():
    try:
        player = subprocess.check_output(
            ["playerctl", "--player=%any", "status"], stderr=subprocess.DEVNULL
        ).decode().strip()
    except subprocess.CalledProcessError:
        return None, None, None

    try:
        title = subprocess.check_output(
            ["playerctl", "--player=%any", "metadata", "title"], stderr=subprocess.DEVNULL
        ).decode().strip()
        artist = subprocess.check_output(
            ["playerctl", "--player=%any", "metadata", "artist"], stderr=subprocess.DEVNULL
        ).decode().strip()
    except subprocess.CalledProcessError:
        title, artist = "", ""

    return player, sys.status, title, artist


def main():
    try:
        status = subprocess.check_output(
            ["playerctl", "--player=%any", "status"], stderr=subprocess.DEVNULL
        ).decode().strip()
    except subprocess.CalledProcessError:
        print(json.dumps({"text": "", "tooltip": "", "class": "stopped", "alt": "stopped"}))
        return

    try:
        title = subprocess.check_output(
            ["playerctl", "--player=%any", "metadata", "title"], stderr=subprocess.DEVNULL
        ).decode().strip()
        artist = subprocess.check_output(
            ["playerctl", "--player=%any", "metadata", "artist"], stderr=subprocess.DEVNULL
        ).decode().strip()
        player_name = subprocess.check_output(
            ["playerctl", "--player=%any", "metadata", "--format", "{{playerName}}"],
            stderr=subprocess.DEVNULL
        ).decode().strip()
    except subprocess.CalledProcessError:
        title, artist, player_name = "", "", ""

    if not title:
        print(json.dumps({"text": "", "tooltip": "", "class": "stopped", "alt": "stopped"}))
        return

    label = f"{artist} - {title}" if artist else title
    if len(label) > 40:
        label = label[:38] + "…"

    icon = "" if "spotify" in player_name.lower() else "󰎈"
    playing_icon = icon if status == "Playing" else "󰏤"

    tooltip = f"{player_name}: {artist} - {title}" if artist else f"{player_name}: {title}"

    output = {
        "text": f"{playing_icon} {label}",
        "tooltip": tooltip,
        "class": status.lower(),
        "alt": player_name,
    }
    print(json.dumps(output))


if __name__ == "__main__":
    main()
