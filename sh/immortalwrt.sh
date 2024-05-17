#!/bin/bash

# 移除要替换的包
rm -rf feeds/packages/net/alist
rm -rf feeds/packages/net/aria2
rm -rf feeds/packages/net/ariang
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/msd_lite
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-msd_lite
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan
#rm -rf feeds/luci/applications/luci-app-homeproxy
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-amlogic
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall2
rm -rf feeds/luci/applications/luci-app-turboacc
#rm -rf feeds/packages/net/shadowsocks-libev

#aria2
chmod -R 777 $GITHUB_WORKSPACE/$OWRT_FILES/etc/aria2
chmod -R 777 $GITHUB_WORKSPACE/$OWRT_FILES/mnt/sda1/aria2
chmod -R 777 $GITHUB_WORKSPACE/$OWRT_FILES/mnt/sda1/aria2/download
chmod -R 755 $GITHUB_WORKSPACE/$OWRT_FILES/mnt/sda1/share

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> feeds.conf.default
echo 'src-git small https://github.com/kenzok8/small' >> feeds.conf.default
######################################################################################
#echo 'src-git homeproxy https://github.com/immortalwrt/homeproxy' >> feeds.conf.default
######################################################################################
#echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >> feeds.conf.default
#echo 'src-git passwall2 https://github.com/xiaorouji/openwrt-passwall2' >> feeds.conf.default
#######################################################################################
#git_sparse_clone master https://github.com/fw876/helloworld helloworld
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall openwrt-passwall
#git_sparse_clone main https://github.com/xiaorouji/openwrt-passwall2 openwrt-passwall2
git_sparse_clone master https://github.com/rmoyulong/AX6-Actions_Lede pcre
git_sparse_clone master https://github.com/rmoyulong/AX6-Actions_Lede aria2
git_sparse_clone master https://github.com/rmoyulong/AX6-Actions_Lede zerotier
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-zerotier
git_sparse_clone main https://github.com/kenzok8/small-package ariang
git_sparse_clone master https://github.com/kiddin9/openwrt-packages dnsforwarder
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-turboacc
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-vlmcsd
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-kodexplorer
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-usb-printer
git_sparse_clone master https://github.com/kiddin9/openwrt-packages mosdns
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-mosdns
git_sparse_clone master https://github.com/kiddin9/openwrt-packages shadowsocksr-libev
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-ssr-plus
#echo 'src-git my_luci https://github.com/rmoyulong/my_luci' >> feeds.conf.default

git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan

# 在线用户
git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-onliner
sudo chmod -Rf 755 package/luci-app-onliner

# msd_lite
git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite

#theme
git_sparse_clone master https://github.com/rmoyulong/AX6-Actions_Lede luci-theme-openwrt-2020

# 取消主题默认设置
find package/luci-theme-*/* -type f -name '*luci-theme-*' -print -exec sed -i '/set luci.main.mediaurlbase/d' {} \;

#Open Clash
cd ./package

git clone --depth=1 --single-branch --branch "dev" https://github.com/vernesong/OpenClash.git
#预置OpenClash内核和GEO数据
export CORE_VER=https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/core_version
export CORE_TUN=https://github.com/vernesong/OpenClash/raw/core/dev/premium/clash-linux
export CORE_DEV=https://github.com/vernesong/OpenClash/raw/core/dev/dev/clash-linux
export CORE_MATE=https://github.com/vernesong/OpenClash/raw/core/dev/meta/clash-linux

export CORE_TYPE=$(echo $OWRT_TARGET | grep -Eiq "64|86" && echo "amd64" || echo "arm64")
export TUN_VER=$(curl -sfL $CORE_VER | sed -n "2{s/\r$//;p;q}")

export GEO_MMDB=https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb
export GEO_SITE=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geosite.dat
export GEO_IP=https://github.com/Loyalsoldier/v2ray-rules-dat/raw/release/geoip.dat

cd ./OpenClash/luci-app-openclash/root/etc/openclash

curl -sfL -o ./Country.mmdb $GEO_MMDB
curl -sfL -o ./GeoSite.dat $GEO_SITE
curl -sfL -o ./GeoIP.dat $GEO_IP

mkdir ./core && cd ./core

curl -sfL -o ./tun.gz "$CORE_TUN"-"$CORE_TYPE"-"$TUN_VER".gz
gzip -d ./tun.gz && mv ./tun ./clash_tun

curl -sfL -o ./meta.tar.gz "$CORE_MATE"-"$CORE_TYPE".tar.gz
tar -zxf ./meta.tar.gz && mv ./clash ./clash_meta

curl -sfL -o ./dev.tar.gz "$CORE_DEV"-"$CORE_TYPE".tar.gz
tar -zxf ./dev.tar.gz

chmod +x ./clash* ; rm -rf ./*.gz
