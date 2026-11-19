#!/usr/bin/env bash
set -euo pipefail

systemctl status miniml-inference.service --no-pager
journalctl -u miniml-inference.service --no-pager -n 50
systemctl show -p User miniml-inference.service

