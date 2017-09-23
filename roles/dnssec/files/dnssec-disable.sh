#!/bin/bash -x

/usr/bin/systemctl disable dnssec-triggerd
/usr/bin/systemctl stop dnssec-triggerd
/usr/bin/systemctl stop unbound
/usr/bin/sed -i 's/^dns/#dns/' /etc/NetworkManager/NetworkManager.conf
/usr/bin/systemctl restart NetworkManager

