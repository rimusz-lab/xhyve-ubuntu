#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ -z "$1" ]; then
    echo "missing path to iso"
    exit 1
fi

dd if=/dev/zero of=tmp.iso bs=$[2*1024] count=1
dd if="$1" bs=$[2*1024] skip=1 >> tmp.iso

hdiutil attach tmp.iso

mkdir -p boot
cp "/Volumes/Ubuntu-Server 16/install/vmlinuz" boot
cp "/Volumes/Ubuntu-Server 16/install/initrd.gz" boot

hdiutil eject "/Volumes/Ubuntu-Server 16"
rm tmp.iso
