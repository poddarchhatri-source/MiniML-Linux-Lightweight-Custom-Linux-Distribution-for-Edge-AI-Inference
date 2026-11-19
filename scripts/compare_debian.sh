#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASELINE="${1:-}"

[[ -n "$BASELINE" ]] || {
    echo "Usage: $0 /path/to/Debian-stock.iso" >&2
    exit 1
}

"$ROOT/scripts/collect_system_info.sh" "$ROOT/reports/miniml-system-information.txt"
"$ROOT/scripts/measure_image_size.sh" "$BASELINE"

