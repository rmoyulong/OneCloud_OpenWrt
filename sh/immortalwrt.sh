#!/bin/bash

# 移除要替换的包
rm -rf feeds/packages/net/alist
rm -rf feeds/packages/net/aria2
rm -rf feeds/packages/net/ariang
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/net/msd_lite
rm -rf feeds/packages/net/smartdns
rm -rf feeds/luci/applications/luci-app-mosdns
rm -rf feeds/luci/applications/luci-app-msd_lite
rm -rf feeds/luci/applications/luci-app-smartdns
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/themes/luci-theme-netgear
rm -rf feeds/luci/applications/luci-app-netdata
rm -rf feeds/luci/applications/luci-app-serverchan
#rm -rf feeds/luci/applications/luci-app-homeproxy
rm -rf feeds/luci/applications/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-amlogic
rm -rf feeds/luci/applications/luci-app-passwall
rm -rf feeds/luci/applications/luci-app-passwall2
rm -rf feeds/luci/applications/luci-app-turboacc
#rm -rf feeds/packages/net/shadowsocks-libev

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

function merge_package() {
    # 参数1是分支名,参数2是库地址,参数3是所有文件下载到指定路径。
    # 同一个仓库下载多个文件夹直接在后面跟文件名或路径，空格分开。
    if [[ $# -lt 3 ]]; then
        echo "Syntax error: [$#] [$*]" >&2
        return 1
    fi
    trap 'rm -rf "$tmpdir"' EXIT
    branch="$1" curl="$2" target_dir="$3" && shift 3
    rootdir="$PWD"
    localdir="$target_dir"
    [ -d "$localdir" ] || mkdir -p "$localdir"
    tmpdir="$(mktemp -d)" || exit 1
    git clone -b "$branch" --depth 1 --filter=blob:none --sparse "$curl" "$tmpdir"
    cd "$tmpdir"
    git sparse-checkout init --cone
    git sparse-checkout set "$@"
    # 使用循环逐个移动文件夹
    for folder in "$@"; do
        mv -f "$folder" "$rootdir/$localdir"
    done
    cd "$rootdir"
}

echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> feeds.conf.default
#echo 'src-git small https://github.com/kenzok8/small' >> feeds.conf.default
######################################################################################
#支持clash方式 有clash ui
git clone --depth=1 https://github.com/bulianglin/homeproxy package/homeproxy
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-homeproxy
######################################################################################
#git clone --depth=1 -b main https://github.com/fw876/helloworld package/luci-app-ssr-plus
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2 package/luci-app-passwall2
merge_package master https://github.com/immortalwrt/luci/ package applications/luci-app-openclash
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-bypass
#######################################################################################
git_sparse_clone main https://github.com/kiddin9/kwrt-packages dnsforwarder
git_sparse_clone master https://github.com/rmoyulong/AX6-Actions_Lede pcre
git_sparse_clone master https://github.com/rmoyulong/AX6-Actions_Lede ruby
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-zerotier
git_sparse_clone main https://github.com/kiddin9/kwrt-packages taskd
git_sparse_clone main https://github.com/kiddin9/kwrt-packages v2dat
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-mosdns
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-ssr-plus
git_sparse_clone main https://github.com/kiddin9/kwrt-packages shadow-tls
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages lua-neturl
git_sparse_clone main https://github.com/kiddin9/kwrt-packages redsocks2
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-turboacc
git_sparse_clone main https://github.com/kenzok8/small-package lua-maxminddb
git_sparse_clone main https://github.com/kiddin9/kwrt-packages shadowsocks-rust
#git_sparse_clone main https://github.com/kenzok8/small-package luci-app-kodexplorer
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-usb-printer
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages shadowsocksr-libev

git clone --depth=1 https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff
git clone --depth=1 https://github.com/Jason6111/luci-app-netdata package/luci-app-netdata
git clone --depth=1 https://github.com/destan19/OpenAppFilter package/OpenAppFilter
git clone --depth=1 -b openwrt-18.06 https://github.com/tty228/luci-app-wechatpush package/luci-app-serverchan

# 在线用户
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-onliner
sudo chmod -Rf 755 package/luci-app-onliner

# msd_lite
git clone --depth=1 https://github.com/ximiTech/luci-app-msd_lite package/luci-app-msd_lite
git clone --depth=1 https://github.com/ximiTech/msd_lite package/msd_lite