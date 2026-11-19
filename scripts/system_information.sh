#!/usr/bin/env bash
set -euo pipefail

output="${1:-system-information.txt}"

{
    date -u +"UTC: %Y-%m-%dT%H:%M:%SZ"
    uname -a
    if [[ -r /etc/os-release ]]; then cat /etc/os-release; fi
    printf 'Architecture: '
    uname -m
    if command -v lscpu >/dev/null 2>&1; then lscpu; fi
    if command -v free >/dev/null 2>&1; then free -h; fi
    df -h /
    git --version 2>/dev/null || true
    python3 --version 2>/dev/null || true
    lb --version 2>/dev/null || true
    qemu-system-x86_64 --version 2>/dev/null | head -n 1 || true
} > "$output"

echo "System information saved to $output"

