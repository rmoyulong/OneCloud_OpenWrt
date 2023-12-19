#!/bin/bash

TAG=latest
echo "OWRT_TAG=$TAG" >> $GITHUB_ENV
		
dos2unix ./*.sh
dos2unix ./rc.local
chmod +x ./*.sh
chmod +x ./rc.local
		
TMPDIR=openwrt_rootfs
OUTDIR=opt/imgs

[ -d "$TMPDIR" ] && rm -rf "$TMPDIR"
mkdir -p "$OUTDIR"
mkdir -p "$TMPDIR"

cd openwrt_rootfs
tar zxvfp ../openwrt-armvirt-onecloud-rootfs.tar.gz
cp ../rc.local etc/rc.local
tar zcvfp ../openwrt-armvirt-onecloud-rootfs.tar.gz .

cd ..
docker build -t mojialin/openwrt_onecloud:${TAG} .
rm -rf "$TMPDIR"  
docker save mojialin/openwrt_onecloud:${TAG} | pigz -9 > $OUTDIR/docker-img-openwrt-oncloud-${TAG}.gz