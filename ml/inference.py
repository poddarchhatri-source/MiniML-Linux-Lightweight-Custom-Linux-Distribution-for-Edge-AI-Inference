#!/usr/bin/env python3

import argparse
import time
from pathlib import Path

import numpy as np
import onnxruntime as ort
from PIL import Image


MODEL_DIR = Path(__file__).resolve().parent / "model"
DEFAULT_MODEL = MODEL_DIR / "squeezenet1.1-7.onnx"
DEFAULT_LABELS = MODEL_DIR / "imagenet_classes.txt"


def preprocess(image_path: Path) -> np.ndarray:
    if not image_path.is_file():
        raise FileNotFoundError(f"Input image not found: {image_path}")

    with Image.open(image_path) as image:
        image = image.convert("RGB")
        image = image.resize((224, 224), Image.Resampling.BILINEAR)
        array = np.asarray(image, dtype=np.float32)

    array /= 255.0
    mean = np.array([0.485, 0.456, 0.406], dtype=np.float32)
    std = np.array([0.229, 0.224, 0.225], dtype=np.float32)
    array = (array - mean) / std
    array = array.transpose(2, 0, 1)
    return np.expand_dims(array, axis=0).astype(np.float32)


def softmax(values: np.ndarray) -> np.ndarray:
    values = values.astype(np.float64)
    values -= np.max(values)
    result = np.exp(values)
    return (result / np.sum(result)).astype(np.float32)


def load_labels(path: Path) -> list[str]:
    if not path.is_file():
        raise FileNotFoundError(f"Label file not found: {path}")
    with path.open("r", encoding="utf-8") as handle:
        return [line.strip() for line in handle if line.strip()]


def run_inference(model_path: Path, image_path: Path, labels_path: Path, iterations: int = 1):
    if not model_path.is_file():
        raise FileNotFoundError(f"ONNX model not found: {model_path}")

    providers = ["CPUExecutionProvider"]
    options = ort.SessionOptions()
    options.intra_op_num_threads = 1
    session = ort.InferenceSession(
        str(model_path),
        sess_options=options,
        providers=providers,
    )

    available = session.get_providers()
    if "CPUExecutionProvider" not in available:
        raise RuntimeError(f"CPUExecutionProvider unavailable; providers={available}")

    tensor = preprocess(image_path)
    input_name = session.get_inputs()[0].name

    warmup = session.run(None, {input_name: tensor})
    latencies = []
    output = warmup

    for _ in range(iterations):
        started = time.perf_counter()
        output = session.run(None, {input_name: tensor})
        latencies.append((time.perf_counter() - started) * 1000.0)

    logits = np.asarray(output[0]).reshape(-1)
    probabilities = softmax(logits)
    labels = load_labels(labels_path)
    top_indices = np.argsort(probabilities)[::-1][:5]

    print(f"Execution provider: {', '.join(available)}")
    print(f"Input image: {image_path}")
    print(f"Model: {model_path}")
    print(f"Inference latency: {latencies[-1]:.2f} ms")
    print("Top 5 predictions:")
    for rank, index in enumerate(top_indices, start=1):
        label = labels[index] if index < len(labels) else f"class_{index}"
        print(f"{rank}. {label}: {probabilities[index] * 100:.2f}%")

    return latencies


def parse_args():
    parser = argparse.ArgumentParser(description="CPU ONNX image classification")
    parser.add_argument(
        "--image",
        type=Path,
        default=Path(__file__).resolve().parent / "test_images" / "test-image.jpg",
    )
    parser.add_argument("--model", type=Path, default=DEFAULT_MODEL)
    parser.add_argument("--labels", type=Path, default=DEFAULT_LABELS)
    parser.add_argument("--iterations", type=int, default=1)
    args = parser.parse_args()
    if args.iterations < 1:
        parser.error("--iterations must be at least 1")
    return args


def main():
    args = parse_args()
    try:
        run_inference(args.model, args.image, args.labels, args.iterations)
    except (FileNotFoundError, RuntimeError, ValueError, OSError) as error:
        print(f"ERROR: {error}")
        raise SystemExit(1)


if __name__ == "__main__":
    main()

