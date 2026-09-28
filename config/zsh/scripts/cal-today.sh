#!/usr/bin/env bash

set -e

if ! command -v icalBuddy &> /dev/null; then
  echo "Error: icalBuddy not installed. Run: brew install ical-buddy"
  exit 1
fi

CALENDAR="$1"

if [ -n "$CALENDAR" ]; then
  icalBuddy -n -nc -iep "title,datetime" -b "" -includeCals "$CALENDAR" eventsToday
else
  icalBuddy -n -nc -iep "title,datetime" -b "" eventsToday
fi
