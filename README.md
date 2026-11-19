<<<<<<< HEAD
# MiniML-Linux-Lightweight-Custom-Linux-Distribution-for-Edge-AI-Inference
A lightweight, custom Debian-based Linux distribution designed for CPU-only edge AI inference using Python and ONNX Runtime. Features a custom Linux kernel, automated ML application startup, SquashFS with OverlayFS, security hardening, and QEMU-based virtual machine testing.
=======
# MiniML Linux

MiniML Linux is an application-specific, lightweight Debian Live ISO for CPU-only image classification. It targets x86_64 virtual machines and uses a custom Linux kernel, systemd, SquashFS, OverlayFS, Python, ONNX Runtime, and QEMU.

## Current environment status

The provided workspace is running on macOS on Apple Silicon (ARM64). Debian Live-build must run inside an x86_64 Debian or Ubuntu Linux build host. The scripts in this repository detect this and stop with an explicit architecture/build-host error.

## Project layout

- `build/`: Live-build configuration, build, verification, and reproducibility scripts
- `config/`: package and live-build configuration
- `kernel/`: kernel configuration and build scripts
- `ml/`: ONNX application, model downloader, and benchmark tools
- `services/`: systemd service units
- `scripts/`: host/system testing, measurement, and QEMU scripts
- `tests/`: boot, kernel, model, service, security, and filesystem tests
- `documentation/`: technical documentation
- `reports/`: test and benchmark reports
- `baseline/`: stock Debian comparison records
- `output/`: generated ISO and build reports (not committed)

## Build host requirements

Use Debian 12 x86_64 or Ubuntu 24.04 x86_64. Debian 12 is the primary build target.

Minimum host resources:

| Resource | Minimum |
|---|---:|
| RAM | 8 GB |
| Disk | 40 GB |
| CPU | 4 cores |

Run the environment check:

```bash
./scripts/check_environment.sh
```

Install build dependencies:

```bash
sudo ./build/install_dependencies.sh
```

Configure the build and create the ISO:

```bash
./build/configure_build.sh
sudo ./build/build_iso.sh
./build/verify_build.sh
```

The ISO will be written to `output/MiniML-Linux.iso`.

## Important validation rule

The repository does not contain fabricated benchmark values or a claimed ISO result. ISO generation, boot tests, model tests, and benchmark values become valid only after commands are run on the Linux build host and QEMU guest.

>>>>>>> 729b599 (Create MiniML Linux implementation scaffold)
