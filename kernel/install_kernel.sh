#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
KERNEL_VERSION="${KERNEL_VERSION:-$(tail -n 1 "$ROOT/kernel/kernel_version.txt" | sed 's/^v//')}"
SOURCE_DIR="$ROOT/kernel/linux-$KERNEL_VERSION"

if [[ "${EUID}" -ne 0 ]]; then
    echo "Run with sudo: sudo ./kernel/install_kernel.sh" >&2
    exit 1
fi

cd "$SOURCE_DIR"
make modules_install
install -D -m 0644 arch/x86/boot/bzImage "/boot/vmlinuz-$KERNEL_VERSION-miniml"
install -D -m 0644 System.map "/boot/System.map-$KERNEL_VERSION-miniml"

if command -v update-initramfs >/dev/null 2>&1; then
    update-initramfs -c -k "$KERNEL_VERSION"
fi
if command -v update-grub >/dev/null 2>&1; then
    update-grub
fi

