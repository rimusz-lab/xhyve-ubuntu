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
MB=$[1024*1024]
GB=$[1024*$MB]

dd if=/dev/zero of=~/Download/storage.img bs=$[1*$GB] count=$storagegb

xhyve \
    -A \
    -c "$cpus" \
    -m "${memgb}G" \
    -s 0,hostbridge \
    -s 2,virtio-net \
    -s "3,ahci-cd,$1" \
    -s 4,virtio-blk,~/Download/storage.img \
    -s 31,lpc \
    -l com1,stdio \
    -f "kexec,boot/vmlinuz,boot/initrd.gz,earlyprintk=serial console=ttyS0"
