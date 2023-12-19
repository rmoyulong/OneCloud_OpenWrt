#!/bin/bash

TMPDIR=openwrt_rootfs
OUTDIR=opt/imgs
IMG_NAME=mojialin/openwrt_onecloud

[ -d "$TMPDIR" ] && rm -rf "$TMPDIR"
mkdir -p "$OUTDIR"
mkdir -p "$TMPDIR"

cd "$TMPDIR"
tar zxvfp ../openwrt-armvirt-onecloud-rootfs.tar.gz
cp ../rc.local ./etc/rc.local

tar zcvfp ../openwrt-armvirt-onecloud-rootfs.tar.gz .

cd ..

docker build -t mojialin/openwrt_onecloud:$OWRT_TAG .
rm -rf "$TMPDIR" 
docker save mojialin/openwrt_onecloud:$OWRT_TAG | pigz -9 > $OUTDIR/docker-img-openwrt-oncloud-$OWRT_TAG.gz