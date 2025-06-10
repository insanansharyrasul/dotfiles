#!/bin/bash

# Screen recording toggle script for wf-recorder
# This script starts/stops screen recording with the same keybind

RECORDINGS_DIR="$HOME/Videos/Recordings"
PID_FILE="/tmp/wf-recorder.pid"
STATUS_FILE="/tmp/wf-recorder.status"

# Create recordings directory if it doesn't exist
mkdir -p "$RECORDINGS_DIR"

# Function to start recording
start_recording() {
    FILENAME="$RECORDINGS_DIR/screen-recording-$(date +%Y-%m-%d-%H%M%S).mp4"
    
    # Start wf-recorder with OBS-like quality settings
    wf-recorder \
        --audio \
        --codec libx264 \
        --codec-param preset=slow \
        --codec-param crf=18 \
        --codec-param profile=high \
        --codec-param level=4.1 \
        --codec-param keyint=120 \
        --codec-param bframes=4 \
        --file="$FILENAME" &
    WF_PID=$!
    
    # Save the PID and filename
    echo "$WF_PID" > "$PID_FILE"
    echo "$FILENAME" > "$STATUS_FILE"
    
    # Send notification
    notify-send "🔴 Recording Started" "Recording to: $(basename "$FILENAME")" -t 3000
    
    echo "Recording started with PID: $WF_PID"
    echo "Saving to: $FILENAME"
}

# Function to stop recording
stop_recording() {
    if [ -f "$PID_FILE" ]; then
        WF_PID=$(cat "$PID_FILE")
        FILENAME=$(cat "$STATUS_FILE" 2>/dev/null || echo "recording")
        
        # Send SIGINT (Ctrl+C equivalent) to wf-recorder to properly save the recording
        if kill -INT "$WF_PID" 2>/dev/null; then
            echo "Sent SIGINT to wf-recorder (PID: $WF_PID), waiting for it to finish..."
            
            # Wait for the process to finish (up to 10 seconds)
            for i in {1..10}; do
                if ! kill -0 "$WF_PID" 2>/dev/null; then
                    echo "Recording process finished"
                    break
                fi
                sleep 1
            done
            
            # Clean up
            rm -f "$PID_FILE" "$STATUS_FILE"
            
            # Send notification with filename
            notify-send "⏹️ Recording Stopped" "Saved: $(basename "$FILENAME")" -t 3000
            
            echo "Recording stopped and saved: $FILENAME"
        else
            echo "Failed to stop recording or process already stopped"
            # Clean up stale files
            rm -f "$PID_FILE" "$STATUS_FILE"
        fi
    else
        echo "No active recording found"
        # Send notification
        notify-send "⚠️ No Active Recording" "No recording is currently running" -t 2000
    fi
}

# Check if recording is active
is_recording_active() {
    if [ -f "$PID_FILE" ]; then
        WF_PID=$(cat "$PID_FILE")
        # Check if the process is still running
        if kill -0 "$WF_PID" 2>/dev/null; then
            return 0  # Recording is active
        else
            # Process died, clean up stale files
            rm -f "$PID_FILE" "$STATUS_FILE"
            return 1  # Recording is not active
        fi
    else
        return 1  # Recording is not active
    fi
}

# Main logic
if is_recording_active; then
    echo "Recording is active, stopping..."
    stop_recording
else
    echo "No active recording, starting..."
    start_recording
fi
