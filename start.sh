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
    -f "kexec,boot/vmlinuz-4.4.0-21-generic,boot/initrd.img-4.4.0-21-generic,earlyprintk=serial console=ttyS0 acpi=off root=/dev/vda1 ro"
