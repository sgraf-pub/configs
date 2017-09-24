#!/bin/bash -x

/usr/bin/systemctl enable dnssec-triggerd
/usr/bin/systemctl start dnssec-triggerd
/usr/bin/sed -i 's/^dns.*/dns = unbound/' /etc/NetworkManager/NetworkManager.conf
/usr/bin/systemctl restart NetworkManager

