#!/usr/bin/bash
/usr/bin/find /media/DATA/ -xdev -name '.DS_Store' -type f -delete
/usr/bin/find /media/DATA/ -xdev -name '._.DS_Store' -type f -delete
