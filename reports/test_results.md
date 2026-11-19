# Test Results

| Test | Environment | Result | Evidence |
|---|---|---|---|
| Environment check | macOS ARM64 | Failed as expected for native Live-build | Current host lacks x86_64/Linux package tooling |
| Live-build configuration | Linux build host | Pending | No host available yet |
| ISO generation | Linux build host | Pending | No verified ISO |
| QEMU boot | Linux build host | Pending | No verified ISO |
| Model loading | Linux build host/guest | Pending | Model not yet downloaded and verified |
| Inference | Linux build host/guest | Pending | ONNX Runtime not yet tested |
| systemd startup | QEMU guest | Pending | Guest not available |
| Model download | macOS host | Blocked | GitHub clone timed out; rerun `ml/download_model.sh` on the Linux host |

