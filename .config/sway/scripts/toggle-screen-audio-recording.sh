#!/bin/bash

# Screen + System Audio recording toggle script for wf-recorder
# This script records screen with computer audio (no microphone)

RECORDINGS_DIR="$HOME/Videos/Recordings"
PID_FILE="/tmp/wf-recorder-screen-audio.pid"
STATUS_FILE="/tmp/wf-recorder-screen-audio.status"

# Create recordings directory if it doesn't exist
mkdir -p "$RECORDINGS_DIR"

# Function to start recording
start_recording() {
    FILENAME="$RECORDINGS_DIR/screen-audio-recording-$(date +%Y-%m-%d-%H%M%S).mp4"
    
    # Get the default audio sink (system audio output)
    AUDIO_SINK=$(pactl get-default-sink)
    
    # Start wf-recorder with screen and system audio (no microphone)
    # Use --audio to specify the monitor source of the default sink
    wf-recorder --audio="${AUDIO_SINK}.monitor" --file="$FILENAME" &
    WF_PID=$!
    
    # Save the PID and filename
    echo "$WF_PID" > "$PID_FILE"
    echo "$FILENAME" > "$STATUS_FILE"
    
    # Send notification
    notify-send "🔴 Screen + Audio Recording Started" "Recording screen with system audio to: $(basename "$FILENAME")" -t 3000
    
    echo "Screen + Audio recording started with PID: $WF_PID"
    echo "Saving to: $FILENAME"
    echo "Capturing system audio from: ${AUDIO_SINK}.monitor"
}

# Function to stop recording
stop_recording() {
    if [ -f "$PID_FILE" ]; then
        WF_PID=$(cat "$PID_FILE")
        FILENAME=$(cat "$STATUS_FILE" 2>/dev/null || echo "screen-audio-recording")
        
        # Send SIGINT (Ctrl+C equivalent) to wf-recorder to properly save the recording
        if kill -INT "$WF_PID" 2>/dev/null; then
            echo "Sent SIGINT to wf-recorder (PID: $WF_PID), waiting for it to finish..."
            
            # Wait for the process to finish (up to 10 seconds)
            for i in {1..10}; do
                if ! kill -0 "$WF_PID" 2>/dev/null; then
                    echo "Screen + Audio recording process finished"
                    break
                fi
                sleep 1
            done
            
            # Clean up
            rm -f "$PID_FILE" "$STATUS_FILE"
            
            # Send notification with filename
            notify-send "⏹️ Screen + Audio Recording Stopped" "Saved: $(basename "$FILENAME")" -t 3000
            
            echo "Screen + Audio recording stopped and saved: $FILENAME"
        else
            echo "Failed to stop recording or process already stopped"
            # Clean up stale files
            rm -f "$PID_FILE" "$STATUS_FILE"
        fi
    else
        echo "No active screen + audio recording found"
        # Send notification
        notify-send "⚠️ No Active Screen + Audio Recording" "No screen + audio recording is currently running" -t 2000
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
    echo "Screen + Audio recording is active, stopping..."
    stop_recording
else
    echo "No active screen + audio recording, starting..."
    start_recording
fi
