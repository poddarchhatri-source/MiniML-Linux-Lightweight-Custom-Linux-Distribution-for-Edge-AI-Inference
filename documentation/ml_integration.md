# ONNX Runtime Integration

The selected model is SqueezeNet 1.1-7 from the ONNX Model Zoo. It accepts a 224x224 RGB NCHW tensor and is suitable for CPU-only inference.

Preprocessing:

1. Convert the image to RGB.
2. Resize to 224x224.
3. Scale pixels to `[0,1]`.
4. Normalize with ImageNet mean `[0.485,0.456,0.406]` and standard deviation `[0.229,0.224,0.225]`.
5. Convert HWC to CHWC NCHW layout.

The application requests `CPUExecutionProvider` explicitly and verifies that ONNX Runtime reports it as available.
