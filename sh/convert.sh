if [ ! -z "$1" ];then
	idtype=$1
fi

sudo apt install android-sdk-libsparse-utils
ver="v0.3.2"
curl -L -o ./AmlImg https://github.com/rmoyulong/AmlImg/releases/download/$ver/AmlImg_${ver}_linux_amd64
chmod +x ./AmlImg
curl -L -o ./uboot.img https://github.com/rmoyulong/u-boot-onecloud/releases/download/Onecloud_Uboot_23.12.24_18.15.09/eMMC.burn.img
rm -rf openwrt/upload
mkdir -p openwrt/upload 

if [[ "${idtype}" == "0" ]]; then
  curl -L -o openwrt/upload/onecloud.img.gz https://github.com/rmoyulong/OneCloud_OpenWrt/releases/download/Docker_Mini/immortalwrt-meson-meson8b-thunder-onecloud-ext4-emmc.img.gz
  echo "选中的参数：0"
elif [[ "${idtype}" == "1" ]]; then  
  curl -L -o openwrt/upload/onecloud.img.gz https://github.com/rmoyulong/OneCloud_OpenWrt/releases/download/Docker_Latest/immortalwrt-meson-meson8b-thunder-onecloud-ext4-emmc.img.gz
  echo "选中的参数：1"
else
  curl -L -o openwrt/upload/onecloud.img.gz ${idtype}
  echo "选中的参数：2"
fi

./AmlImg unpack ./uboot.img burn/

gunzip  openwrt/upload/*.gz
diskimg=$(ls openwrt/upload/*.img)
loop=$(sudo losetup --find --show --partscan $diskimg)
img_ext="openwrt.img"
img_mnt="xd"
rootfs_mnt="img"
boot_img=${img_ext}
boot_img_mnt=${img_mnt}
rootfs_img_mnt=${rootfs_mnt}
echo ${boot_img}
echo ${boot_img_mnt}
echo ${rootfs_img_mnt}
sudo rm -rf ${boot_img}
sudo rm -rf ${boot_img_mnt}
sudo rm -rf ${rootfs_img_mnt}
sudo dd if=/dev/zero of=${boot_img} bs=1M count=2000
sudo mkfs.ext4 ${boot_img}
sudo mkdir ${boot_img_mnt}
sudo mkdir ${rootfs_img_mnt}
sudo mount ${boot_img} ${boot_img_mnt}
sudo mount ${loop}p2 ${rootfs_img_mnt}
cd ${rootfs_img_mnt}
sudo cp -r * ../${boot_img_mnt}
cd ..
sudo sync
sudo umount ${boot_img_mnt}
sudo umount ${rootfs_img_mnt}
sudo img2simg ${loop}p1 burn/boot.simg
sudo img2simg openwrt.img burn/rootfs.simg
sudo rm -rf *.img
sudo losetup -d $loop
cat <<EOF >>burn/commands.txt
PARTITION:boot:sparse:boot.simg
PARTITION:rootfs:sparse:rootfs.simg
EOF
prefix=$(ls openwrt/upload/*.img | sed 's/\.img$//')
burnimg=${prefix}.burn.img
./AmlImg pack $burnimg burn/
for f in openwrt/upload/*.burn.img; do
  sha256sum "$f" >"${f}.sha"
  xz -9 --threads=0 --compress "$f"
done
mv ${burnimg}.xz openwrt/upload/openwrt-onecloud_$(date +"%Y-%m-%d_%H_%M")-burn.img.xz
sudo rm -rf openwrt/upload/*.img
sudo rm -rf openwrt/upload/*.gz