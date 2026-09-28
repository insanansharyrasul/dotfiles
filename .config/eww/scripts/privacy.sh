#!/usr/bin/env bash
# "true" when an application is actively recording from a microphone source.
if pactl list source-outputs 2>/dev/null | grep -q 'Source Output #'; then
  echo "true"
else
  echo "false"
fi
