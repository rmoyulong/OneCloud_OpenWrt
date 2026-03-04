#公用函数
source $GITHUB_WORKSPACE/sh/functions.sh

rm -rf feeds/packages/lang/rust
merge_package master https://github.com/coolsnowwolf/packages package lang/rust

git clone https://github.com/kenzok8/small package/kenzok8
rm -rf package/kenzok8/xray-core

cd package
$GITHUB_WORKSPACE/sh/Packages.sh
$GITHUB_WORKSPACE/sh/Handles.sh