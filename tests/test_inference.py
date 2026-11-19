#!/usr/bin/env python3

import importlib.util
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("miniml_inference", ROOT / "ml" / "inference.py")
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)

latencies = module.run_inference(
    ROOT / "ml" / "model" / "squeezenet1.1-7.onnx",
    ROOT / "ml" / "test_images" / "test-image.jpg",
    ROOT / "ml" / "model" / "imagenet_classes.txt",
    iterations=1,
)

if not latencies or latencies[-1] <= 0:
    raise SystemExit("Inference did not return a positive latency")

