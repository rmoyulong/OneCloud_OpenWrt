#!/bin/bash

if [ ! -z "$1" ];then
    ip="$1"
fi

if [ ! -z "$2" ];then
    ip_server="$2"
fi

#默认主路由
rm -rf ./files/etc/config/network

#如果files/etc/config文件夹不存在，创建文件夹
if [ ! -d "./files/etc/config" ]; then
  mkdir -p ./files/etc/config
fi

# 使用正则表达式校验IP地址格式是否符合规范
if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	echo "玩客云IP地址 $ip 符合规范。"
else
	echo "玩客云IP地址 $ip 不符合规范。"
	exit 1
fi
		  
if [[ $ip_server =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	echo "config interface 'loopback'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'
	option device 'lo'

config globals 'globals'

config interface 'lan'
	option proto 'static'
	option ipaddr '$ip'
	option netmask '255.255.255.0'
	option ip6assign '60'
	option device 'br-lan'
	option gateway '$ip_server'
	list dns '$ip_server'

config interface 'utun'
	option proto 'none'
	option ifname 'utun'
	option device 'utun'
	option auto '0'

config interface 'docker'
	option proto 'none'
	option auto '0'
	option device 'docker0'

config device
	option type 'bridge'
	option name 'docker0'

config device
	option name 'br-lan'
	option type 'bridge'
	list ports 'eth0'

config interface 'lan6'
	option proto 'dhcpv6'
	option reqaddress 'try'
	option reqprefix 'auto'
	option device 'br-lan'">files/etc/config/network
else
	echo "主路由IP地址 $ip 不符合规范。"
	exit 1
fi


