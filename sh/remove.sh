#rm -rf feeds/packages/net/ztdns
#rm -rf feeds/packages/net/zerotier
#rm -rf feeds/packages/libs/libnatpmp
#只有openwrt/luci没有feeds/luci/applications/luci-app-zerotier
#openwrt/luci没有feeds/luci/applications/luci-app-kodexplorer
#lede/luci没有feeds/luci/applications/luci-app-kodexplorer
#rm -rf feeds/luci/applications/luci-app-zerotier
rm -rf feeds/luci/applications/luci-app-turboacc
#immortarwrt 自带luci-app-kodexplorer
#rm -rf feeds/luci/applications/luci-app-kodexplorer
rm -rf feeds/packages/net/mosdns
rm -rf feeds/small/mosdns
rm -rf feeds/small/luci-app-mosdns
rm -rf feeds/small/shadowsocksr-libev
rm -rf feeds/small/luci-app-ssr-plus
rm -rf feeds/packages/net/homeproxy
rm -rf feeds/luci/applications/luci-app-homeproxy
####################################################
#解决shadowsocks-libev编译错误
git clone https://github.com/rmoyulong/AX6-Actions_Lede rmoyulong
rm -rf feeds/packages/net/shadowsocks-libev
cp -rf ./rmoyulong/shadowsocks-libev feeds/packages/net/

rm -rf package/libs/mbedtls
rm -rf package/libs/ustream-ssl
rm -rf package/libs/uclient
cp -rf ./rmoyulong/libs/mbedtls package/libs/
cp -rf ./rmoyulong/libs/ustream-ssl package/libs/
cp -rf ./rmoyulong/libs/uclient package/libs/

rm -rf rmoyulong
#####################################################