#!/usr/bin/env bash
set -euxo pipefail

RUNTIME_INSTALL_URL="${RUNTIME_INSTALL_URL:-https://openclaw.ai/install.sh}"
RUNTIME_INSTALL_ARGS="${RUNTIME_INSTALL_ARGS:---no-onboard}"

curl -fsSL --proto '=https' --tlsv1.2 "${RUNTIME_INSTALL_URL}" | bash -s -- ${RUNTIME_INSTALL_ARGS}

if command -v openclaw >/dev/null 2>&1; then
  openclaw --version
else
  echo "Runtime binary was not found in PATH after installation."
  exit 1
fi
