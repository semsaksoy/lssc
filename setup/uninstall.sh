
# uninstall
 systemctl stop lssc
 systemctl disable lssc
 systemctl daemon-reload
 rm -f /lib/systemd/system/lssc.service
 rm -rf /opt/lssc