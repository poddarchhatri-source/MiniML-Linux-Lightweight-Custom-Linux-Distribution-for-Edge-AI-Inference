#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KERNEL_VERSION="${KERNEL_VERSION:-$(cat "$ROOT/kernel/kernel_version.txt" | sed -n '2p' | sed 's/^Exact version: record .*//;s/v//')}"
SOURCE_DIR="$ROOT/kernel/linux-${KERNEL_VERSION}"
REPORT="$ROOT/reports/kernel_report.txt"

mkdir -p "$ROOT/reports"
{
    echo "MiniML custom kernel report"
    uname -a
    if [[ -f "$SOURCE_DIR/arch/x86/boot/bzImage" ]]; then
        stat "$SOURCE_DIR/arch/x86/boot/bzImage"
    fi
    if [[ -d "$SOURCE_DIR/modules" ]]; then
        du -sh "$SOURCE_DIR/modules"
    fi
    if [[ -f "$SOURCE_DIR/.config" ]]; then
        sha256sum "$SOURCE_DIR/.config"
        grep '^CONFIG_\(64BIT\|SMP\|VIRTIO\|SQUASHFS\|OVERLAY_FS\|INET\|RANDOMIZE_BASE\|MODULE_SIG_FORCE\)' "$SOURCE_DIR/.config"
    fi
} > "$REPORT"

echo "Kernel report saved to $REPORT"

