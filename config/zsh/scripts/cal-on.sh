#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Usage: cal-on.sh DATE [CALENDAR_NAME]"
  echo "Example: cal-on.sh 2025-10-24"
  echo "Example: cal-on.sh 2025-10-24 Personal"
  exit 1
fi

if ! command -v icalBuddy &> /dev/null; then
  echo "Error: icalBuddy not installed. Run: brew install ical-buddy"
  exit 1
fi

DATE="$1"
CALENDAR="$2"

if [ -n "$CALENDAR" ]; then
  icalBuddy -n -nc -iep "title,datetime" -b "" -includeCals "$CALENDAR" eventsFrom:"$DATE" to:"$DATE"
else
  icalBuddy -n -nc -iep "title,datetime" -b "" eventsFrom:"$DATE" to:"$DATE"
fi
