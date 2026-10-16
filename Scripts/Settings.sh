#!/bin/bash
ip="192.168.31.1"
iname="Openwrt"
ithemes="luci-theme-material"
if [ ! -z "$1" ];then
    ip=$1
fi
if [ ! -z "$2" ];then
    iname=$2
fi
if [ ! -z "$3" ];then
    ithemes="luci-theme-$3"
fi

#修改默认主题
#替换主题为原版argon
if [[ "$4" == *"lede"* ]]; then
  rm -rf feeds/luci/themes/luci-theme-argon
  rm -rf package/luci-theme-argon
  git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
  
  #修改lede默认时间格式
  sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' $(find ./package/*/autocore/files/ -type f -name "index.htm")
fi

#最新golang
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang


#修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/${ip}/g" ./package/base-files/files/bin/config_generate
#修改默认主机名
sed -i "s/hostname='.*'/hostname='${iname}'/g" ./package/base-files/files/bin/config_generate
#修改默认时区
sed -i "s/timezone='.*'/timezone='CST-8'/g" ./package/base-files/files/bin/config_generate
sed -i "/timezone='.*'/a\\\t\t\set system.@system[-1].zonename='Asia/Shanghai'" ./package/base-files/files/bin/config_generate

# Modify default NTP server
echo 'Modify default NTP server...'
sed -i 's/ntp.aliyun.com/ntp.ntsc.ac.cn/' package/base-files/files/bin/config_generate
sed -i 's/time1.cloud.tencent.com/ntp.aliyun.com/' package/base-files/files/bin/config_generate
sed -i 's/time.ustc.edu.cn/cn.ntp.org.cn/' package/base-files/files/bin/config_generate
sed -i 's/cn.pool.ntp.org/pool.ntp.org/' package/base-files/files/bin/config_generate

######################################################################################################
#luci Makefile基础配置

if [ ! -d "./feeds/luci/collections/luci" ]; then
  mkdir -p ./feeds/luci/collections/luci
fi

cp -rf $GITHUB_WORKSPACE/patch/luci/Makefile ./feeds/luci/collections/luci
# 修改 argon 为默认主题
if [[ "$4" == *"lede"* ]]; then
  cat <<EOF >>./feeds/luci/collections/luci/Makefile

LUCI_TYPE:=col
LUCI_BASENAME:=luci

LUCI_TITLE:=Standard OpenWrt set including full admin with ppp support and the default Bootstrap theme
LUCI_DEPENDS:= \
	+uhttpd +uhttpd-mod-ubus +luci-mod-admin-full +luci-theme-$3 \
	+dos2unix +luci-proto-ppp +libiwinfo-lua \
	+rpcd-mod-rrdns

PKG_LICENSE:=Apache-2.0

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
EOF
else
  cat <<EOF >>./feeds/luci/collections/luci/Makefile

LUCI_TYPE:=col
LUCI_BASENAME:=luci

LUCI_TITLE:=LuCI interface with Uhttpd as Webserver (default)
LUCI_DESCRIPTION:=Standard OpenWrt set including package management and attended sysupgrades support
LUCI_DEPENDS:= \
    +luci-theme-$3 \
	+luci-light \
	+dos2unix \
	+luci-app-opkg

PKG_LICENSE:=Apache-2.0

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
EOF
fi

######################################################################################################

#固件版本号添加个人标识和日期
[ -e package/lean/default-settings/files/zzz-default-settings ] && sed -i "/DISTRIB_DESCRIPTION='*'/d" package/lean/default-settings/files/zzz-default-settings
[ -e package/lean/default-settings/files/zzz-default-settings ] && && echo "DISTRIB_DESCRIPTION='Openwrt LEDE 莫小小($(TZ=UTC-8 date +%Y.%m.%d))'" >> package/lean/default-settings/files/zzz-default-settings
[ ! -e package/lean/default-settings/files/zzz-default-settings ] && sed -i "/DISTRIB_DESCRIPTION='*'/d" package/base-files/files/etc/openwrt_release
[ ! -e package/lean/default-settings/files/zzz-default-settings ] && echo "DISTRIB_DESCRIPTION='ImmortalWRT SNAPSHOT 莫小小($(TZ=UTC-8 date +%Y.%m.%d))'" >> package/base-files/files/etc/openwrt_release

# 修改默认wifi名称ssid为moyulong
sed -i 's/ssid=OpenWrt/ssid=moyulong/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改默认wifi密码key为password
sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${devidx}.encryption=psk2/a\set wireless.default_radio${devidx}.key=password' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 设置密码为password
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/' package/base-files/files/etc/shadow

#连接数
sed -i '/customized in this file/a fs.file-max=102400\nnet.ipv4.neigh.default.gc_thresh1=512\nnet.ipv4.neigh.default.gc_thresh2=2048\nnet.ipv4.neigh.default.gc_thresh3=4096\nnet.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

# 修正连接数（by ベ七秒鱼ベ）
sed -i '/customized in this file/a net.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

#修正ttyd
sed -i 's|/bin/login|/bin/login -f root|g' feeds/packages/utils/ttyd/files/ttyd.config

# Modify default banner
echo 'Modify default banner...'
echo "      %D %C ${build_date}                   " >> package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >> package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >> package/base-files/files/etc/banner
echo "                                                               " >> package/base-files/files/etc/banner
