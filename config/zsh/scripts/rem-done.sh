#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Usage: rem-done.sh 'Task description' [LIST_NAME]"
  echo "Example: rem-done.sh 'Buy milk'"
  echo "Example: rem-done.sh 'Call doctor' Family"
  exit 1
fi

if ! command -v reminders &> /dev/null; then
  echo "Error: reminders-cli not installed. Install with: brew install reminders-cli"
  exit 1
fi

TASK="$1"
LIST="$2"

if [ -n "$LIST" ]; then
  reminders complete "$LIST" "$TASK"
else
  reminders complete "$TASK"
fi
echo "Completed '$TASK'"
