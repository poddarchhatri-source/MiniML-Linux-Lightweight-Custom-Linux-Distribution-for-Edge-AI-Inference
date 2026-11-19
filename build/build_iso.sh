#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ "$(uname -m)" != "x86_64" && "$(uname -m)" != "amd64" ]]; then
    echo "Build requires a native x86_64 Linux host." >&2
    exit 1
fi

if [[ "${EUID}" -ne 0 ]]; then
    echo "Run with sudo: sudo ./build/build_iso.sh" >&2
    exit 1
fi

"$ROOT/build/configure_build.sh"

mkdir -p output
cd build/live
lb clean
lb config
lb build

ISO="$(find . -maxdepth 1 -type f -name '*.iso' -print -quit)"
if [[ -z "$ISO" ]]; then
    echo "Live-build completed without producing an ISO." >&2
    exit 1
fi

cp "$ISO" "$ROOT/output/MiniML-Linux.iso"
sha256sum "$ROOT/output/MiniML-Linux.iso" > "$ROOT/output/MiniML-Linux.iso.sha256"
stat --printf='ISO size: %s bytes\n' "$ROOT/output/MiniML-Linux.iso"

