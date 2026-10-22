#设置armv8 64位的openclash

#删除以前设置的所有openclash
rm -rf ./package/OpenClash
rm -rf ./package/luci-app-openclash
rm -rf feeds/kenzo/luci-app-openclash
rm -rf feeds/luci/applications/luci-app-openclash

#如果 core 文件夹不存在，创建文件夹
if [ ! -d "./files/etc/openclash/core" ]; then
  mkdir -p files/etc/openclash/core
fi

#如果 temp 文件夹不存在，创建文件夹
#if [ ! -d "./files/tmp" ]; then
#  mkdir -p files/tmp
#fi

#Open Clash
git clone --depth=1 --single-branch --branch "dev" https://github.com/vernesong/OpenClash.git package/OpenClash

CORE_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
GEOIP_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
GEO_MMDB_URL="https://github.com/alecthw/mmdb_china_ip_list/raw/release/lite/Country.mmdb"

#echo ">>> 下载 clash_meta 内核"
#wget ${CORE_URL} -O armv8.gz
#gunzip  armv8.gz 
#mv armv8 ./files/tmp/clash_meta
#chmod +x ./files/tmp/clash_meta

echo ">>> 下载 clash_meta 内核"
wget ${CORE_URL} | tar xOvz > files/etc/openclash/core/clash_meta
chmod +x files/etc/openclash/core/clash_meta

echo ">>> 下载地理数据（失败不中断，刷好后可在界面里再下载）"
wget ${GEOIP_URL}    > files/etc/openclash/GeoIP.dat    || { echo "  GeoIP 失败，跳过";       rm -f files/etc/openclash/GeoIP.dat; }
wget ${GEOSITE_URL}  > files/etc/openclash/GeoSite.dat  || { echo "  GeoSite 失败，跳过";     rm -f files/etc/openclash/GeoSite.dat; }
wget ${GEO_MMDB_URL} > files/etc/openclash/Country.mmdb || { echo "  Country.mmdb 失败，跳过"; rm -f files/etc/openclash/Country.mmdb; }

ls -lh files/etc/openclash/core files/etc/openclash