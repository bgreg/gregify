#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="gregify-e2e"
MOUNT="/home/greg/Personal/gregify"

if [[ "${E2E_SKIP_BUILD:-0}" != "1" ]]; then
    docker build --platform linux/arm64 -t "$IMAGE" -f "$REPO_ROOT/e2e/Dockerfile" "$REPO_ROOT"
fi

read -r -d '' PHASES <<'EOF' || true
set -u
phase() {
    local name="$1"; shift
    local start=$SECONDS
    echo "=== PHASE $name ==="
    if "$@"; then
        echo "=== PHASE $name PASSED in $((SECONDS - start))s ==="
    else
        echo "=== PHASE $name FAILED in $((SECONDS - start))s ==="
        exit 1
    fi
}
phase install bash ~/Personal/gregify/dotfiles.sh
phase validate zsh -li -c '~/Personal/gregify/test-dotfiles.sh'
phase inspect zsh -li -c '~/Personal/gregify/e2e/inspect.sh'
EOF

start=$SECONDS
docker run --rm --platform linux/arm64 \
    -v "$REPO_ROOT:$MOUNT" \
    "$IMAGE" bash -c "$PHASES"
echo "=== E2E PASSED in $((SECONDS - start))s ==="
