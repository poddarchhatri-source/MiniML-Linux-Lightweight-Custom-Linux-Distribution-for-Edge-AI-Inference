#!/usr/bin/env bash
set -euo pipefail

uname -r
uname -m

required="/proc/cmdline /proc/filesystems /proc/self/status"
for path in $required; do
    test -r "$path"
done

grep -E 'overlay|squashfs' /proc/filesystems

