#!/usr/bin/env bash
set -euxo pipefail

if command -v tailscale >/dev/null 2>&1; then
  echo "Tailscale already installed."
  exit 0
fi

curl -fsSL https://tailscale.com/install.sh | sh
