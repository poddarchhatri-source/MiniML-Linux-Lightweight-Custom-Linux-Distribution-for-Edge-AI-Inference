#!/usr/bin/env python3

import argparse
import json
import statistics
import time
from pathlib import Path

import onnxruntime as ort
import numpy as np
from PIL import Image


def percentile(values, percentile_value):
    ordered = sorted(values)
    index = max(0, min(len(ordered) - 1, int(round((percentile_value / 100) * (len(ordered) - 1)))))
    return ordered[index]


def preprocess(path):
    with Image.open(path).convert("RGB").resize((224, 224), Image.Resampling.BILINEAR) as image:
        array = np.asarray(image, dtype=np.float32) / 255.0
    mean = np.array([0.485, 0.456, 0.406], dtype=np.float32)
    std = np.array([0.229, 0.224, 0.225], dtype=np.float32)
    array = (array - mean) / std
    return np.expand_dims(array.transpose(2, 0, 1), 0)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", type=Path, required=True)
    parser.add_argument("--image", type=Path, required=True)
    parser.add_argument("--iterations", type=int, default=30)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    session = ort.InferenceSession(
        str(args.model),
        providers=["CPUExecutionProvider"],
    )
    tensor = preprocess(args.image)
    input_name = session.get_inputs()[0].name

    session.run(None, {input_name: tensor})
    latencies = []
    for _ in range(args.iterations):
        start = time.perf_counter()
        session.run(None, {input_name: tensor})
        latencies.append((time.perf_counter() - start) * 1000.0)

    result = {
        "iterations": args.iterations,
        "provider": "CPUExecutionProvider",
        "average_ms": statistics.mean(latencies),
        "median_ms": statistics.median(latencies),
        "p95_ms": percentile(latencies, 95),
        "minimum_ms": min(latencies),
        "maximum_ms": max(latencies),
    }
    text = json.dumps(result, indent=2)
    print(text)
    if args.output:
        args.output.write_text(text + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()

