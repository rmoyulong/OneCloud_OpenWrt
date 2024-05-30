chmod -R 777 /etc/aria2
chmod -R 777 /mnt/sda1/aria2
chmod -R 777 /mnt/sda1/aria2/download
chmod -R 755 /mnt/sda1/share

echo "# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

#mount -o remount rw /
/usr/sbin/balethirq.pl
sh /etc/diymo.sh
aria2c --conf-path=/etc/aria2/aria2.conf.main >/dev/null 2>&1
exit 0">/etc/rc.local

rm -rf /etc/1.sh
sh /etc/rc.local
