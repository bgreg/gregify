#!/usr/bin/env bash

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: cal-delete-pattern.sh CALENDAR_NAME PATTERN"
  echo "Example: cal-delete-pattern.sh Personal lunch"
  exit 1
fi

CALENDAR="$1"
PATTERN="$2"

osascript <<EOF
tell application "Calendar"
    tell calendar "$CALENDAR"
        set eventsToDelete to (every event whose summary contains "$PATTERN")
        set deleteCount to count of eventsToDelete
        repeat with evt in eventsToDelete
            delete evt
        end repeat
        return "Deleted " & deleteCount & " event(s) containing '$PATTERN' from $CALENDAR"
    end tell
end tell
EOF
