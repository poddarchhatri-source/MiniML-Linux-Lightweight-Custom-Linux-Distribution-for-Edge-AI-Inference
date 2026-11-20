# Troubleshooting

## Live-build refuses to run

Check architecture with `uname -m`. Native build requires x86_64. Use Ubuntu 24.04 or Debian 12 in WSL2, UTM, or a Linux VM.

## Model download fails

Install Git LFS, verify network access, and rerun `ml/download_model.sh`.

## ONNX Runtime cannot import

The inference runtime is installed in its dedicated virtual environment:

```bash
/opt/miniml/venv/bin/python --version
/opt/miniml/venv/bin/python -m pip show onnxruntime
/opt/miniml/venv/bin/python -c "import onnxruntime as ort; print(ort.get_available_providers())"
```

## QEMU does not find the ISO

Verify `file output/MiniML-Linux.iso`, rerun `build/verify_build.sh`, and ensure the ISO was copied with its SHA256 file.

## systemd service fails

```bash
systemctl status miniml-inference.service --no-pager
journalctl -u miniml-inference.service --no-pager
systemctl show -p ExecStart miniml-inference.service
```
