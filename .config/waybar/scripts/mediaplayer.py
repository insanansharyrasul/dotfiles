#!/usr/bin/env python3
import subprocess
import json
import signal
import sys


def output(text="", tooltip="", css_class="stopped", alt="stopped"):
    print(json.dumps({"text": text, "tooltip": tooltip, "class": css_class, "alt": alt}), flush=True)


def get_current_state():
    try:
        status = subprocess.check_output(
            ["playerctl", "--player=%any", "status"], stderr=subprocess.DEVNULL
        ).decode().strip()
    except subprocess.CalledProcessError:
        output()
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
        output()
        return

    label = f"{artist} - {title}" if artist else title
    if len(label) > 40:
        label = label[:38] + "…"

    icon = "" if "spotify" in player_name.lower() else "󰎈"
    playing_icon = icon if status == "Playing" else "󰏤"

    tooltip = f"{player_name}: {artist} - {title}" if artist else f"{player_name}: {title}"

    output(f"{playing_icon} {label}", tooltip, status.lower(), player_name)


def main():
    signal.signal(signal.SIGTERM, lambda *_: sys.exit(0))
    signal.signal(signal.SIGINT, lambda *_: sys.exit(0))

    # Print initial state
    get_current_state()

    # Follow player events for real-time updates
    proc = subprocess.Popen(
        ["playerctl", "--player=%any", "--follow", "status"],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
    )

    for line in proc.stdout:
        get_current_state()


if __name__ == "__main__":
    main()
