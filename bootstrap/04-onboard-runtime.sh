#!/usr/bin/env bash
set -euxo pipefail

RUNTIME_ONBOARD_COMMAND="${RUNTIME_ONBOARD_COMMAND:-openclaw onboard --install-daemon}"

eval "${RUNTIME_ONBOARD_COMMAND}"
