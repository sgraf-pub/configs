#!/usr/bin/bash -x
/usr/bin/hardlink --reflink --exclude '/media/DATA/zalohy/btrbk/*' /media/DATA/zalohy/
/usr/bin/hardlink --reflink --exclude '/media/DATA/data/btrbk/*' /media/DATA/data/
/usr/sbin/fstrim -a -v
