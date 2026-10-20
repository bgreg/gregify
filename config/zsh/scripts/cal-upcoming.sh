#!/usr/bin/env bash

set -e

if ! command -v icalBuddy &> /dev/null; then
  echo "Error: icalBuddy not installed. Run: brew install ical-buddy"
  exit 1
fi

DAYS="$1"
CALENDAR="$2"

if [[ "$DAYS" =~ ^[0-9]+$ ]]; then
  if [ -n "$CALENDAR" ]; then
    icalBuddy -n -nc -iep "title,datetime" -b "" -includeCals "$CALENDAR" eventsFrom:today to:today+${DAYS}
  else
    icalBuddy -n -nc -iep "title,datetime" -b "" eventsFrom:today to:today+${DAYS}
  fi
elif [ -n "$DAYS" ]; then
  CALENDAR="$DAYS"
  icalBuddy -n -nc -iep "title,datetime" -b "" -includeCals "$CALENDAR" eventsFrom:today to:today+7
else
  icalBuddy -n -nc -iep "title,datetime" -b "" eventsFrom:today to:today+7
fi
