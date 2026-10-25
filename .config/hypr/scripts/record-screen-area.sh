#!/usr/bin/env bash

set -u

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}"
PID_FILE="$STATE_DIR/wl-screenrec.pid"
OUTPUT_FILE_STATE="$STATE_DIR/wl-screenrec.output"
LOG_FILE="$STATE_DIR/wl-screenrec.log"
NOTIFICATION_ID=7351

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send --replace-id="$NOTIFICATION_ID" "$@"
    fi
}

# Check for required dependencies
if ! command -v wl-screenrec >/dev/null 2>&1; then
    notify -u critical "Screen recording" "wl-screenrec is not installed"
    exit 1
fi

if ! command -v slurp >/dev/null 2>&1; then
    notify -u critical "Screen recording" "slurp is not installed"
    exit 1
fi

# Stop active recording session if running
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
        rm -f "$PID_FILE" "$OUTPUT_FILE_STATE" "$LOG_FILE"
        if command -v nemo >/dev/null 2>&1; then
            [ "$(notify -u normal -t 5000 -A "default=Show in Folder" "Screen recording" "Saved to $OUTPUT_FILE")" = "default" ] && nemo --no-desktop "$OUTPUT_FILE"
        else
            notify -u normal -t 5000 "Screen recording" "Saved to $OUTPUT_FILE"
        fi
        exit 0
    fi

    rm -f "$PID_FILE" "$OUTPUT_FILE_STATE" "$LOG_FILE"
fi

# Select area with slurp and guarantee even dimensions
RAW_GEOMETRY=$(slurp 2>/dev/null)

if [ -z "$RAW_GEOMETRY" ]; then
    notify -u low -t 2000 "Screen recording" "Selection canceled"
    exit 0
fi

# Ensure width and height are even numbers
GEOMETRY=$(echo "$RAW_GEOMETRY" | awk -F'[, x]' '{
    w = ($3 % 2 == 0) ? $3 : $3 - 1;
    h = ($4 % 2 == 0) ? $4 : $4 - 1;
    print $1","$2" "w"x"h
}')

mkdir -p "$HOME/Videos"
OUTPUT_FILE="$HOME/Videos/area-rec-$(date +%Y-%m-%d-%H%M%S).mp4"

notify -u low -t 1000 "Screen recording" "Recording region in 1 second"
sleep 1.1

# Launch wl-screenrec with avc codec (H.264) for maximum compatibility
wl-screenrec \
    -g "$GEOMETRY" \
    --max-fps 60 \
    --bitrate 2000000b \
    --codec avc \
    -f "$OUTPUT_FILE" >/dev/null 2>"$LOG_FILE" &
PID=$!

sleep 0.2
if ! kill -0 "$PID" 2>/dev/null; then
    # Strip ANSI color codes from log output
    ERR_MSG=$(sed 's/\x1b\[[0-9;]*m//g' "$LOG_FILE" 2>/dev/null | tail -n 1)
    [ -z "$ERR_MSG" ] && ERR_MSG="Unknown startup error"

    notify -u critical "Screen recording failed" "$ERR_MSG"
    rm -f "$LOG_FILE"
    exit 1
fi

printf '%s\n' "$PID" > "$PID_FILE"
printf '%s\n' "$OUTPUT_FILE" > "$OUTPUT_FILE_STATE"
