#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

"$ROOT/scripts/check_environment.sh"

mkdir -p build/live/auto build/live/config/package-lists \
         build/live/config/hooks build/live/config/bootloaders/isolinux \
         build/live/config/includes.chroot/etc \
         build/live/config/includes.chroot/etc/sysctl.d \
         build/live/config/includes.chroot/etc/apt/sources.list.d \
         build/live/config/includes.chroot/usr/bin \
         build/live/config/includes.chroot/opt/miniml/ml/test_images \
         build/live/config/includes.chroot/opt/miniml/ml/model \
         build/live/config/includes.chroot/etc/systemd/system/timers.target.wants \
         config/live-build config/boot config/filesystem config/security

if [[ -d build/live/config/includes.chroot/tmp ]]; then
    rm -f build/live/config/includes.chroot/tmp/miniml-inference.service \
        build/live/config/includes.chroot/tmp/miniml-inference.timer
    chmod 1777 build/live/config/includes.chroot/tmp
fi

cat > build/live/auto/config <<'EOF'
#!/bin/sh
lb config noauto \
  --distribution bookworm \
  --mode debian \
  --architecture amd64 \
  --archive-areas main \
  --parent-archive-areas main \
  --keyring-packages debian-archive-keyring \
  --linux-packages linux-image \
  --linux-flavours amd64 \
  --security false \
  --volatile false \
  --parent-mirror-bootstrap http://deb.debian.org/debian \
  --parent-mirror-chroot http://deb.debian.org/debian \
  --parent-mirror-chroot-security http://security.debian.org/debian-security \
  --parent-mirror-binary http://deb.debian.org/debian \
  --parent-mirror-binary-security http://security.debian.org/debian-security \
  --parent-mirror-debian-installer http://deb.debian.org/debian \
  --mirror-bootstrap http://deb.debian.org/debian \
  --mirror-chroot http://deb.debian.org/debian \
  --mirror-chroot-security http://security.debian.org/debian-security \
  --mirror-binary http://deb.debian.org/debian \
  --mirror-binary-security http://security.debian.org/debian-security \
  --mirror-debian-installer http://deb.debian.org/debian \
  --binary-images iso-hybrid \
  --bootloader syslinux \
  --syslinux-theme live-build \
  --debian-installer false \
  --bootstrap-flavour minimal \
  --initsystem systemd \
  --bootappend-live "boot=live components persistence username=miniml console=tty0 console=ttyS0,115200n8" \
  --apt-indices false \
  --apt-recommends false \
  "$@"
EOF
chmod +x build/live/auto/config

cp build/live/auto/config config/live-build.auto.config.txt

cp -a /usr/share/live/build/bootloaders/isolinux/. \
    build/live/config/bootloaders/isolinux/
ln -sfn /usr/lib/ISOLINUX/isolinux.bin \
    build/live/config/bootloaders/isolinux/isolinux.bin
ln -sfn /usr/lib/syslinux/modules/bios/ldlinux.c32 \
    build/live/config/bootloaders/isolinux/ldlinux.c32
ln -sfn /usr/lib/syslinux/modules/bios/libcom32.c32 \
    build/live/config/bootloaders/isolinux/libcom32.c32
ln -sfn /usr/lib/syslinux/modules/bios/libutil.c32 \
    build/live/config/bootloaders/isolinux/libutil.c32
ln -sfn /usr/lib/syslinux/modules/bios/vesamenu.c32 \
    build/live/config/bootloaders/isolinux/vesamenu.c32
(cd build/live/config/bootloaders/isolinux && printf '' | cpio -o -H newc --quiet > bootlogo)
sed -i 's/^timeout 0$/timeout 50/' \
    build/live/config/bootloaders/isolinux/isolinux.cfg

cat > build/live/config/package-lists/miniml.list.chroot <<'EOF'
linux-image-amd64
systemd
systemd-sysv
live-config-systemd
user-setup
dbus
busybox
python3
python3-pip
python3-venv
python3-numpy
python3-pil
libglvnd0
udev
e2fsprogs
parted
squashfs-tools
syslinux-utils
isolinux
librsvg2-bin
ca-certificates
curl
iproute2
iputils-ping
netbase
procps
isc-dhcp-client
sudo
adduser
EOF

cat > build/live/config/includes.chroot/etc/os-release <<'EOF'
PRETTY_NAME="MiniML Linux"
NAME="MiniML Linux"
ID=miniml
ID_LIKE=debian
HOME_URL="https://www.debian.org/"
EOF

install -m 0644 "$ROOT/config/security/sysctl.conf" \
    build/live/config/includes.chroot/etc/sysctl.d/99-miniml.conf
install -m 0644 "$ROOT/config/security/nftables.conf" \
    build/live/config/includes.chroot/etc/nftables.conf

cat > build/live/config/includes.chroot/etc/apt/sources.list.d/miniml-security.list <<'EOF'
deb https://security.debian.org/debian-security bookworm-security main
EOF

cat > build/live/config/hooks/010-security-updates.chroot <<'EOF'
#!/bin/sh
set -eu
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y
apt-get install -y linux-image-amd64
latest_kernel="$(printf '%s\n' /boot/vmlinuz-* | sort -V | tail -n 1)"
latest_package="linux-image-${latest_kernel##*/vmlinuz-}"
apt-mark manual "$latest_package"
for kernel_image in /boot/vmlinuz-*; do
    if [ "$kernel_image" != "$latest_kernel" ]; then
        apt-get purge -y "linux-image-${kernel_image##*/vmlinuz-}"
    fi
done
apt-get purge -y linux-image-amd64
apt-get autoremove --purge -y
EOF
chmod +x build/live/config/hooks/010-security-updates.chroot

cat > build/live/config/includes.chroot/usr/bin/rsvg <<'EOF'
#!/bin/sh
set -eu

if [ "$#" -ne 8 ] || [ "$1" != "--format" ] ||
   [ "$3" != "--height" ] || [ "$5" != "--width" ]; then
    echo "Unsupported rsvg invocation" >&2
    exit 2
fi

exec /usr/bin/rsvg-convert \
    --format "$2" --height "$4" --width "$6" \
    --output "$8" "$7"
EOF
chmod +x build/live/config/includes.chroot/usr/bin/rsvg

cp "$ROOT/services/miniml-inference.service" \
   build/live/config/includes.chroot/etc/systemd/system/miniml-inference.service
cp "$ROOT/services/miniml-inference.timer" \
   build/live/config/includes.chroot/etc/systemd/system/miniml-inference.timer
ln -sfn ../miniml-inference.timer \
   build/live/config/includes.chroot/etc/systemd/system/timers.target.wants/miniml-inference.timer

cp "$ROOT/ml/inference.py" \
   build/live/config/includes.chroot/opt/miniml/ml/inference.py
cp "$ROOT/ml/requirements.txt" \
   build/live/config/includes.chroot/opt/miniml/ml/requirements.txt

cat > build/live/config/hooks/020-inference-runtime.chroot <<'EOF'
#!/bin/sh
set -eu
python3 -m venv /opt/miniml/venv
/opt/miniml/venv/bin/pip install --no-cache-dir -r /opt/miniml/ml/requirements.txt
EOF
chmod +x build/live/config/hooks/020-inference-runtime.chroot

if [[ -f "$ROOT/ml/model/squeezenet1.1-7.onnx" ]]; then
    cp "$ROOT/ml/model/squeezenet1.1-7.onnx" \
       build/live/config/includes.chroot/opt/miniml/ml/model/squeezenet1.1-7.onnx
fi

if [[ -f "$ROOT/ml/model/imagenet_classes.txt" ]]; then
    cp "$ROOT/ml/model/imagenet_classes.txt" \
       build/live/config/includes.chroot/opt/miniml/ml/model/imagenet_classes.txt
fi

if [[ -f "$ROOT/ml/test_images/test-image.jpg" ]]; then
    cp "$ROOT/ml/test_images/test-image.jpg" \
       build/live/config/includes.chroot/opt/miniml/ml/test_images/test-image.jpg
fi

if [[ ! -f "$ROOT/ml/model/squeezenet1.1-7.onnx" ||
      ! -f "$ROOT/ml/model/imagenet_classes.txt" ||
      ! -f "$ROOT/ml/test_images/test-image.jpg" ]]; then
    echo "Missing model, labels, or test image. Run ml/download_model.sh and regenerate the test image." >&2
    exit 1
fi

echo "Live-build configuration prepared in $ROOT/build/live"

