#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

KERNEL_VERSION="${KERNEL_VERSION:-6.1.128}"
SOURCE_URL="${SOURCE_URL:-https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-${KERNEL_VERSION}.tar.xz}"
SOURCE_DIR="$ROOT/kernel/linux-${KERNEL_VERSION}"
TARBALL="$ROOT/kernel/linux-${KERNEL_VERSION}.tar.xz"

mkdir -p "$ROOT/kernel"

if [[ ! -f "$TARBALL" ]]; then
    curl -fL --retry 3 "$SOURCE_URL" -o "$TARBALL"
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
    tar -xf "$TARBALL" -C "$ROOT/kernel"
fi

cp "$ROOT/kernel/.config" "$SOURCE_DIR/.config"
cd "$SOURCE_DIR"
make olddefconfig
make -j"$(nproc)" bzImage modules

printf 'v%s\n' "$KERNEL_VERSION" > "$ROOT/kernel/kernel_version.txt"
stat --printf='Kernel bzImage size: %s bytes\n' arch/x86/boot/bzImage

