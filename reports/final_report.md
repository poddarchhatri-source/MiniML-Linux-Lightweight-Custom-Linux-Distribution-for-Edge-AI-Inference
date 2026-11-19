# MiniML Linux: Academic Project Report

## 1. Introduction

MiniML Linux is a Debian Live ISO project for CPU-only edge image inference in QEMU.

## 2. Problem Statement

Standard desktop distributions include unnecessary packages and services. This project investigates whether a live Debian image can provide a smaller, reproducible platform for local ONNX inference.

## 3. Project Objectives

The source implementation targets an x86_64 ISO, custom kernel, CPU inference, systemd startup, minimal package set, secure filesystem, and measured QEMU benchmarking.

## 4. Requirements Analysis

See `documentation/requirements.md`.

## 5. Hardware and Software Requirements

An x86_64 Linux build host is required. QEMU software virtual hardware replaces physical hardware.

## 6-8. Build, Comparison, and Architecture

Debian Live-build was selected and compared with Buildroot. The architecture is documented in `documentation/build_system_comparison.md` and `documentation/architecture.md`.

## 9. Linux Kernel Customisation

The kernel build scripts and configuration are in `kernel/`. Kernel and module size remain pending real build measurements.

## 10-12. Userland, ONNX, and Application

The package manifest and ML integration are in `config/package-list.txt`, `ml/inference.py`, and `documentation/ml_integration.md`.

## 13-15. Filesystem, Security, and Image Generation

The live filesystem, firewall, systemd sandboxing, and ASLR configuration are implemented in source. ISO creation remains pending a suitable Linux build host.

## 16-18. Deployment and Testing

Use the QEMU scripts and tests after generating the ISO. No boot or inference result is claimed here.

## 19-20. Comparison and Discussion

Results must be inserted from identical QEMU configurations. The 40% ISO reduction is a target, not a current claim.

## 21-23. Limitations, Future Work, and Conclusion

The current macOS ARM environment cannot natively build or validate the Debian x86_64 ISO. Completion requires an x86_64 Debian or Ubuntu host.

## 24-25. References and Licence List

- Debian Live Manual
- Debian Project packages
- Linux kernel documentation
- ONNX Runtime documentation
- ONNX Model Zoo
- PyTorch ImageNet labels

See `documentation/licence_list.md`.
