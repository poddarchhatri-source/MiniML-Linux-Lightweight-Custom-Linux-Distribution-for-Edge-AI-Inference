#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

for iso in output/MiniML-Linux.iso build/live/*.iso; do
    [[ -f "$iso" ]] || continue
    sha256sum "$iso"
done

echo "Compare hashes from clean builds. ISO byte reproducibility may vary with timestamps and live-build metadata."

