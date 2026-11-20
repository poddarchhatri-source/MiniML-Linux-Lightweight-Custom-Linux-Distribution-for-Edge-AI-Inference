#!/usr/bin/env bash
set -euo pipefail

missing=0

check_command() {
    local command_name="$1"
    if command -v "$command_name" >/dev/null 2>&1; then
        printf 'OK      %-20s %s\n' "$command_name" "$(command -v "$command_name")"
    else
        printf 'MISSING %-20s\n' "$command_name"
        missing=1
    fi
}

printf 'MiniML Linux environment check\n'
printf '================================\n'

if [[ -r /etc/os-release ]]; then
    source /etc/os-release
    printf 'OS:      %s\n' "${PRETTY_NAME:-unknown}"
fi

printf 'Kernel:  %s\n' "$(uname -r)"
printf 'CPU:     %s\n' "$(uname -m)"

if command -v free >/dev/null 2>&1; then
    printf 'RAM:\n'
    free -h
else
    printf 'RAM: '
    if command -v sysctl >/dev/null 2>&1; then
        sysctl -n hw.memsize
    else
        echo "unknown"
    fi
fi

printf 'Storage:\n'
df -h .

printf '\nTools:\n'
for tool in git python3 pip3 gcc make live-build lb debootstrap \
            xorriso mksquashfs qemu-system-x86_64 qemu-img \
            rsync curl wget unzip file cpio systemd-analyze; do
    check_command "$tool"
done

printf '\nVersions:\n'
git --version 2>/dev/null || true
python3 --version 2>/dev/null || true
gcc --version 2>/dev/null | head -n 1 || true
make --version 2>/dev/null | head -n 1 || true
lb --version 2>/dev/null || true
qemu-system-x86_64 --version 2>/dev/null | head -n 1 || true

printf '\nVirtualization:\n'
if [[ -e /dev/kvm ]]; then
    echo 'KVM: available'
else
    echo 'KVM: unavailable (QEMU TCG fallback is supported)'
fi

case "$(uname -m)" in
    x86_64|amd64)
        echo 'Architecture: suitable'
        ;;
    *)
        echo 'Architecture: unsuitable for native x86_64 Live-build'
        missing=1
        ;;
esac

if [[ -r /etc/os-release ]]; then
    source /etc/os-release
    if [[ "${ID:-}" != "debian" && "${ID:-}" != "ubuntu" ]]; then
        echo 'Build OS: unsupported'
        missing=1
    fi
fi

if (( missing != 0 )); then
    echo
    echo 'Environment not complete. Missing tools or unsupported host detected.'
    exit 1
fi

echo
echo 'Environment check passed.'

