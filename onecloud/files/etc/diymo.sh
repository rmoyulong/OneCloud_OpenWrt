mkdir -p /tmp/run/homeproxy
/etc/init.d/kodexplorer restart
/etc/init.d/zerotier restart
/etc/init.d/samba4 restart
/etc/init.d/ttyd restart
/etc/init.d/homeproxy restart

