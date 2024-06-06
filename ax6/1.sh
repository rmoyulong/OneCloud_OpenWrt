chmod -R 777 /etc/aria2
chmod -R 777 /mnt/sda1/aria2
chmod -R 777 /mnt/sda1/aria2/download
chmod -R 755 /mnt/sda1/share

echo "# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

# 修复在某些docker环境下网络卡顿的问题, 如果非必要请勿删除!
cat > /etc/resolv.conf <<EOF
search lan
nameserver 127.0.0.1
nameserver 114.114.114.114
options ndots:0
EOF

sh /etc/diymo.sh
sh /etc/aria2.sh

exit 0">/etc/rc.local

rm -rf /etc/1.sh
sh /etc/rc.local
