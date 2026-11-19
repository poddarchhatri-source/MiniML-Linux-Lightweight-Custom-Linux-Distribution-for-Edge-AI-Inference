# Benchmarking

Run the inference benchmark inside the guest:

```bash
./scripts/benchmark.sh
```

It reads the same model and test image for every iteration and records average, median, minimum, maximum, and 95th-percentile latency.

Image size:

```bash
./scripts/measure_image_size.sh /path/to/Debian-stock.iso
```

Boot, RAM, package count, and kernel sizes must be collected with commands in the guest or host and inserted into the report only after measurement.
