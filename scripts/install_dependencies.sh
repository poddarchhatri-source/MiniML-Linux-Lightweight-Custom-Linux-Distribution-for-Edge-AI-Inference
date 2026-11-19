#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -m)" != "x86_64" && "$(uname -m)" != "amd64" ]]; then
    echo "This host cannot natively build the x86_64 image." >&2
    exit 1
fi

if [[ -r /etc/os-release ]]; then
    source /etc/os-release
else
    echo "Cannot identify the Linux distribution." >&2
    exit 1
fi

if [[ "${EUID}" -ne 0 ]]; then
    echo "Run this script with sudo:" >&2
    echo "sudo ./scripts/install_dependencies.sh" >&2
    exit 1
fi

apt-get update

case "${ID:-}" in
    debian)
        apt-get install -y live-build debootstrap debian-archive-keyring \
            xorriso squashfs-tools isolinux syslinux-utils \
            build-essential bc bison flex libssl-dev libelf-dev \
            libncurses-dev rsync git curl wget unzip file cpio \
            python3 python3-pip python3-venv qemu-system-x86 \
            qemu-utils debootstrap
        ;;
    ubuntu)
        apt-get install -y live-build debootstrap ubuntu-keyring \
            xorriso squashfs-tools isolinux syslinux-utils \
            build-essential bc bison flex libssl-dev libelf-dev \
            libncurses-dev rsync git curl wget unzip file cpio \
            python3 python3-pip python3-venv qemu-system-x86 \
            qemu-utils
        ;;
    *)
        echo "Unsupported build OS: ${PRETTY_NAME:-unknown}" >&2
        exit 1
        ;;
esac

