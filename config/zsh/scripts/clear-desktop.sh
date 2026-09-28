#!/usr/bin/env zsh

set -e

if find "$HOME/Desktop" -maxdepth 1 -type f | grep -v '/\.' &>/dev/null
then
  DATE=$(date | tr " " "_")
  FILENAME="desktop_backup_$DATE"
  TMP="$HOME/Desktop/tmp_$DATE"
  NEW_PATH="$HOME/Documents/$FILENAME"

  mkdir "$TMP"
  find "$HOME/Desktop" -not -path "$HOME/Desktop/.*" -maxdepth 1 -type f -exec mv {} "$TMP" \;

  mv "$TMP" "$NEW_PATH"
  echo "Desktop files were moved to: $NEW_PATH"
else
  echo "No files found on Desktop to clear"
fi
