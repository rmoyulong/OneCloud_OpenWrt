#公用函数
source $GITHUB_WORKSPACE/sh/functions.sh

rm -rf feeds/packages/lang/rust
merge_package master https://github.com/coolsnowwolf/packages package lang/rust

git clone https://github.com/stupidloud/helloworld package/helloworld
rm -rf feeds/packages/net/xray-core

cd package
$GITHUB_WORKSPACE/sh/Packages.sh
$GITHUB_WORKSPACE/sh/Handles.sh