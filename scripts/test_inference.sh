#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
python3 "$ROOT/ml/inference.py" \
    --model "$ROOT/ml/model/squeezenet1.1-7.onnx" \
    --image "$ROOT/ml/test_images/test-image.jpg" \
    --labels "$ROOT/ml/model/imagenet_classes.txt"

