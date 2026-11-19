#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODEL_DIR="$ROOT/ml/model"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

mkdir -p "$MODEL_DIR"

if ! command -v git-lfs >/dev/null 2>&1 && ! git lfs version >/dev/null 2>&1; then
    echo "Git LFS is required to download the ONNX model." >&2
    echo "Debian/Ubuntu: sudo apt install git-lfs" >&2
    exit 1
fi

git lfs install
git clone --depth 1 --filter=blob:none --sparse \
    https://github.com/onnx/models.git "$WORK/models"
cd "$WORK/models"
git sparse-checkout set validated/vision/classification/squeezenet/model
SOURCE="validated/vision/classification/squeezenet/model/squeezenet1.1-7.onnx"
git lfs pull --include="$SOURCE"
if [[ ! -s "$SOURCE" ]]; then
    echo "Expected model was not found in the ONNX Model Zoo checkout." >&2
    exit 1
fi

cp "$SOURCE" "$MODEL_DIR/squeezenet1.1-7.onnx"
sha256sum "$MODEL_DIR/squeezenet1.1-7.onnx" | tee "$MODEL_DIR/squeezenet1.1-7.onnx.sha256"

curl -fL --retry 3 \
    https://raw.githubusercontent.com/pytorch/hub/master/imagenet_classes.txt \
    -o "$MODEL_DIR/imagenet_classes.txt"

echo "Model and labels downloaded under $MODEL_DIR"

