#!/usr/bin/env bash

set -u

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}"
PID_FILE="$STATE_DIR/wl-screenrec.pid"
OUTPUT_FILE_STATE="$STATE_DIR/wl-screenrec.output"
NOTIFICATION_ID=7351

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send --replace-id="$NOTIFICATION_ID" "$@"
    fi
}

if ! command -v wl-screenrec >/dev/null 2>&1; then
    notify -u critical "Screen recording" "wl-screenrec is not installed"
    exit 1
fi

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")

    if kill -0 "$PID" 2>/dev/null && [ "$(ps -p "$PID" -o comm=)" = "wl-screenrec" ]; then
        kill -INT "$PID"

        for _ in {1..100}; do
            if ! kill -0 "$PID" 2>/dev/null; then
                break
            fi
            sleep 0.1
        done

        OUTPUT_FILE=$(cat "$OUTPUT_FILE_STATE" 2>/dev/null || printf '%s' "$HOME/Videos")
        rm -f "$PID_FILE" "$OUTPUT_FILE_STATE"
        notify -u normal -t 5000 "Screen recording" "Saved to $OUTPUT_FILE"
        exit 0
    fi

    rm -f "$PID_FILE" "$OUTPUT_FILE_STATE"
fi

mkdir -p "$HOME/Videos"
OUTPUT_FILE="$HOME/Videos/screen-rec-$(date +%Y-%m-%d-%H%M%S).mp4"

notify -u low -t 1000 "Screen recording" "Recording starts in 1 second"
sleep 1.1

wl-screenrec \
    --max-fps 60 \
    --bitrate 2000000b \
    --codec hevc \
    -f "$OUTPUT_FILE" >/dev/null 2>&1 &
PID=$!

sleep 0.2
if ! kill -0 "$PID" 2>/dev/null; then
    notify -u critical "Screen recording" "wl-screenrec failed to start"
    exit 1
fi

printf '%s\n' "$PID" > "$PID_FILE"
printf '%s\n' "$OUTPUT_FILE" > "$OUTPUT_FILE_STATE"