#!/bin/bash

# High-quality recording toggle script with hardware acceleration
# This script provides OBS-like quality using Intel QuickSync

RECORDINGS_DIR="$HOME/Videos/Recordings"
PID_FILE="/tmp/wf-recorder-hq.pid"
STATUS_FILE="/tmp/wf-recorder-hq.status"

# Create recordings directory if it doesn't exist
mkdir -p "$RECORDINGS_DIR"

# Function to start recording with hardware acceleration
start_recording() {
    FILENAME="$RECORDINGS_DIR/hq-recording-$(date +%Y-%m-%d-%H%M%S).mp4"
    
    # Try Intel QuickSync first, fallback to high-quality software encoding
    if ffmpeg -f lavfi -i testsrc -t 1 -c:v h264_qsv -f null - >/dev/null 2>&1; then
        # Hardware accelerated recording (Intel QuickSync)
        wf-recorder \
            --audio \
            --codec h264_qsv \
            --codec-param preset=slow \
            --codec-param global_quality=18 \
            --codec-param profile=high \
            --codec-param level=4.1 \
            --file="$FILENAME" &
        WF_PID=$!
        echo "Using Intel QuickSync hardware acceleration"
    else
        # High-quality software encoding
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
        echo "Using high-quality software encoding"
    fi
    
    # Save the PID and filename
    echo "$WF_PID" > "$PID_FILE"
    echo "$FILENAME" > "$STATUS_FILE"
    
    # Send notification
    notify-send "🔴 HQ Recording Started" "High-quality recording to: $(basename "$FILENAME")" -t 3000
    
    echo "High-quality recording started with PID: $WF_PID"
    echo "Saving to: $FILENAME"
}

# Function to stop recording
stop_recording() {
    if [ -f "$PID_FILE" ]; then
        WF_PID=$(cat "$PID_FILE")
        FILENAME=$(cat "$STATUS_FILE" 2>/dev/null || echo "hq-recording")
        
        # Send SIGINT (Ctrl+C equivalent) to wf-recorder to properly save the recording
        if kill -INT "$WF_PID" 2>/dev/null; then
            echo "Sent SIGINT to wf-recorder (PID: $WF_PID), waiting for it to finish..."
            
            # Wait for the process to finish (up to 15 seconds for hardware encoding)
            for i in {1..15}; do
                if ! kill -0 "$WF_PID" 2>/dev/null; then
                    echo "High-quality recording process finished"
                    break
                fi
                sleep 1
            done
            
            # Clean up
            rm -f "$PID_FILE" "$STATUS_FILE"
            
            # Send notification with filename
            notify-send "⏹️ HQ Recording Stopped" "Saved: $(basename "$FILENAME")" -t 3000
            
            echo "High-quality recording stopped and saved: $FILENAME"
        else
            echo "Failed to stop recording or process already stopped"
            # Clean up stale files
            rm -f "$PID_FILE" "$STATUS_FILE"
        fi
    else
        echo "No active recording found"
        # Send notification
        notify-send "⚠️ No Active HQ Recording" "No high-quality recording is currently running" -t 2000
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
    echo "High-quality recording is active, stopping..."
    stop_recording
else
    echo "No active high-quality recording, starting..."
    start_recording
fi
