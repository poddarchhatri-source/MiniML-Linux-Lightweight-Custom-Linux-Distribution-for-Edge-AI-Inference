# MiniML Linux: Lightweight Edge-AI Inference Live System

MiniML Linux is a minimal Debian 12 (Bookworm) live image for running image classification locally on x86_64 hardware. It boots a pre-trained SqueezeNet model and performs ONNX Runtime inference on the CPU, without sending the image to a cloud service.

## Project summary

The project combines a Debian Live system, a compressed read-only SquashFS root, a writable live overlay, Python image preprocessing, ONNX Runtime, and systemd automation. The same image can be tested in QEMU or booted on compatible x86_64 hardware.

This is an **inference demonstration**, not a model-training project. It classifies an image supplied to the program; it does not include a camera capture pipeline.

## Goals

- Produce a bootable x86_64 live ISO.
- Include a small CPU-capable image-classification model and its runtime.
- Run inference locally and report the top five ImageNet label scores and latency.
- Support an automatic systemd timer as well as manual inference.
- Make the image testable in QEMU.

## Architecture

```mermaid
flowchart LR
    A[Debian Live build] --> B[Bootable ISO]
    B --> C[QEMU or x86_64 device]
    C --> D[Live system: SquashFS + OverlayFS]
    D --> E[systemd timer and service]
    E --> F[Python preprocessing]
    F --> G[ONNX Runtime CPUExecutionProvider]
    G --> H[Top-five labels and latency in journal]
```

### Inference pipeline

1. Load the input image and convert it to RGB.
2. Resize it to 224 × 224 pixels.
3. Scale pixel values to `[0, 1]`, then normalize using ImageNet mean and standard deviation.
4. Convert the image to the tensor layout expected by SqueezeNet.
5. Run the ONNX model using `CPUExecutionProvider`.
6. Apply softmax to the output scores and print the five highest-scoring labels.

The model is SqueezeNet 1.1 from the ONNX Model Zoo. The model and Python requirements are placed in the image during the build. After boot, inference itself does not require network access.

The runtime uses ONNX Runtime `1.17.1`, NumPy `1.26.4`, and Pillow `10.4.0` in a dedicated Python virtual environment.

## Run the live image

The generated ISO is `output/MiniML-Linux.iso` (about 398 MiB). Build outputs and the ONNX model are ignored by Git; download the model before building a fresh checkout.

### Build on Linux

Use an x86_64 Debian 12 or Ubuntu Linux build host. The project was built and tested on Ubuntu 25.04 x86_64 with Live-build 3.0~a57-1. Allow at least 8 GB RAM and 40 GB free disk space.

**Important:** Live-build rejects working directories whose paths contain spaces. A symlink to a path containing spaces does not fix this. Clone into a path without spaces:

```bash
git clone https://github.com/poddarchhatri-source/MiniML-Linux-Lightweight-Custom-Linux-Distribution-for-Edge-AI-Inference.git \
  "$HOME/miniml-build"
cd "$HOME/miniml-build"

make deps
make check
./ml/download_model.sh
make configure
make build
make verify
```

The model downloader uses Git LFS and needs network access. The image build also needs network access to Debian repositories and PyPI to install the pinned Python dependencies into `/opt/miniml/venv`.

### Boot in QEMU

From the repository root, run:

```bash
make qemu
```

The live system logs in on the serial console. Demo credentials are:

- Username: `miniml`
- Password: `live`

These are demo credentials, not suitable for a production deployment.

## Test inference

The ISO includes a sample image at `/opt/miniml/ml/test_images/test-image.jpg`. Run the model directly:

```bash
/opt/miniml/venv/bin/python /opt/miniml/ml/inference.py \
  --image /opt/miniml/ml/test_images/test-image.jpg --iterations 1
```

To run the systemd service and read its output:

```bash
sudo systemctl start miniml-inference.service
sudo journalctl -u miniml-inference.service -o cat --no-pager -n 20
```

The service is a oneshot. It exits after each inference, so `inactive (dead)` after a successful run is expected. Check the journal for the result.

The automatic timer runs shortly after boot and then every ten minutes:

```bash
systemctl list-timers miniml-inference.timer
```

For a custom image, first make the image available inside the guest, then pass its actual guest path with `--image`. A host path is not automatically visible inside QEMU.

## Verified results

The following results were observed during validation on November 20, 2026:

| Check | Result |
|---|---|
| ISO build and checksum verification | Passed |
| ISO size | 417,333,248 bytes (about 398 MiB) |
| QEMU boot | Reached the Debian 12 systemd login prompt |
| Live user and service timer | User login worked; inference timer became active |
| Inference service | Completed successfully; logs contained CPU provider and top-five predictions |
| Direct sample-image inference | Completed in approximately 6.7–7.1 ms in the tested QEMU setup |

Example output:

```text
Execution provider: CPUExecutionProvider
Inference latency: 6.79 ms
Top 5 predictions:
1. lycaenid: 3.78%
2. matchstick: 3.70%
3. ant: 2.82%
4. jellyfish: 2.73%
5. pool table: 1.97%
```

The bundled `test-image.jpg` is a simple color gradient, not a photograph of an object. Its predictions are therefore not meaningful evidence of classification accuracy. The output confirms that the image-to-model-to-logging pipeline runs; use real, labeled images to evaluate recognition quality. The percentages are model scores, not measured accuracy.

The latency above measures one model execution after warm-up; it excludes boot and model-startup time. It is an observed single-run result, not a statistically controlled benchmark. A MiniML-versus-stock-Debian comparison, multi-image accuracy evaluation, and formal latency distribution have not yet been completed.

## Current limitations and scope

- The verified image is x86_64 and uses CPU inference; GPU and accelerator providers are not configured.
- The generated ISO uses Debian's packaged kernel `6.1.0-56-amd64`. Kernel customization scripts exist in `kernel/`, but building that custom kernel is not currently integrated into this ISO build.
- The included sample image is only a pipeline test. Replace it with real images and ground-truth labels before making accuracy claims.
- The live overlay provides a writable session, but changes should not be assumed persistent unless a persistence medium is configured.
- The default `miniml`/`live` credentials are for demonstration only. Harden credentials and validate firewall policy before any production use.

## Repository map

| Path | Purpose |
|---|---|
| `build/` | Live-build configuration, ISO generation, and verification |
| `config/` | Filesystem and security configuration |
| `kernel/` | Kernel configuration and separate kernel build scripts |
| `ml/` | Inference code, model downloader, requirements, and test image |
| `services/` | systemd inference service and timer |
| `scripts/` | Environment checks, QEMU launch, benchmarks, and utilities |
| `tests/` | Model, inference, and guest-side tests |
| `documentation/` | Architecture, deployment, security, and integration details |
| `reports/` | Project and benchmark report material |
| `output/` | Generated ISO and checksum; not committed |

## Presentation summary

> MiniML Linux is a minimal Debian live system for local edge-AI image classification. It boots a pre-trained SqueezeNet model and runs it through ONNX Runtime on the CPU. A systemd timer can trigger inference automatically, while QEMU provides a repeatable demonstration environment. The current validation proves the end-to-end inference pipeline; meaningful accuracy and performance comparisons require additional labeled images and benchmark runs.

For design and implementation details, see [the architecture](documentation/architecture.md), [ONNX integration](documentation/ml_integration.md), [deployment guide](documentation/deployment.md), and [package selection](documentation/package_selection.md).
