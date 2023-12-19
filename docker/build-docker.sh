#!/bin/bash

TAG=latest
if [ ! -z "$1" ];then
	TAG=$1
fi

echo "TAG=$TAG" >> $GITHUB_ENV

TMPDIR=openwrt_rootfs
OUTDIR=opt/imgs
IMG_NAME=mojialin/openwrt_onecloud

[ -d "$TMPDIR" ] && rm -rf "$TMPDIR"
mkdir -p "$OUTDIR"
mkdir -p "$TMPDIR"  && \
gzip -dc openwrt-armvirt-onecloud-rootfs.tar.gz | ( cd "$TMPDIR" && tar xf - ) && \
cp -f rc.local "$TMPDIR/etc/" && \
rm -f "$TMPDIR/etc/bench.log" && \

(cd "$TMPDIR" && tar -czvf ../openwrt-armvirt-onecloud-rootfs.tar.gz .) && \

docker build -t ${IMG_NAME}:${TAG} . && \
rm -rf "$TMPDIR" && \
docker save ${IMG_NAME}:${TAG} | pigz -9 > $OUTDIR/docker-img-openwrt-oncloud-${TAG}.gz