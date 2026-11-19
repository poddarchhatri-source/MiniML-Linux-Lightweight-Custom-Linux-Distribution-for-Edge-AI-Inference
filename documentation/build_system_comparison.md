# Debian Live-build and Buildroot Comparison

| Criterion | Debian Live-build | Buildroot |
|---|---|---|
| Build complexity | Moderate; Debian packaging and live-boot conventions are familiar | Moderate to high; rootfs, busybox, and package recipes require more setup |
| Package management | apt/deb repositories | Buildroot package recipes and package build system |
| Kernel customisation | Custom kernel packages or local kernel builds | Built into the build framework |
| Python support | Python Debian packages and pip | Supported, but package integration requires recipes |
| ML integration | ONNX Runtime wheel or Debian package | ONNX Runtime requires custom package/build integration |
| Image size | Small when recommendations and desktops are excluded | Usually capable of a smaller image |
| Reproducibility | Debian snapshot and pinned package policies can improve reproducibility | Strong cross-compilation reproducibility |
| Development difficulty | Lower for Debian beginners | Higher because users manage more of userspace |
| QEMU compatibility | BIOS/UEFI live ISO and QEMU support | Highly configurable for QEMU |

Debian Live-build is selected because it provides familiar apt packages, systemd, Debian live-boot behavior, and direct ISO construction while permitting kernel customisation. Buildroot can potentially produce a smaller image, but it adds more custom userspace, package, and dependency integration work.
