#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISO="${1:-$ROOT/output/MiniML-Linux.iso}"
CPU="${QEMU_CPU:-4}"
RAM="${QEMU_RAM:-2048}"

if [[ ! -f "$ISO" ]]; then
    echo "ISO not found: $ISO" >&2
    exit 1
fi

ACCEL="tcg"
if [[ -e /dev/kvm ]]; then
    ACCEL="kvm"
fi

exec qemu-system-x86_64 \
    -machine q35,accel="$ACCEL" \
    -cpu max \
    -smp "$CPU" \
    -m "$RAM" \
    -drive "file=$ISO,media=cdrom,readonly=on" \
    -boot d \
    -netdev user,id=net0 \
    -device virtio-net-pci,netdev=net0 \
    -device virtio-rng-pci \
    -nographic

