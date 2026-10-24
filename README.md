# openwrt-onecloud-玩客云三代(WS1608)<br>
[![build](https://img.shields.io/github/actions/workflow/status/rmoyulong/OneCloud_OpenWrt/all-quiker.yml)](https://github.com/rmoyulong/OneCloud_OpenWrt/actions/workflows/all-quiker.yml) [![downloads](https://img.shields.io/github/downloads/rmoyulong/OneCloud_OpenWrt/total)](https://github.com/rmoyulong/OneCloud_OpenWrt/releases) [![downloads@latest](https://img.shields.io/github/downloads/rmoyulong/OneCloud_OpenWrt/latest/total)](https://github.com/rmoyulong/OneCloud_OpenWrt/releases/latest)<br>
---------------------------------------------------------------<br>
使用MosDns作为默认的DNS解析<br>
请根据自己的需求自行修改<br>
使用openclash，请使用HTTP(S)&SOCKS5 混合代理端口（默认1092）<br>
---------------------------------------------------------------<br>
登录192.168.31.110

ssh登录

root<br>
password<br>

注解：<br>
1.使用双USB公头线刷机: 双公头的USB线连接电脑和玩客云，使用USB_Burning_Tool刷机。<br>
2.使用rufus写盘启动：将IMG用rufus等写盘工具烧录到U盘上，插入玩客云USB口启动。玩客云必须使用使用USB_Burning_Tool刷过eMMC.burn.img<br>
eMMC.burn.img下载地址： https://github.com/rmoyulong/u-boot-onecloud/releases/download/Onecloud_Uboot_23.12.24_22.17.50/eMMC.burn.img<br>
<br>
USB_Burning_Tool下载地址： https://xd1314.lanzoul.com/iXHbz17bqjhc<br>

hub docker版是为hub.docker.com特意编译的版本。本质是个armbian用docker方式装入的op的文件。<br>
食用方法：<br>
ip link set eth0 promisc on<br>
docker network create -d macvlan --subnet=192.168.31.0/24 --gateway=192.168.31.1 -o parent=eth0 macnet<br>
docker pull mojialin/openwrt_onecloud:latest<br>
docker run -itd --name=onecloud --restart=unless-stopped --network=macnet --privileged=true mojialin/openwrt_onecloud:latest /sbin/init<br>
--------------------------------------------------------------------------<br>
玩客云使用docker版，举个列子（地址可能会变，酌情自己改正）：<br>
https://github.com/hzyitc/armbian-onecloud/releases/download/ci-20240311-162146-UTC/Armbian-unofficial_24.5.0-trunk_Onecloud_bookworm_edge_6.7.9_minimal.burn.img.xz <br>

用双公头刷完armbian后，下载 https://github.com/rmoyulong/OneCloud_OpenWrt/releases/download/Docker_Latest/immortalwrt-meson-meson8b-thunder-onecloud-rootfs.tar.gz <br>

把immortalwrt-meson-meson8b-thunder-onecloud-rootfs.tar.gz改名op.tar.gz <br>
ssh armbian输入以下命令 <br>
1.ip link set eth0 promisc on <br>
2.docker network create -d macvlan --subnet=192.168.31.0/24 --gateway=192.168.31.1 -o parent=eth0 macnet <br>
[↑自己根据 盒子 所在网段修改，如：盒子IP:192.168.1.175，则192.168.31.0/24 改成 192.168.1.0/24，192.168.31.1改成主路由地址]<br>
3.docker import op.tar.gz onecloud_openwrt <br>
4.docker run --restart always --name onecloud -d --network macnet --ip 192.168.31.110 --privileged onecloud_openwrt /sbin/init <br>
5.修改创建的openwrt 默认lan口配置<br>
(须结合实际网络情况，不能照抄配置)<br>
docker exec -it onecloud bash<br>
vi etc/config/network<br>

[按下键盘 Ins 键切至输入状态]<br>
config interface 'loopback'<br>
option ifname 'lo'<br>
option proto 'static'<br>
option ipaddr '127.0.0.1'<br>
option netmask '255.0.0.0'<br>
<br>
config globals 'globals'<br>
<br>
config interface 'lan'<br>
option type 'bridge'<br>
option ifname 'eth0'<br>
option proto 'static'<br>
option ipaddr '192.168.31.110' # 填写openwrt容器的IP<br>
option netmask '255.255.255.0'<br>
option getway '192.168.31.1' # 修改为你自己主路由的IP<br>
option dns '192.168.31.1' # DNS 可填主路由IP 也可填公共DNS<br>
<br>
config interface 'utun'<br>
option proto 'none'<br>
option ifname 'utun'<br>
option device 'utun'<br>
<br>
config interface 'docker'<br>
option ifname 'docker0'<br>
option proto 'none'<br>
option auto '0'<br>
<br>
config device<br>
option type 'bridge'<br>
option name 'docker0'<br>
<br>
[按下键盘 Esc 键退出输入状态，英文键盘输入 :wq 回车 保存退出]<br>
<br>
重启容器网络服务<br>
/etc/init.d/network restart<br>
<br>
退出容器<br>
exit<br>
---------------------------------------------------------------------------<br>

启动命令在/etc/rc.local中修改<br>
下载目录更改需要修改/etc/aria2/aria2.conf.main<br>
并赋予下载目录777权限<br>
