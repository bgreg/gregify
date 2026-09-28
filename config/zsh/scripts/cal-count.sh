#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Usage: cal-count.sh CALENDAR_NAME [EVENT_TITLE_PATTERN]"
  exit 1
fi

CALENDAR="$1"
PATTERN="${2}"

if [ -z "$PATTERN" ]; then
  osascript <<EOF
tell application "Calendar"
    tell calendar "$CALENDAR"
        return count of every event
    end tell
end tell
EOF
else
  osascript <<EOF
tell application "Calendar"
    tell calendar "$CALENDAR"
        return count of (every event whose summary contains "$PATTERN")
    end tell
end tell
EOF
fi
