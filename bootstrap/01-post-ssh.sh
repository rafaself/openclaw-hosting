#!/usr/bin/env bash
set -euxo pipefail

echo "Host identity:"
hostnamectl || true

echo
echo "Memory summary:"
free -h

echo
echo "Disk summary:"
df -h /

echo
echo "Swap summary:"
swapon --show || true

echo
echo "Runtime binary check:"
command -v openclaw || true

echo
echo "Tailscale binary check:"
command -v tailscale || true
