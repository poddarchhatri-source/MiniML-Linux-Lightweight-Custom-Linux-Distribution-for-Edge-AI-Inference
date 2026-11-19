#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ -d build/live ]]; then
    cd build/live
    lb clean 2>/dev/null || true
    cd "$ROOT"
fi

rm -rf build/live/cache build/live/chroot build/live/binary build/live/binary.modified build/live/chroot.tmp

