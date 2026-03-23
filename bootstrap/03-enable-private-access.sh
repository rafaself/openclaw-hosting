#!/usr/bin/env bash
set -euxo pipefail

if ! command -v tailscale >/dev/null 2>&1; then
  echo "Tailscale is not installed."
  exit 1
fi

sudo tailscale up
sudo tailscale set --ssh

cat <<'EOF'
Private access baseline enabled.

Next steps:
- verify the node joined your tailnet,
- optionally configure Tailscale Serve for your runtime UI later,
- keep runtime ports private by default.
EOF
