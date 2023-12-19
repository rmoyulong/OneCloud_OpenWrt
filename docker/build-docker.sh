#!/bin/bash

TMPDIR=openwrt_rootfs
OUTDIR=opt/imgs

[ -d "$TMPDIR" ] && rm -rf "$TMPDIR"
mkdir -p "$OUTDIR"
mkdir -p "$TMPDIR"   && \
gzip -dc openwrt-armvirt-onecloud-rootfs.tar.gz | ( cd "$TMPDIR" && tar xf - ) && \
cp -f rc.local "$TMPDIR/etc/" && \
(cd "$TMPDIR" && tar cf ../openwrt-armvirt-onecloud-rootfs.tar .) && \
docker build -t mojialin/openwrt_onecloud:${OWRT_TAG} . && \
rm -rf "$TMPDIR"  && \
docker save mojialin/openwrt_onecloud:${OWRT_TAG} | pigz -9 > $OUTDIR/docker-img-openwrt-oncloud-${OWRT_TAG}.gz