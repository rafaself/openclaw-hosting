#!/usr/bin/env bash
set -euxo pipefail

SWAP_SIZE_GB="${1:-2}"

if swapon --show | grep -q '^/swapfile'; then
  echo "Swap already enabled."
  exit 0
fi

if [ -f /swapfile ]; then
  echo "Swap file exists but is not active. Enabling it."
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  grep -q '^/swapfile ' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
  exit 0
fi

fallocate -l "${SWAP_SIZE_GB}G" /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
grep -q '^/swapfile ' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
