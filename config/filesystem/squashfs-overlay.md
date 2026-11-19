# SquashFS and OverlayFS

Debian live-build constructs a read-only SquashFS root filesystem. live-boot mounts it and supplies a writable upper layer.

- `/opt/miniml`: read-only application files
- `/var/lib/miniml`: dedicated runtime state
- `/tmp`: private temporary storage
- ISO: read-only

Runtime writes use a tmpfs or optional persistence volume. QEMU testing should verify the actual mount with `findmnt`.
