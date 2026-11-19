#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO="$ROOT/output/MiniML-Linux.iso"
BASELINE="${1:-}"

[[ -f "$ISO" ]] || { echo "Missing $ISO" >&2; exit 1; }

miniml_size="$(stat -c '%s' "$ISO")"
echo "MiniML-Linux.iso=$miniml_size bytes"

if [[ -n "$BASELINE" && -f "$BASELINE" ]]; then
    baseline_size="$(stat -c '%s' "$BASELINE")"
    reduction="$(awk -v mini="$miniml_size" -v base="$baseline_size" 'BEGIN { printf "%.2f", (base-mini)*100/base }')"
    echo "Stock baseline=$baseline_size bytes"
    echo "Reduction=$reduction%"
fi
