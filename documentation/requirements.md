# Requirements

## Functional requirements

- x86_64 bootable Live ISO
- Custom Linux kernel
- systemd startup
- CPU-only ONNX image classification
- Offline operation after boot
- Dedicated miniml user
- Read-only SquashFS root with OverlayFS
- Security and firewall configuration
- QEMU test support
- Actual benchmark and comparison scripts

## Hardware requirements

| Item | Build host | QEMU guest |
|---|---|---|
| Architecture | x86_64 | x86_64 |
| CPU | 4 cores minimum | 2-4 cores |
| RAM | 8 GB minimum | 2 GB minimum |
| Disk | 40 GB minimum | 8 GB virtual disk if persistence is used |
| Physical devices | None required | None required |
