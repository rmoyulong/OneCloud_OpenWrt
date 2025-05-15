#!/bin/bash
             
##配置ip等
#sed -i 's/192.168.1.1/192.168.1.110/g' package/base-files/files/bin/config_generate
#修改默认IP地址
sed -i "s/192\.168\.[0-9]*\.[0-9]*/$OWRT_IP/g" ./package/base-files/files/bin/config_generate
#修改默认主机名
sed -i "s/hostname='.*'/hostname='$OWRT_NAME'/g" ./package/base-files/files/bin/config_generate
#修改默认时区
sed -i "s/timezone='.*'/timezone='CST-8'/g" ./package/base-files/files/bin/config_generate
sed -i "/timezone='.*'/a\\\t\t\set system.@system[-1].zonename='Asia/Shanghai'" ./package/base-files/files/bin/config_generate


# Modify default NTP server
echo 'Modify default NTP server...'
sed -i 's/ntp.aliyun.com/ntp.ntsc.ac.cn/' package/base-files/files/bin/config_generate
sed -i 's/time1.cloud.tencent.com/ntp.aliyun.com/' package/base-files/files/bin/config_generate
sed -i 's/time.ustc.edu.cn/cn.ntp.org.cn/' package/base-files/files/bin/config_generate
sed -i 's/cn.pool.ntp.org/pool.ntp.org/' package/base-files/files/bin/config_generate

#固件版本号添加个人标识和日期
[ -e package/lean/default-settings/files/zzz-default-settings ] && sed -i "s/DISTRIB_DESCRIPTION='.*OpenWrt '/DISTRIB_DESCRIPTION='莫小小($(TZ=UTC-8 date +%Y.%m.%d))@OpenWrt '/g" package/lean/default-settings/files/zzz-default-settings
#[ ! -e package/lean/default-settings/files/zzz-default-settings ] && sed -i "/DISTRIB_DESCRIPTION='*'/d" package/base-files/files/etc/openwrt_release
[ ! -e package/lean/default-settings/files/zzz-default-settings ] && echo "DISTRIB_DESCRIPTION='莫小小($(TZ=UTC-8 date +%Y.%m.%d))@lean '" >> package/base-files/files/etc/openwrt_release

# 设置密码为password
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/' package/base-files/files/etc/shadow

#连接数
sed -i '/customized in this file/a fs.file-max=102400\nnet.ipv4.neigh.default.gc_thresh1=512\nnet.ipv4.neigh.default.gc_thresh2=2048\nnet.ipv4.neigh.default.gc_thresh3=4096\nnet.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

# 修改默认wifi名称ssid为moyulong
sed -i 's/ssid=OpenWrt/ssid=moyulong/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改默认wifi密码key为password
sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${devidx}.encryption=psk2/a\set wireless.default_radio${devidx}.key=password' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 修改 argon 为默认主题
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# hijack dns queries to router(firewall)
sed -i '/REDIRECT --to-ports 53/d' package/network/config/firewall/files/firewall.user
# 把局域网内所有客户端对外ipv4的53端口查询请求，都劫持指向路由器(iptables -n -t nat -L PREROUTING -v --line-number)(iptables -t nat -D PREROUTING 2)
echo 'iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user
echo 'iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user
# 把局域网内所有客户端对外ipv6的53端口查询请求，都劫持指向路由器(ip6tables -n -t nat -L PREROUTING -v --line-number)(ip6tables -t nat -D PREROUTING 1)
echo '[ -n "$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user
echo '[ -n "$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user

# Modify default banner
echo 'Modify default banner...'
build_date=$(date +"%Y-%m-%d %H:%M:%S")
echo "      %D %C ${build_date}                   " >> package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >> package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >> package/base-files/files/etc/banner
echo "                                                               " >> package/base-files/files/etc/banner