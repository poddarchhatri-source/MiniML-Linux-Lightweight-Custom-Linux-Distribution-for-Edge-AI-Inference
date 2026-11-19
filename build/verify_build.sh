#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO="$ROOT/output/MiniML-Linux.iso"

if [[ ! -f "$ISO" ]]; then
    echo "Missing $ISO" >&2
    exit 1
fi

file "$ISO"
stat --printf='Size: %s bytes\n' "$ISO"
sha256sum -c "$ROOT/output/MiniML-Linux.iso.sha256"

if command -v xorriso >/dev/null 2>&1; then
    xorriso -indev "$ISO" -toc 2>/dev/null | head -n 20
fi

