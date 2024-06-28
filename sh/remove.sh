#rm -rf feeds/packages/net/zerotier
#rm -rf feeds/luci/applications/luci-app-zerotier
rm -rf feeds/luci/applications/luci-app-turboacc
rm -rf feeds/packages/net/homeproxy
rm -rf feeds/luci/applications/luci-app-homeproxy
rm -rf feeds/kenzo/homeproxy
rm -rf feeds/kenzo/luci-app-homeproxy
rm -rf feeds/packages/lang/ruby
###############################
rm -rf  package/openwrt-passwall/shadowsocks-rust
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