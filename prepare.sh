#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

if [ -z "$1" ]; then
    echo "missing path to iso"
    exit 1
fi

dd if=/dev/zero of=~/Download/tmp.iso bs=$[2*1024] count=1
dd if="$1" bs=$[2*1024] skip=1 >> ~/Download/tmp.iso

diskinfo=$(hdiutil attach ~/Download/tmp.iso)

set +e
mkdir -p boot
mnt=$(echo "$diskinfo" | perl -ne '/(\/Volumes.*)/ and print $1')
cp "$mnt/install/vmlinuz" boot
cp "$mnt/install/initrd.gz" boot
set -e

disk=$(echo "$diskinfo" |  cut -d' ' -f1)
hdiutil eject "$disk"
rm ~/Download/tmp.iso
