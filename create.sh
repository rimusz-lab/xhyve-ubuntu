#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ -z "$1" ]; then
    echo "missing path to iso"
    exit 1
fi

if [ "$(whoami)" != "root" ]; then
    echo "missing sudo"
    exit 1
fi

storagegb=16
memgb=2
cpus=1

dd if=/dev/zero of=storage.img bs=1G count=$storagegb

xhyve \
    -A \
    -c "$cpus" \
    -m "${memgb}G" \
    -l com1,stdio \
    -s 0:0,hostbridge \
    -s 31,lpc \
    -s 2:0,virtio-net \
    -s "3,ahci-cd,$1" \
    -s 4,virtio-blk,storage.img \
    -f "kexec,boot/vmlinuz,boot/initrd.gz,earlyprintk=serial console=ttyS0"
