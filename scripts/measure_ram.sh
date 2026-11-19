#!/usr/bin/env bash
set -euo pipefail

if command -v free >/dev/null 2>&1; then
    free -h
    cat /proc/meminfo
elif command -v vm_stat >/dev/null 2>&1; then
    vm_stat
else
    echo "No supported memory reporting command is available." >&2
    exit 1
fi

