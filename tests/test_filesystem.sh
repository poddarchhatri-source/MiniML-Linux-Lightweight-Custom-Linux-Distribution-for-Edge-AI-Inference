#!/usr/bin/env bash
set -euo pipefail

findmnt /
findmnt -t squashfs || true
findmnt -t overlay || true
grep -E 'overlay|squashfs' /proc/filesystems

