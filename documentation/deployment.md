# QEMU Deployment

On an x86_64 Linux host:

```bash
./scripts/run_qemu.sh output/MiniML-Linux.iso
```

To change resources:

```bash
QEMU_CPU=4 QEMU_RAM=2048 ./scripts/run_qemu.sh
```

Inside the guest:

```bash
uname -m
uname -r
systemctl status miniml-inference.service --no-pager
journalctl -u miniml-inference.service --no-pager
/opt/miniml/ml/inference.py
free -h
```
