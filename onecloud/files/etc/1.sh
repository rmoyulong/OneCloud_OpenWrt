#!/bin/bash

mkdir -p /mnt/sda1/aria2
mkdir -p /mnt/sda1/aria2/download
mkdir -p /mnt/sda1/share

resize2fs /dev/mmcblk1p2
echo "# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

#mount -o remount rw /
exit 0">/etc/rc.local
rm -rf /etc/1.sh

