#!/usr/bin/env bash

set -eox pipefail
IFS=$'\n\t'

if [ "$(whoami)" != "root" ]; then
    echo "missing sudo"
    exit 1
fi

memgb=2
cpus=1

xhyve \
    -A \
	-U "$(cat uuid.xhyve)" \
    -c "$cpus" \
    -m "${memgb}G" \
    -s 0,hostbridge \
    -s 2,virtio-net \
    -s 4,virtio-blk,storage.img \
	-f "kexec,boot/vmlinuz-4.4.0-31-generic,boot/initrd.img-4.4.0-31-generic,root=/dev/vda1 ro"
