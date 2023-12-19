#!/bin/bash

TAG=latest
echo "OWRT_TAG=$TAG" >> $GITHUB_ENV
TMPDIR=openwrt_rootfs
OUTDIR=opt/imgs
IMG_NAME=mojialin/openwrt_onecloud
		
dos2unix ./*.sh
dos2unix ./rc.local
chmod +x ./*.sh
chmod +x ./rc.local
		
[ -d "$TMPDIR" ] && rm -rf "$TMPDIR"
mkdir -p "$OUTDIR"
mkdir -p "$TMPDIR"  && \
gzip -dc openwrt-armvirt-onecloud-rootfs.tar.gz | ( cd "$TMPDIR" && tar xf - ) && \
cp -f rc.local "$TMPDIR/etc/" && \
(cd "$TMPDIR" && tar cf ../openwrt-armvirt-onecloud-rootfs.tar .) && \
rm -f DockerImg-OpenwrtArm32-${TAG}.gz && \
docker build -t ${IMG_NAME}:${TAG} . && \
rm -f  openwrt-armvirt-onecloud-rootfs.tar && \
rm -rf "$TMPDIR" && \
docker save ${IMG_NAME}:${TAG} | pigz -9 > $OUTDIR/docker-img-openwrt-oncloud-${TAG}.gz