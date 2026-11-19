#!/usr/bin/env bash
set -euo pipefail

echo "Boot test must run inside the MiniML Linux guest."
echo "Guest checks:"
uname -m
cat /etc/os-release
systemctl is-system-running --wait
systemctl is-active miniml-inference.service

