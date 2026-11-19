#!/usr/bin/env python3

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
MODEL = ROOT / "ml" / "model" / "squeezenet1.1-7.onnx"
LABELS = ROOT / "ml" / "model" / "imagenet_classes.txt"
IMAGE = ROOT / "ml" / "test_images" / "test-image.jpg"


def main():
    for path in (MODEL, LABELS, IMAGE):
        if not path.is_file():
            raise SystemExit(f"Missing required file: {path}")

    with Image.open(IMAGE) as image:
        image.verify()

    print(f"Model exists: {MODEL}")
    print(f"Labels exist: {LABELS}")
    print(f"Test image exists and can be read: {IMAGE}")


if __name__ == "__main__":
    main()

