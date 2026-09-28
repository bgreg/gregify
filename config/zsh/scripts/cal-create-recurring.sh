#!/usr/bin/env bash

set -e

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
  echo "Usage: cal-create-recurring.sh CALENDAR_NAME 'EVENT_TITLE' START_TIME END_TIME [RECURRENCE_RULE]"
  echo "Example: cal-create-recurring.sh Family 'Work Hours' '08:00' '17:00' 'FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR'"
  echo "Example: cal-create-recurring.sh Personal 'Lunch Break' '12:00' '13:00' 'FREQ=DAILY;BYDAY=MO,TU,WE,TH,FR'"
  exit 1
fi

CALENDAR="$1"
TITLE="$2"
START_TIME="$3"
END_TIME="$4"
RECURRENCE="${5:-FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR}"

TODAY=$(date '+%A, %B %d, %Y')
START_DATETIME="$TODAY at $START_TIME"
END_DATETIME="$TODAY at $END_TIME"

osascript <<EOF
tell application "Calendar"
    tell calendar "$CALENDAR"
        set startDate to date "$START_DATETIME"
        set endDate to date "$END_DATETIME"
        set newEvent to make new event with properties {summary:"$TITLE", start date:startDate, end date:endDate}
        tell newEvent
            set recurrence to "$RECURRENCE"
        end tell
        return "Created recurring event '$TITLE' in $CALENDAR"
    end tell
end tell
EOF
