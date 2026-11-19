# Package Selection

The runtime package manifest is intentionally limited to systemd, Python, ONNX Runtime dependencies, image handling, networking, storage, device management, and diagnostic utilities.

Build-only tools such as GCC, Make, kernel headers, xorriso, and Live-build are not copied into the final image unless required at runtime.

ONNX Runtime is pinned to `1.17.1`, NumPy to `1.26.4`, and Pillow to `10.4.0` for the Debian 12 Python 3.11 environment. Availability must be verified on the build host before use.
