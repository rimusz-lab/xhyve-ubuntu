#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ "$(whoami)" != "root" ]; then
    echo "missing sudo"
    exit 1
fi

memgb=2
cpus=1

xhyve \
    -c "$cpus" \
    -m "${memgb}G" \
    -s 0:0,hostbridge \
    -s 31,lpc \
    -l com1,stdio \
    -s 2:0,virtio-net \
    -s 4,virtio-blk,storage.img \
	-f "kexec,$(ls boot/vmlinuz-*),$(ls boot/initrd.img-*),earlyprintk=serial console=ttyS0 acpi=off root=/dev/vda1 ro"
