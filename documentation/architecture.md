# MiniML Linux Architecture

```mermaid
flowchart TD
    A[Debian 12 Build Host] --> B[Debian Live-build]
    B --> C[Custom Linux Kernel]
    B --> D[Minimal Debian Userland]
    D --> E[Python and ONNX Runtime]
    E --> F[Image Classifier]
    C --> G[Live ISO Root]
    D --> G
    F --> G
    G --> H[SquashFS Read-only Root]
    H --> I[QEMU virtio Storage]
    I --> J[OverlayFS Writable Upper Layer]
    J --> K[systemd and miniml User]
    K --> L[CPUExecutionProvider Inference]
```

The ISO contains a read-only root filesystem. Live-boot supplies a writable upper layer. The application runs as `miniml`, and ONNX Runtime restricts execution to `CPUExecutionProvider`.
