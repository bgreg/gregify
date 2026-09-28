#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
  echo "Usage: chrome-session.sh SESSION_ID [URL]"
  echo "Example: chrome-session.sh 1"
  echo "Example: chrome-session.sh 2 https://example.com"
  exit 1
fi

SESSION_ID="$1"
URL="${2:-}"

mkdir -p "/tmp/chrome${SESSION_ID}"

/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
  --user-data-dir="/tmp/chrome${SESSION_ID}" \
  --no-first-run \
  --no-default-browser-check \
  --disable-sync \
  --disable-background-networking \
  --disable-default-apps \
  --disable-extensions \
  --disable-features=Translate \
  ${URL:+"$URL"}
