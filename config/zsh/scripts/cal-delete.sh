#!/usr/bin/env bash

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: cal-delete.sh CALENDAR_NAME EVENT_TITLE"
  echo "Example: cal-delete.sh Personal 'Work Hours'"
  exit 1
fi

CALENDAR="$1"
EVENT_TITLE="$2"

osascript <<EOF
tell application "Calendar"
    tell calendar "$CALENDAR"
        set eventsToDelete to (every event whose summary is "$EVENT_TITLE")
        set deleteCount to count of eventsToDelete
        repeat with evt in eventsToDelete
            delete evt
        end repeat
        return "Deleted " & deleteCount & " event(s) titled '$EVENT_TITLE' from $CALENDAR"
    end tell
end tell
EOF
