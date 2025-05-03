#!/bin/bash

rm -rf package/libs/mbedtls
rm -rf package/libs/ustream-ssl
rm -rf package/libs/uclient
rm -rf package/network/services/hostapd
rm -rf feeds/packages/net/curl

sudo curl -L -o rmoyulong.tar.gz https://github.com/rmoyulong/AX6-Actions_Lede/releases/download/union_package/openwrt_orther.tar.gz
tar zxvfp rmoyulong.tar.gz