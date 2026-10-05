#!/usr/bin/env bash
if pactl list source-outputs 2>/dev/null | grep -q 'Source Output #'; then
  echo "true"
else
  echo "false"
fi
