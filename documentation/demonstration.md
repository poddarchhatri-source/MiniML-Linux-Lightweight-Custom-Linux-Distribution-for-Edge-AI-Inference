# 3–5 Minute Demonstration

## 1. Start QEMU

```bash
./scripts/run_qemu.sh
```

## 2. Show boot and identity

```bash
uname -a
cat /etc/os-release
systemctl --failed
```

## 3. Show kernel and RAM

```bash
uname -r
free -h
```

## 4. Show automatic service

```bash
systemctl status miniml-inference.service --no-pager
journalctl -u miniml-inference.service --no-pager -n 20
```

## 5. Run classification

```bash
./scripts/test_inference.sh
```

Suggested screenshots:

- QEMU boot
- `/etc/os-release`
- `uname -r`
- systemd service status
- journal output
- top five predictions
- inference latency
- RAM usage
- benchmark or stock Debian comparison table
