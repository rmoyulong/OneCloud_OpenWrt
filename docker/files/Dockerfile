FROM scratch
ADD openwrt-armvirt-onecloud-rootfs.tar.gz /
EXPOSE 22 80 443
# using exec format so that /sbin/init is proc 1 (see procd docs)
ENTRYPOINT ["/sbin/init"]
