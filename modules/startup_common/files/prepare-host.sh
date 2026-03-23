#!/usr/bin/env bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl ca-certificates jq git

mkdir -p /var/log/agent-runtime-foundation
mkdir -p /opt/agent-runtime-foundation
touch /var/log/agent-runtime-foundation/bootstrap.log
