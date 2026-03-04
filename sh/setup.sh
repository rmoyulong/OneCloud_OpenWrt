#公用函数
source $GITHUB_WORKSPACE/sh/functions.sh

#echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf.default
#echo 'src-git kenzo  https://github.com/kiddin9/kwrt-packages' >> feeds.conf.default

#rm libs/mbedtls/Makefile
#cp -f $GITHUB_WORKSPACE/patch/mbedtls/Makefile package/libs/mbedtls/Makefile
git_sparse_clone master https://github.com/kenzok8/small luci-app-ssr-plus

cd package
$GITHUB_WORKSPACE/sh/Packages.sh
$GITHUB_WORKSPACE/sh/Handles.sh