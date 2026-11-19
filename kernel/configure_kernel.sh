#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ -n "${KERNEL_TREE:-}" ]]; then
    cd "$KERNEL_TREE"
elif [[ -d kernel/linux ]]; then
    cd kernel/linux
else
    echo "Set KERNEL_TREE=/path/to/linux-source or run build_kernel.sh first." >&2
    exit 1
fi

make defconfig

scripts/config --enable CONFIG_64BIT
scripts/config --enable CONFIG_SMP
scripts/config --enable CONFIG_SCHED_SMT
scripts/config --enable CONFIG_PREEMPT
scripts/config --enable CONFIG_VIRTIO
scripts/config --enable CONFIG_VIRTIO_PCI
scripts/config --enable CONFIG_VIRTIO_BLK
scripts/config --enable CONFIG_VIRTIO_NET
scripts/config --enable CONFIG_VIRTIO_MMIO
scripts/config --enable CONFIG_DEVTMPFS
scripts/config --enable CONFIG_DEVTMPFS_MOUNT
scripts/config --enable CONFIG_SYSFS
scripts/config --enable CONFIG_PROC_FS
scripts/config --enable CONFIG_TMPFS
scripts/config --enable CONFIG_DEVTMPFS
scripts/config --enable CONFIG_EXT4_FS
scripts/config --enable CONFIG_SQUASHFS
scripts/config --enable CONFIG_SQUASHFS_ZLIB
scripts/config --enable CONFIG_OVERLAY_FS
scripts/config --enable CONFIG_BLK_DEV_INITRD
scripts/config --enable CONFIG_INET
scripts/config --enable CONFIG_PACKET
scripts/config --enable CONFIG_UNIX
scripts/config --enable CONFIG_SERIAL_8250
scripts/config --enable CONFIG_SERIAL_8250_CONSOLE
scripts/config --enable CONFIG_VGA_CONSOLE
scripts/config --enable CONFIG_FRAMEBUFFER_CONSOLE
scripts/config --enable CONFIG_DRM
scripts/config --enable CONFIG_DRM_BOCHS
scripts/config --enable CONFIG_DRM_VIRTIO_GPU
scripts/config --enable CONFIG_RELOCATABLE
scripts/config --enable CONFIG_RANDOMIZE_BASE
scripts/config --enable CONFIG_CC_STACKPROTECTOR_STRONG
scripts/config --enable CONFIG_STACKPROTECTOR
scripts/config --enable CONFIG_MODULE_SIG
scripts/config --enable CONFIG_MODULE_SIG_FORCE
scripts/config --enable CONFIG_SECURITY
scripts/config --enable CONFIG_SECURITY_DMESG_RESTRICT
scripts/config --enable CONFIG_HARDENED_USERCOPY
scripts/config --enable CONFIG_FORTIFY_SOURCE

make olddefconfig
cp .config "$ROOT/kernel/.config"
echo "Kernel configuration copied to $ROOT/kernel/.config"

