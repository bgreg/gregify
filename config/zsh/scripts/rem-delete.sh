#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Usage: rem-delete.sh 'Task description' [LIST_NAME]"
  echo "Example: rem-delete.sh 'Buy milk'"
  echo "Example: rem-delete.sh 'Call doctor' Family"
  exit 1
fi

if ! command -v reminders &> /dev/null; then
  echo "Error: reminders-cli not installed. Install with: brew install reminders-cli"
  exit 1
fi

TASK="$1"
LIST="$2"

if [ -n "$LIST" ]; then
  reminders delete "$LIST" "$TASK"
else
  reminders delete "$TASK"
fi
echo "Deleted '$TASK'"
