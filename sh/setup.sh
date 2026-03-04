#公用函数
source $GITHUB_WORKSPACE/sh/functions.sh

merge_package master https://github.com/coolsnowwolf/packages package lang/rust
git clone https://github.com/stupidloud/helloworld package/helloworld

rm -rf package/helloworld/v2ray-geodata
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

cd package
$GITHUB_WORKSPACE/sh/Packages.sh
$GITHUB_WORKSPACE/sh/Handles.sh