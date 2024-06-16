# openwrt-onecloud-玩客云<br>
---------------------------------------------------------------<br>
使用MosDns作为默认的DNS解析<br>
请根据自己的需求自行修改<br>
---------------------------------------------------------------<br>
登录192.168.1.110

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
docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 macnet<br>
docker pull mojialin/openwrt_onecloud:latest<br>
docker run -itd --name=onecloud --restart=unless-stopped --network=macnet --privileged=true mojialin/openwrt_onecloud:latest /sbin/init<br>
--------------------------------------------------------------------------<br>
玩客云使用docker版，举个列子（地址可能会变，酌情自己改正）：<br>
https://github.com/hzyitc/armbian-onecloud/releases/download/ci-20240311-162146-UTC/Armbian-unofficial_24.5.0-trunk_Onecloud_bookworm_edge_6.7.9_minimal.burn.img.xz <br>

用双公头刷完armbian后，下载 https://github.com/rmoyulong/OneCloud_OpenWrt/releases/download/Docker_Latest/immortalwrt-meson-meson8b-thunder-onecloud-rootfs.tar.gz <br>

把immortalwrt-meson-meson8b-thunder-onecloud-rootfs.tar.gz改名op.tar.gz <br>
ssh armbian输入以下命令 <br>
1.ip link set eth0 promisc on <br>
2.docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=eth0 macnet <br>
3.docker import op.tar.gz onecloud_openwrt <br>
4.docker run -itd --name=onecloud --restart=unless-stopped --network=macnet --privileged=true onecloud_openwrt /sbin/init <br>
---------------------------------------------------------------------------<br>

启动命令在/etc/rc.local中修改<br>
下载目录更改需要修改/etc/aria2/aria2.conf.main<br>
并赋予下载目录777权限<br>

---------------------------------------------------------------------------
编译固件的小知识：<br>
一个脚本执行多个任务---可以指定单个变量来创建单维矩阵来分别执行任务。<br>

例如，以下工作流使用值 [10, 12, 14] 定义变量 version。 工作流将运行三个作业，其中针对变量中的每个值提供一个作业。 每个作业都会通过 matrix.version 上下文访问 version 值，并此值作为 node-version 传递给 actions/setup-node 操作。<br>

jobs:
  example_matrix:
    strategy:
      matrix:
        version: [10, 12, 14]
    steps:
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.version }}
