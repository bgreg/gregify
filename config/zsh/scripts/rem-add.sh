#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Usage: rem-add.sh 'Task description' [LIST_NAME] [DUE_DATE]"
  echo "Example: rem-add.sh 'Buy milk'"
  echo "Example: rem-add.sh 'Call doctor' Family"
  echo "Example: rem-add.sh 'Post to Craigslist' Reminders 2025-10-27"
  echo "Example: rem-add.sh 'Team meeting' Family '2025-10-27 14:00'"
  exit 1
fi

TASK="$1"
LIST="${2:-Reminders}"
DUE_DATE="$3"

if [ -n "$DUE_DATE" ]; then
  osascript <<EOF
tell application "Reminders"
    tell list "$LIST"
        set newReminder to make new reminder with properties {name:"$TASK"}
        set due date of newReminder to date "$DUE_DATE"
    end tell
end tell
EOF
  echo "Added '$TASK' to $LIST with due date $DUE_DATE"
else
  if ! command -v reminders &> /dev/null; then
    echo "Error: reminders-cli not installed. Install with: brew install reminders-cli"
    exit 1
  fi
  reminders add "$LIST" "$TASK"
  echo "Added '$TASK' to $LIST"
fi
