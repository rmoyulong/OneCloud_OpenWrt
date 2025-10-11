#公用函数
source $GITHUB_WORKSPACE/sh/functions.sh

cd openwrt
merge_package master https://github.com/rmoyulong/old_coolsnowwolf_packages package lang/python
rm -rf feeds/packages/lang/python
cp -rf ./package/python feeds/packages/lang/