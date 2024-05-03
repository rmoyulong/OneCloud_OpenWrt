#!/bin/bash

# 移除要替换的包
rm -rf feeds/packages/net/alist
#rm -rf feeds/packages/net/aria2
#rm -rf feeds/packages/net/ariang
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
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall2
rm -rf feeds/luci/applications/luci-app-turboacc
rm -rf feeds/packages/net/shadowsocks-libev

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
#echo 'src-git small https://github.com/kenzok8/small' >> feeds.conf.default
#echo 'src-git helloworld https://github.com/stupidloud/helloworld' >> feeds.conf.default
echo 'src-git my_luci https://github.com/rmoyulong/my_luci' >> feeds.conf.default
#echo 'src-git homeproxy https://github.com/immortalwrt/homeproxy' >> feeds.conf.default
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages aria2
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages ariang
#it_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-vlmcsd
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-kodexplorer
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-usb-printer
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-turboacc
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-ssr-plus
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages shadowsocksr-libev
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-bypass
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-passwall
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-passwall2

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

#设置armv7 32位的openclash
mkdir -p files/etc/openclash/core
mkdir -p files/etc/profile.d
mkdir -p files/root

CLASH_DEV_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/dev/clash-linux-armv7.tar.gz"
CLASH_TUN_URL=$(curl -fsSL https://api.github.com/repos/vernesong/OpenClash/contents/dev/premium\?ref\=core | grep download_url | grep armv7 | awk -F '"' '{print $4}')
CLASH_META_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/dev/meta/clash-linux-armv7.tar.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
GEO_MMDB_URL="https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb"
#kr_URL="https://raw.githubusercontent.com/shiyu1314/openwrt-onecloud/main/sh/1.sh"
#xx_URL="https://raw.githubusercontent.com/shiyu1314/openwrt-onecloud/main/sh/30-sysinfo.sh"

wget -qO- $CLASH_DEV_URL | tar xOvz > files/etc/openclash/core/clash
wget -qO- $CLASH_TUN_URL | gunzip -c > files/etc/openclash/core/clash_tun
wget -qO- $CLASH_META_URL | tar xOvz > files/etc/openclash/core/clash_meta
wget -qO- $GEOIP_URL > files/etc/openclash/GeoIP.dat
wget -qO- $GEOSITE_URL > files/etc/openclash/GeoSite.dat
wget -qO- $GEO_MMDB_URL > files/etc/openclash/Country.mmdb
