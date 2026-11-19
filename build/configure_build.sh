#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

"$ROOT/scripts/check_environment.sh"

mkdir -p build/live/auto build/live/package-lists \
         build/live/includes.chroot/etc \
         build/live/includes.chroot/etc/sysctl.d \
         build/live/includes.chroot/opt/miniml/ml/test_images \
         build/live/includes.chroot/opt/miniml/ml/model \
         build/live/includes.chroot/tmp \
         config/live-build config/boot config/filesystem config/security

cat > build/live/auto/config <<'EOF'
#!/bin/sh
lb config noauto \
  --distribution bookworm \
  --architecture amd64 \
  --binary-images iso-hybrid \
  --debian-installer live \
  --debootstrap-options "--variant=minbase" \
  --bootappend-live "boot=live components persistence username=miniml" \
  --apt-indices false \
  --apt-recommends false \
  "$@"
EOF
chmod +x build/live/auto/config

cp build/live/auto/config config/live-build.auto.config.txt

cat > build/live/package-lists/miniml.list.chroot <<'EOF'
linux-image-amd64
systemd
systemd-sysv
busybox
python3
python3-pip
python3-numpy
python3-pil
libglvnd0
udev
e2fsprogs
parted
squashfs-tools
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

cat > build/live/includes.chroot/etc/os-release <<'EOF'
PRETTY_NAME="MiniML Linux"
NAME="MiniML Linux"
ID=miniml
ID_LIKE=debian
HOME_URL="https://www.debian.org/"
EOF

install -m 0644 "$ROOT/config/security/sysctl.conf" \
    build/live/includes.chroot/etc/sysctl.d/99-miniml.conf
install -m 0644 "$ROOT/config/security/nftables.conf" \
    build/live/includes.chroot/etc/nftables.conf

cp "$ROOT/services/miniml-inference.service" \
   build/live/includes.chroot/tmp/miniml-inference.service
cp "$ROOT/services/miniml-inference.timer" \
   build/live/includes.chroot/tmp/miniml-inference.timer

cp "$ROOT/ml/inference.py" \
   build/live/includes.chroot/opt/miniml/ml/inference.py

if [[ -f "$ROOT/ml/model/squeezenet1.1-7.onnx" ]]; then
    cp "$ROOT/ml/model/squeezenet1.1-7.onnx" \
       build/live/includes.chroot/opt/miniml/ml/model/squeezenet1.1-7.onnx
fi

if [[ -f "$ROOT/ml/model/imagenet_classes.txt" ]]; then
    cp "$ROOT/ml/model/imagenet_classes.txt" \
       build/live/includes.chroot/opt/miniml/ml/model/imagenet_classes.txt
fi

if [[ -f "$ROOT/ml/test_images/test-image.jpg" ]]; then
    cp "$ROOT/ml/test_images/test-image.jpg" \
       build/live/includes.chroot/opt/miniml/ml/test_images/test-image.jpg
fi

if [[ ! -f "$ROOT/ml/model/squeezenet1.1-7.onnx" ||
      ! -f "$ROOT/ml/model/imagenet_classes.txt" ||
      ! -f "$ROOT/ml/test_images/test-image.jpg" ]]; then
    echo "Missing model, labels, or test image. Run ml/download_model.sh and regenerate the test image." >&2
    exit 1
fi

echo "Live-build configuration prepared in $ROOT/build/live"

