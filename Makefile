SHELL := /usr/bin/bash

.PHONY: check deps configure build verify clean test qemu

check:
	./scripts/check_environment.sh

deps:
	sudo ./build/install_dependencies.sh

configure:
	./build/configure_build.sh

build:
	sudo ./build/build_iso.sh

verify:
	./build/verify_build.sh

test:
	./tests/test_boot.sh
	python3 ./tests/test_model.py
	python3 ./tests/test_inference.py

qemu:
	./scripts/run_qemu.sh

clean:
	./build/clean_build.sh

