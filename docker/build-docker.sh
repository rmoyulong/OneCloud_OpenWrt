#!/bin/bash

TAG=latest
if [ ! -z "$1" ];then
	TAG=$1
fi

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

gzip -dc $OUTDIR/*.gz | docker load
docker login --username=${{ secrets.DOCKER_USERNAME }} --password=${{ secrets.DOCKER_PASSWORD }}

docker tag mojialin/openwrt_onecloud mojialin/openwrt_onecloud:${TAG}
docker push mojialin/openwrt_onecloud
docker push mojialin/openwrt_onecloud:${TAG}

cd ..
mv hubdocker/opt/imgs/docker-img-openwrt-oncloud-${TAG}.gz openwrt/bin/targets/*/*/docker-img-openwrt-oncloud-${TAG}.gz
echo "::set-output name=status::success"
