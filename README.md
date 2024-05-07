# openwrt-onecloud-玩客云


登录192.168.1.110

ssh登录

root
password

注解：
1.使用双USB公头线刷机: 双公头的USB线连接电脑和玩客云，使用USB_Burning_Tool刷机。
2.使用rufus写盘启动：将IMG用rufus等写盘工具烧录到U盘上，插入玩客云USB口启动。玩客云必须使用使用USB_Burning_Tool刷过eMMC.burn.img
eMMC.burn.img下载地址： https://github.com/rmoyulong/u-boot-onecloud/releases/download/Onecloud_Uboot_23.12.24_22.17.50/eMMC.burn.img
USB_Burning_Tool下载地址： https://xd1314.lanzoul.com/iXHbz17bqjhc

hub docker版是为hub.docker.com特意编译的版本。本质是个可以使用docker装入armbian的文件。
食用方法：
ip link set eth0 promisc on
docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 macnet
docker pull mojialin/openwrt_onecloud:latest
docker run -itd --name=onecloud --restart=unless-stopped --network=macnet --privileged=true mojialin/openwrt_onecloud:latest /sbin/init
