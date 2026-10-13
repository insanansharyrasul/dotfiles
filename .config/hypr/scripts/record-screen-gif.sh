#!/usr/bin/env bash

set -u

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}"
PID_FILE="$STATE_DIR/wl-screenrec-gif.pid"
OUTPUT_FILE_STATE="$STATE_DIR/wl-screenrec-gif.output"
TMP_FILE_STATE="$STATE_DIR/wl-screenrec-gif.tmp"
NOTIFICATION_ID=7352

notify() {
    if command -v notify-send >/dev/null 2>&1; then
        notify-send --replace-id="$NOTIFICATION_ID" "$@"
    fi
}

finish() {
    OUTPUT_FILE=$(cat "$OUTPUT_FILE_STATE" 2>/dev/null || printf '%s' "$HOME/Videos")
    rm -f "$PID_FILE" "$OUTPUT_FILE_STATE" "$TMP_FILE_STATE"
    if command -v nemo >/dev/null 2>&1; then
        [ "$(notify -u normal -t 5000 -A "default=Show in Folder" "GIF recording" "Saved to $OUTPUT_FILE")" = "default" ] && nemo --no-desktop "$OUTPUT_FILE"
    else
        notify -u normal -t 5000 "GIF recording" "Saved to $OUTPUT_FILE"
    fi
    exit 0
}

if ! command -v wl-screenrec >/dev/null 2>&1; then
    notify -u critical "GIF recording" "wl-screenrec is not installed"
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

        OUTPUT_FILE=$(cat "$OUTPUT_FILE_STATE" 2>/dev/null)
        TMP_FILE=$(cat "$TMP_FILE_STATE" 2>/dev/null)

        if [ -z "${OUTPUT_FILE:-}" ] || [ -z "${TMP_FILE:-}" ] || [ ! -f "$TMP_FILE" ]; then
            notify -u critical "GIF recording" "Recording file missing, GIF not saved"
            rm -f "$PID_FILE" "$OUTPUT_FILE_STATE" "$TMP_FILE_STATE"
            exit 1
        fi

        if ! command -v ffmpeg >/dev/null 2>&1; then
            notify -u critical "GIF recording" "ffmpeg is not installed, raw video kept at $TMP_FILE"
            rm -f "$PID_FILE" "$OUTPUT_FILE_STATE" "$TMP_FILE_STATE"
            exit 1
        fi

        notify -u low -t 2000 "GIF recording" "Converting to GIF…"
        # ponytail: single ffmpeg pass, 15fps palette. Lower fps/scale here if GIFs get huge.
        if ffmpeg -y -loglevel error -i "$TMP_FILE" -vf "fps=15,scale=iw:-1:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=256[p];[s1][p]paletteuse" "$OUTPUT_FILE"; then
            rm -f "$TMP_FILE"
            finish
        else
            notify -u critical "GIF recording" "ffmpeg conversion failed, raw video kept at $TMP_FILE"
            rm -f "$PID_FILE" "$OUTPUT_FILE_STATE" "$TMP_FILE_STATE"
            exit 1
        fi
    fi

    rm -f "$PID_FILE" "$OUTPUT_FILE_STATE" "$TMP_FILE_STATE"
fi

if ! command -v slurp >/dev/null 2>&1; then
    notify -u critical "GIF recording" "slurp is not installed"
    exit 1
fi

GEO=$(slurp 2>/dev/null) || exit 0
[ -n "$GEO" ] || exit 0

mkdir -p "$HOME/Videos"
OUTPUT_FILE="$HOME/Videos/screen-gif-$(date +%Y-%m-%d-%H%M%S).gif"
TMP_FILE="$STATE_DIR/gif-rec-$(date +%Y-%m-%d-%H%M%S).mp4"

notify -u low -t 1000 "GIF recording" "Recording starts in 1 second — press SUPER+SHIFT+G to stop"
sleep 1.1

wl-screenrec \
    --max-fps 15 \
    -g "$GEO" \
    -f "$TMP_FILE" >/dev/null 2>&1 &
PID=$!

sleep 0.2
if ! kill -0 "$PID" 2>/dev/null; then
    notify -u critical "GIF recording" "wl-screenrec failed to start"
    exit 1
fi

printf '%s\n' "$PID" > "$PID_FILE"
printf '%s\n' "$OUTPUT_FILE" > "$OUTPUT_FILE_STATE"
printf '%s\n' "$TMP_FILE" > "$TMP_FILE_STATE"
