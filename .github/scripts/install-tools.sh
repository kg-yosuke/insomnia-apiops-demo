#!/usr/bin/env bash
# Install Inso CLI and decK into ~/bin (used by GitHub Actions jobs).
set -euo pipefail
mkdir -p "$HOME/bin"
if [[ "${1:-}" != "deck-only" ]]; then
  curl -fsSL "https://github.com/Kong/insomnia/releases/download/core%40${INSO_VERSION}/inso-linux-x64-${INSO_VERSION}.tar.xz" \
    | tar -xJ -C "$HOME/bin"
fi
curl -fsSL "https://github.com/Kong/deck/releases/download/v${DECK_VERSION}/deck_${DECK_VERSION}_linux_amd64.tar.gz" \
  | tar -xz -C "$HOME/bin" deck
echo "$HOME/bin" >> "$GITHUB_PATH"
