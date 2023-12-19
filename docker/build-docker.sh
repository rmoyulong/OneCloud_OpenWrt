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
mkdir -p "$TMPDIR"

cd "$TMPDIR"
tar zxvfp gzip openwrt-armvirt-onecloud-rootfs.tar.gz
mv ../rc.local "$TMPDIR/etc/"

tar zcvfp ../openwrt-armvirt-onecloud-rootfs.tar.gz .

cd ..

docker build -t ${IMG_NAME}:${TAG} .
rm -rf "$TMPDIR" 
docker save ${IMG_NAME}:${TAG} | pigz -9 > $OUTDIR/docker-img-openwrt-oncloud-${TAG}.gz