#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODEL="$ROOT/ml/model/squeezenet1.1-7.onnx"
CHECKSUM="$MODEL.sha256"

[[ -f "$MODEL" ]] || { echo "Missing model: $MODEL" >&2; exit 1; }
[[ -f "$CHECKSUM" ]] || { echo "Missing checksum file: $CHECKSUM" >&2; exit 1; }

cd "$(dirname "$MODEL")"
while read -r hash filename; do
    if [[ "$(sha256sum "$(basename "$MODEL")" | awk '{print $1}')" != "$hash" ]]; then
        echo "SHA256 mismatch for $MODEL" >&2
        exit 1
    fi
done < "$(basename "$CHECKSUM")"

echo "SHA256 verified: $MODEL"

