#如果files文件夹不存在，创建文件夹
if [ ! -d "/var/run/homeproxy" ]; then
  mkdir /var/run/homeproxy
fi

/etc/init.d/kodexplorer restart
/etc/init.d/zerotier restart
/etc/init.d/samba4 restart
/etc/init.d/ttyd restart
/etc/init.d/homeproxy restart
/etc/init.d/aria2 restart