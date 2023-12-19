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

cd /mnt/docker/openwrt_rootfs
tar zxvfp /mnt/docker/openwrt-armvirt-onecloud-rootfs.tar.gz
cp /mnt/docker/rc.local /mnt/docker/openwrt_rootfs/etc/rc.local
tar zcvfp /mnt/docker/openwrt-armvirt-onecloud-rootfs.tar.gz .

cd /mnt/docker/
docker build -t mojialin/openwrt_onecloud:${TAG} .
rm -rf "$TMPDIR"  
docker save mojialin/openwrt_onecloud:${TAG} | pigz -9 > $OUTDIR/docker-img-openwrt-oncloud-${TAG}.gz