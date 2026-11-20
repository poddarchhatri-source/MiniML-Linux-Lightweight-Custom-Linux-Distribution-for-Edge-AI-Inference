# Security Implementation

1. **Dedicated application user:** systemd runs the application as `miniml`, not root.
2. **Systemd sandboxing:** `ProtectSystem`, `ProtectHome`, `PrivateTmp`, `NoNewPrivileges`, capability restrictions, and read-only application paths limit service permissions.
3. **Minimal services:** Bluetooth, Avahi, and ModemManager are disabled when present.
4. **ASLR:** `kernel.randomize_va_space=2` is configured.
5. **Firewall:** nftables defaults to drop inbound traffic and accept established traffic and loopback traffic.
6. **Kernel hardening:** the kernel configuration requests module signature verification support and stack protection where available.

The Bookworm security repository is added to the image and security upgrades are applied during the chroot hook. Live-build's legacy security/volatile mirror defaults are disabled because their suite names do not match current Debian Bookworm repositories.

The hook installs the security-current kernel and keeps its concrete versioned package, then removes the kernel metapackage. This prevents Live-build's later binary-stage upgrade from adding a second kernel, which its single-flavour Syslinux image layout cannot handle.

The ISO's live-boot configuration determines whether kernel audit or full SELinux/AppArmor enforcement is practical. Those features must be verified rather than assumed.
