#!/bin/sh
#
# SD card: /dev/mmcblk0
# eMMC: /dev/mmcblk1

_help () {
    echo "./resize.sh emmc|sd\n"
    exit 0
}

_resize() {
    parted /dev/${DISK} resizepart 2 100%
    losetup /dev/loop0 /dev/${DISK}p2
    resize2fs -f /dev/loop0
}

case $1 in
    emmc)   DISK=mmcblk1 _resize    ;;
    sd)     DISK=mmcblk0 _resize    ;;
    *)      _help                   ;;
esac
