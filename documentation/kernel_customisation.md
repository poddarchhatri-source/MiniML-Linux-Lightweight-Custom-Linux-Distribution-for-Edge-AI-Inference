# Kernel Customisation

The kernel build begins from the Linux 6.1.x source family and applies an x86_64 `defconfig`. Important option groups are enabled explicitly:

- 64-bit x86 and SMP scheduling
- VirtIO PCI, block, network, and MMIO support
- initramfs, tmpfs, ext4, SquashFS, and OverlayFS
- TCP/IP, packet, UNIX, serial, and virtual console support
- ASLR and stack protection
- module signature support
- kernel security restrictions

The resulting `.config` must be recorded and the kernel modules and `bzImage` measured after a real build. No reduction can be reported until measured.
