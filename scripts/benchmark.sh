#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ITERATIONS="${ITERATIONS:-30}"
OUTPUT="$ROOT/reports/benchmark_results.json"

python3 "$ROOT/ml/benchmark.py" \
    --model "$ROOT/ml/model/squeezenet1.1-7.onnx" \
    --image "$ROOT/ml/test_images/test-image.jpg" \
    --iterations "$ITERATIONS" \
    --output "$OUTPUT"

