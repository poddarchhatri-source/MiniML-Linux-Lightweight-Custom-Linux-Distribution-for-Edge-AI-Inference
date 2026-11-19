#!/usr/bin/env bash
set -euo pipefail

getent passwd miniml
systemctl is-enabled miniml-inference.service
systemctl show -p NoNewPrivileges miniml-inference.service
systemctl show -p ProtectSystem miniml-inference.service
sysctl kernel.randomize_va_space

