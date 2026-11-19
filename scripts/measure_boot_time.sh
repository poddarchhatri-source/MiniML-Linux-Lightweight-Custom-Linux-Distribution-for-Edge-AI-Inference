#!/usr/bin/env bash
set -euo pipefail

if command -v systemd-analyze >/dev/null 2>&1; then
    systemd-analyze
    systemd-analyze blame
else
    echo "systemd-analyze is unavailable outside a systemd guest." >&2
    exit 1
fi

