rm -rf feeds/packages/net/homeproxy
rm -rf feeds/luci/applications/luci-app-homeproxy
rm -rf feeds/kenzo/homeproxy
rm -rf feeds/kenzo/luci-app-homeproxy
rm -rf feeds/luci/applications/luci-app-turboacc
rm -rf feeds/luci/applications/luci-app-kodexplorer
rm -rf feeds/luci/applications/luci-app-zerotier
rm -rf feeds/packages/lang/ruby
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/packages/net/aria2
rm -rf feeds/packages/net/ariang 
rm -rf feeds/luci/luci-app-aria2
###############################
rm -rf  package/openwrt-passwall/shadowsocks-rust
rm -rf  package/openwrt-passwall/hysteria
####################################################
#解决shadowsocks-libev编译错误
rm -rf feeds/packages/net/shadowsocks-libev
cp -rf ./package/shadowsocks-libev feeds/packages/net/
#####################################################
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang
#####################################################